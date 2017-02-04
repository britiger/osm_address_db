#!/bin/sh

. ./config 

# mapping user and password for osm2pgsql
export PGHOST=$pghost
export PGPORT=$pgport
export PGUSER=$username
export PGPASSWORD=$password
export PGDATABASE=$database

# delete old data
echo Delete old data ...
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
echo Import data from $import_file ...
osm2pgsql --create -s --number-processes $o2pProcesses -C $o2pCache -H $pghost -P $pgport -d $database \
	-S others/import.style -U $username $o2pParameters $import_file

# disable Vaccum
psql -f sql/disableVacuum.sql > /dev/null 2>&1

# create additional fields for later updates (timestamps-fields)
echo Creating timestamp fields ...
psql -f sql/planetAddTimestamp.sql > /dev/null

# create delete-tables
echo Creating delete-tables ...
psql -f sql/planetCreateDeleteTables.sql > /dev/null
psql -f sql/disableVacuum.sql > /dev/null 2>&1

# create trigger for delete-tables
echo Creating delete triggers ...
psql -f sql/planetCreateDeleteTriggers.sql > /dev/null

# create functions
echo Creating functions ...
psql -f sql/createFunctions.sql > /dev/null

# create view for later processing
echo Creating views on imported tables ...
psql -f sql/planetCreateViews.sql > /dev/null

echo Create config values ...
psql -f sql/planetCreateConfigValues.sql > /dev/null

echo Building up schema import ...

# create Tables for Initial import-schema including drop old schema
echo " - Tables"
psql -f sql/importCreateTables.sql > /dev/null
psql -f sql/disableVacuum.sql > /dev/null 2>&1

# create Views for import-schema
echo " - Views"
psql -f sql/importCreateViews.sql > /dev/null

echo Starting importing data ...
./osmupdate.sh first

