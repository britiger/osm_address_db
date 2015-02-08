#!/bin/sh

. ./config 

# mapping user and password for osm2pgsql
export pguser=$username
export pgpass=$password
export PGPASS=$password

# if a parameter is given only fill empty fields
if [ $# -lt 1 ]
then
	# reset updatetime
	psql "dbname=$database host=$pghost user=$username password=$password port=5432" -t -c 'UPDATE config_values SET "val"='\''2014-12-31'\'' WHERE "key"='\''last_update'\'';'  > /dev/null

	# create Tables for Initial import-schema including drop old schema
	echo Creating import tables ...
	psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createTables.sql > /dev/null

	# create Tables for Initial import-schema including drop old schema
	echo Copy content of tables ...
	psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/copyTables.sql > /dev/null

	# mark copied entries as updated
	psql "dbname=$database host=$pghost user=$username password=$password port=5432" -t -c 'UPDATE config_values SET "val"=now() WHERE "key"='\''last_update'\'';' > /dev/null

	# create Index for import-schema
	echo Creating indexes on import tables ...
	psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createIndex.sql > /dev/null

	# create Views for import-schema
	echo Creating views on import tables ...
	psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createView.sql > /dev/null
fi

# vacuum tables
echo Vacuum on import tables ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/vacuumTables.sql > /dev/null

# fill missing fields like postcode, city and country
echo Fill postcode, city and country fields with surrounding polygons ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/fillMissingFields.sql > /dev/null

# apply assisciated Street relations
echo Apply relations type=associatedStreet ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/applyAssociatedStreet.sql > /dev/null
