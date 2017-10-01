-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create Tables
CREATE UNLOGGED TABLE update_line AS SELECT DISTINCT osm_id, 'I'::char(1) AS update_type FROM planet_osm_line;
CREATE UNLOGGED TABLE update_nodes AS SELECT DISTINCT id AS osm_id, 'I'::char(1) AS update_type FROM planet_osm_nodes;
CREATE UNLOGGED TABLE update_point AS SELECT DISTINCT osm_id, 'I'::char(1) AS update_type FROM planet_osm_point;
CREATE UNLOGGED TABLE update_polygon AS SELECT DISTINCT osm_id, 'I'::char(1) AS update_type FROM planet_osm_polygon;
CREATE UNLOGGED TABLE update_rels AS SELECT DISTINCT id AS osm_id, 'I'::char(1) AS update_type FROM planet_osm_rels;
CREATE UNLOGGED TABLE update_roads AS SELECT DISTINCT osm_id, 'I'::char(1) AS update_type FROM planet_osm_roads;
CREATE UNLOGGED TABLE update_ways AS SELECT DISTINCT id AS osm_id, 'I'::char(1) AS update_type FROM planet_osm_ways;

-- constrains
ALTER TABLE update_line ADD CONSTRAINT update_line_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_nodes ADD CONSTRAINT update_nodes_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_point ADD CONSTRAINT update_point_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_polygon ADD CONSTRAINT update_polygon_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_rels ADD CONSTRAINT update_rels_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_roads ADD CONSTRAINT update_roads_unique_id_type UNIQUE (update_type, osm_id);
ALTER TABLE update_ways ADD CONSTRAINT update_ways_unique_id_type UNIQUE (update_type, osm_id);

-- create table for storing lines for next full update
CREATE TABLE update_polygon_full ( LIKE update_polygon EXCLUDING CONSTRAINTS );

ALTER TABLE update_polygon_full ADD CONSTRAINT update_polygon_full_unique_id_type UNIQUE (update_type, osm_id);
