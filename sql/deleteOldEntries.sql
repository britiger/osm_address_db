﻿-- deletes old (deleted and updated entries)
-- osm_addresses
DELETE FROM import.osm_addresses AS addr
USING delete_polygon_point AS del
WHERE addr.osm_id=del.osm_id;

-- osm_admin_2
DELETE FROM import.osm_admin_2 AS admin
USING delete_polygon AS del
WHERE admin.osm_id=del.osm_id;

-- osm_admin_4
DELETE FROM import.osm_admin_4 AS admin
USING delete_polygon AS del
WHERE admin.osm_id=del.osm_id;

-- osm_admin_6
DELETE FROM import.osm_admin_6 AS admin
USING delete_polygon AS del
WHERE admin.osm_id=del.osm_id;

-- osm_admin_8
DELETE FROM import.osm_admin_8 AS admin
USING delete_polygon AS del
WHERE admin.osm_id=del.osm_id;

-- osm_admin_9_up
DELETE FROM import.osm_admin_9_up AS admin
USING delete_polygon AS del
WHERE admin.osm_id=del.osm_id;

-- osm_places
DELETE FROM import.osm_places AS places
USING delete_polygon_point AS del
WHERE places.osm_id=del.osm_id;

-- osm_postcodes
DELETE FROM import.osm_postcode AS postcode
USING delete_polygon AS del
WHERE postcode.osm_id=del.osm_id;

-- osm_roads
DELETE FROM import.osm_roads AS roads
USING delete_polygon_line AS del
WHERE roads.osm_id=del.osm_id;
