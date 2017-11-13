-- ignore NOTICE
SET client_min_messages TO WARNING;

-- create functions for analyse relations

-- returns the value for the given key or NULL
CREATE OR REPLACE FUNCTION getAssoStreet(bigint)
RETURNS text AS
'SELECT road.name
		FROM imposm_asso_street asso INNER JOIN imposm_roads road ON asso.role=''street'' AND asso.osm_id=$1 AND asso.member_osm_id=road.osm_id
		LIMIT 1;'
IMMUTABLE
LANGUAGE SQL
RETURNS NULL ON NULL INPUT;

-- function for rating housenumbers for sorting
CREATE OR REPLACE FUNCTION sort_housenumber(housenumber text) 
RETURNS bigint AS
$BODY$
DECLARE
	outnumber bigint := 0;
	retnumber bigint;
	number_part text;
	num text;
	multi_factor bigint := 1000000;
BEGIN
	num := housenumber;
	num := trim(leading ' ' from num);

	-- split first part full number from input
	number_part := substring(num from '^\d+');
	outnumber := number_part::bigint * multi_factor; 
	multi_factor := multi_factor / 1000;
	num := substr(num, length(number_part)+1);
	num := trim(leading ' ' from num);
	IF length(num) < 1 THEN
		RETURN outnumber; 
	END IF;
	
	-- extract partnums (1/2, 1/3)
	number_part := substring(num from '^1/\d+');
	IF number_part IS NOT NULL THEN
		num := substr(num, length(number_part)+1);
		num := trim(leading ' ' from num);
		number_part := substr(number_part, 3);
		outnumber := outnumber + number_part::bigint * multi_factor; 
		multi_factor := multi_factor / 1000;
		
		IF length(num) < 1 THEN
			RETURN outnumber; 
		END IF;
	END IF;

	-- extract alphabet (a,b,A,B)
	number_part := substring(num from '^[a-zA-Z]+');
	IF number_part IS NOT NULL THEN
		outnumber := outnumber + (ascii(upper(number_part))-64) * multi_factor;
		multi_factor := multi_factor / 1000;
		num := substr(num, length(number_part)+1);
		num := trim(leading ' ' from num);

		IF length(num) < 1 THEN
			RETURN outnumber; 
		END IF;
	END IF;

	-- is range of number
	IF substr(num, 1, 1) is not distinct from '-' 
	OR substr(num, 1, 1) is not distinct from ';' 
	OR substr(num, 1, 1) is not distinct from ',' 
	OR substr(num, 1, 1) is not distinct from '+'
	OR substr(num, 1, 1) is not distinct from '/' THEN
		retnumber := sort_housenumber(substr(num, 2))::float/1000000 * multi_factor;
		IF retnumber IS NOT NULL THEN
			outnumber := outnumber + retnumber;
		END IF;
		RETURN outnumber; 
	END IF;

	RAISE NOTICE 'INCOMPLETE RESULT: % of % (REST: %)',outnumber,housenumber,num;

	RETURN outnumber; 
END;
$BODY$ 
IMMUTABLE
PARALLEL SAFE
RETURNS NULL ON NULL INPUT
LANGUAGE plpgsql;
