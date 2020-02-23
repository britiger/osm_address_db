#!/bin/bash

. ../../config 
. ../../tools/bash_functions.sh

# mapping user and password for psql
export PGHOST=$pghost
export PGPORT=$pgport
export PGUSER=$username
export PGPASSWORD=$password
export PGDATABASE=$database

# create tables for external data
echo_time "Create Tables for External Datasources"
psql -f ../../sql/externalTables.sql > /dev/null
