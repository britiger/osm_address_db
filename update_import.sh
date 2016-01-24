#!/bin/bash

# This script updates the imported data
# TODO: set initial update osc number in config
# TODO: set url for update in config
. ./config 

# mapping user and password for osm2pgsql
export PGHOST=$pghost
export PGPORT=$pgport
export PGUSER=$username
export PGPASSWORD=$password
export PGDATABASE=$database 

# read seq-number
next_osc=`psql -t -c 'SELECT val FROM config_values WHERE "key"='\''next_osc'\'';'`
update_url=`psql -t -c 'SELECT val FROM config_values WHERE "key"='\''update_url'\'';'`

# set success variables
success=0
successLoad=1

# create tmp dir if not exists and cleanup
if [ ! -d tmp ]; then
	mkdir tmp
fi
rm -f tmp/*

while [ $successLoad -eq 1 ] && [ $updateMaxCount -ge 1 ]
do
	# reset success flag for current iteration
	successLoad=0

	# create 3 Blocks of numbers
	block3=$(($next_osc % 1000))
	tmp=$(($next_osc / 1000))
	block2=$(($tmp % 1000))
	tmp=$(($tmp / 1000))
	block1=$(($tmp % 1000))

	printf -v num_path "%03d/%03d/%03d" $block1 $block2 $block3
	url=$update_url$num_path.osc.gz

	echo Loading from url ...
	status=`curl -o tmp/update.osc.gz -D tmp/head.txt --silent --write-out '%{http_code} %{size_download}\n' $url`
	
	# check status code
	if [[ $status != "200"* ]]
	then
		echo 'Error loading update with number' $next_osc ': HTTP-Status' `echo $status | awk '{print $1}'` '.'
	else
		successLoad=1
	fi

	file_size_head=`cat tmp/head.txt | grep Content-Length | awk '{print $2+0}'`
	file_size_load=`echo $status | awk '{print $2+0}'`
	if [ ! $file_size_load -eq $file_size_head ] && [ $successLoad -eq 1 ]
	then
		echo 'Error loading update with number $next_osc: illegal file size' $file_size_load 'loaded' $file_size_head 'expected.'
		successLoad=0
	fi

	if [[ $successLoad -eq 1 ]]
	then
		echo Apply update number $next_osc ...

		# make update using tmp/update.osc.gz
		osm2pgsql --append -s --number-processes $o2pProcesses -C $o2pCache -H $pghost -P $pgport -d $database -S others/import.style -U $username $o2pParameters tmp/update.osc.gz
		echo Update sequence on database and VACUUM tables ...
		psql -f sql/updateSeq.sql > /dev/null
		psql -f sql/vacuumPlanet.sql > /dev/null
		next_osc=$((next_osc + 1))
		updateMaxCount=$((updateMaxCount - 1))
		success=1
	fi
done

if [[ $success -eq 1 ]]
then
	# Delete old entries in import schema
	echo Delete old elements ...
	psql -f sql/deleteOldEntries.sql > /dev/null

	# copy new entries
	echo Copy new elements ...
	psql -f sql/copyTables.sql > /dev/null

	# Refresh the materialized views
	echo Update views ...
	psql -f sql/updateMatViews.sql > /dev/null

	# rerun to fill all empty fields +  associatedStreets
	./reimport.sh full

	# truncate delete tables
	echo Truncate delete tables ...
	psql -f sql/truncateDeleteTables.sql > /dev/null

	# add one to seq number and update time
	echo Update time on database ...
	psql -f sql/updateTime.sql > /dev/null

	echo Finish
else
	echo Nothing loaded.
fi
