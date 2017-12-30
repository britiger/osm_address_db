-- Delete accepted false positives if position or content changes

-- double address by distance
DELETE FROM web.osm_false_positive_double AS double 
USING import.osm_addresses AS addr
WHERE addr.osm_id=double.osm_id AND addr.class=double.class AND
  (ST_DISTANCE(addr.geometry,double.geometry) > 50
  OR double.geometry IS NULL
  OR addr."addr:housenumber"  != addr."addr:housenumber"
  OR addr."addr:street" != addr."addr:street"
  OR addr."addr:postcode" != addr."addr:postcode");