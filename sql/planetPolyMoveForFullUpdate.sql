
-- Moves data from update-Table for next full update
WITH moved_rows AS (
	DELETE 
	FROM update_admin u
	RETURNING u.*
)
INSERT INTO update_admin_full
SELECT * FROM moved_rows
ON CONFLICT DO NOTHING;

WITH moved_rows AS (
	DELETE 
	FROM update_roads u
	RETURNING u.*
)
INSERT INTO update_roads_full
SELECT * FROM moved_rows
ON CONFLICT DO NOTHING;