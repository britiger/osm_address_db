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
  "de:amtlicher_gemeindeschluessel" text,
  "de:regionalschluessel" text,
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
  postal_code text,
  "addr:suburb" text,
  "de:strassenschluessel" text,
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
) PARTITION BY HASH (osm_id);

-- Split into 16 Partitions
CREATE TABLE import.osm_addresses_00 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 0);
CREATE TABLE import.osm_addresses_01 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 1);
CREATE TABLE import.osm_addresses_02 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 2);
CREATE TABLE import.osm_addresses_03 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 3);
CREATE TABLE import.osm_addresses_04 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 4);
CREATE TABLE import.osm_addresses_05 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 5);
CREATE TABLE import.osm_addresses_06 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 6);
CREATE TABLE import.osm_addresses_07 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 7);
CREATE TABLE import.osm_addresses_08 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 8);
CREATE TABLE import.osm_addresses_09 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 9);
CREATE TABLE import.osm_addresses_10 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 10);
CREATE TABLE import.osm_addresses_11 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 11);
CREATE TABLE import.osm_addresses_12 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 12);
CREATE TABLE import.osm_addresses_13 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 13);
CREATE TABLE import.osm_addresses_14 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 14);
CREATE TABLE import.osm_addresses_15 PARTITION OF import.osm_addresses
  FOR VALUES WITH (modulus 16, remainder 15);
