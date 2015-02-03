-- ignore NOTICE
SET client_min_messages TO WARNING;

-- Vacuum Tables in import Schema
VACUUM ANALYSE import.osm_admin_2;
VACUUM ANALYSE import.osm_admin_4;
VACUUM ANALYSE import.osm_admin_6;
VACUUM ANALYSE import.osm_admin_8;
VACUUM ANALYSE import.osm_admin_9_up;
VACUUM ANALYSE import.osm_places;
VACUUM ANALYSE import.osm_postcode;
VACUUM ANALYSE import.osm_roads;
VACUUM ANALYSE import.osm_addresses;
