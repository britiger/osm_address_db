-- This files contains some tables which usable for building web applications

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
