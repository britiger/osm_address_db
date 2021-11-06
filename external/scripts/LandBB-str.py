#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import json
import csv

from sqlalchemy import create_engine, text

SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
    'postgresql://' + os.environ.get('PGUSER') + ':' + os.environ.get('PGPASSWORD') + '@' + os.environ.get('PGHOST') + ':' + os.environ.get('PGPORT') + '/' + os.environ.get('PGDATABASE')
sql_insert = text('INSERT INTO externaldata.all_data (datasource_id, all_data) VALUES (:source_id, :json)')

try:
    engine = create_engine(SQLALCHEMY_DATABASE_URI)
except:
    print("Unable to connect to the database.")


def add_street(val):
    # KREISSCHLUESSEL,KATASTERBEHOERDE,GEMEINDESCHLUESSEL,GEMEINDE,LAGESCHLUESSEL,LAGEBEZEICHNUNG
    # 51,Brandenburg an der Havel,12051000,Brandenburg an der Havel,00005,Abtstraße

    kreisschl = val[0].strip()
    katasterbehoerde = val[1].strip()
    gemeindeschl = val[2].strip()
    gemeinde = val[3].strip()
    strschl = val[4].strip()
    bezeichnung = val[5].strip()
    json_data = {
        'kreisschl': kreisschl,
        'katasterbehoerde': katasterbehoerde,
        'gemeindeschl': gemeindeschl,
        'gemeinde': gemeinde,
        'strschl': strschl,
        'bezeichnung': bezeichnung
    }

    engine.execute(sql_insert, {
        'source_id': 1,
        'json': json.dumps(json_data)
    })


def parse_file():
    with open('../data/brandenburg/12-str.csv', 'r') as infile:
        reader = csv.reader(infile)
        next(reader, None) # Skip header
        for r in reader:
            add_street(r)

parse_file()
