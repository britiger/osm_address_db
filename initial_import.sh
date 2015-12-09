#!/bin/sh

. ./config 

# mapping user and password for osm2pgsql
export PGHOST=$pghost
export PGPORT=$pgport
export PGUSER=$username
export PGPASSWORD=$password
export PGDATABASE=$database

# delete old data
psql -f sql/dropTables.sql > /dev/null

# import data into database
osm2pgsql --create -s --number-processes $o2pProcesses -C $o2pCache -H $pghost -P $pgport -d $database -S others/import.style -U $username $o2pParameters $import_file

# create additional fields for later updates (timestamps-fields)
echo Creating timestamp fileds ...
psql -f sql/addTimestamp.sql > /dev/null

# create delete-tables
echo Creating delete-tables ...
psql -f sql/createDeleteTables.sql > /dev/null

# create trigger for delete-tables
echo Creating delete triggers ...
psql -f sql/createDeleteTriggers.sql > /dev/null

# create functions
echo Creating functions ...
psql -f sql/createFunctions.sql > /dev/null

# create view for later processing
echo Creating import views ...
psql -f sql/createImportViews.sql > /dev/null

# call reimport.sh to create import-schema
./reimport.sh

# TODO: get number from everywhere
echo Set OSC number ...
psql -f sql/createConfigOSC.sql > /dev/null

if [ $updateStartNumber -ne 999999999 ]
then
	psql -t -c 'UPDATE config_values SET val='$updateStartNumber' WHERE "key"='\''next_osc'\'';' > /dev/null
fi

if [ $updatePath != 'none' ]
then
        psql -t -c 'UPDATE config_values SET val='\'''$updatePath''\'' WHERE "key"='\''update_url'\'';' > /dev/null
fi
