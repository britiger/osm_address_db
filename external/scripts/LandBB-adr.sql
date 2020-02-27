-- Copy Data from import to all_data
INSERT INTO externaldata.all_data
    (datasource_id, all_data, "addr:country", "addr:city", "addr:suburb", "addr:street", "addr:housenumber", is_valid)
SELECT  2 AS datasource_id,
        json_build_object(
                            'oi', oi, 
                            'ags', gmdnr, 
                            'ott', ott,
                            'stnnr', stnnr,
                            'stnschl', sss,
                            'kreisname', krsname,
                            'amtsname', amtname,
                            'gemeindename', gmdname,
                            'ortsteilname', ottname,
                            'strassenname', stn,
                            'hnr', hnr,
                            'adz', adz,
                            'hnrsdz', hnradz,
                            'aud', aud
                        ) as all_data, 
        'DE' AS "addr:country",
        gmdname AS "addr:city",
        NULLIF(ottname,'') AS "addr:suburb",
        stn AS "addr:street",
        hnradz AS "addr:housenumber",
        true AS is_valid
FROM externaldata.landbb_adr;

-- set admin_id for addr:city
UPDATE externaldata.all_data 
SET city_osm_id = o.osm_id
FROM import.osm_admin o 
WHERE datasource_id=2
  AND "de:amtlicher_gemeindeschluessel" = all_data ->> 'ags'
;

-- set admin_id for addr:suburb
UPDATE externaldata.all_data ad
SET suburb_osm_id=cs.suburb_osm_id
FROM import.city_suburb cs 
WHERE datasource_id=2
  AND ad.city_osm_id=cs.city_osm_id AND ad."addr:suburb"=cs.suburb_name
  AND "addr:suburb" IS NOT NULL;

-- Update Views
REFRESH MATERIALIZED VIEW externaldata.street_data_city;
REFRESH MATERIALIZED VIEW externaldata.street_data;
REFRESH MATERIALIZED VIEW externaldata.address_data_city;
REFRESH MATERIALIZED VIEW externaldata.address_data;
REFRESH MATERIALIZED VIEW externaldata.suburb_data;
