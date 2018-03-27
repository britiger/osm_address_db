-- ignore NOTICE
SET client_min_messages TO WARNING;

-- This files contains some functions which usable for building web applications based on the tables

-- Create function for caching invalid addresses
-- create invalid addresses for a city in import.city_list
--  reslut can be generate in web.invalid_state (status of addresses generated in following table) 
--  and web.invalid_addresses (list of addresses)
CREATE OR REPLACE FUNCTION web.update_invalid_addresses(osm_id bigint, force boolean) 
RETURNS boolean
AS $$
DECLARE update_ts timestamptz;
DECLARE city_ts timestamptz;
DECLARE need_update boolean;
	BEGIN
		need_update := false;

		-- Add Dummy Entry if not existis
		INSERT INTO web.invalid_state (city_osm_id) VALUES ($1) ON CONFLICT DO NOTHING;
		-- Query current state
		SELECT last_update INTO city_ts FROM web.invalid_state WHERE city_osm_id = $1 AND suburb_osm_id = 0 FOR UPDATE;
		SELECT val INTO update_ts FROM config_values WHERE "key" = 'update_ts_address';
		IF city_ts IS NULL OR force = true OR city_ts < update_ts THEN
			need_update := true;
		END IF;
		IF need_update = true THEN
			-- Delete old entries
			DELETE FROM web.invalid_addresses WHERE city_osm_id = $1 AND suburb_osm_id = 0;
			-- Copy current invalid addresses
			INSERT INTO web.invalid_addresses
			SELECT city.osm_id AS city_osm_id, 0, addr.osm_id AS address_osm_id
			FROM import.osm_addresses AS addr 
			LEFT OUTER JOIN (SELECT city_osm_id, road_name FROM import.city_roads) AS road
				ON addr."addr:street" = road.road_name AND road.city_osm_id=$1,
				import.osm_admin AS city 
			WHERE city.osm_id=$1
				AND ST_WITHIN(addr.geometry, city.geometry)
				AND road_name IS NULL;
				
			-- UPDATE Statistics
			INSERT INTO statistics.road_addresses (osm_id, last_update, count_errors)
			VALUES ($1, update_ts, (SELECT count(address_osm_id) FROM web.invalid_addresses WHERE city_osm_id = $1 AND suburb_osm_id = 0))
			ON CONFLICT ON CONSTRAINT road_addresses_pk
  			DO UPDATE SET count_errors=EXCLUDED.count_errors;
			  
			-- UPDATE Status
			UPDATE web.invalid_state SET last_update=update_ts WHERE city_osm_id = $1 AND suburb_osm_id = 0;			
		END IF;
		RETURN need_update;
	END;
$$ LANGUAGE plpgsql
PARALLEL SAFE;

-- explaint on top, can create list of invalid addresses for a suburb within a city.
CREATE OR REPLACE FUNCTION web.update_invalid_addresses(c_osm_id bigint, sub_osm_id bigint, force boolean) 
RETURNS boolean
AS $$
DECLARE update_ts timestamptz;
DECLARE city_ts timestamptz;
DECLARE need_update boolean;
	BEGIN
		IF $2 = 0 THEN
			RETURN web.update_invalid_addresses($1, $3);
		END IF;

		need_update := false;

		-- Add Dummy Entry if not existis
		INSERT INTO web.invalid_state (city_osm_id, suburb_osm_id) VALUES ($1, $2) ON CONFLICT DO NOTHING;
		-- Query current state
		SELECT last_update INTO city_ts FROM web.invalid_state WHERE city_osm_id = $1 AND suburb_osm_id = $2 FOR UPDATE;
		SELECT val INTO update_ts FROM config_values WHERE "key" = 'update_ts_address';
		IF city_ts IS NULL OR force = true OR city_ts < update_ts THEN
			need_update := true;
		END IF;
		IF need_update = true THEN
			-- Delete old entries
			DELETE FROM web.invalid_addresses WHERE city_osm_id = $1 AND suburb_osm_id = $2;
			-- Copy current invalid addresses
			INSERT INTO web.invalid_addresses
			SELECT $1 AS city_osm_id, $2 AS suburb_osm_id, addr.osm_id AS address_osm_id
			FROM import.osm_addresses AS addr
			LEFT OUTER JOIN (SELECT city_osm_id, road_name FROM import.city_roads LEFT JOIN import.osm_admin ON ST_INTERSECTS(roads_geom,geometry) 
						WHERE city_osm_id=$1 AND osm_id=$2) AS road 
				ON addr."addr:street" = road.road_name, 
				import.osm_admin AS city
			WHERE city.osm_id=$2
				AND ST_WITHIN(addr.geometry, city.geometry) 
				AND road_name IS NULL;
				
			-- UPDATE Status
			UPDATE web.invalid_state SET last_update=update_ts WHERE city_osm_id = $1 AND suburb_osm_id = $2;
		END IF;
		RETURN need_update;
	END;
$$ LANGUAGE plpgsql
PARALLEL SAFE;

-- https://wiki.postgresql.org/wiki/First/last_(aggregate)
-- Create a function that always returns the first non-NULL item
CREATE OR REPLACE FUNCTION public.first_agg ( anyelement, anyelement )
RETURNS anyelement LANGUAGE SQL IMMUTABLE STRICT AS $$
        SELECT $1;
$$;
 
-- And then wrap an aggregate around it
DROP AGGREGATE IF EXISTS public.FIRST(anyelement);
CREATE AGGREGATE public.FIRST (
        sfunc    = public.first_agg,
        basetype = anyelement,
        stype    = anyelement
);

-- Create a function that always returns the last non-NULL item
CREATE OR REPLACE FUNCTION public.last_agg ( anyelement, anyelement )
RETURNS anyelement LANGUAGE SQL IMMUTABLE STRICT AS $$
        SELECT $2;
$$;
 
-- And then wrap an aggregate around it
DROP AGGREGATE IF EXISTS public.LAST(anyelement);
CREATE AGGREGATE public.LAST (
        sfunc    = public.last_agg,
        basetype = anyelement,
        stype    = anyelement
);
