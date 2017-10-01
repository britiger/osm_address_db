
-- Moves data from temporaray update-Table for current full update
WITH moved_rows AS (
	DELETE 
	FROM update_polygon_full u
	RETURNING u.*
)
INSERT INTO update_polygon
SELECT * FROM moved_rows
ON CONFLICT DO NOTHING;
