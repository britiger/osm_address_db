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
logfile_name=errors_`date '+%Y-%m-%d_%H-%M-%S'`.log

# invoke update_invalid_addresses for all cities
# results faster loading an write statistics
# need to run build_statistics.sh once first to cerate table

# update current 
echo_time "Update errors ..."
psql -c "SELECT web.update_invalid_addresses(osm_id, false) FROM import.osm_admin_city;" > /dev/null

echo_time "Update errors completed."
