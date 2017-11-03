-- Update statistics table for osm_admin_city 

-- update global statistics
INSERT INTO statistics.road_addresses (osm_id, last_update, count_addresses, count_roads)
VALUES (0,
-- current update state
    (SELECT val FROM config_values WHERE key='update_ts_address')::timestamptz,
-- count all addresses
    (SELECT count(*)
    FROM
    (SELECT 1
    FROM import.osm_addresses
    GROUP BY "addr:country", "addr:city", "addr:postcode", "addr:street", "addr:housename", "addr:housenumber", "addr:suburb") addr_list),
-- count all roads
    (SELECT count(*)
    FROM
    import.city_roads)
)
ON CONFLICT DO NOTHING;

-- update all cities
-- Update address_count
DO $$
BEGIN
  IF (SELECT val FROM config_values WHERE key='update_ts_address')::timestamptz <= (SELECT max(last_update) FROM statistics.road_addresses WHERE count_addresses IS NOT NULL AND osm_id<>0) THEN
    RAISE NOTICE 'No update for addresses needed.';
  ELSE
    INSERT INTO statistics.road_addresses AS stats (osm_id, last_update, count_addresses)
    SELECT oac.osm_id,
    (SELECT val FROM config_values WHERE key='update_ts_address')::timestamptz last_update,
    (SELECT count(*)
        FROM
        (SELECT 1
        FROM import.osm_addresses addr
        WHERE ST_INTERSECTS(addr.geometry,oa.geometry)
        GROUP BY "addr:country", "addr:city", "addr:postcode", "addr:street", "addr:housename", "addr:housenumber", "addr:suburb") addr_list) count_addresses
    FROM import.osm_admin_city oac LEFT JOIN import.osm_admin oa ON oac.osm_id=oa.osm_id
    ON CONFLICT ON CONSTRAINT road_addresses_pk
    DO UPDATE SET count_addresses=EXCLUDED.count_addresses
    WHERE stats.count_addresses IS NULL;
  END IF;
END$$;

-- Update road_count
DO $$
BEGIN
  IF (SELECT val FROM config_values WHERE key='update_ts_full')::timestamptz <= (SELECT max(last_update) FROM statistics.road_addresses WHERE count_roads IS NOT NULL AND osm_id<>0) THEN
    RAISE NOTICE 'No update for roads needed.';
  ELSE
    INSERT INTO statistics.road_addresses AS stats (osm_id, last_update, count_roads)
    SELECT oac.osm_id,
    (SELECT val FROM config_values WHERE key='update_ts_full')::timestamptz last_update,
    (SELECT count(*) FROM import.city_roads WHERE city_osm_id=oac.osm_id) count_roads
    FROM import.osm_admin_city oac LEFT JOIN import.osm_admin oa ON oac.osm_id=oa.osm_id
    ON CONFLICT ON CONSTRAINT road_addresses_pk
    DO UPDATE SET count_roads=EXCLUDED.count_roads
    WHERE stats.count_roads IS NULL;
  END IF;
END$$;
