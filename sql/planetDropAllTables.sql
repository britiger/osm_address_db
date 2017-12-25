-- ignore NOTICE
SET client_min_messages TO WARNING;

-- Dropping imposm3 schema
DROP SCHEMA IF EXISTS backup CASCADE;
DROP SCHEMA IF EXISTS imposm3 CASCADE;

-- DROP all existing tables
-- config
DROP TABLE IF EXISTS config_values CASCADE;

-- Update-tables 
DROP TABLE IF EXISTS update_addresses_point CASCADE;
DROP TABLE IF EXISTS update_addresses_poly CASCADE;
DROP TABLE IF EXISTS update_admin CASCADE;
DROP TABLE IF EXISTS update_admin_full CASCADE;
DROP TABLE IF EXISTS update_asso_street CASCADE;
DROP TABLE IF EXISTS update_places_point CASCADE;
DROP TABLE IF EXISTS update_places_poly CASCADE;
DROP TABLE IF EXISTS update_postcodes CASCADE;
DROP TABLE IF EXISTS update_postcodes_full CASCADE;
DROP TABLE IF EXISTS update_roads CASCADE;
DROP TABLE IF EXISTS update_roads_full CASCADE;

-- imposm3-tables
DROP TABLE IF EXISTS imposm_addresses_point CASCADE;
DROP TABLE IF EXISTS imposm_addresses_poly CASCADE;
DROP TABLE IF EXISTS imposm_admin CASCADE;
DROP TABLE IF EXISTS imposm_asso_street CASCADE;
DROP TABLE IF EXISTS imposm_places_point CASCADE;
DROP TABLE IF EXISTS imposm_places_poly CASCADE;
DROP TABLE IF EXISTS imposm_postcodes CASCADE;
DROP TABLE IF EXISTS imposm_roads CASCADE;

-- create Extension if not exists
CREATE EXTENSION IF NOT EXISTS postgis; 
