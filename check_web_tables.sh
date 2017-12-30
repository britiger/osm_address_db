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
logfile_name=web_`date '+%Y-%m-%d_%H-%M-%S'`.log

# check tables
echo_time "Check tables in schema web ..."
psql -f sql/checkWebTables.sql > /dev/null

echo_time "Check completed."
