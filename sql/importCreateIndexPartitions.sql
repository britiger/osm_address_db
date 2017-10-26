-- ignore NOTICE
SET client_min_messages TO WARNING;

-- addresses
-- XX will be replaces with number of partition. see osmupdate.sh first
CREATE INDEX IF NOT EXISTS osm_addresses_XX_geom ON import.osm_addresses_XX USING gist (geometry);
CREATE INDEX IF NOT EXISTS osm_addresses_XX_osm_id_idx ON import.osm_addresses_XX (osm_id);
CREATE INDEX IF NOT EXISTS osm_addresses_XX_addr_street_idx ON import.osm_addresses_XX ("addr:street");
CREATE INDEX IF NOT EXISTS osm_addresses_XX_addr_country_idx ON import.osm_addresses_XX ("addr:country");
CREATE INDEX IF NOT EXISTS osm_addresses_XX_addr_city_idx ON import.osm_addresses_XX ("addr:city");
CREATE INDEX IF NOT EXISTS osm_addresses_XX_addr_postcode_idx ON import.osm_addresses_XX ("addr:postcode");
CREATE INDEX IF NOT EXISTS osm_addresses_XX_addr_suburb_idx ON import.osm_addresses_XX ("addr:suburb");
CREATE INDEX IF NOT EXISTS osm_addresses_XX_source_addr_country_idx ON import.osm_addresses_XX ("source:addr:country");
CREATE INDEX IF NOT EXISTS osm_addresses_XX_source_addr_city_idx ON import.osm_addresses_XX ("source:addr:city");
CREATE INDEX IF NOT EXISTS osm_addresses_XX_source_addr_postcode_idx ON import.osm_addresses_XX ("source:addr:postcode");
CREATE INDEX IF NOT EXISTS osm_addresses_XX_source_addr_suburb_idx ON import.osm_addresses_XX ("source:addr:suburb");
CREATE INDEX IF NOT EXISTS osm_addresses_XX_source_addr_street_idx ON import.osm_addresses_XX ("source:addr:street");
CREATE INDEX IF NOT EXISTS osm_addresses_XX_uptodate_idx ON import.osm_addresses_XX (uptodate) WHERE NOT uptodate;
