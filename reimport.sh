#!/bin/sh

. ./config 

# mapping user and password for osm2pgsql
export pguser=$username
export pgpass=$password
export PGPASS=$password

# create Tables for Initial import-schema including drop old schema
echo Creating import tables ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createTables.sql > /dev/null

# create Index for Initial import-schema
echo Creating indexes on import tables ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createIndex.sql > /dev/null

# create Views for Initial import-schema
echo Creating views on import tables ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createView.sql > /dev/null
