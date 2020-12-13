-- ID: 6 - Land Brandenburg - OSM-Id Relation 62504

-- Metadata
INSERT INTO externaldata.datasource (id, sourcename, sourcedescription, license, link, hassuburb) 
    VALUES (6,
        'Gemeinde- und Ortsteilverzeichnis Land Brandenburg',
        'Verzeichnis aller Gemeinden und Ortsteile in Brandenburg',
        '© GeoBasis-DE/LGB, dl-de/by-2-0',
        'https://geobroker.geobasis-bb.de/gbss.php?MODE=GetProductInformation&PRODUCTID=33e424b4-972f-421b-9775-1716496f321b',
        true)
    ON CONFLICT DO NOTHING;
INSERT INTO externaldata.datasource_admin (datasource_id, admin_osm_id) 
    VALUES (6, -62504) 
    ON CONFLICT DO NOTHING;

-- copy street and city from source
UPDATE externaldata.all_data
SET "addr:suburb" = all_data ->> 'name',
    "addr:country" = 'DE'
WHERE datasource_id=6;

-- search admin boundary
UPDATE externaldata.all_data 
SET city_osm_id = o.osm_id
FROM import.osm_admin o 
WHERE datasource_id=6
  AND "de:amtlicher_gemeindeschluessel" = all_data ->> 'ags'
;

-- validate data
UPDATE externaldata.all_data
SET is_valid = true
WHERE datasource_id=6
  AND city_osm_id IS NOT NULL
  AND all_data ->> 'status' IN ('KFS', 'AFS', 'AFG', 'STD', 'GEM', 'OTL')
;

-- Update Views
REFRESH MATERIALIZED VIEW externaldata.suburb_data;
