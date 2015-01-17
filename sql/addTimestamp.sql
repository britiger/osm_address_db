-- ignore NOTICE
SET client_min_messages TO WARNING;

-- adding timestamp column
ALTER TABLE planet_osm_line ADD last_update timestamp DEFAULT NOW();
ALTER TABLE planet_osm_nodes ADD last_update timestamp DEFAULT NOW();
ALTER TABLE planet_osm_point ADD last_update timestamp DEFAULT NOW();
ALTER TABLE planet_osm_polygon ADD last_update timestamp DEFAULT NOW();
ALTER TABLE planet_osm_rels ADD last_update timestamp DEFAULT NOW();
ALTER TABLE planet_osm_roads ADD last_update timestamp DEFAULT NOW();
ALTER TABLE planet_osm_ways ADD last_update timestamp DEFAULT NOW();
