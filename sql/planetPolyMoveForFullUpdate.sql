
-- Moves data from update-Table for next full update
WITH moved_rows AS (
	DELETE 
	FROM update_polygon u
	RETURNING u.*
)
INSERT INTO update_polygon_full
SELECT * FROM moved_rows
ON CONFLICT DO NOTHING;
