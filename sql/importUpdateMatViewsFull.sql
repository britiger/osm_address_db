-- ignore NOTICE
SET client_min_messages TO WARNING;

REFRESH MATERIALIZED VIEW import.osm_admin_hierarchy;
REFRESH MATERIALIZED VIEW import.osm_admin_city;

-- TODO: Test REFRESH MATERIALIZED VIEW CONCURRENTLY
REFRESH MATERIALIZED VIEW import.city_postcode;
REFRESH MATERIALIZED VIEW import.city_roads;
REFRESH MATERIALIZED VIEW import.city_places;
