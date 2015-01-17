#!/bin/sh

. ./config 

# mapping user and password for osm2pgsql
export pguser=$username
export pgpass=$password
export PGPASS=$password

# delete old data
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/dropTables.sql > /dev/null

# import data into database
osm2pgsql --create -s --number-processes $o2pProcesses -C $o2pCache -H $pghost -d $database -S others/import.style -U $username $import_file

# create additional fields for later updates (timestamps-fields)
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/addTimestamp.sql > /dev/null

# create delete-tables
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createDeleteTables.sql > /dev/null

# create trigger for delete-tables
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/createDeleteTriggers.sql > /dev/null

# create view for later processing
