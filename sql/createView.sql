-- ignore NOTICE
SET client_min_messages TO WARNING;

-- Drop old views
DROP MATERIALIZED VIEW IF EXISTS import.city_list_country CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.city_list CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.city_suburb CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.city_postcode CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.country_state CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.state_county CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.state_city CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.county_city CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.city_roads CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.city_places CASCADE;
DROP MATERIALIZED VIEW IF EXISTS import.osm_admin_hierarchy_max_level;
DROP MATERIALIZED VIEW IF EXISTS import.osm_admin_hierarchy;
DROP VIEW IF EXISTS import.osm_addresses_distance CASCADE;

-- Creating views in final import schema

-- All cities within a state
CREATE MATERIALIZED VIEW import.state_city
AS SELECT
city.name AS city_name, 
city.osm_id AS city_osm_id,
state.name AS state_name,
state.osm_id AS state_osm_id,
city.geometry
FROM import.osm_admin_8 AS city, 
import.osm_admin_4 AS state
WHERE ST_WITHIN(city.geometry, state.geometry);

-- All cities within a county
CREATE MATERIALIZED VIEW import.county_city
AS SELECT
city.name AS city_name, 
city.osm_id AS city_osm_id,
county.name AS county_name,
county.osm_id AS county_osm_id,
city.geometry
FROM import.osm_admin_8 AS city, 
import.osm_admin_6 AS county
WHERE ST_WITHIN(city.geometry, county.geometry);

CREATE INDEX county_city_county_osm_id_idx ON import.county_city (county_osm_id);
CREATE INDEX county_city_city_osm_id_idx ON import.county_city (city_osm_id);

-- All county within a state
CREATE MATERIALIZED VIEW import.state_county
AS SELECT
state.name AS state_name, 
state.osm_id AS state_osm_id,
county.name AS county_name,
county.osm_id AS county_osm_id,
(SELECT COUNT(*) FROM import.county_city AS rc WHERE rc.county_osm_id=county.osm_id) AS sub_count,
county.geometry
FROM import.osm_admin_4 AS state, 
import.osm_admin_6 AS county
WHERE ST_WITHIN(county.geometry, state.geometry);

CREATE INDEX state_county_state_osm_id_idx ON import.state_county (state_osm_id);
CREATE INDEX state_county_county_osm_id_idx ON import.state_county (county_osm_id);

-- All states within a country
CREATE MATERIALIZED VIEW import.country_state
AS SELECT
state.name AS state_name, 
state.osm_id AS state_osm_id,
country.name AS country_name,
country."ISO3166-1" AS country_code,
country.osm_id AS country_osm_id,
(SELECT COUNT(*) FROM import.state_county AS sr WHERE sr.state_osm_id=state.osm_id) AS sub_count_county,
(SELECT COUNT(*) FROM import.state_city AS sc WHERE sc.state_osm_id=state.osm_id) AS sub_count_city,
state.geometry
FROM import.osm_admin_4 AS state, 
import.osm_admin_2 AS country 
WHERE ST_WITHIN(state.geometry, country.geometry);

CREATE INDEX country_state_country_osm_id_idx ON import.country_state (country_osm_id);
CREATE INDEX country_state_state_osm_id_idx ON import.country_state (state_osm_id);

-- Build list of hierarchy for every admin_level
CREATE MATERIALIZED VIEW import.osm_admin_hierarchy
AS SELECT 	big.osm_id big_osm_id, small.osm_id small_osm_id,
		big.admin_level big_admin_level, small.admin_level small_admin_level,
		big.name big_name, small.name small_name
FROM 	import.osm_admin big,
	import.osm_admin small
WHERE st_intersects(big.geometry, small.geometry) 
  AND NOT st_touches(big.geometry, small.geometry)
  AND big.admin_level < small.admin_level;

CREATE INDEX osm_admin_big_osm_id_idx ON import.osm_admin_hierarchy (big_osm_id);
CREATE INDEX osm_admin_small_osm_id_idx ON import.osm_admin_hierarchy (small_osm_id);

