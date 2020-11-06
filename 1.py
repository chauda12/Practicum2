import numpy as np
import pandas as pd
import sqlite3
import pymysql
from sqlalchemy import create_engine



def insertTitleBasic():
    file = 'title.basics.tsv'

    csv_database = create_engine('mysql+pymysql://root@127.0.0.1/test')
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('titleBasic', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

def insertAkas():
    file = 'title.akas.tsv'

    csv_database = create_engine('mysql+pymysql://root@127.0.0.1/test')
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('titleAkas', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

def insertCrew():
    file = 'title.crew.tsv'

    csv_database = create_engine('mysql+pymysql://root@127.0.0.1/test')
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('crew', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

def insertEpisode():
    file = 'title.episode.tsv'

    csv_database = create_engine('mysql+pymysql://root@127.0.0.1/test')
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('episode', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

def insertPrincipals():
    file = 'title.principals.tsv'

    csv_database = create_engine('mysql+pymysql://root@127.0.0.1/test')
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('principals', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))


def insertRatings():
    file = 'title.ratings.tsv'

    csv_database = create_engine('mysql+pymysql://root@127.0.0.1/test')
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('ratings', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

def insertNames():
    file = 'name.basics.tsv'

    csv_database = create_engine('mysql+pymysql://root@127.0.0.1/test')
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('name', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

def main():
    insertTitleBasic()
    print(1)
    insertAkas()
    print(2)
    insertCrew()
    print(2)
    insertEpisode()
    print(2)
    insertPrincipals()
    print(2)
    insertRatings()
    print(2)
    insertNames()

main()
