#!/bin/bash

# ID within database:
# externaldata.datasource.id = 1

# Import-Script for streets of Brandenburg, Germany
# Source: https://geobroker.geobasis-bb.de/gbss.php?MODE=GetProductInformation&PRODUCTID=56f65bd3-ea75-40f9-afff-090a9fe3804f
#         https://geobasis-bb.de/lgb/de/geodaten/liegenschaftskataster/strassennamen-regionaldaten/
# put the file LandBB-str.csv in external/data/brandenburg

. ./basic.sh

if [ ! -f ../data/brandenburg/LandBB-str.csv ]
then
    echo_time "File LandBB-str.csv not found."
    exit 1
fi

echo_time "Delete old Data ..."
psql -c "DELETE FROM externaldata.all_data WHERE datasource_id=1" > /dev/null

echo_time "Start Import Data ..."
echo_time "Create tables "

psql -c "CREATE TABLE IF NOT EXISTS externaldata.landbb_str (kreisschl CHAR(2), katasterbehoerde VARCHAR(64), gemeindeschl  CHAR(8), gemeinde VARCHAR(64), strschl VARCHAR(20), bezeichnung VARCHAR(64))" > /dev/null

psql -c "TRUNCATE externaldata.landbb_str" > /dev/null

echo_time "Import Straßen"
cat ../data/brandenburg/LandBB-str.csv | psql -c "COPY externaldata.landbb_str FROM STDIN DELIMITER ',' CSV HEADER"

echo_time "Process Data ..."
psql -f LandBB-str.sql > /dev/null

echo_time "Completed"
