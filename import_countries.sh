#!/bin/sh

. ./config 

# mapping user and password for osm2pgsql
export pguser=$username
export pgpass=$password
export PGPASS=$password

countryList=`ls country_files/*.osm`
for country in $countryList
do
	echo Importing country-file $country ...
	# import data into database
	osm2pgsql --create --prefix country --number-processes $o2pProcesses -C $o2pCache -H $pghost -d $database -S others/import.country.style -U $username $country

	# copy/replace country
	echo Copy country ...
	psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/copyCountry.sql > /dev/null
done

# update materilized views
echo Update views ...
psql "dbname=$database host=$pghost user=$username password=$password port=5432" -f sql/updateMatViews.sql > /dev/null
