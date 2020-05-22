-- Germany -> Brandenburg -> Regionaldaten
INSERT INTO externaldata.datasource (id, sourcename, sourcedescription, license, link) 
VALUES (3,
  'Regionaldaten-Verzeichnis',
  'Verzeichnis der Kreise mit ihren Gemeinden und Gemarkungen',
  '© GeoBasis-DE/LGB, dl-de/by-2-0',
  'https://geobroker.geobasis-bb.de/gbss.php?MODE=GetProductInformation&PRODUCTID=39eb6261-37ab-45c8-8867-88304d4f908c') 
ON CONFLICT DO NOTHING;

INSERT INTO externaldata.datasource_admin (datasource_id, admin_osm_id) 
VALUES (3, -62504) 
ON CONFLICT DO NOTHING;

-- Copy Data from import to all_data
INSERT INTO externaldata.all_data
    (datasource_id, all_data, "addr:country", "addr:city", "addr:suburb", is_valid)
SELECT  3 AS datasource_id,
        json_build_object(
                            'KREISSCHLUESSEL', kreisschluessel, 
                            'KATASTERBEHOERDE', KATASTERBEHOERDE, 
                            'GEMEINDESCHLUESSEL', GEMEINDESCHLUESSEL,
                            'GEMEINDE', GEMEINDE,
                            'GEMARKUNGSSCHLUESSEL', GEMARKUNGSSCHLUESSEL,
                            'GEMARKUNG', GEMARKUNG
                        ) as all_data, 
        'DE' AS "addr:country",
        GEMEINDE AS "addr:city",
        NULLIF(GEMARKUNG,'') AS "addr:suburb",
        true AS is_valid
FROM externaldata.landbb_reg;

-- set admin_id for addr:city
UPDATE externaldata.all_data 
SET city_osm_id = o.osm_id
FROM import.osm_admin o 
WHERE datasource_id=3
  AND "de:amtlicher_gemeindeschluessel" = all_data ->> 'GEMEINDESCHLUESSEL'
;

-- invalid data
UPDATE externaldata.all_data 
SET is_valid = false
WHERE datasource_id=3
  AND city_osm_id IS NULL;

-- Update Views
REFRESH MATERIALIZED VIEW externaldata.suburb_data;
