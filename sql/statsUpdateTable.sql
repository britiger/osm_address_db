-- Update statistics table for osm_admin_city 

-- update global statistics
INSERT INTO statistics.road_addresses (osm_id, statedate, count_addresses, count_roads)
VALUES (0,
-- current update state
    (SELECT val FROM config_values WHERE key='last_update')::timestamptz,
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
INSERT INTO statistics.road_addresses (osm_id, statedate, count_addresses, count_roads)
SELECT oac.osm_id,
(SELECT val FROM config_values WHERE key='last_update')::timestamptz statedate,
(SELECT count(*) FROM import.osm_addresses addr WHERE ST_INTERSECTS(addr.geometry,oa.geometry) ) count_addresses,
(SELECT count(*) FROM import.city_roads WHERE city_osm_id=oac.osm_id) count_roads
FROM import.osm_admin_city oac LEFT JOIN import.osm_admin oa ON oac.osm_id=oa.osm_id
ON CONFLICT DO NOTHING;