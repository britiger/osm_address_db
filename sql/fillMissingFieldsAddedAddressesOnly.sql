-- same as fillMissingFields.sql but with filter for new entries 

-- Postcode
UPDATE import.osm_addresses AS addr
   SET "addr:postcode" = post.postal_code,
       "source:addr:postcode" = post.osm_id
FROM import.osm_postcode AS post
WHERE "addr:postcode" IS NULL
  AND ST_WITHIN(addr.geometry, post.geometry)
  AND addr.last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp;

VACUUM ANALYSE import.osm_addresses;

-- Cityname
UPDATE import.osm_addresses AS addr
   SET "addr:city" = city_name,
       "source:addr:city" = city_osm_id
FROM import.city_list AS city
WHERE "addr:city" IS NULL
  AND ST_WITHIN(addr.geometry, city.geometry)
  AND addr.last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp;

VACUUM ANALYSE import.osm_addresses;

-- Country
UPDATE import.osm_addresses AS addr
   SET "addr:country" = "ISO3166-1",
       "source:addr:country" = country_osm_id
FROM import.city_list_country AS country
WHERE "addr:country" IS NULL
  AND ST_WITHIN(addr.geometry, country.geometry)
  AND addr.last_update>(SELECT val FROM config_values WHERE key='last_update')::timestamp;

VACUUM ANALYSE import.osm_addresses;
