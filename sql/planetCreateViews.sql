-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create Import Views

-- osm_admin
CREATE OR REPLACE VIEW osm_admin AS
	SELECT osm_id, name, admin_level::integer, NULLIF("ISO3166-1",'') AS "ISO3166-1", geometry
	FROM imposm_admin
	WHERE admin_level IN('1','2','3','4','5','6','7','8','9','10','11','12','13')
	  AND boundary='administrative'
	  AND name<>'';

-- osm_places
CREATE OR REPLACE VIEW osm_places AS
	SELECT osm_id, 'polygon' AS class, name, "type", population, geometry
	FROM imposm_places_poly 
	WHERE boundary<>'administrative' 
	  AND admin_level IS NULL 
	  AND name<>''
		UNION
	SELECT osm_id, 'point' AS class, name, "type", population, geometry
	FROM imposm_places_point
	WHERE name<>'';

-- osm_postcodes
CREATE OR REPLACE VIEW osm_postcode AS
	SELECT osm_id, postal_code, geometry
	FROM imposm_postcodes
	WHERE postal_code<>'';

-- osm_addresses
CREATE OR REPLACE VIEW osm_addresses AS
	SELECT osm_id, 'polygon' AS class,
		NULLIF("addr:country",'') AS "addr:country", NULLIF("addr:city",'') AS "addr:city", NULLIF("addr:postcode",'') AS "addr:postcode", 
		NULLIF("addr:street",'') AS "addr:street", NULLIF("addr:housename",'') AS "addr:housename", NULLIF("addr:housenumber",'') AS "addr:housenumber", 
		NULLIF("addr:suburb",'') AS "addr:suburb", NULLIF("addr:place",'') AS "addr:place", NULLIF("addr:hamlet",'') AS "addr:hamlet", geometry
	FROM imposm_addresses_poly
		UNION
	SELECT osm_id, 'point' AS class,
		NULLIF("addr:country",'') AS "addr:country", NULLIF("addr:city",'') AS "addr:city", NULLIF("addr:postcode",'') AS "addr:postcode", 
		NULLIF("addr:street",'') AS "addr:street", NULLIF("addr:housename",'') AS "addr:housename", NULLIF("addr:housenumber",'') AS "addr:housenumber", 
		NULLIF("addr:suburb",'') AS "addr:suburb", NULLIF("addr:place",'') AS "addr:place", NULLIF("addr:hamlet",'') AS "addr:hamlet", geometry
	FROM imposm_addresses_point;

-- osm_associated (view for accociated streets)
CREATE OR REPLACE VIEW osm_associated AS
	SELECT osm_id, 
		COALESCE(NULLIF(name,''), getAssoStreet(osm_id)) AS name,
		name AS name_tag,
		CASE WHEN member_type=0 THEN member_osm_id ELSE NULL END AS house_point,
		CASE WHEN member_type=1 THEN member_osm_id ELSE NULL END AS house_polygon_way,
		CASE WHEN member_type=2 THEN member_osm_id*-1 ELSE NULL END AS house_polygon_rel,
		getAssoStreet(osm_id) AS street
	FROM imposm_asso_street
	WHERE "role"='house';

-- osm_roads
CREATE OR REPLACE VIEW osm_roads AS
	SELECT osm_id, name, highway, NULLIF(postal_code,'') AS postal_code, NULLIF("addr:suburb",'') AS "addr:suburb", geometry
	FROM imposm_roads
	WHERE name<>'' AND highway<>'' AND highway NOT IN('platform', 'bus_stop', 'proposed');

-- union update-tables
CREATE OR REPLACE VIEW update_addresses AS
	SELECT osm_id, 'point' AS class, update_type
	FROM update_addresses_point
	UNION
	SELECT osm_id, 'polygon' AS class, update_type
	FROM update_addresses_poly;

CREATE OR REPLACE VIEW update_places AS
	SELECT osm_id, 'point' AS class, update_type
	FROM update_places_point
	UNION
	SELECT osm_id, 'polygon' AS class, update_type
	FROM update_places_poly;
	