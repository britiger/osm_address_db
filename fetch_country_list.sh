#!/bin/sh

country_file=country_files/list.xml

# delete old list
if [ -f $country_file ] 
then
	rm $country_file
fi

# fetch list via overpass-api
#    (relation[admin_level=2];)->.admin;relation.admin[boundary=administrative];out;

wget http://overpass-api.de/api/interpreter?data=\(relation%5Badmin_level%3D2%5D%3B\)-%3E.admin%3Brelation.admin%5Bboundary%3Dadministrative%5D%3Bout%3B  -O $country_file

# TODO: list all containg country-codes
