-- ignore NOTICE
SET client_min_messages TO WARNING;

-- Vacuum tables in import schema
VACUUM ANALYSE import.osm_admin;
VACUUM ANALYSE import.osm_places;
VACUUM ANALYSE import.osm_postcode;
VACUUM ANALYSE import.osm_roads;
VACUUM ANALYSE import.osm_addresses;

-- Update statistis of all views
ANALYSE import.osm_admin_hierarchy;
ANALYSE import.osm_admin_city;
ANALYSE import.city_suburb;
ANALYSE import.city_postcode;
ANALYSE import.city_roads;
ANALYSE import.city_places;
