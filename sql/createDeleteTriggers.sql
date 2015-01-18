-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create functions

-- Line
CREATE OR REPLACE FUNCTION delete_line() RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO delete_line (osm_id) VALUES (OLD.osm_id);
	RETURN OLD;
END
$BODY$
LANGUAGE plpgsql VOLATILE;
-- Nodes
CREATE OR REPLACE FUNCTION delete_nodes() RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO delete_nodes (osm_id) VALUES (OLD.osm_id);
	RETURN OLD;
END
$BODY$
LANGUAGE plpgsql VOLATILE;
-- Point
CREATE OR REPLACE FUNCTION delete_point() RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO delete_point (osm_id) VALUES (OLD.osm_id);
	RETURN OLD;
END
$BODY$
LANGUAGE plpgsql VOLATILE;
-- Polygon
CREATE OR REPLACE FUNCTION delete_polygon() RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO delete_polygon (osm_id) VALUES (OLD.osm_id);
	RETURN OLD;
END
$BODY$
LANGUAGE plpgsql VOLATILE;
-- Rels
CREATE OR REPLACE FUNCTION delete_rels() RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO delete_rels (osm_id) VALUES (OLD.osm_id);
	RETURN OLD;
END
$BODY$
LANGUAGE plpgsql VOLATILE;
-- Roads
CREATE OR REPLACE FUNCTION delete_roads() RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO delete_roads (osm_id) VALUES (OLD.osm_id);
	RETURN OLD;
END
$BODY$
LANGUAGE plpgsql VOLATILE;
-- Ways
CREATE OR REPLACE FUNCTION delete_ways() RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO delete_ways (osm_id) VALUES (OLD.osm_id);
	RETURN OLD;
END
$BODY$
LANGUAGE plpgsql VOLATILE;

-- add triggers for all tables
CREATE TRIGGER delete_line_trigger BEFORE DELETE ON planet_osm_line FOR EACH ROW EXECUTE PROCEDURE delete_line();
--CREATE TRIGGER delete_nodes_trigger BEFORE DELETE ON planet_osm_nodes FOR EACH ROW EXECUTE PROCEDURE delete_nodes();
CREATE TRIGGER delete_point_trigger BEFORE DELETE ON planet_osm_point FOR EACH ROW EXECUTE PROCEDURE delete_point();
CREATE TRIGGER delete_polygon_trigger BEFORE DELETE ON planet_osm_polygon FOR EACH ROW EXECUTE PROCEDURE delete_polygon();
CREATE TRIGGER delete_rels_trigger BEFORE DELETE ON planet_osm_rels FOR EACH ROW EXECUTE PROCEDURE delete_rels();
--CREATE TRIGGER delete_roads_trigger BEFORE DELETE ON planet_osm_roads FOR EACH ROW EXECUTE PROCEDURE delete_roads();
--CREATE TRIGGER delete_ways_trigger BEFORE DELETE ON planet_osm_ways FOR EACH ROW EXECUTE PROCEDURE delete_ways();
