-- ignore NOTICE
SET client_min_messages TO WARNING;

-- deletes old (deleted and updated entries)
-- osm_addresses
DELETE FROM import.osm_addresses AS addr
USING update_polygon_point AS del
WHERE addr.osm_id=del.osm_id 
  AND del.update_type != 'I';

-- osm_admin
DELETE FROM import.osm_admin AS admin
USING update_polygon AS del
WHERE admin.osm_id=del.osm_id 
  AND del.update_type != 'I';

-- osm_places
DELETE FROM import.osm_places AS places
USING update_polygon_point AS del
WHERE places.osm_id=del.osm_id 
  AND del.update_type != 'I';

-- osm_postcodes
DELETE FROM import.osm_postcode AS postcode
USING update_polygon AS del
WHERE postcode.osm_id=del.osm_id 
  AND del.update_type != 'I';

-- osm_roads
DELETE FROM import.osm_roads AS roads
USING update_polygon_line AS del
WHERE roads.osm_id=del.osm_id 
  AND del.update_type != 'I';

-- delete dependencies in osm_addresses
-- addr:country
UPDATE import.osm_addresses AS addr
SET "addr:country"=NULL, "source:addr:country"=NULL
FROM update_polygon as del
WHERE "source:addr:country"=del.osm_id
  AND del.update_type != 'I';
-- addr:city
UPDATE import.osm_addresses AS addr
SET "addr:city"=NULL, "source:addr:city"=NULL
FROM update_polygon as del
WHERE "source:addr:city"=del.osm_id
  AND del.update_type != 'I';
-- addr:postcode
UPDATE import.osm_addresses AS addr
SET "addr:postcode"=NULL, "source:addr:postcode"=NULL
FROM update_polygon as del
WHERE "source:addr:postcode"=del.osm_id
  AND del.update_type != 'I';
-- addr:street
UPDATE import.osm_addresses AS addr
SET "addr:street"=NULL, "source:addr:street"=NULL
FROM update_rels as del
WHERE "source:addr:street"=del.osm_id
  AND del.update_type != 'I';
