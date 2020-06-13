#!/bin/bash

# ID within database:
# externaldata.datasource.id = 4

# Source (WFS): https://daten.berlin.de/datensaetze/adressen-berlin-wfs
# will be download if file not exists

# put the file berlin_adr.wfs in folder external/data/berlin
. ./basic.sh

mkdir -p ../data/berlin

if [ ! -f ../data/berlin/berlin_adr.wfs ]
then
    echo_time "Download file (WFS) ..."
    wget -O ../data/berlin/berlin_adr.wfs 'https://fbinter.stadt-berlin.de/fb/wfs/data/senstadt/s_wfs_adressenberlin?service=WFS&version=2.0.0&request=GetFeature&typeNames=fis:s_wfs_adressenberlin'
fi

# Check ogr2ogr
if [ -z `which ogr2ogr` ]
then
    echo_time "Please install ogr2ogr e.g. 'apt install gdal-bin'"
    exit 2
fi

OGR2OGR_PGSQL="host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER password=$PGPASSWORD SCHEMAS=externaldata"

echo_time "Delete old Data ..."
psql -c "DELETE FROM externaldata.all_data WHERE datasource_id=4" > /dev/null

echo_time "Start Import Data ..."

# python3 LandBB-adr.py
ogr2ogr -f "PostgreSQL" PG:"$OGR2OGR_PGSQL" \
    -progress \
    -overwrite -lco GEOMETRY_NAME=geom \
    -nln landbe_adr \
    ../data/berlin/berlin_adr.wfs

echo_time "Process Data ..."
psql -f LandBE-adr.sql > /dev/null

echo_time "Completed"