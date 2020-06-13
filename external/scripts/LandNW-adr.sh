#!/bin/bash

# ID within database:
# externaldata.datasource.id = 5

# Import-Script for streets of Nordrhein-Westfalen, Germany
# Source: https://open.nrw/dataset/172a0ba8-d470-47c1-ac89-b85f8190ac7e
#
# unzip all files to data/nrw/

. ./basic.sh

if [ ! -f ../data/nrw/gebref.txt ]
then
    echo_time "File gebref.txt not found ..."
    exit 1
fi
if [ ! -f ../data/nrw/gebref_schluessel.txt ]
then
    echo_time "File gebref_schluessel.txt not found ..."
    exit 1
fi

# Check ogr2ogr
if [ -z `which ogr2ogr` ]
then
    echo_time "Please install ogr2ogr e.g. 'apt install gdal-bin'"
    exit 2
fi

echo_time "Delete old Data ..."
psql -c "DELETE FROM externaldata.all_data WHERE datasource_id=5" > /dev/null

echo_time "Start Import Data ..."
echo_time "Create tables "

psql -c "CREATE TABLE IF NOT EXISTS externaldata.landnw_adr_schl (ds char(1), lan char(2), rbz char(1), krs char(2), gmd char(3), name varchar(255))" > /dev/null
psql -c "CREATE TABLE IF NOT EXISTS externaldata.landnw_adr (nba char(1), oi varchar(128), qua char(1), lan char(2), rbz char(1), krs char(2), gmd char(3), ott char(4), sss char(5), hnr varchar(128), adz varchar(128), zzee varchar(128), nnnn varchar(128), stn varchar(128), datum char(10))" > /dev/null

psql -c "TRUNCATE externaldata.landnw_adr_schl" > /dev/null
psql -c "TRUNCATE externaldata.landnw_adr" > /dev/null
# CSV import
# NRW-Schlüssel
echo_time "Import Schlüssel"
grep -E '^G' ../data/nrw/gebref_schluessel.txt | psql -c "COPY externaldata.landnw_adr_schl FROM STDIN DELIMITER ';'"

# NRW-Adressen
echo_time "Import Adressen"
cat ../data/nrw/gebref.txt | psql -c "COPY externaldata.landnw_adr FROM STDIN DELIMITER ';'"

echo_time "Process Data ..."
psql -f LandNW-adr.sql > /dev/null

echo_time "Completed"
