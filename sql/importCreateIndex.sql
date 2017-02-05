-- ignore NOTICE
SET client_min_messages TO WARNING;

-- TABLEs

-- roads
CREATE INDEX IF NOT EXISTS osm_roads_geom ON import.osm_roads USING gist (geometry);
CREATE INDEX IF NOT EXISTS osm_roads_osm_id_idx ON import.osm_roads USING btree (osm_id);

-- addresses
CREATE INDEX IF NOT EXISTS osm_addresses_geom ON import.osm_addresses USING gist (geometry);
CREATE INDEX IF NOT EXISTS osm_addresses_osm_id_idx ON import.osm_addresses USING btree (osm_id);
CREATE INDEX IF NOT EXISTS osm_addresses_addr_street_idx ON import.osm_addresses ("addr:street" text_pattern_ops);

CREATE INDEX IF NOT EXISTS osm_addresses_addr_country_idx ON import.osm_addresses ("addr:country" text_pattern_ops);
CREATE INDEX IF NOT EXISTS osm_addresses_addr_city_idx ON import.osm_addresses ("addr:city" text_pattern_ops);
CREATE INDEX IF NOT EXISTS osm_addresses_addr_postcode_idx ON import.osm_addresses ("addr:postcode" text_pattern_ops);
CREATE INDEX IF NOT EXISTS osm_addresses_addr_suburb_idx ON import.osm_addresses ("addr:suburb" text_pattern_ops);

CREATE INDEX IF NOT EXISTS osm_addresses_source_addr_country_idx ON import.osm_addresses ("source:addr:country");
CREATE INDEX IF NOT EXISTS osm_addresses_source_addr_city_idx ON import.osm_addresses ("source:addr:city");
CREATE INDEX IF NOT EXISTS osm_addresses_source_addr_postcode_idx ON import.osm_addresses ("source:addr:postcode");
CREATE INDEX IF NOT EXISTS osm_addresses_source_addr_suburb_idx ON import.osm_addresses ("source:addr:suburb");
CREATE INDEX IF NOT EXISTS osm_addresses_source_addr_street_idx ON import.osm_addresses ("source:addr:street");

CREATE INDEX IF NOT EXISTS osm_addresses_uptodate_idx ON import.osm_addresses (uptodate) WHERE NOT uptodate;

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

