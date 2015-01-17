-- ignore NOTICE
SET client_min_messages TO WARNING;

-- DROP all existing tables
-- Delete-tables 
DROP TABLE IF EXISTS delete_line CASCADE;
DROP TABLE IF EXISTS delete_nodes CASCADE;
DROP TABLE IF EXISTS delete_point CASCADE;
DROP TABLE IF EXISTS delete_polygon CASCADE;
DROP TABLE IF EXISTS delete_rels CASCADE;
DROP TABLE IF EXISTS delete_roads CASCADE;
DROP TABLE IF EXISTS delete_ways CASCADE;

-- osm2pgsql-tables
DROP TABLE IF EXISTS planet_osm_line CASCADE;
DROP TABLE IF EXISTS planet_osm_nodes CASCADE;
DROP TABLE IF EXISTS planet_osm_point CASCADE;
DROP TABLE IF EXISTS planet_osm_polygon CASCADE;
DROP TABLE IF EXISTS planet_osm_rels CASCADE;
DROP TABLE IF EXISTS planet_osm_roads CASCADE;
DROP TABLE IF EXISTS planet_osm_ways CASCADE;
