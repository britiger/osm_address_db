-- ignore NOTICE
SET client_min_messages TO WARNING;

-- Update addresses
UPDATE import.osm_addresses_XX AS addr
SET "addr:street" = asso.name,
	"source:addr:street" = asso.osm_id
FROM osm_associated_with_street AS asso
WHERE asso.name IS NOT NULL AND "addr:street" IS NULL
  AND ( (addr.class='point' AND addr.osm_id=asso.house_point) OR
        (addr.class='polygon' AND addr.osm_id=asso.house_polygon_way) OR
		(addr.class='polygon' AND addr.osm_id=asso.house_polygon_rel) );

ANALYSE import.osm_addresses_XX;
