-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create View to fill street and filter useless tupels
CREATE MATERIALIZED VIEW IF NOT EXISTS osm_associated_with_street AS
SELECT *
FROM osm_associated AS asso
WHERE house_polygon_way IS NOT NULL 
   OR house_polygon_rel IS NOT NULL 
   OR house_point IS NOT NULL
WITH NO DATA;

-- Update view
REFRESH MATERIALIZED VIEW osm_associated_with_street;
