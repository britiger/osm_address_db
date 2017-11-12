
-- Moves data from temporaray update-Table for current full update
WITH moved_rows AS (
	DELETE 
	FROM update_admin_full u
	RETURNING u.*
)
INSERT INTO update_admin
SELECT * FROM moved_rows
ON CONFLICT DO NOTHING;

WITH moved_rows AS (
	DELETE 
	FROM update_roads_full u
	RETURNING u.*
)
INSERT INTO update_roads
SELECT * FROM moved_rows
ON CONFLICT DO NOTHING;