import numpy as np
import pandas as pd
import sqlite3
import pymysql
from sqlalchemy import create_engine

database = 'mysql+pymysql://root:5DL5oYhn5a2G@127.0.0.1/practicum2'

def insertTitleBasic():
    file = 'title.basics.tsv'

    csv_database = create_engine(database)
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t', dtype='string', na_values='\\N'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('title_tsv', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

        if (j > 280000):
            break


def insertAkas():
    file = 'akas.tsv'

    csv_database = create_engine(database)
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t', dtype='string', na_values='\\N'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('akas_tsv', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

        if (j > 280000):
            break

def insertCrew():
    file = 'crew.tsv'

    csv_database = create_engine(database)
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t', dtype='string', na_values='\\N'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('crew_tsv', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

        if (j > 280000):
            break

def insertEpisode():
    file = 'episodes.tsv'

    csv_database = create_engine(database)
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t', dtype='string', na_values='\\N'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('episode_tsv', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

        if (j > 280000):
            break

def insertPrincipals():
    file = 'principals.tsv'

    csv_database = create_engine(database)
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t', dtype='string', na_values='\\N'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('principals_tsv', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

        if (j > 280000):
            break


def insertRatings():
    file = 'ratings.tsv'

    csv_database = create_engine(database)
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t', dtype='string', na_values='\\N'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('ratings_tsv', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

        if (j > 280000):
            break

def insertNames():
    file = 'name.basics.tsv'

    csv_database = create_engine(database)
    dbConnection = csv_database.connect()

    chunksize = 10000
    i = 0
    j = 0

    for df in pd.read_csv(file, chunksize=chunksize, iterator=True, delimiter='\t', dtype='string', na_values='\\N'):
        df = df.rename(columns = {c: c.replace(' ', '') for c in df.columns})
        df.index += j
        df.to_sql('name_tsv', dbConnection, if_exists='append')
        j = df.index[-1]+1
        print('| index: {}'.format(j))

        if (j > 280000):
            break

def main():
##    insertTitleBasic()
    insertAkas()
##    insertNames()
##    insertRatings()
##    insertEpisode()
##    insertPrincipals()
##    insertCrew()
    
    
main()
