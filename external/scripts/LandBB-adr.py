#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import json

from sqlalchemy import create_engine, text

SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
    'postgresql://' + os.environ.get('PGUSER') + ':' + os.environ.get('PGPASSWORD') + '@' + os.environ.get('PGHOST') + ':' + os.environ.get('PGPORT') + '/' + os.environ.get('PGDATABASE')
sql_insert = text('INSERT INTO externaldata.all_data (datasource_id, all_data) VALUES (:source_id, :json)')

try:
    engine = create_engine(SQLALCHEMY_DATABASE_URI)
except:
    print("Unable to connect to the database.")


def init_external():
    sql = text('INSERT INTO externaldata.datasource (id, sourcename, sourcedescription, license, link) VALUES (:id,:name,:desc,:lic,:link) ON CONFLICT DO NOTHING')
    engine.execute(sql, {
        'id': 2,
        'name': 'Adressverzeichnis Brandenburg',
        'desc': 'Verzeichnis aller Adressen in Brandenburg',
        'lic': '© GeoBasis-DE/LGB, dl-de/by-2-0',
        'link': 'https://geobroker.geobasis-bb.de/gbss.php?MODE=GetProductInformation&PRODUCTID=51600a1d-c7a3-4211-aff8-e94fb7dc166d'
    })
    sql = text('INSERT INTO externaldata.datasource_admin (datasource_id, admin_osm_id) VALUES (:src, :osm_id) ON CONFLICT DO NOTHING')
    engine.execute(sql, {
        'src': 2,
        'osm_id': -62504
    })


init_external()
