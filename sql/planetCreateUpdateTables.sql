-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create Tables
CREATE UNLOGGED TABLE update_addresses_point AS SELECT DISTINCT osm_id, 'I'::char(1) AS update_type FROM imposm_addresses_point;
CREATE UNLOGGED TABLE update_addresses_poly AS SELECT DISTINCT osm_id, 'I'::char(1) AS update_type FROM imposm_addresses_poly;
CREATE UNLOGGED TABLE update_admin AS SELECT DISTINCT osm_id, 'I'::char(1) AS update_type FROM imposm_admin;
CREATE UNLOGGED TABLE update_asso_street AS SELECT DISTINCT osm_id, 'I'::char(1) AS update_type FROM imposm_asso_street;
CREATE UNLOGGED TABLE update_places_point AS SELECT DISTINCT osm_id, 'I'::char(1) AS update_type FROM imposm_places_point;
CREATE UNLOGGED TABLE update_places_poly AS SELECT DISTINCT osm_id, 'I'::char(1) AS update_type FROM imposm_places_poly;
CREATE UNLOGGED TABLE update_postcodes AS SELECT DISTINCT osm_id, 'I'::char(1) AS update_type FROM imposm_postcodes;
CREATE UNLOGGED TABLE update_roads AS SELECT DISTINCT osm_id, 'I'::char(1) AS update_type FROM imposm_roads;

-- constrains
ALTER TABLE update_addresses_point ADD CONSTRAINT update_addresses_point_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_addresses_poly ADD CONSTRAINT update_addresses_poly_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_admin ADD CONSTRAINT update_admin_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_asso_street ADD CONSTRAINT update_asso_street_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_places_point ADD CONSTRAINT update_places_point_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_places_poly ADD CONSTRAINT update_places_poly_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_postcodes ADD CONSTRAINT update_postcodes_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_roads ADD CONSTRAINT update_roads_unique_id_type UNIQUE (update_type, osm_id);

-- create table for storing lines for next full update
CREATE TABLE update_admin_full ( LIKE update_admin EXCLUDING CONSTRAINTS );
CREATE TABLE update_postcodes_full ( LIKE update_postcodes EXCLUDING CONSTRAINTS );
CREATE TABLE update_roads_full ( LIKE update_roads EXCLUDING CONSTRAINTS );

ALTER TABLE update_admin_full ADD CONSTRAINT update_admin_full_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_postcodes_full ADD CONSTRAINT update_postcodes_full_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_roads_full ADD CONSTRAINT update_roads_full_unique_id_type UNIQUE (update_type, osm_id);
