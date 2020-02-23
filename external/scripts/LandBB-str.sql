-- File for processing data imported

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
  ;

-- Update Views
REFRESH MATERIALIZED VIEW externaldata.street_data_city;
REFRESH MATERIALIZED VIEW externaldata.street_data;
