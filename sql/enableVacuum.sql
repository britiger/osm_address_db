-- enable autovacuum for all tables

-- public
ALTER TABLE planet_osm_line SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE planet_osm_nodes SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE planet_osm_point SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE planet_osm_polygon SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE planet_osm_rels SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE planet_osm_roads SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE planet_osm_ways SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
-- delete-tables
ALTER TABLE update_line SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_nodes SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_point SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_polygon SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_rels SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_roads SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_ways SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);

-- import
ALTER TABLE import.osm_admin SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE import.osm_postcode SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE import.osm_places SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE import.osm_addresses SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE import.osm_roads SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
