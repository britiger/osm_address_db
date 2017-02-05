-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create View to fill street and filter useless tupels
CREATE OR REPLACE VIEW osm_associated_with_street AS
SELECT osm_id,
	CASE WHEN name IS NULL THEN (SELECT name FROM osm_roads AS roads WHERE roads.osm_id=asso.street LIMIT 1) ELSE name END AS name,
	house_polygon, house_point
FROM osm_associated AS asso
WHERE house_polygon IS NOT NULL OR house_point IS NOT NULL;

-- Update addresses
UPDATE import.osm_addresses AS addr
SET "addr:street" = asso.name,
	"source:addr:street" = asso.osm_id
FROM osm_associated_with_street AS asso
WHERE asso.name IS NOT NULL AND "addr:street" IS NULL
  AND ( (addr.class='point' AND addr.osm_id=ANY(asso.house_point)) OR
        (addr.class='polygon' AND addr.osm_id=ANY(asso.house_polygon)) );

ANALYSE import.osm_addresses;
