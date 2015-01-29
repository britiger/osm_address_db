-- Postcode
UPDATE import.osm_addresses AS addr
   SET "addr:postcode" = post.postal_code,
       "source:addr:postcode" = post.osm_id
FROM (SELECT osm_id, postal_code, geometry FROM import.osm_postcode) AS post
WHERE "addr:postcode" IS NULL
  AND addr.geometry && post.geometry AND ST_WITHIN(addr.geometry, post.geometry);

-- Cityname
UPDATE import.osm_addresses AS addr
   SET "addr:city" = city_name,
       "source:addr:city" = city_osm_id
FROM (SELECT city_osm_id, city_name, geometry FROM import.city_list) AS city
WHERE "addr:city" IS NULL
  AND addr.geometry && city.geometry AND ST_WITHIN(addr.geometry, city.geometry);
