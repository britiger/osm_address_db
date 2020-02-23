-- This files contains tables and views for storing external data
SET client_min_messages TO WARNING;
-- Creating schema
CREATE SCHEMA IF NOT EXISTS externaldata;

CREATE TABLE IF NOT EXISTS externaldata.datasource (
    id serial PRIMARY KEY,
    sourcedate date,
    sourcename VARCHAR(255),
    sourcedescription TEXT,
    license VARCHAR(255),
    link VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS externaldata.all_data (
    id serial PRIMARY KEY,
    datasource_id BIGINT,
    city_osm_id BIGINT, -- osm_id of admin boundary
    suburb_osm_id BIGINT,
    "addr:country" TEXT,
    "addr:city" TEXT,
    "addr:postcode" TEXT,
    "addr:street" TEXT,
    "addr:housenumber" TEXT,
    "addr:suburb" TEXT,
    is_valid BOOLEAN DEFAULT false,
    all_data jsonb
);

-- View for all streets
CREATE MATERIALIZED VIEW IF NOT EXISTS externaldata.street_data AS
SELECT array_agg(DISTINCT datasource_id) AS datasource_ids, 
    city_osm_id,
    suburb_osm_id,
    "addr:country",
    "addr:city",
    "addr:postcode",
    "addr:street",
    "addr:suburb"
FROM externaldata.all_data
WHERE is_valid = true
GROUP BY city_osm_id,
    suburb_osm_id,
    "addr:country",
    "addr:city",
    "addr:postcode",
    "addr:street",
    "addr:suburb"
;

CREATE MATERIALIZED VIEW IF NOT EXISTS externaldata.street_data_city AS
SELECT array_agg(DISTINCT datasource_id) AS datasource_ids, 
    city_osm_id,
    "addr:country",
    "addr:city",
    "addr:postcode",
    "addr:street"
FROM externaldata.all_data
WHERE is_valid = true
GROUP BY city_osm_id,
    "addr:country",
    "addr:city",
    "addr:postcode",
    "addr:street"
;

-- View for all addresses
CREATE MATERIALIZED VIEW IF NOT EXISTS externaldata.address_data AS
SELECT array_agg(DISTINCT datasource_id) AS datasource_ids, 
    city_osm_id,
    suburb_osm_id,
    "addr:country",
    "addr:city",
    "addr:postcode",
    "addr:street",
    "addr:housenumber",
    "addr:suburb"
FROM externaldata.all_data
WHERE is_valid = true 
  AND "addr:housenumber" IS NOT NULL
GROUP BY city_osm_id,
    suburb_osm_id,
    "addr:country",
    "addr:city",
    "addr:postcode",
    "addr:street",
    "addr:housenumber",
    "addr:suburb"
;

CREATE MATERIALIZED VIEW IF NOT EXISTS externaldata.address_data_city AS
SELECT array_agg(DISTINCT datasource_id) AS datasource_ids, 
    city_osm_id,
    "addr:country",
    "addr:city",
    "addr:postcode",
    "addr:street",
    "addr:housenumber"
FROM externaldata.all_data
WHERE is_valid = true 
  AND "addr:housenumber" IS NOT NULL
GROUP BY city_osm_id,
    "addr:country",
    "addr:city",
    "addr:postcode",
    "addr:street",
    "addr:housenumber"
;
