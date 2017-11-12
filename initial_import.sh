#!/bin/bash

. ./config 
. ./tools/bash_functions.sh

# mapping user and password for osm2pgsql
export PGHOST=$pghost
export PGPORT=$pgport
export PGUSER=$username
export PGPASSWORD=$password
export PGDATABASE=$database

# delete old cache and diff
rm -rf $cache_dir $diff_dir

# Creating nessesary directories
mkdir -p tmp # for storing last update files
mkdir -p log # logging

# define logfile name
logfile_name=import_`date '+%Y-%m-%d_%H-%M-%S'`.log

# set tool path fot custom osm2pgsql
export PATH=`pwd`/tools/:$PATH

# delete old data
echo_time "Delete old data ..."
rm -f tmp/*
psql -f sql/planetDropAllTables.sql > /dev/null

# TODO: Importing all countires
#echo Importing country borders ...
#countryList=`ls country_files/*.osm`
#for country in $countryList
#do
#	echo Importing country-file $country ...
#	# import data into database
#	osm2pgsql --create -s --number-processes $o2pProcesses -C $o2pCache -H $pghost -P $pgport -d $database \
#		-S others/import.style -U $username $o2pParameters $country
#done

# import data into database
echo_time "Import data from $import_file ..."
imposm3  import -config config.json -read $import_file -write -connection "postgis://${username}:${password}@${pghost}:${pgport}/${database}?prefix=imposm_" \
  -diff -cachedir $cache_dir -diffdir $diff_dir -dbschema-import imposm3 -deployproduction
# catch exit code of osm2pgsql
RESULT=$?
if [ $RESULT -ne 0 ]
then
	echo_time "imposm3 exits with error code $RESULT."
	exit 1
fi

# disable Vaccum
psql -f sql/disableVacuum.sql > /dev/null 2>&1

# create update tables
echo_time "Creating update tables ..."
psql -f sql/planetCreateUpdateTables.sql > /dev/null

# create trigger for update tables
echo_time "Creating update triggers ..."
psql -f sql/planetCreateUpdateTriggers.sql > /dev/null
exit
# create functions
echo_time "Creating functions ..."
psql -f sql/createFunctions.sql > /dev/null

# create view for later processing
echo_time "Creating views on imported tables ..."
psql -f sql/planetCreateViews.sql > /dev/null

echo_time "Create config values ..."
psql -f sql/planetCreateConfigValues.sql > /dev/null

echo_time "Building up schema import ..."

# create Tables for Initial import-schema including drop old schema
echo_time " - Tables"
psql -f sql/importCreateTables.sql > /dev/null
psql -f sql/disableVacuum.sql > /dev/null 2>&1

# create Views for import-schema
echo_time " - Views"
psql -f sql/importCreateViews.sql > /dev/null

echo_time "Starting importing data ..."
./osmupdate.sh first

echo_time "Create tables and functions for web applications"
psql -f sql/webTables.sql > /dev/null
psql -f sql/webFunctions.sql > /dev/null

echo_time "Initial import finished."
