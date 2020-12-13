#!/bin/bash

# ID within database:
# externaldata.datasource.id = 6

# Import-Script for Gemeinden in Brandenburg
# Source: https://geobroker.geobasis-bb.de/gbss.php?MODE=GetProductInformation&PRODUCTID=56f65bd3-ea75-40f9-afff-090a9fe3804f
#         https://geobasis-bb.de/lgb/de/geodaten/liegenschaftskataster/strassennamen-regionaldaten/
# put the file GemVerz.xlsx in external/data/brandenburg

. ./basic.sh

if [ ! -f ../data/brandenburg/GemVerz.xlsx ]
then
    echo_time "File GemVerz.xlsx not found."
    exit 1
fi

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
psql -c "DELETE FROM externaldata.all_data WHERE datasource_id=6" > /dev/null
psql -f LandBB-gem.sql > /dev/null

echo_time "Start Import Data ..."
python3 LandBB-gem.py

echo_time "Process Data ..."
psql -f LandBB-gem.sql > /dev/null

echo_time "Completed"
