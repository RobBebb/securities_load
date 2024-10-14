"""
Create a database connection
"""

import os
import sys

import psycopg2
from dotenv import load_dotenv
from sqlalchemy import Engine, create_engine


def connect():
    """
    Connect to the database
    user = securities
    password = securities
    host = localhost
    port = 5432
    database = securities
    """
    conn = None
    try:
        # print("Connecting...")
        conn = psycopg2.connect(
            user=os.environ["DB_USER"],
            password=os.environ["DB_PASS"],
            host=os.environ["DB_HOST"],
            port=os.environ["DB_PORT"],
            database=os.environ["DB_NAME"],
        )
    except psycopg2.Error as error:
        print("Error while connecting to PostgreSQL", error)
        if conn:
            conn.close()
            print("PostgreSQL connection is closed")
        sys.exit(1)
    # print("All good, Connection successful!")
    return conn


def sqlalchemy_connect():
    """
    Connect to the database
    user = securities
    password = securities
    host = localhost
    port = 5432
    database = securities
    """
    # try:
    #     print('Connecting...')
    #     conn = psycopg2.connect(
    #         user=os.environ['DB_USER'],
    #         password=os.environ['DB_PASS'],
    #         host=os.environ['DB_HOST'],
    #         port=os.environ['DB_PORT'],
    #         database=os.environ['DB_NAME'])
    # except psycopg2.Error as error:
    #     print("Error while connecting to PostgreSQL", error)
    #     if conn:
    #         conn.close()
    #         print("PostgreSQL connection is closed")
    #     sys.exit(1)
    # # print("All good, Connection successful!")
    # return conn
    # load_dotenv()

    user = os.environ["DB_USER"]
    password = os.environ["DB_PASS"]
    host = os.environ["DB_HOST"]
    port = os.environ["DB_PORT"]
    database = os.environ["DB_NAME"]

    conn_string = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
    print(conn_string)
    engine = create_engine(conn_string)
    connection = engine.connect()
    return connection


def sqlalchemy_engine() -> Engine:
    """
    Create the SQLAlchemy engine
    user = securities
    password = securities
    host = localhost
    port = 5432
    database = securities
    """
    # try:
    #     print('Connecting...')
    #     conn = psycopg2.connect(
    #         user=os.environ['DB_USER'],
    #         password=os.environ['DB_PASS'],
    #         host=os.environ['DB_HOST'],
    #         port=os.environ['DB_PORT'],
    #         database=os.environ['DB_NAME'])
    # except psycopg2.Error as error:
    #     print("Error while connecting to PostgreSQL", error)
    #     if conn:
    #         conn.close()
    #         print("PostgreSQL connection is closed")
    #     sys.exit(1)
    # # print("All good, Connection successful!")
    # return conn
    load_dotenv()

    user = os.environ["DB_USER"]
    password = os.environ["DB_PASS"]
    host = os.environ["DB_HOST"]
    port = os.environ["DB_PORT"]
    database = os.environ["DB_NAME"]

    conn_string = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
    print(conn_string)
    engine = create_engine(conn_string)
    return engine


if __name__ == "__main__":
    print("Running")
    sqlalchemy_connect()
    print("End")
