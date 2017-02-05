-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create functions

-- Line
CREATE OR REPLACE FUNCTION update_line() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_line (osm_id, update_type) VALUES (OLD.osm_id, 'D');
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_line (osm_id, update_type) VALUES (NEW.osm_id, 'U');
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_line (osm_id, update_type) VALUES (NEW.osm_id, 'I');
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- Nodes
CREATE OR REPLACE FUNCTION update_nodes() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_nodes (osm_id, update_type) VALUES (OLD.id, 'D');
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_nodes (osm_id, update_type) VALUES (NEW.id, 'U');
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_nodes (osm_id, update_type) VALUES (NEW.id, 'I');
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- Point
CREATE OR REPLACE FUNCTION update_point() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_point (osm_id, update_type) VALUES (OLD.osm_id, 'D');
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_point (osm_id, update_type) VALUES (NEW.osm_id, 'U');
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_point (osm_id, update_type) VALUES (NEW.osm_id, 'I');
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- Polygon
CREATE OR REPLACE FUNCTION update_polygon() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_polygon (osm_id, update_type) VALUES (OLD.osm_id, 'D');
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_polygon (osm_id, update_type) VALUES (NEW.osm_id, 'U');
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_polygon (osm_id, update_type) VALUES (NEW.osm_id, 'I');
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- Rels
CREATE OR REPLACE FUNCTION update_rels() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_rels (osm_id, update_type) VALUES (OLD.id, 'D');
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_rels (osm_id, update_type) VALUES (NEW.id, 'U');
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_rels (osm_id, update_type) VALUES (NEW.id, 'I');
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- Roads
CREATE OR REPLACE FUNCTION update_roads() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_roads (osm_id, update_type) VALUES (OLD.osm_id, 'D');
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_roads (osm_id, update_type) VALUES (NEW.osm_id, 'U');
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_roads (osm_id, update_type) VALUES (NEW.osm_id, 'I');
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- Ways
CREATE OR REPLACE FUNCTION update_ways() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_ways (osm_id, update_type) VALUES (OLD.id, 'D');
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_ways (osm_id, update_type) VALUES (NEW.id, 'U');
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_ways (osm_id, update_type) VALUES (NEW.id, 'I');
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;

-- add triggers for all tables
CREATE TRIGGER update_line_trigger BEFORE INSERT OR UPDATE OR DELETE ON planet_osm_line FOR EACH ROW EXECUTE PROCEDURE update_line();
--CREATE TRIGGER update_nodes_trigger BEFORE INSERT OR UPDATE OR DELETE ON planet_osm_nodes FOR EACH ROW EXECUTE PROCEDURE update_nodes();
CREATE TRIGGER update_point_trigger BEFORE INSERT OR UPDATE OR DELETE ON planet_osm_point FOR EACH ROW EXECUTE PROCEDURE update_point();
CREATE TRIGGER update_polygon_trigger BEFORE INSERT OR UPDATE OR DELETE ON planet_osm_polygon FOR EACH ROW EXECUTE PROCEDURE update_polygon();
CREATE TRIGGER update_rels_trigger BEFORE INSERT OR UPDATE OR DELETE ON planet_osm_rels FOR EACH ROW EXECUTE PROCEDURE update_rels();
--CREATE TRIGGER update_roads_trigger BEFORE INSERT OR UPDATE OR DELETE ON planet_osm_roads FOR EACH ROW EXECUTE PROCEDURE update_roads();
--CREATE TRIGGER update_ways_trigger BEFORE INSERT OR UPDATE OR DELETE ON planet_osm_ways FOR EACH ROW EXECUTE PROCEDURE update_ways();
