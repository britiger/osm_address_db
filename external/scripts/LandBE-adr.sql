-- ID: 4 - Land Berlin - OSM-Id Relation 62422

-- Metadata
INSERT INTO externaldata.datasource (id, sourcename, sourcedescription, license, link, hasaddress, hasstreet, hassuburb) 
    VALUES (4,
        'Adressen Berlin - [WFS]',
        'Die Adresspunkte stellen die amtlichen Berliner Adressen inklusive Koordinaten gemäß den Nummerierungsplänen der Vermessungsämter dar.',
        'Datenlizenz Deutschland – Namensnennung – Version 2.0',
        'https://daten.berlin.de/datensaetze/adressen-berlin-wfs',
        true,
        true,
        true)
    ON CONFLICT DO NOTHING;
INSERT INTO externaldata.datasource_admin (datasource_id, admin_osm_id) 
    VALUES (4, -62442) 
    ON CONFLICT DO NOTHING;

-- Copy Data from import to all_data
INSERT INTO externaldata.all_data
    (datasource_id, all_data, "addr:country", "addr:city", "addr:suburb", "addr:street", "addr:housenumber", is_valid)
SELECT 4 AS datasource_id,
        json_build_object(
                            'adressid', adressid, 
                            'str_nr', str_nr, 
                            'str_name', str_name,
                            'plz', plz,
                            'bez_name', bez_name,
                            'bez_nr', bez_nr,
                            'ort_name', ort_name,
                            'ort_nr', ort_nr,
                            'plr_name', plr_name,
                            'plr_nr', plr_nr,
                            'str_datum', str_datum,
                            'qualitaet', qualitaet,
                            'typ', typ,
                            'hnr', hnr,
                            'hnr_zusatz', hnr_zusatz,
                            'blk', blk,
                            'adr_datum', adr_datum,
                            'hko_id', hko_id
                        ) as all_data, 
        'DE' AS "addr:country",
        'Berlin' AS "addr:city",
        NULLIF(ort_name,'') AS "addr:suburb",
        str_name AS "addr:street",
        hnr||hnr_zusatz AS "addr:housenumber",
        true AS is_valid
FROM externaldata.landbe_adr;

-- append Bezirke for suburb
INSERT INTO externaldata.all_data
    (datasource_id, all_data, "addr:country", "addr:city", "addr:suburb", is_valid)
SELECT 4 AS datasource_id,
        json_build_object(
                            'bez_name', bez_name,
                            'bez_nr', bez_nr
                        ) as all_data, 
        'DE' AS "addr:country",
        'Berlin' AS "addr:city",
        NULLIF(bez_name,'') AS "addr:suburb",
        true AS is_valid
FROM externaldata.landbe_adr
GROUP BY bez_nr, bez_name;

-- set admin_id for addr:city
UPDATE externaldata.all_data 
SET city_osm_id = -62422
WHERE datasource_id=4;

-- set admin_id for addr:suburb
UPDATE externaldata.all_data ad
SET suburb_osm_id=cs.suburb_osm_id
FROM import.city_suburb cs 
WHERE datasource_id=4
  AND ad.city_osm_id=cs.city_osm_id AND ad."addr:suburb"=cs.suburb_name
  AND "addr:suburb" IS NOT NULL;

-- set source date of dataset
UPDATE externaldata.datasource 
  SET sourcedate=(select to_date(max(adr_datum),'YYYY-MM-DD') FROM externaldata.landbe_adr)
WHERE id=4;

-- Update Views
REFRESH MATERIALIZED VIEW externaldata.street_data_city;
REFRESH MATERIALIZED VIEW externaldata.street_data;
REFRESH MATERIALIZED VIEW externaldata.address_data_city;
REFRESH MATERIALIZED VIEW externaldata.address_data;
REFRESH MATERIALIZED VIEW externaldata.suburb_data;
