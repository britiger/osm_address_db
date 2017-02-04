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
ALTER TABLE delete_line SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE delete_nodes SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE delete_point SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE delete_polygon SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE delete_rels SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE delete_roads SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE delete_ways SET (
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
