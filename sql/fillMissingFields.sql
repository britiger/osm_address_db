-- TODO: check performance with and without && operator

-- Postcode
UPDATE import.osm_addresses AS addr
   SET "addr:postcode" = post.postal_code,
       "source:addr:postcode" = post.osm_id
FROM import.osm_postcode AS post
WHERE "addr:postcode" IS NULL
  AND ST_WITHIN(addr.geometry, post.geometry);

VACUUM ANALYSE import.osm_addresses;

-- Cityname
UPDATE import.osm_addresses AS addr
   SET "addr:city" = city_name,
       "source:addr:city" = city_osm_id
FROM import.city_list AS city
WHERE "addr:city" IS NULL
  AND ST_WITHIN(addr.geometry, city.geometry);

VACUUM ANALYSE import.osm_addresses;

-- Country
UPDATE import.osm_addresses AS addr
   SET "addr:country" = "ISO3166-1",
       "source:addr:country" = country_osm_id
FROM import.city_list_country AS country
WHERE "addr:country" IS NULL
  AND ST_WITHIN(addr.geometry, country.geometry);

VACUUM ANALYSE import.osm_addresses;
