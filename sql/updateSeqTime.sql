UPDATE config_values SET "val"=now() WHERE "key"='last_update';
UPDATE config_values SET "val"="val"::int+1 WHERE "key"='next_osc';
