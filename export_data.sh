#!/bin/bash

. ./config 
. ./tools/bash_functions.sh

# mapping user and password
export PGHOST=$pghost
export PGPORT=$pgport
export PGUSER=$username
export PGPASSWORD=$password
export PGDATABASE=$database

# Creating nessesary directories
mkdir -p export

# Export roads by city
echo_time "Export roads to export/city_roads.csv ..."
psql -c "COPY (SELECT cr.road_name, oa.name city_name, cr.postal_code_tags FROM import.city_roads cr LEFT JOIN import.osm_admin oa ON cr.city_osm_id=oa.osm_id GROUP BY cr.road_name, oa.name, cr.postal_code_tags) TO STDOUT WITH (FORMAT CSV, HEADER, FORCE_QUOTE *);" > export/city_roads.csv

# Export postcode by city
echo_time "Export postcodes to export/city_postcode.csv ..."
psql -c "COPY (SELECT city_name, postal_code FROM import.city_postcode GROUP BY city_name, postal_code) TO STDOUT WITH (FORMAT CSV, HEADER, FORCE_QUOTE *);" > export/city_postcode.csv

# Export all addresses
echo_time "Export addresses to export/addresses.csv ..."
addr_fields='"addr:country", "addr:city", "addr:suburb", "addr:postcode", "addr:street", "addr:housenumber", "addr:housename"'
psql -c "COPY (SELECT $addr_fields, ST_X(ST_Transform(ST_Centroid(st_union(addr.geometry)),4326)) lon, ST_Y(ST_Transform(ST_Centroid(st_union(addr.geometry)),4326)) lat FROM import.osm_addresses addr GROUP BY $addr_fields) TO STDOUT WITH (FORMAT CSV, HEADER, FORCE_QUOTE *);" > export/addresses.csv
echo_time "Export completed."
