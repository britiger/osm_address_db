#!/bin/sh

. ./config 

# mapping user and password for osm2pgsql
export pguser=$username
export pgpass=$password
export PGPASS=$password

# delete old data
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/dropTables.sql > /dev/null

# import data into database
osm2pgsql --create -s --number-processes $o2pProcesses -C $o2pCache -H $pghost -d $database -S others/import.style --flat-nodes flat-nodes.bin -U $username $import_file

# create additional fields for later updates (timestamps-fields)
echo Creating timestamp fileds ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/addTimestamp.sql > /dev/null

# create delete-tables
echo Creating delete-tables ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createDeleteTables.sql > /dev/null

# create trigger for delete-tables
echo Creating delete triggers ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createDeleteTriggers.sql > /dev/null

# create functions
echo Creating functions ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createFunctions.sql > /dev/null

# create view for later processing
echo Creating import views ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createImportViews.sql > /dev/null

# create Tables for Initial import-schema
echo Creating import tables ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createTables.sql > /dev/null

# create Index for Initial import-schema
echo Creating indexes on import tables ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createIndex.sql > /dev/null

# create Views for Initial import-schema
echo Creating views on import tables ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createView.sql > /dev/null
