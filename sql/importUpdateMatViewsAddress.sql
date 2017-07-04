-- ignore NOTICE
SET client_min_messages TO WARNING;

REFRESH MATERIALIZED VIEW import.city_places;
REFRESH MATERIALIZED VIEW import.osm_addresses_distance;
