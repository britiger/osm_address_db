-- ID: 1 - Land Brandenburg - OSM-Id Relation 62504

-- Metadata
INSERT INTO externaldata.datasource (id, sourcename, sourcedescription, license, link, hasstreet) 
    VALUES (1,
        'Straßenverzeichnis Brandenburg',
        'Verzeichnis aller Straßen der Gemeinden in Brandenburg',
        '© GeoBasis-DE/LGB, dl-de/by-2-0',
        'https://geobroker.geobasis-bb.de/gbss.php?MODE=GetProductInformation&PRODUCTID=56f65bd3-ea75-40f9-afff-090a9fe3804f',
        true)
    ON CONFLICT DO NOTHING;
INSERT INTO externaldata.datasource_admin (datasource_id, admin_osm_id) 
    VALUES (1, -62504) 
    ON CONFLICT DO NOTHING;

-- copy street and city from source
UPDATE externaldata.all_data
SET "addr:street" = all_data ->> 'bezeichnung',
    "addr:city" = all_data ->> 'gemeinde',
    "addr:country" = 'DE'
WHERE datasource_id=1;

-- search admin boundary
UPDATE externaldata.all_data 
SET city_osm_id = o.osm_id
FROM import.osm_admin o 
WHERE datasource_id=1
  AND "de:amtlicher_gemeindeschluessel" = all_data ->> 'gemeindeschl'
;

-- validate data
UPDATE externaldata.all_data
SET is_valid = true
WHERE datasource_id=1
  AND (city_osm_id IS NOT NULL OR suburb_osm_id IS NOT NULL)
  AND all_data ->> 'strschl' NOT LIKE '99%' -- Plätze/Ortsteile
  AND all_data ->> 'strschl' NOT LIKE '98%' -- ? Gärten
  AND all_data ->> 'strschl' NOT LIKE '96%' -- ? 
  AND all_data ->> 'strschl' NOT LIKE '95%' -- ? Lokale Namen
  AND all_data ->> 'strschl' NOT LIKE '=%'  -- Gleise/Eisenbahn
  AND all_data ->> 'strschl' NOT LIKE 'X%'  -- Außerhalb des Ortes
  AND all_data ->> 'strschl' NOT LIKE 'Z%'  -- ?
  AND all_data ->> 'strschl' NOT LIKE 'W%'  -- Gewässer
  AND all_data ->> 'strschl' NOT LIKE 'K%'  -- Kreisstraße
  AND all_data ->> 'strschl' NOT LIKE 'L%'  -- Landesstraße
  AND all_data ->> 'strschl' NOT LIKE 'B%'  -- Bundestraße
  AND all_data ->> 'strschl' NOT LIKE 'A%'  -- Autobahn
  AND all_data ->> 'strschl' NOT LIKE 'F%'  -- Forststraßen
  AND all_data ->> 'strschl' NOT LIKE '%9999'  -- Germarkungen/Sonstiges
  AND char_length(all_data->>'strschl') <= 5 -- long strschl are waterways 
  ;

-- set source date of dataset
UPDATE externaldata.datasource 
  SET sourcedate=NOW()
WHERE id=1;

-- Update Views
REFRESH MATERIALIZED VIEW externaldata.street_data_city;
REFRESH MATERIALIZED VIEW externaldata.street_data;
