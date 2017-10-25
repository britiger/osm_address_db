#!/bin/bash

. ./config
. ./tools/bash_functions.sh

# mapping user and password
export PGHOST=$pghost
export PGPORT=$pgport
export PGUSER=$username
export PGPASSWORD=$password
export PGDATABASE=$database

# define logfile name
logfile_name=statistics_`date '+%Y-%m-%d_%H-%M-%S'`.log

# Building statistics for current state

# call sql for creating database
echo_time "Check schema statistics and create table if nessesary ..."
psql -f sql/statsCreateTable.sql > /dev/null

# update current 
echo_time "Update statistics ..."
psql -f sql/statsUpdateTable.sql > /dev/null

echo_time "Statistics completed."
