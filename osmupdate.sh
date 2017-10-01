#!/bin/sh

. ./config

# mapping user and password for osm2pgsql
export PGHOST=$pghost
export PGPORT=$pgport
export PGUSER=$username
export PGPASSWORD=$password
export PGDATABASE=$database

# Check already running
if [ "$(pidof -x $(basename $0))" != $$ ]
then
        echo "Update is already running"
        exit
fi

# Check Parameter
if [ $# -lt 1 ] || [ "$1" != "full" -a "$1" != "address" -a "$1" != "first" ]
then
	echo "Parameter missing: use 'full' or 'address' "
	exit
fi

# find osmconvert, osmupdate
export PATH=`pwd`/tools/:$PATH
oupdate=`which osmupdate &> /dev/null`
oconvert=`which osmconvert &> /dev/null`

# Creating tmp-directory for updates
mkdir -p tmp

# if not find compile
if [ -z $oconvert ]
then
	echo "Try to complie osmconvert ..."
	wget -O - http://m.m.i24.cc/osmconvert.c | cc -x c - -lz -O3 -o tools/osmconvert
	if [ ! -f tools/osmconvert ]
	then
		echo "Unable to compile osmconvert, please install osmconvert into \$PATH or tools/ directory."
		exit
	fi
fi
if [ -z $oupdate ]
then
	echo "Try to complie osmupdate ..."
	wget -O - http://m.m.i24.cc/osmupdate.c | cc -x c - -o tools/osmupdate
	if [ ! -f tools/osmconvert ]
	then
		echo "Unable to compile osmconvert, please install osmupdate into \$PATH or tools/ directory."
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

if [ "$1" = "first" ] || [ -f tmp/update.osc.gz ]
then
	echo Disable autovacuum ...
	psql -f sql/disableVacuum.sql > /dev/null 2>&1

	if [ "$1" = "first" ]
	then
		# First run without update
		update_ts="initial"
	else
		# Import in DB
		osm2pgsql --append -s --number-processes $o2pProcesses -C $o2pCache -H $pghost -P $pgport -d $database \
			-S others/import.style -U $username $o2pParameters tmp/update.osc.gz
		psql -f sql/planetVacuumTables.sql > /dev/null

		update_ts=`zcat tmp/update.osc.gz | xmllint --xpath 'string(/osmChange/@timestamp)' -`
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
	echo Delete old elements ...
	psql -f sql/importDeleteOldEntries.sql > /dev/null
	echo Copy new elements ...
	psql -f sql/copyTables.sql > /dev/null
	echo Truncate update tables ...
	psql -f sql/planetTruncateUpdateTables.sql > /dev/null
	echo Vacuum on schema import ...
	psql -f sql/importVacuumTables.sql > /dev/null

	# apply assisciated Street relations
	echo Apply relations type=associatedStreet ...
	psql -f sql/importApplyAssociatedStreet.sql > /dev/null

	# Update Database ... full | address | first
	if [ "$1" != "address" ]
	then
		# Running full update

		# this part is for first running after import
		echo Checking indexes on schema import ...
		psql -f sql/importCreateIndex.sql > /dev/null

		echo Refresh materialized views ...
		psql -f sql/importUpdateMatViewsFull.sql > /dev/null

		# fill missing fields like postcode, city and country
		echo Fill postcode, city and country fields with surrounding polygons ...
		psql -f sql/importFillMissingFields.sql > /dev/null
		
		psql -c 'UPDATE config_values SET "val"='\'${update_ts}\'' WHERE "key"='\''update_ts_address'\'';' > /dev/null
		psql -c 'UPDATE config_values SET "val"='\'${update_ts}\'' WHERE "key"='\''update_ts_full'\'';' > /dev/null
	else # address
		# Running address update

		echo Refresh materialized views ...
		psql -f sql/importUpdateMatViewsAddress.sql > /dev/null

		# fill missing fields like postcode, city and country, only for updated addresses
		echo Fill postcode, city and country fields with surrounding polygons ...
		psql -f sql/importFillMissingFieldsAddedAddressesOnly.sql > /dev/null
		
		psql -c 'UPDATE config_values SET "val"='\'${update_ts}\'' WHERE "key"='\''update_ts_address'\'';' > /dev/null
	fi

	# update timestamp for find new elements
	echo Update time on database ...
	psql -f sql/planetUpdateConfigTime.sql > /dev/null
	echo Vacuum on schema import ...
	psql -f sql/importVacuumTables.sql > /dev/null
	echo Enable autovacuum ...
	psql -f sql/enableVacuum.sql > /dev/null 2>&1
else
	echo No update needed.
fi

