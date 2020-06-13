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


def add_street(val):
    # header:  # SCHL # KATASTERBEHOERDE           # SCHL     # GEMEINDE                  # SCHL  # LAGEBEZEICHNUNG                         #
    # data:    #  51  #  Brandenburg an der Havel  # 12051000 # Brandenburg an der Havel  # A0002 # A 2                                     #

    kreisschl = val[1].strip()
    katasterbehoerde = val[2].strip()
    gemeindeschl = val[3].strip()
    gemeinde = val[4].strip()
    strschl = val[5].strip()
    bezeichnung = val[6].strip()
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
    f = open('../data/brandenburg/LandBB-str.txt', 'r', encoding='iso-8859-15')
    for line in f:
        splitted = line.split('#')
        if len(splitted) == 8:
            if splitted[1].strip().isnumeric():
                add_street(splitted)
            else:
                # maybe the header
                print('Skip line: ' + line)
        else:
            print('Skip line: ' + line)
    f.close()


parse_file()
