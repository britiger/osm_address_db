#!/bin/bash

# ID within database:
# externaldata.datasource.id = 2

# Import-Script for adresses of Brandenburg, Germany
# Source: https://geobroker.geobasis-bb.de/gbss.php?MODE=GetProductInformation&PRODUCTID=51600a1d-c7a3-4211-aff8-e94fb7dc166d (Format GeoJSON)
# put the file geoadr.json in folder external/data/brandenburg
. ./basic.sh

if [ ! -f ../data/brandenburg/geoadr.json ]
then
    echo_time "File geoadr.json not found."
    exit 1
fi

# Check ogr2ogr
if [ -z `which ogr2ogr` ]
then
    echo_time "Please install ogr2ogr e.g. 'apt install gdal-bin'"
    exit 2
fi

OGR2OGR_PGSQL="host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER password=$PGPASSWORD SCHEMAS=externaldata"

echo_time "Setup Python ..."
python3 -m venv venv
if [ $? -ne 0 ]
then
    echo_time "Can't setup Python3 virtual enviroment."
    exit 2
fi
source ./venv/bin/activate
pip install --upgrade setuptools
pip install wheel
pip install -r  requirements.txt

echo_time "Delete old Data ..."
psql -c "DELETE FROM externaldata.all_data WHERE datasource_id=2" > /dev/null


echo_time "Start Import Data ..."

python3 LandBB-adr.py
ogr2ogr -f "PostgreSQL" PG:"$OGR2OGR_PGSQL" \
    -progress -f GeoJSON \
    -overwrite -lco GEOMETRY_NAME=geom \
    -s_srs EPSG:4326 \
    -t_srs EPSG:3857 \
    -nln landbb_adr \
    ../data/brandenburg/geoadr.json

echo_time "Process Data ..."
psql -f LandBB-adr.sql > /dev/null

echo_time "Completed"
