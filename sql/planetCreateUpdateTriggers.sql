-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create functions

-- Address
CREATE OR REPLACE FUNCTION update_addresses_point() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_addresses_point (osm_id, update_type) VALUES (OLD.osm_id, 'D') ON CONFLICT DO NOTHING;
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_addresses_point (osm_id, update_type) VALUES (NEW.osm_id, 'U') ON CONFLICT DO NOTHING;
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_addresses_point (osm_id, update_type) VALUES (NEW.osm_id, 'I') ON CONFLICT DO NOTHING;
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- Address
CREATE OR REPLACE FUNCTION update_addresses_poly() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_addresses_poly (osm_id, update_type) VALUES (OLD.osm_id, 'D') ON CONFLICT DO NOTHING;
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_addresses_poly (osm_id, update_type) VALUES (NEW.osm_id, 'U') ON CONFLICT DO NOTHING;
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_addresses_poly (osm_id, update_type) VALUES (NEW.osm_id, 'I') ON CONFLICT DO NOTHING;
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- admin
CREATE OR REPLACE FUNCTION update_admin() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_admin (osm_id, update_type) VALUES (OLD.osm_id, 'D') ON CONFLICT DO NOTHING;
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_admin (osm_id, update_type) VALUES (NEW.osm_id, 'U') ON CONFLICT DO NOTHING;
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_admin (osm_id, update_type) VALUES (NEW.osm_id, 'I') ON CONFLICT DO NOTHING;
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- Relation Asso
CREATE OR REPLACE FUNCTION update_asso_street() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_asso_street (osm_id, update_type) VALUES (OLD.osm_id, 'D') ON CONFLICT DO NOTHING;
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_asso_street (osm_id, update_type) VALUES (NEW.osm_id, 'U') ON CONFLICT DO NOTHING;
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_asso_street (osm_id, update_type) VALUES (NEW.osm_id, 'I') ON CONFLICT DO NOTHING;
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- places
CREATE OR REPLACE FUNCTION update_places_point() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_places_point (osm_id, update_type) VALUES (OLD.osm_id, 'D') ON CONFLICT DO NOTHING;
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_places_point (osm_id, update_type) VALUES (NEW.osm_id, 'U') ON CONFLICT DO NOTHING;
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_places_point (osm_id, update_type) VALUES (NEW.osm_id, 'I') ON CONFLICT DO NOTHING;
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- places
CREATE OR REPLACE FUNCTION update_places_poly() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_places_poly (osm_id, update_type) VALUES (OLD.osm_id, 'D') ON CONFLICT DO NOTHING;
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_places_poly (osm_id, update_type) VALUES (NEW.osm_id, 'U') ON CONFLICT DO NOTHING;
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_places_poly (osm_id, update_type) VALUES (NEW.osm_id, 'I') ON CONFLICT DO NOTHING;
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- postcodes
CREATE OR REPLACE FUNCTION update_postcodes() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_postcodes (osm_id, update_type) VALUES (OLD.osm_id, 'D') ON CONFLICT DO NOTHING;
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_postcodes (osm_id, update_type) VALUES (NEW.osm_id, 'U') ON CONFLICT DO NOTHING;
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_postcodes (osm_id, update_type) VALUES (NEW.osm_id, 'I') ON CONFLICT DO NOTHING;
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;
-- roads
CREATE OR REPLACE FUNCTION update_roads() RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO update_roads (osm_id, update_type) VALUES (OLD.osm_id, 'D') ON CONFLICT DO NOTHING;
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO update_roads (osm_id, update_type) VALUES (NEW.osm_id, 'U') ON CONFLICT DO NOTHING;
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO update_roads (osm_id, update_type) VALUES (NEW.osm_id, 'I') ON CONFLICT DO NOTHING;
		RETURN NEW;
	END IF;
END
$BODY$
LANGUAGE plpgsql 
VOLATILE
PARALLEL SAFE;

-- add triggers for all tables
CREATE TRIGGER trigger_addresses_point BEFORE INSERT OR UPDATE OR DELETE ON imposm_addresses_point FOR EACH ROW EXECUTE PROCEDURE update_addresses_point();
CREATE TRIGGER trigger_addresses_poly BEFORE INSERT OR UPDATE OR DELETE ON imposm_addresses_poly FOR EACH ROW EXECUTE PROCEDURE update_addresses_poly();
CREATE TRIGGER trigger_admin BEFORE INSERT OR UPDATE OR DELETE ON imposm_admin FOR EACH ROW EXECUTE PROCEDURE update_admin();
CREATE TRIGGER trigger_asso_street BEFORE INSERT OR UPDATE OR DELETE ON imposm_asso_street FOR EACH ROW EXECUTE PROCEDURE update_asso_street();
CREATE TRIGGER trigger_places_point BEFORE INSERT OR UPDATE OR DELETE ON imposm_places_point FOR EACH ROW EXECUTE PROCEDURE update_places_point();
CREATE TRIGGER trigger_places_poly BEFORE INSERT OR UPDATE OR DELETE ON imposm_places_poly FOR EACH ROW EXECUTE PROCEDURE update_places_poly();
CREATE TRIGGER trigger_postcodes BEFORE INSERT OR UPDATE OR DELETE ON imposm_postcodes FOR EACH ROW EXECUTE PROCEDURE update_postcodes();
CREATE TRIGGER trigger_roads BEFORE INSERT OR UPDATE OR DELETE ON imposm_roads FOR EACH ROW EXECUTE PROCEDURE update_roads();
