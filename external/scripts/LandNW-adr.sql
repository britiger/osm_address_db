-- ID: 5 - Land NRW - OSM-Id Relation 62761

-- Metadata
INSERT INTO externaldata.datasource (id, sourcename, sourcedescription, license, link, hasaddress, hasstreet) 
    VALUES (5,
        'Gebäudereferenzen NW',
        'Die Gebäudereferenzen definieren die genaue Position einer georeferenzierten Lagebezeichnung (Adresse) eines Gebäudeobjektes im Liegenschaftskataster.',
        'Datenlizenz Deutschland - Zero - Version 2.0',
        'https://open.nrw/dataset/172a0ba8-d470-47c1-ac89-b85f8190ac7e',
        true,
        true)
    ON CONFLICT DO NOTHING;
INSERT INTO externaldata.datasource_admin (datasource_id, admin_osm_id) 
    VALUES (5, -62761) 
    ON CONFLICT DO NOTHING;
    
-- Copy Data from import to all_data
INSERT INTO externaldata.all_data
    (datasource_id, all_data, "addr:country", "addr:city", "addr:street", "addr:housenumber", is_valid)
SELECT 5 AS datasource_id,
        json_build_object(
                            'oi', oi, 
                            'ags', adr.lan||adr.rbz||adr.krs||adr.gmd, 
                            'ott', ott,
                            'stnschl', sss,
                            'gemeindename', schl.name,
                            'strassenname', stn,
                            'hnr', hnr,
                            'adz', adz,
                            'hnradz', concat(hnr,adz),
                            'datum', datum
                        ) as all_data, 
        'DE' AS "addr:country",
        schl.name AS "addr:city",
        stn AS "addr:street",
        concat(hnr,adz) AS "addr:housenumber",
        true AS is_valid
FROM externaldata.landnw_adr adr
    INNER JOIN externaldata.landnw_adr_schl schl
        ON adr.lan=schl.lan 
            and adr.rbz=schl.rbz
            and adr.krs=schl.krs
            and adr.gmd=schl.gmd;

-- set admin_id for addr:city
UPDATE externaldata.all_data 
SET city_osm_id = o.osm_id
FROM import.osm_admin o 
WHERE datasource_id=5
  AND "de:amtlicher_gemeindeschluessel" = all_data ->> 'ags'
;

-- set source date of dataset
UPDATE externaldata.datasource 
  SET sourcedate=(select to_date(max(datum),'YYYY-MM-DD') FROM externaldata.landnw_adr)
WHERE id=5;

-- Update Views
REFRESH MATERIALIZED VIEW externaldata.street_data_city;
REFRESH MATERIALIZED VIEW externaldata.street_data;
REFRESH MATERIALIZED VIEW externaldata.address_data_city;
REFRESH MATERIALIZED VIEW externaldata.address_data;
REFRESH MATERIALIZED VIEW externaldata.suburb_data;
