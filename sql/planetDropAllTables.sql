-- ignore NOTICE
SET client_min_messages TO WARNING;

-- DROP all existing tables
-- config
DROP TABLE IF EXISTS config_values CASCADE;

-- Update-tables 
DROP TABLE IF EXISTS update_line CASCADE;
DROP TABLE IF EXISTS update_nodes CASCADE;
DROP TABLE IF EXISTS update_point CASCADE;
DROP TABLE IF EXISTS update_polygon CASCADE;
DROP TABLE IF EXISTS update_rels CASCADE;
DROP TABLE IF EXISTS update_roads CASCADE;
DROP TABLE IF EXISTS update_ways CASCADE;

-- osm2pgsql-tables
DROP TABLE IF EXISTS planet_osm_line CASCADE;
DROP TABLE IF EXISTS planet_osm_nodes CASCADE;
DROP TABLE IF EXISTS planet_osm_point CASCADE;
DROP TABLE IF EXISTS planet_osm_polygon CASCADE;
DROP TABLE IF EXISTS planet_osm_rels CASCADE;
DROP TABLE IF EXISTS planet_osm_roads CASCADE;
DROP TABLE IF EXISTS planet_osm_ways CASCADE;

-- create Extension if not exists
CREATE EXTENSION IF NOT EXISTS postgis; 
