-- disable autovacuum for all tables

-- public
ALTER TABLE planet_osm_line SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE planet_osm_nodes SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE planet_osm_point SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE planet_osm_polygon SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE planet_osm_rels SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE planet_osm_roads SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE planet_osm_ways SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
-- delete-tables
ALTER TABLE update_line SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE update_nodes SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE update_point SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE update_polygon SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE update_rels SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE update_roads SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE update_ways SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);

-- import
ALTER TABLE import.osm_admin SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE import.osm_postcode SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE import.osm_places SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE import.osm_addresses SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
ALTER TABLE import.osm_roads SET (
  autovacuum_enabled = false, toast.autovacuum_enabled = false
);
