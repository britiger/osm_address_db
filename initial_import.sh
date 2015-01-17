#!/bin/sh

. ./config 

# mapping user and password for osm2pgsql
export pguser=$pgUser
export pgpassword=$pgPassword

# delete old data
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/dropTables.sql > /dev/null

# import data into database
osm2pgsql --create -s --number-processes $o2pProcesses -C $o2pCache -H $pghost -d $database -S others/import.style -U $username -W $import_file

# create additional fields for later updates

# create delete-tables

# create trigger for delete-tables

# create view for later processing
