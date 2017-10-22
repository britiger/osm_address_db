-- ignore NOTICE
SET client_min_messages TO WARNING;

-- TABLEs

-- roads
CREATE INDEX IF NOT EXISTS osm_roads_geom ON import.osm_roads USING gist (geometry);
CREATE INDEX IF NOT EXISTS osm_roads_osm_id_idx ON import.osm_roads USING btree (osm_id);

-- places
CREATE INDEX IF NOT EXISTS osm_places_geom ON import.osm_places USING gist (geometry);
CREATE INDEX IF NOT EXISTS osm_places_osm_id_idx ON import.osm_places USING btree (osm_id);

-- postcode
CREATE INDEX IF NOT EXISTS osm_postcode_geom ON import.osm_postcode USING gist (geometry);
CREATE INDEX IF NOT EXISTS osm_postcode_osm_id_idx ON import.osm_postcode USING btree (osm_id);

-- admin
CREATE INDEX IF NOT EXISTS osm_admin_geom ON import.osm_admin USING gist (geometry);
CREATE INDEX IF NOT EXISTS osm_admin_osm_id_idx ON import.osm_admin USING btree (osm_id);
CREATE INDEX IF NOT EXISTS osm_admin_level_idx ON import.osm_admin USING btree (admin_level);
