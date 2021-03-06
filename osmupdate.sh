#!/bin/bash

. ./config
. ./tools/bash_functions.sh

# mapping user and password for osm2pgsql
export PGHOST=$pghost
export PGPORT=$pgport
export PGUSER=$username
export PGPASSWORD=$password
export PGDATABASE=$database

# define logfile name
logfile_name=update_`date '+%Y-%m-%d_%H-%M-%S'`_$1.log

# Maximum number of partiton using in table osm_addresses
partition_count=15

# Check already running
if [ "$(pidof -x $(basename $0))" != $$ ]
then
        echo_time "Update is already running"
        exit
fi

# Check Parameter
if [ $# -lt 1 ] || [ "$1" != "full" -a "$1" != "address" -a "$1" != "first" ]
then
	echo_time "Parameter missing: use 'full' or 'address' "
	exit
fi

# find osmupdate
export PATH=`pwd`/tools/:$PATH
oupdate=`which osmupdate 2> /dev/null`
oconvert=`which osmconvert 2> /dev/null` # needed by osmupdate

# Creating tmp-directory for updates
mkdir -p tmp

# if not find compile
if [ -z "$oupdate" ]
then
	echo_time "Try to complie osmupdate ..."
	wget -O - http://m.m.i24.cc/osmupdate.c | cc -x c - -o tools/osmupdate
	if [ ! -f tools/osmupdate ]
	then
		echo_time "Unable to compile osmupdate, please install osmupdate into \$PATH or in tools/ directory."
		exit
	fi
fi
if [ -z "$oconvert" ]
then
	echo_time "Try to complie osmconvert ..."
	wget -O - http://m.m.i24.cc/osmconvert.c | cc -x c - -lz -O3 -o tools/osmconvert
	if [ ! -f tools/osmconvert ]
	then
		echo_time "Unable to compile osmconvert, please install osmconvert into \$PATH or tools/ directory."
		exit
	fi
fi

# Check old reference file to find date
if [ "$1" != "first" ]
then
	if [ -f tmp/old_update.osc.gz ]
	then
		# 2nd Update
		osmupdate -v $osmupdate_parameter tmp/old_update.osc.gz tmp/update.osc.gz
	else
		# 1st Update using dump
		osmupdate -v $osmupdate_parameter $import_file tmp/update.osc.gz
	fi
fi
# catch exit code of osmupdate
RESULT=$?
if [ $RESULT -ne 0 ]
then
	echo_time "osmupdate exits with error code $RESULT."
	exit 1
fi

# Set update start time
psql -f sql/planetUpdateStartConfigTime.sql > /dev/null

if [ "$1" = "first" ] || [ -f tmp/update.osc.gz ]
then
	echo_time "Disable autovacuum ..."
	psql -f sql/disableVacuum.sql > /dev/null 2>&1

	if [ "$1" = "first" ]
	then
		update_ts=`osmconvert ${import_file} 2> /dev/null | head | grep '<osm' | awk '{print $0"</osm>"}' | xmllint --xpath 'string(/osm/@timestamp)' -`
		if [ -z "$update_ts" ]
		then
			# First run without update, date not found in import file
			update_ts="initial"
		fi
	else
		# Import in DB
		imposm3  diff -config config.json -connection "postgis://${username}:${password}@${pghost}:${pgport}/${database}?prefix=imposm_" \
           -cachedir $cache_dir -diffdir $diff_dir tmp/update.osc.gz
		# catch exit code of imposm3
		RESULT=$?
		if [ $RESULT -ne 0 ]
		then
			echo_time "imposm3 exits with error code $RESULT."
			exit 1
		fi
		psql -f sql/planetVacuumTables.sql > /dev/null

		update_ts=`zcat tmp/update.osc.gz | head | grep '<osmChange' | awk '{print $0"</osmChange>"}' | xmllint --xpath 'string(/osmChange/@timestamp)' -`
		mv tmp/update.osc.gz tmp/old_update.osc.gz
	fi

	if [ "$1" != "address" ]
	then
		# Restore data of last polygon updates
		psql -f sql/planetPolyRestoreForFullUpdate.sql > /dev/null
	else
		# Save data of updates for polygon for next full update
		psql -f sql/planetPolyMoveForFullUpdate.sql > /dev/null
	fi

	# Complete Update table data in schema import
	echo_time "Delete old elements ..."
	psql -f sql/importDeleteOldEntries.sql > /dev/null
	echo_time "Copy new elements ..."
	psql -f sql/copyTables.sql > /dev/null
	echo_time "Truncate update tables ..."
	psql -f sql/planetTruncateUpdateTables.sql > /dev/null
	echo_time "Vacuum on schema import ..."
	psql -f sql/importVacuumTables.sql > /dev/null

	if [ "$1" == "first" ]
	then
		# this part is for first running after import
		echo_time "Create indexes on schema import ..."
		psql -f sql/importCreateIndex.sql > /dev/null

		echo_time "Create indexes on address partition tables ..."
		for i in $(seq -f "%02g" 0 $partition_count)
		do
			echo_time "  - For partition ${i}"
			cat sql/importCreateIndexPartitions.sql | sed -e "s/XX/${i}/g" | psql > /dev/null
		done
	fi

	# apply assisciated Street relations
	echo_time "Apply relations type=associatedStreet ..."
	psql -f sql/importRefreshAssociatedStreet.sql > /dev/null
	for i in $(seq -f "%02g" 0 $partition_count)
	do
		execute_partition_script $i "sql/importApplyAssociatedStreet.sql" "Apply AssociatedStreet"&
	done
	wait

	# Update Database ... full | address | first
	if [ "$1" != "address" ]
	then
		# Running full / first update
		
		echo_time "Refresh materialized views ..."
		psql -f sql/importUpdateMatViewsFull.sql > /dev/null

		# fill missing fields like postcode, city and country
		echo_time "Fill postcode, city and country fields with surrounding polygons ..."
		for i in $(seq -f "%02g" 0 $partition_count)
		do
			execute_partition_script $i "sql/importFillMissingFields.sql" "Filling missing"&
		done
		wait
		
		psql -c 'UPDATE config_values SET "val"='\'${update_ts}\'' WHERE "key"='\''update_ts_address'\'';' > /dev/null
		psql -c 'UPDATE config_values SET "val"='\'${update_ts}\'' WHERE "key"='\''update_ts_full'\'';' > /dev/null
	else # address
		# Running address update

		echo_time "Refresh materialized views ..."
		psql -f sql/importUpdateMatViewsAddress.sql > /dev/null

		# fill missing fields like postcode, city and country, only for updated addresses
		echo_time "Fill postcode, city and country fields with surrounding polygons ..."
		for i in $(seq -f "%02g" 0 $partition_count)
		do
			execute_partition_script $i "sql/importFillMissingFieldsAddedAddressesOnly.sql" "Fill missing"&
		done
		wait
		
		psql -c 'UPDATE config_values SET "val"='\'${update_ts}\'' WHERE "key"='\''update_ts_address'\'';' > /dev/null
	fi

	# update timestamp for find new elements
	echo_time "Update time on database ..."
	psql -f sql/planetUpdateConfigTime.sql > /dev/null
	echo_time "Vacuum on schema import ..."
	psql -f sql/importVacuumTables.sql > /dev/null
	echo_time "Enable autovacuum ..."
	psql -f sql/enableVacuum.sql > /dev/null 2>&1
	echo_time "Update completed."
else
	echo_time "No update needed."
fi
