-- enable autovacuum for all tables

-- public
ALTER TABLE imposm_addresses_point SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE imposm_addresses_poly SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE imposm_admin SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE imposm_asso_street SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE imposm_places_point SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE imposm_places_poly SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE imposm_postcodes SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE imposm_roads SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
-- delete-tables
ALTER TABLE update_addresses_point SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_addresses_poly SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_admin SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_asso_street SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_places_point SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_places_poly SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_postcodes SET (
  autovacuum_enabled = true, toast.autovacuum_enabled = true
);
ALTER TABLE update_roads SET (
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
