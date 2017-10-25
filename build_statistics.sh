#!/bin/bash

. ./config

# mapping user and password
export PGHOST=$pghost
export PGPORT=$pgport
export PGUSER=$username
export PGPASSWORD=$password
export PGDATABASE=$database

# Building statistics for current state

# call sql for creating database
echo Check schema statistics and create table if nessesary ...
psql -f sql/statsCreateTable.sql &> /dev/null

# update current 
echo Update statistics ...
psql -f sql/statsUpdateTable.sql > /dev/null