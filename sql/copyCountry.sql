-- ignore NOTICE
SET client_min_messages TO WARNING;

-- remove old country
DELETE FROM import.osm_admin_2 WHERE osm_id IN (SELECT osm_id FROM country_polygon WHERE admin_level='2');

-- insert new counties
INSERT INTO import.osm_admin_2
SELECT osm_id, name, admin_level::int, "ISO3166-1", ST_UNION(way) AS geometry, NOW() AS last_update
FROM country_polygon
WHERE admin_level='2'AND "ISO3166-1" IS NOT NULL
GROUP BY osm_id, name, admin_level, "ISO3166-1", last_update;
