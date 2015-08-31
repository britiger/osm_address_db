-- ignore NOTICE
SET client_min_messages TO WARNING;

-- copy data into tables by timestamp

-- osm_admin

INSERT INTO import.osm_admin
SELECT osm_id, name, admin_level, "ISO3166-1", ST_Union(geometry) AS geometry, max(last_update) AS last_update
FROM osm_admin
WHERE ((admin_level = 2 AND "ISO3166-1" IS NOT NULL) OR admin_level>2)
	AND osm_id < 0
	AND last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp
GROUP BY osm_id, name, admin_level, "ISO3166-1";

-- Level 2 - Country / Land
INSERT INTO import.osm_admin_2
SELECT osm_id, name, admin_level, "ISO3166-1", ST_Union(geometry) AS geometry, max(last_update) AS last_update
FROM osm_admin
WHERE admin_level = 2 AND "ISO3166-1" IS NOT NULL
	AND osm_id < 0
	AND last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp
GROUP BY osm_id, name, admin_level, "ISO3166-1";

-- Level 3
INSERT INTO import.osm_admin_3
SELECT osm_id, name, admin_level, ST_Union(geometry) AS geometry, max(last_update) AS last_update
FROM osm_admin
WHERE admin_level = 3
	AND osm_id < 0
	AND last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp
GROUP BY osm_id, name, admin_level;

-- Level 4 - State / Bundesland
INSERT INTO import.osm_admin_4
SELECT osm_id, name, admin_level, ST_Union(geometry) AS geometry, max(last_update) AS last_update
FROM osm_admin
WHERE admin_level = 4
	AND osm_id < 0
	AND last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp
GROUP BY osm_id, name, admin_level;

-- Level 5 - Regierungsbezirke
INSERT INTO import.osm_admin_5
SELECT osm_id, name, admin_level, ST_Union(geometry) AS geometry, max(last_update) AS last_update
FROM osm_admin
WHERE admin_level = 5
	AND osm_id < 0
	AND last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp
GROUP BY osm_id, name, admin_level;

-- Level 6 - County / Landkreis
INSERT INTO import.osm_admin_6
SELECT osm_id, name, admin_level, ST_Union(geometry) AS geometry, max(last_update) AS last_update
FROM osm_admin
WHERE admin_level = 6
	AND osm_id < 0
	AND last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp
GROUP BY osm_id, name, admin_level;

-- Level 7
INSERT INTO import.osm_admin_7
SELECT osm_id, name, admin_level, ST_Union(geometry) AS geometry, max(last_update) AS last_update
FROM osm_admin
WHERE admin_level = 7
	AND osm_id < 0
	AND last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp
GROUP BY osm_id, name, admin_level;

-- Level 8 - City-Town / Stadt-Gemeinde
INSERT INTO import.osm_admin_8
SELECT osm_id, name, admin_level, ST_Union(geometry) AS geometry, max(last_update) AS last_update
FROM osm_admin
WHERE admin_level = 8
	AND osm_id < 0
	AND last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp
GROUP BY osm_id, name, admin_level;

-- Level 9 and up - Parts of Cities
INSERT INTO import.osm_admin_9_up
SELECT osm_id, name, admin_level, ST_Union(geometry) AS geometry, max(last_update) AS last_update
FROM osm_admin
WHERE admin_level >= 9
	AND osm_id < 0
	AND last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp
GROUP BY osm_id, name, admin_level;

-- osm_postcode
INSERT INTO import.osm_postcode
SELECT osm_id, postal_code, ST_Union(geometry) AS geometry, max(last_update) AS last_update
FROM osm_postcode
WHERE last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp
GROUP BY osm_id, postal_code;

-- osm_places
INSERT INTO import.osm_places
SELECT osm_id, class, name, type, 
CASE WHEN population~E'^\\d+$' THEN population::bigint ELSE NULL::bigint END AS population,
ST_Union(geometry) AS geometry, max(last_update) AS last_update
FROM osm_places
WHERE last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp
GROUP BY osm_id, class, name, type, population;

-- osm_roads
INSERT INTO import.osm_roads
SELECT osm_id, name, highway, "addr:suburb", geometry, last_update
FROM osm_roads
WHERE last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp;
UPDATE import.osm_roads SET geometry=ST_ExteriorRing(geometry) WHERE ST_geometrytype(geometry) = 'ST_Polygon';

-- osm_addresses
INSERT INTO import.osm_addresses
SELECT osm_id, class,
	"addr:country", "addr:city", "addr:postcode", "addr:street", "addr:housename", "addr:housenumber", "addr:suburb", "addr:place", "addr:hamlet",
	NULL::bigint AS "source:addr:country", NULL::bigint AS "source:addr:city", NULL::bigint AS "source:addr:postcode", NULL::bigint AS "source:addr:suburb", NULL::bigint AS "source:addr:place", NULL::bigint AS "source:addr:hamlet", NULL::bigint AS "source:addr:street",
	ST_Union(geometry) AS geometry, max(last_update) AS last_update
FROM osm_addresses
WHERE last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp
GROUP BY osm_id, class,
	"addr:country", "addr:city", "addr:postcode", "addr:street", "addr:housename", "addr:housenumber", "addr:suburb", "addr:place", "addr:hamlet",
	"source:addr:country", "source:addr:city", "source:addr:postcode", "source:addr:suburb", "source:addr:place", "source:addr:hamlet", "source:addr:street";

