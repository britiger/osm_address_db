#!/bin/bash

# ID within database:
# externaldata.datasource.id = 3

# Import-Script for regiodata of Brandenburg, Germany
# Source: https://geobroker.geobasis-bb.de/gbss.php?MODE=GetProductInformation&PRODUCTID=39eb6261-37ab-45c8-8867-88304d4f908c (Format CSV)
# put the file 12_reg.txt in folder external/data/brandenburg
. ./basic.sh

if [ ! -f ../data/brandenburg/12-reg.csv ]
then
    echo_time "File 12_reg.csv not found."
    exit 1
fi

echo_time "Delete old Data ..."
psql -c "DELETE FROM externaldata.all_data WHERE datasource_id=3" > /dev/null
psql -c "CREATE TABLE IF NOT EXISTS externaldata.landbb_reg (KREISSCHLUESSEL INT,KATASTERBEHOERDE VARCHAR(255),GEMEINDESCHLUESSEL INT,GEMEINDE VARCHAR(255),GEMARKUNGSSCHLUESSEL INT,GEMARKUNG VARCHAR(255))" > /dev/null
psql -c "TRUNCATE TABLE externaldata.landbb_reg"
echo_time "Start Import Data ..."
cat ../data/brandenburg/12-reg.csv | psql -c "COPY externaldata.landbb_reg FROM STDIN DELIMITER ',' CSV HEADER"
echo_time "Process Data ..."
psql -f LandBB-reg.sql > /dev/null

echo_time "Completed"
