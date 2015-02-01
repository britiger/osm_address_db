#!/bin/sh

. ./config 

# mapping user and password for osm2pgsql
export pguser=$username
export pgpass=$password
export PGPASS=$password

# create Tables for Initial import-schema including drop old schema
echo Creating import tables ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createTables.sql > /dev/null

# create Index for import-schema
echo Creating indexes on import tables ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createIndex.sql > /dev/null

# create Views for import-schema
echo Creating views on import tables ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createView.sql > /dev/null

# vacuum tables
echo Vacuum on import tables ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/vacuumTables.sql > /dev/null

# fill missing fields like postcode, city and country
echo Fill postcode, city and country fields with surrounding polygons ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/fillMissingFields.sql > /dev/null
