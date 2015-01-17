-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create schema (and drop if exists)
DROP SCHEMA IF EXISTS  import CASCADE;
CREATE SCHEMA import;

-- copy data

-- osm_admin

-- Level 2 - Country / Land
SELECT osm_id, name, admin_level, "ISO3166-1", ST_Union(geometry) AS geometry, max(last_update) AS last_update
INTO import.osm_admin_2
FROM osm_admin
WHERE admin_level = 2
GROUP BY osm_id, name, admin_level, "ISO3166-1";

-- Level 4 - State / Bundesland
SELECT osm_id, name, admin_level, ST_Union(geometry) AS geometry, max(last_update) AS last_update
INTO import.osm_admin_4
FROM osm_admin
WHERE admin_level = 4
GROUP BY osm_id, name, admin_level;

-- Level 6 - County / Landkreis
SELECT osm_id, name, admin_level, ST_Union(geometry) AS geometry, max(last_update) AS last_update
INTO import.osm_admin_6
FROM osm_admin
WHERE admin_level = 6
GROUP BY osm_id, name, admin_level;

-- Level 8 - City-Town / Stadt-Gemeinde
SELECT osm_id, name, admin_level, ST_Union(geometry) AS geometry, max(last_update) AS last_update
INTO import.osm_admin_8
FROM osm_admin
WHERE admin_level = 8
GROUP BY osm_id, name, admin_level;

-- Level 9 and up - Parts of Cities
SELECT osm_id, name, admin_level, ST_Union(geometry) AS geometry, max(last_update) AS last_update
INTO import.osm_admin_9_up
FROM osm_admin
WHERE admin_level >= 9
GROUP BY osm_id, name, admin_level;

-- osm_postcode
SELECT osm_id, postal_code, ST_Union(way) AS geometry, max(last_update) AS last_update
INTO import.osm_postcode
FROM planet_osm_polygon
WHERE postal_code IS NOT NULL
GROUP BY osm_id, postal_code;

-- osm_places
SELECT osm_id, class, name, type, population::integer, ST_Union(geometry) AS geometry, max(last_update) AS last_update
INTO import.osm_places
FROM osm_places
GROUP BY osm_id, class, name, type, population;

-- osm_addresses

