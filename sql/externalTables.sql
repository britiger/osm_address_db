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
    link VARCHAR(255),
    hassuburb boolean DEFAULT false,
    hasstreet boolean DEFAULT false,
    hasaddress boolean DEFAULT false
);

-- Table contains osm_ids of admininistraive boundaries for datasources
CREATE TABLE IF NOT EXISTS externaldata.datasource_admin (
    datasource_id BIGINT,
    admin_osm_id BIGINT,
    UNIQUE (datasource_id, admin_osm_id)
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
CREATE INDEX IF NOT EXISTS all_data_datasource_idx ON externaldata.all_data (datasource_id);

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
  AND "addr:street" IS NOT NULL
GROUP BY city_osm_id,
    suburb_osm_id,
    "addr:country",
    "addr:city",
    "addr:postcode",
    "addr:street",
    "addr:suburb"
;
CREATE INDEX IF NOT EXISTS street_data_idx ON externaldata.street_data (city_osm_id);
CREATE INDEX IF NOT EXISTS street_data_upper_idx ON externaldata.street_data (UPPER("addr:street"));

CREATE MATERIALIZED VIEW IF NOT EXISTS externaldata.street_data_city AS
SELECT array_agg(DISTINCT datasource_id) AS datasource_ids, 
    city_osm_id,
    "addr:country",
    "addr:city",
    "addr:postcode",
    "addr:street"
FROM externaldata.all_data
WHERE is_valid = true
  AND "addr:street" IS NOT NULL
GROUP BY city_osm_id,
    "addr:country",
    "addr:city",
    "addr:postcode",
    "addr:street"
;
CREATE INDEX IF NOT EXISTS street_data_city_idx ON externaldata.street_data_city (city_osm_id);
CREATE INDEX IF NOT EXISTS street_data_city_upper_idx ON externaldata.street_data_city (UPPER("addr:street"));

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
CREATE INDEX IF NOT EXISTS address_data_idx ON externaldata.address_data (city_osm_id);
CREATE INDEX IF NOT EXISTS address_data_street_idx ON externaldata.address_data ("addr:street");
CREATE INDEX IF NOT EXISTS address_data_street_upper_idx ON externaldata.address_data (UPPER("addr:street"));

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
CREATE INDEX IF NOT EXISTS address_data_city_idx ON externaldata.address_data_city (city_osm_id);
CREATE INDEX IF NOT EXISTS address_data_city_street_idx ON externaldata.address_data_city ("addr:street");
CREATE INDEX IF NOT EXISTS address_data_city_street_upper_idx ON externaldata.address_data_city (UPPER("addr:street"));

-- View for suburbs per city
CREATE MATERIALIZED VIEW IF NOT EXISTS externaldata.suburb_data AS
SELECT array_agg(DISTINCT datasource_id) AS datasource_ids, 
    city_osm_id,
    "addr:country",
    "addr:city",
    "addr:suburb"
FROM externaldata.all_data
WHERE is_valid = true 
  AND "addr:suburb" IS NOT NULL
GROUP BY city_osm_id,
    "addr:country",
    "addr:city",
    "addr:suburb"
;
CREATE INDEX IF NOT EXISTS suburb_data_idx ON externaldata.suburb_data (city_osm_id);