-- List of all ploygons which are the last in hierachy (max. level 8) (city_list)
CREATE MATERIALIZED VIEW import.osm_admin_hierarchy_max_level
AS SELECT small_osm_id osm_id, small_name AS name, small_admin_level admin_level
FROM import.osm_admin_hierarchy hi
WHERE ( SELECT count(small_osm_id) 
		FROM import.osm_admin_hierarchy se 
		WHERE se.big_osm_id=hi.small_osm_id 
		  AND se.small_admin_level<=8 ) < 1
  AND small_admin_level<=8;

CREATE INDEX osm_admin_hierarchy_max_level_osm_id_idx ON import.osm_admin_hierarchy_max_level (osm_id);

-- List of all Cities
CREATE MATERIALIZED VIEW import.city_list
AS SELECT state_name AS city_name, state_osm_id AS city_osm_id, 'state' AS city_type, geometry FROM import.country_state WHERE sub_count_county=0 AND sub_count_city=0
UNION
SELECT county_name AS city_name, county_osm_id AS city_osm_id, 'county' AS city_type, geometry FROM import.state_county WHERE sub_count=0
UNION 
SELECT city_name, city_osm_id, 'city' AS city_type, geometry FROM import.county_city;

CREATE INDEX city_list_geom ON import.city_list USING gist(geometry);
CREATE INDEX city_list_city_osm_id ON import.city_list (city_osm_id);

-- Combine Cities with counties
CREATE MATERIALIZED VIEW import.city_list_country AS
SELECT city_osm_id, city_name, osm_id AS country_osm_id, "ISO3166-1", city_list.geometry
FROM import.city_list, import.osm_admin_2
WHERE ST_WITHIN(import.city_list.geometry,import.osm_admin_2.geometry);

CREATE INDEX city_list_country_geom ON import.city_list_country USING gist(geometry);
CREATE INDEX city_list_country_osm_id ON import.city_list_country (country_osm_id);

-- All postcodes within an state/county/city
CREATE MATERIALIZED VIEW import.city_postcode
AS SELECT
city_name,
city_osm_id,
postcode.postal_code AS postal_code,
postcode.osm_id AS postal_osm_id
FROM import.city_list AS city,
import.osm_postcode AS postcode
WHERE ST_INTERSECTS(city.geometry, postcode.geometry)
AND NOT ST_Touches(city.geometry, postcode.geometry);

-- List of Suburbs by cities
CREATE MATERIALIZED VIEW import.city_suburb
AS SELECT
city_name,
city_osm_id,
suburb.name AS suburb_name,
suburb.osm_id AS suburb_osm_id,
suburb.admin_level AS suburb_admin_level
FROM import.osm_admin_9_up AS suburb,
import.city_list
WHERE ST_WITHIN(suburb.geometry, city_list.geometry);

-- All Roads within a city
CREATE MATERIALIZED VIEW import.city_roads
AS SELECT 
road.name as road_name, 
city_osm_id, 
"addr:suburb" as suburb,
string_agg(road.osm_id::text, ',') as road_osm_ids,
ST_UNION(road.geometry) as roads_geom
FROM import.osm_roads as road, 
import.city_list
WHERE ST_INTERSECTS(road.geometry, city_list.geometry)
GROUP BY road_name, suburb, city_osm_id;

CREATE INDEX city_roads_idx_city ON import.city_roads USING btree (city_osm_id);
CREATE INDEX city_roads_road_name ON import.city_roads (road_name);

-- All Places within an city
CREATE MATERIALIZED VIEW import.city_places AS
SELECT 	place.name AS place_name,
	city_list.city_osm_id,
	string_agg(distinct place.type, ',') AS place_type, 
	string_agg(place.osm_id  || ';' || place.class, ',') AS place_osm_ids,
	st_union(place.geometry) AS place_geom
FROM 	import.osm_places place,
	import.city_list
WHERE st_within(place.geometry, city_list.geometry)
  AND place.type IN ('village','hamlet','suburb','neighbourhood')
GROUP BY place.name, city_list.city_osm_id;

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
