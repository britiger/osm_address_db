-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create Import Views

-- osm_admin
CREATE OR REPLACE VIEW osm_admin AS
	SELECT osm_id, name, admin_level::integer, "ISO3166-1", way AS geometry, last_update
	FROM planet_osm_polygon
	WHERE admin_level IN('1','2','3','4','5','6','7','8','9','10','11','12','13')
		AND name IS NOT NULL;

-- osm_places
CREATE OR REPLACE VIEW osm_places AS
	SELECT osm_id, 'polygon' AS class, name, place AS "type", population, way AS geometry, last_update
	FROM planet_osm_polygon
	WHERE place IS NOT NULL AND name IS NOT NULL
		UNION
	SELECT osm_id, 'point' AS class, name, place AS "type", population, way AS geometry, last_update
	FROM planet_osm_point  
	WHERE place IS NOT NULL AND name IS NOT NULL;

-- osm_postcodes
CREATE OR REPLACE VIEW osm_postcode AS
	SELECT osm_id, postal_code, way AS geometry, last_update
	FROM planet_osm_polygon
	WHERE postal_code IS NOT NULL;

-- osm_addresses
CREATE OR REPLACE VIEW osm_addresses AS
	SELECT osm_id, 'polygon' AS class,
		"addr:country", "addr:city", "addr:postcode", "addr:street", "addr:housename", "addr:housenumber", "addr:suburb", "addr:place", "addr:hamlet",
		"source:addr:country", "source:addr:city", "source:addr:postcode", "source:addr:street", "source:addr:housename", "source:addr:housenumber", "source:addr:suburb", "source:addr:place", "source:addr:hamlet",
		way AS geometry, last_update 
	FROM planet_osm_polygon
	WHERE "addr:housenumber" IS NOT NULL
		UNION
	SELECT osm_id, 'point' AS class,
		"addr:country", "addr:city", "addr:postcode", "addr:street", "addr:housename", "addr:housenumber", "addr:suburb", "addr:place", "addr:hamlet",
		"source:addr:country", "source:addr:city", "source:addr:postcode", "source:addr:street", "source:addr:housename", "source:addr:housenumber", "source:addr:suburb", "source:addr:place", "source:addr:hamlet",
		way AS geometry, last_update 
	FROM planet_osm_point
	WHERE "addr:housenumber" IS NOT NULL;

-- osm_associated (view for accociated streets)
CREATE OR REPLACE VIEW osm_associated AS
	SELECT id*-1 AS osm_id, getValueOf('name',tags) AS name,
		getMembersRoleType('house', 'polygon', members) AS house_polygon,
		getMembersRoleType('house', 'point', members) AS house_point,
		getMemberRoleType('street', 'way', members) AS street,
		last_update
	FROM planet_osm_rels WHERE 'associatedStreet' = ANY(tags);

-- osm_roads
CREATE OR REPLACE VIEW osm_roads AS
	SELECT osm_id, name, highway, way AS geometry, last_update
	FROM planet_osm_line
	WHERE name IS NOT NULL AND highway IS NOT NULL;
