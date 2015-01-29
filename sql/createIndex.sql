-- ignore NOTICE
SET client_min_messages TO WARNING;

-- TABLEs

-- roads
CREATE INDEX osm_roads_geom ON import.osm_roads USING gist (geometry);
CREATE INDEX osm_roads_osm_id_idx ON import.osm_roads USING btree (osm_id);

-- addresses
CREATE INDEX osm_addresses_geom ON import.osm_addresses USING gist (geometry);
CREATE INDEX osm_addresses_osm_id_idx ON import.osm_addresses USING btree (osm_id);
CREATE INDEX osm_addresses_addr_street_idx ON import.osm_addresses ("addr:street" text_pattern_ops);

CREATE INDEX osm_addresses_addr_country_idx ON import.osm_addresses ("addr:country" text_pattern_ops);
CREATE INDEX osm_addresses_addr_city_idx ON import.osm_addresses ("addr:city" text_pattern_ops);
CREATE INDEX osm_addresses_addr_postcode_idx ON import.osm_addresses ("addr:postcode" text_pattern_ops);
CREATE INDEX osm_addresses_addr_suburb_idx ON import.osm_addresses ("addr:suburb" text_pattern_ops);

CREATE INDEX osm_addresses_source_addr_country_idx ON import.osm_addresses ("source:addr:country");
CREATE INDEX osm_addresses_source_addr_city_idx ON import.osm_addresses ("source:addr:city");
CREATE INDEX osm_addresses_source_addr_postcode_idx ON import.osm_addresses ("source:addr:postcode");
CREATE INDEX osm_addresses_source_addr_suburb_idx ON import.osm_addresses ("source:addr:suburb");

-- places
CREATE INDEX osm_places_geom ON import.osm_places USING gist (geometry);
CREATE INDEX osm_places_osm_id_idx ON import.osm_places USING btree (osm_id);

-- postcode
CREATE INDEX osm_postcode_geom ON import.osm_postcode USING gist (geometry);
CREATE INDEX osm_postcode_osm_id_idx ON import.osm_postcode USING btree (osm_id);

-- admin 2
CREATE INDEX osm_admin_2_geom ON import.osm_admin_2 USING gist (geometry);
CREATE INDEX osm_admin_2_osm_id_idx ON import.osm_admin_2 USING btree (osm_id);

-- admin 4
CREATE INDEX osm_admin_4_geom ON import.osm_admin_4 USING gist (geometry);
CREATE INDEX osm_admin_4_osm_id_idx ON import.osm_admin_4 USING btree (osm_id);

-- admin 6
CREATE INDEX osm_admin_6_geom ON import.osm_admin_6 USING gist (geometry);
CREATE INDEX osm_admin_6_osm_id_idx ON import.osm_admin_6 USING btree (osm_id);

-- admin 8
CREATE INDEX osm_admin_8_geom ON import.osm_admin_8 USING gist (geometry);
CREATE INDEX osm_admin_8_osm_id_idx ON import.osm_admin_8 USING btree (osm_id);

-- admin 9 and upper
CREATE INDEX osm_admin_9_up_geom ON import.osm_admin_9_up USING gist (geometry);
CREATE INDEX osm_admin_9_up_osm_id_idx ON import.osm_admin_9_up USING btree (osm_id);


