-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create schema (and drop if exists)
DROP SCHEMA IF EXISTS  import CASCADE;
CREATE SCHEMA import;

-- osm_admin
CREATE TABLE import.osm_admin
(
  osm_id bigint,
  name text,
  admin_level integer,
  "ISO3166-1" text,
  geometry geometry
);

-- osm_postcode
CREATE TABLE import.osm_postcode
(
  osm_id bigint,
  postal_code text,
  geometry geometry
);

-- osm_places
CREATE TABLE import.osm_places
(
  osm_id bigint,
  class text,
  name text,
  type text,
  population bigint,
  geometry geometry
);

-- osm_roads
CREATE TABLE import.osm_roads
(
  osm_id bigint,
  name text,
  highway text,
  "addr:suburb" text,
  geometry geometry
);

-- osm_addresses (as partition table)
CREATE TABLE import.osm_addresses
(
  osm_id bigint,
  class text,
  "addr:country" text,
  "addr:city" text,
  "addr:postcode" text,
  "addr:street" text,
  "addr:housename" text,
  "addr:housenumber" text,
  "addr:suburb" text,
  "addr:place" text,
  "addr:hamlet" text,
  "source:addr:country" bigint,
  "source:addr:city" bigint,
  "source:addr:postcode" bigint,
  "source:addr:suburb" bigint,
  "source:addr:place" bigint,
  "source:addr:hamlet" bigint,
  "source:addr:street" bigint,
  geometry geometry,
  uptodate boolean DEFAULT FALSE
) PARTITION BY RANGE (osm_id);

-- Split into 9 Partitions
CREATE TABLE import.osm_addresses_00 PARTITION OF import.osm_addresses
  FOR VALUES FROM (MINVALUE)   TO  (150000000);
CREATE TABLE import.osm_addresses_01 PARTITION OF import.osm_addresses
  FOR VALUES FROM (150000001)  TO  (250000000);
CREATE TABLE import.osm_addresses_02 PARTITION OF import.osm_addresses
  FOR VALUES FROM (250000001)  TO  (350000000);
CREATE TABLE import.osm_addresses_03 PARTITION OF import.osm_addresses
  FOR VALUES FROM (350000001)  TO (1000000000);
CREATE TABLE import.osm_addresses_04 PARTITION OF import.osm_addresses
  FOR VALUES FROM (1000000001) TO (2000000000);
CREATE TABLE import.osm_addresses_05 PARTITION OF import.osm_addresses
  FOR VALUES FROM (2000000001) TO (3000000000);
CREATE TABLE import.osm_addresses_06 PARTITION OF import.osm_addresses
  FOR VALUES FROM (3000000001) TO (4000000000);
CREATE TABLE import.osm_addresses_07 PARTITION OF import.osm_addresses
  FOR VALUES FROM (4000000001) TO (5000000000);
CREATE TABLE import.osm_addresses_08 PARTITION OF import.osm_addresses
  FOR VALUES FROM (5000000001) TO (MAXVALUE);
