-- Create schema and table for statistics
SET client_min_messages TO WARNING;

CREATE SCHEMA IF NOT EXISTS statistics;

CREATE TABLE IF NOT EXISTS statistics.road_addresses  (
    osm_id bigint,
    last_update timestamptz,
    count_addresses int DEFAULT NULL,
    count_roads int DEFAULT NULL,
    count_errors int DEFAULT NULL,
    CONSTRAINT road_addresses_pk PRIMARY KEY(osm_id,last_update)
);
