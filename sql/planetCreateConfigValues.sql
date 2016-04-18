-- adding config table with timestamp for copy
CREATE TABLE config_values (key varchar(255) PRIMARY KEY, val varchar(255) NOT NULL);
INSERT INTO config_values VALUES ('last_update', '2006-07-04' );
INSERT INTO config_values VALUES ('update_ts_full', 'initial');
INSERT INTO config_values VALUES ('update_ts_address', 'initial');
