#!/bin/bash

# This script updates the imported data
# TODO: set initial update osc number in config
# TODO: set url for update in config
. ./config 

# mapping user and password for osm2pgsql
export pguser=$username
export pgpass=$password
export PGPASS=$password

# read seq-number
next_osc=`psql "dbname=$database host=$pghost user=$username password=$password port=5432" -t -c 'SELECT val FROM config_values WHERE "key"='\''next_osc'\'';'`

# create 3 Blocks of numbers
block3=$(($next_osc % 1000))
tmp=$(($next_osc / 1000))
block2=$(($tmp % 1000))
tmp=$(($tmp / 1000))
block1=$(($tmp % 1000))

printf -v num_path "%03d/%03d/%03d" $block1 $block2 $block3
url=$updatePath$num_path.osc.gz

if [ ! -d tmp ]; then
	mkdir tmp
fi
rm -f tmp/*

status=`curl -o tmp/update.osc.gz -D tmp/head.txt --silent --write-out '%{http_code} %{size_download}\n' $url`

# check status code
if [[ $status != "200"* ]]
then
	echo 'Error loading update with number' $next_osc ': HTTP-Status' `echo $status | awk '{print $1}'` '.'
	exit 1
fi

file_size_head=`cat tmp/head.txt | grep Content-Length | awk '{print $2+0}'`
file_size_load=`echo $status | awk '{print $2+0}'`
if [[ ! $file_size_load -eq $file_size_head ]]
then
	echo 'Error loading update with number $next_osc: illegal file size' $file_size_load 'loaded' $file_size_head 'expected.'
	exit 1
fi

## make update using tmp/update.osc.gz
osm2pgsql --append -s --number-processes $o2pProcesses -C $o2pCache -H $pghost -d $database -S others/import.style -U $username tmp/update.osc.gz

# add one to seq number and update time
echo Update seqence and update time on database ...
#psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/updateSeqTime.sql > /dev/null

echo Finish
