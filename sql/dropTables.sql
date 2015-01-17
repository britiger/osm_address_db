-- ignore NOTICE
SET client_min_messages TO WARNING;

-- DROP all existing tables
DROP TABLE IF EXISTS planet_osm_line CASCADE;
DROP TABLE IF EXISTS planet_osm_nodes CASCADE;
DROP TABLE IF EXISTS planet_osm_point CASCADE;
DROP TABLE IF EXISTS planet_osm_polygon CASCADE;
DROP TABLE IF EXISTS planet_osm_rels CASCADE;
DROP TABLE IF EXISTS planet_osm_roads CASCADE;
DROP TABLE IF EXISTS planet_osm_ways CASCADE;
