-- This files contains some tables and views which usable for building web applications
SET client_min_messages TO WARNING;
-- Creating schema
CREATE SCHEMA IF NOT EXISTS web;

-- Table for storing false positives
CREATE TABLE IF NOT EXISTS web.osm_false_positive_double
(
  osm_id bigint NOT NULL,
  class text NOT NULL,
  verified_by character varying(255),
  CONSTRAINT pk_osm_id_class PRIMARY KEY (osm_id, class)
);

-- Tables for caching invalid addresses
CREATE UNLOGGED TABLE IF NOT EXISTS web.invalid_state (
	city_osm_id bigint,
	suburb_osm_id bigint DEFAULT 0,
	last_update timestamptz DEFAULT NULL,
	CONSTRAINT primary_invalid_state PRIMARY KEY(city_osm_id, suburb_osm_id)
);
CREATE UNLOGGED TABLE IF NOT EXISTS web.invalid_addresses (
	city_osm_id bigint,
	suburb_osm_id bigint DEFAULT 0,
	address_osm_id bigint
);
CREATE INDEX IF NOT EXISTS invalid_addresses_city_osm_id_idx ON web.invalid_addresses (city_osm_id, suburb_osm_id);

-- View for query addresses with distance to road
CREATE OR REPLACE VIEW import.osm_address_distance_road
AS
SELECT 
	adr.osm_id || ';' || adr.class AS address_osm_id,
	rd.road_osm_ids, 
	rd.road_name,
	adr."addr:city",
	adr."addr:housenumber",
	adr."addr:street",
	adr."addr:suburb",
	adr."addr:postcode",
	ST_Distance(adr.geometry, st_collect(rd.roads_geom)) distance,
	adr.geometry AS address_geometry,
	city_osm_id
FROM	
	import.city_roads rd 
		INNER JOIN import.osm_admin city ON rd.city_osm_id=city.osm_id
		INNER JOIN import.osm_addresses adr ON rd.road_name=adr."addr:street" AND ST_WITHIN(adr.geometry, city.geometry)
GROUP BY adr.osm_id, adr.class, rd.road_osm_ids, rd.road_name, adr.geometry, city_osm_id, adr."addr:city", adr."addr:housenumber", adr."addr:street", adr."addr:suburb", adr."addr:postcode";
