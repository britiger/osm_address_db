-- ignore NOTICE
SET client_min_messages TO WARNING;

CREATE INDEX osm_roads_geom ON import.osm_roads USING gist (geometry);
CREATE INDEX osm_roads_osm_id_idx ON import.osm_roads USING btree (osm_id);

CREATE INDEX osm_addresses_geom ON import.osm_addresses USING gist (geometry);
CREATE INDEX osm_addresses_osm_id_idx ON import.osm_addresses USING btree (osm_id);

CREATE INDEX osm_places_geom ON import.osm_places USING gist (geometry);
CREATE INDEX osm_places_osm_id_idx ON import.osm_places USING btree (osm_id);

CREATE INDEX osm_postcode_geom ON import.osm_postcode USING gist (geometry);
CREATE INDEX osm_postcode_osm_id_idx ON import.osm_postcode USING btree (osm_id);

CREATE INDEX osm_admin_2_geom ON import.osm_admin_2 USING gist (geometry);
CREATE INDEX osm_admin_2_osm_id_idx ON import.osm_admin_2 USING btree (osm_id);

CREATE INDEX osm_admin_4_geom ON import.osm_admin_4 USING gist (geometry);
CREATE INDEX osm_admin_4_osm_id_idx ON import.osm_admin_4 USING btree (osm_id);

CREATE INDEX osm_admin_6_geom ON import.osm_admin_6 USING gist (geometry);
CREATE INDEX osm_admin_6_osm_id_idx ON import.osm_admin_6 USING btree (osm_id);

CREATE INDEX osm_admin_8_geom ON import.osm_admin_8 USING gist (geometry);
CREATE INDEX osm_admin_8_osm_id_idx ON import.osm_admin_8 USING btree (osm_id);

CREATE INDEX osm_admin_9_up_geom ON import.osm_admin_9_up USING gist (geometry);
CREATE INDEX osm_admin_9_up_osm_id_idx ON import.osm_admin_9_up USING btree (osm_id);
