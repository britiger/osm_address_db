-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create Tables
CREATE UNLOGGED TABLE update_line AS SELECT osm_id, 'I'::char(1) AS update_type FROM planet_osm_line;
CREATE UNLOGGED TABLE update_nodes AS SELECT id AS osm_id, 'I'::char(1) AS update_type FROM planet_osm_nodes;
CREATE UNLOGGED TABLE update_point AS SELECT osm_id, 'I'::char(1) AS update_type FROM planet_osm_point;
CREATE UNLOGGED TABLE update_polygon AS SELECT osm_id, 'I'::char(1) AS update_type FROM planet_osm_polygon;
CREATE UNLOGGED TABLE update_rels AS SELECT id AS osm_id, 'I'::char(1) AS update_type FROM planet_osm_rels;
CREATE UNLOGGED TABLE update_roads AS SELECT osm_id, 'I'::char(1) AS update_type FROM planet_osm_roads;
CREATE UNLOGGED TABLE update_ways AS SELECT id AS osm_id, 'I'::char(1) AS update_type FROM planet_osm_ways;

