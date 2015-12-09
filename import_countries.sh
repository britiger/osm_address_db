#!/bin/sh

. ./config 

# mapping user and password for osm2pgsql
export PGHOST=$pghost
export PGPORT=$pgport
export PGUSER=$username
export PGPASSWORD=$password
export PGDATABASE=$database

countryList=`ls country_files/*.osm`
for country in $countryList
do
	echo Importing country-file $country ...
	# import data into database
	osm2pgsql --create --prefix country --number-processes $o2pProcesses -C $o2pCache -H $pghost -P $pgport -d $database -S others/import.country.style -U $username $country
	# copy/replace country
	echo Copy country ...
	psql -f sql/copyCountry.sql > /dev/null
done

# update materilized views
echo Update views ...
psql -f sql/updateMatViews.sql > /dev/null
