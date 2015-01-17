-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create Tables
CREATE TABLE delete_line (osm_id bigint, timer timestamp DEFAULT NOW() );
CREATE TABLE delete_nodes (osm_id bigint, timer timestamp DEFAULT NOW() );
CREATE TABLE delete_point (osm_id bigint, timer timestamp DEFAULT NOW() );
CREATE TABLE delete_polygon (osm_id bigint, timer timestamp DEFAULT NOW() );
CREATE TABLE delete_rels (osm_id bigint, timer timestamp DEFAULT NOW() );
CREATE TABLE delete_roads (osm_id bigint, timer timestamp DEFAULT NOW() );
CREATE TABLE delete_ways (osm_id bigint, timer timestamp DEFAULT NOW() );
