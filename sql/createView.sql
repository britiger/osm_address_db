-- ignore NOTICE
SET client_min_messages TO WARNING;

-- Drop old views
DROP MATERIALIZED VIEW IF EXISTS import.osm_admin_hierarchy CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.osm_admin_city CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.city_suburb CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.city_postcode CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.city_roads CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.city_places CASCADE;

DROP VIEW IF EXISTS import.osm_addresses_distance CASCADE;

-- Creating views in final import schema

-- Build list of hierarchy for every admin_level
CREATE MATERIALIZED VIEW import.osm_admin_hierarchy
AS SELECT 	big.osm_id big_osm_id, big.admin_level big_admin_level, big.name big_name,
		small.osm_id small_osm_id, small.admin_level small_admin_level, small.name small_name
FROM 	import.osm_admin big,
	import.osm_admin small
WHERE st_intersects(big.geometry, small.geometry) 
  AND NOT st_touches(big.geometry, small.geometry)
  AND big.admin_level < small.admin_level;

CREATE INDEX osm_admin_big_osm_id_idx ON import.osm_admin_hierarchy (big_osm_id);
CREATE INDEX osm_admin_small_osm_id_idx ON import.osm_admin_hierarchy (small_osm_id);

-- List of all ploygons which are the last in hierachy (max. level 8) (city list)
CREATE MATERIALIZED VIEW import.osm_admin_city
AS SELECT small_osm_id osm_id, small_name AS name, small_admin_level admin_level
FROM import.osm_admin_hierarchy hi
WHERE ( SELECT count(small_osm_id) 
		FROM import.osm_admin_hierarchy se 
		WHERE se.big_osm_id=hi.small_osm_id 
		  AND se.small_admin_level<=8 ) < 1
  AND small_admin_level<=8
GROUP BY osm_id, name, admin_level;

CREATE INDEX osm_admin_city_osm_id_idx ON import.osm_admin_city (osm_id);

-- Update Statistics
SET client_min_messages TO ERROR; -- ignore warnings of skipped tables
ANALYSE;
SET client_min_messages TO WARNING;

-- All postcodes within a city
CREATE MATERIALIZED VIEW import.city_postcode
AS SELECT
city.name AS city_name,
city.osm_id AS city_osm_id,
postcode.postal_code AS postal_code,
postcode.osm_id AS postal_osm_id
FROM (import.osm_admin_city AS city_list LEFT JOIN 
import.osm_admin AS city ON city.osm_id=city_list.osm_id),
import.osm_postcode AS postcode
WHERE ST_INTERSECTS(city.geometry, postcode.geometry)
AND NOT ST_Touches(city.geometry, postcode.geometry);

-- List of Suburbs by cities
CREATE MATERIALIZED VIEW import.city_suburb
AS SELECT
city.osm_id AS city_osm_id,
city.name AS city_name,
suburb.name AS suburb_name,
suburb.osm_id AS suburb_osm_id,
suburb.admin_level AS suburb_admin_level
FROM import.osm_admin AS suburb,
(import.osm_admin_city AS city_list LEFT JOIN 
import.osm_admin AS city ON city.osm_id=city_list.osm_id)
WHERE suburb.admin_level>8 AND
ST_WITHIN(suburb.geometry, city.geometry);

-- All Roads within a city
CREATE MATERIALIZED VIEW import.city_roads
AS SELECT 
road.name AS road_name, 
city.osm_id AS city_osm_id, 
"addr:suburb" as suburb,
string_agg(road.osm_id::text, ',') as road_osm_ids,
ST_UNION(road.geometry) as roads_geom
FROM import.osm_roads as road, 
(import.osm_admin_city AS city_list LEFT JOIN 
import.osm_admin AS city ON city.osm_id=city_list.osm_id)
WHERE ST_INTERSECTS(road.geometry, city.geometry)
GROUP BY road_name, suburb, city_osm_id;

CREATE INDEX city_roads_idx_city ON import.city_roads USING btree (city_osm_id);
CREATE INDEX city_roads_road_name ON import.city_roads (road_name);

-- All Places within an city
CREATE MATERIALIZED VIEW import.city_places AS
SELECT 	place.name AS place_name,
	city.osm_id AS city_osm_id,
	string_agg(distinct place.type, ',') AS place_type, 
	string_agg(place.osm_id  || ';' || place.class, ',') AS place_osm_ids,
	st_union(place.geometry) AS place_geom
FROM 	import.osm_places place,
	(import.osm_admin_city AS city_list LEFT JOIN 
	 import.osm_admin AS city ON city.osm_id=city_list.osm_id)
WHERE st_within(place.geometry, city.geometry)
  AND place.type IN ('village','hamlet','suburb','neighbourhood')
GROUP BY place.name, city.osm_id;

-- VIEW for finding errors (Distance between addresses)
CREATE OR REPLACE VIEW import.osm_addresses_distance AS 
SELECT 	a.osm_id AS osm_id_first, a.class AS class_first, 
	b.osm_id AS osm_id_second, b.class AS class_second, 
	ST_DISTANCE(ST_CENTROID(a.geometry), ST_CENTROID(b.geometry)) AS distance
FROM import.osm_addresses AS a, import.osm_addresses AS b
WHERE a.osm_id<b.osm_id
  AND a."addr:country" = b."addr:country"
  AND a."addr:city" = b."addr:city"
  AND a."addr:postcode" = b."addr:postcode"
  AND a."addr:suburb" = b."addr:suburb"
  AND a."addr:street" = b."addr:street"
  AND a."addr:housenumber" = b."addr:housenumber";
