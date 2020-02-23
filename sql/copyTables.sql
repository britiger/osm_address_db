-- ignore NOTICE
SET client_min_messages TO WARNING;

-- copy data into tables by timestamp

-- osm_admin

INSERT INTO import.osm_admin
SELECT osm_id, name, admin_level, "ISO3166-1", "de:amtlicher_gemeindeschluessel", ST_Union(geometry) AS geometry
FROM osm_admin
WHERE ((admin_level = 2 AND "ISO3166-1" IS NOT NULL) OR admin_level>2)
	AND osm_id IN (SELECT osm_id FROM update_admin WHERE update_type!='D')
GROUP BY osm_id, name, admin_level, "ISO3166-1", "de:amtlicher_gemeindeschluessel";

-- osm_postcode
INSERT INTO import.osm_postcode
SELECT osm_id, postal_code, ST_Union(geometry) AS geometry
FROM osm_postcode
WHERE osm_id IN (SELECT osm_id FROM update_postcodes WHERE update_type!='D')
GROUP BY osm_id, postal_code;

-- osm_places
INSERT INTO import.osm_places
SELECT osm_id, class, name, type, population, ST_Union(geometry) AS geometry
FROM osm_places
WHERE osm_id IN (SELECT osm_id FROM update_places WHERE update_type!='D')
GROUP BY osm_id, class, name, type, population;

-- osm_roads
INSERT INTO import.osm_roads
SELECT osm_id, name, highway, postal_code, "addr:suburb", geometry
FROM osm_roads
WHERE osm_id IN (SELECT osm_id FROM update_roads WHERE update_type!='D');
UPDATE import.osm_roads SET geometry=ST_ExteriorRing(geometry) WHERE ST_geometrytype(geometry) = 'ST_Polygon';

-- osm_addresses
INSERT INTO import.osm_addresses
SELECT osm_id, class,
	"addr:country", "addr:city", "addr:postcode", "addr:street", "addr:housename", "addr:housenumber", "addr:suburb", "addr:place", "addr:hamlet",
	NULL::bigint AS "source:addr:country", NULL::bigint AS "source:addr:city", NULL::bigint AS "source:addr:postcode", NULL::bigint AS "source:addr:suburb", NULL::bigint AS "source:addr:place", NULL::bigint AS "source:addr:hamlet", NULL::bigint AS "source:addr:street",
	ST_Union(geometry) AS geometry
FROM osm_addresses
WHERE osm_id IN (SELECT osm_id FROM update_addresses WHERE update_type!='D')
GROUP BY osm_id, class,
	"addr:country", "addr:city", "addr:postcode", "addr:street", "addr:housename", "addr:housenumber", "addr:suburb", "addr:place", "addr:hamlet",
	"source:addr:country", "source:addr:city", "source:addr:postcode", "source:addr:suburb", "source:addr:place", "source:addr:hamlet", "source:addr:street";
