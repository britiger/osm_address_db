-- ignore NOTICE
SET client_min_messages TO WARNING;

-- adding timestamp column
ALTER TABLE planet_osm_line ADD last_update timestamp with time zone DEFAULT NOW();
--ALTER TABLE planet_osm_nodes ADD last_update timestamp with time zone DEFAULT NOW();
ALTER TABLE planet_osm_point ADD last_update timestamp with time zone DEFAULT NOW();
ALTER TABLE planet_osm_polygon ADD last_update timestamp with time zone DEFAULT NOW();
ALTER TABLE planet_osm_rels ADD last_update timestamp with time zone DEFAULT NOW();
--ALTER TABLE planet_osm_roads ADD last_update timestamp with time zone DEFAULT NOW();
--ALTER TABLE planet_osm_ways ADD last_update timestamp with time zone DEFAULT NOW();

-- adding config table with current timestamp
CREATE TABLE config_values (key varchar(255) PRIMARY KEY, val varchar(255) NOT NULL);
INSERT INTO config_values VALUES ('last_update', NOW() );
