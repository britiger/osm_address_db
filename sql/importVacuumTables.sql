-- ignore NOTICE
SET client_min_messages TO WARNING;

-- Vacuum tables in import schema
ANALYSE import.osm_admin;
ANALYSE import.osm_places;
ANALYSE import.osm_postcode;
ANALYSE import.osm_roads;
ANALYSE import.osm_addresses;

-- Update statistis of all views
ANALYSE import.osm_admin_hierarchy;
ANALYSE import.osm_admin_city;
ANALYSE import.city_postcode;
ANALYSE import.city_roads;
ANALYSE import.city_places;
