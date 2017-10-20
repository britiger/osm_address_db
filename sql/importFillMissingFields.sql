-- TODO: check performance with and without && operator

SET from_collapse_limit = 1; -- needed for pgsql 9.5 to explicit join first

-- Postcode
UPDATE import.osm_addresses AS addr
   SET "addr:postcode" = post.postal_code,
       "source:addr:postcode" = post.osm_id
FROM import.osm_postcode AS post
WHERE "addr:postcode" IS NULL
  AND ST_WITHIN(addr.geometry, post.geometry);

ANALYSE import.osm_addresses;

-- Cityname
UPDATE import.osm_addresses AS addr
   SET "addr:city" = city.name,
       "source:addr:city" = city.osm_id
FROM (import.osm_admin_city AS city_list LEFT JOIN 
	 import.osm_admin AS city ON city.osm_id=city_list.osm_id)
WHERE "addr:city" IS NULL
  AND ST_WITHIN(addr.geometry, city.geometry);

ANALYSE import.osm_addresses;

-- Country
UPDATE import.osm_addresses AS addr
   SET "addr:country" = "ISO3166-1",
       "source:addr:country" = country.osm_id
FROM (SELECT * FROM import.osm_admin WHERE admin_level=2) AS country
WHERE "addr:country" IS NULL
  AND ST_WITHIN(addr.geometry, country.geometry);

UPDATE import.osm_addresses AS addr
   SET uptodate=TRUE
WHERE NOT uptodate;

ANALYSE import.osm_addresses;

SET from_collapse_limit = DEFAULT; -- reset planer value to default
