#!/bin/sh

# setting complete EU countries
countries="AL AD AT BY BE BA BG HR CY CZ DK EE FO FI FR DE GI GR HU IS IE IT LV LI LT LU MK MT MD MC NL NO PL PT RO RU SM RS SK SI ES SE CH UA GB VA RS IM RS ME"
countries="DE"

if [ $1 ]
then
	# parameter is given, use this as country code
	countries=$1
fi

# check list of country border
if [ ! -f country_files/list.xml ]
then
	# fetch list
	./fetch_country_list.sh
fi

for c in $countries
do
	echo fetching $c ...
	# delete old data for country
	rm country_files/country_${c}_*.osm 2> /dev/null
	# call python script found ids
	ids=`python python/found_country_id.py ${c}`

	num=0
	# loop over ids for this country
	for id in $ids
	do
		# set next increment
		num=$(( $num + 1 ))
		# load from api
		# Sample: relation(51477);>>;out;
		wget http://overpass-api.de/api/interpreter?data=relation\(${id}\)%3B%3E%3E%3Bout%3B  -O country_files/country_${c}_${num}.osm
	done

done
