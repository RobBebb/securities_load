"""
Date: 29/04/2023
Author: Rob Bebbington

Get S&P500 sysmbols from Wikipedia and insert them into our database.
"""
from datetime import datetime as dt

import bs4
import requests


def obtain_parse_wiki_snp500():
    """
    Download and parse the Wikipedia list of S&P500 constituents using requests
    and BeautifulSoup.

    Returns a list of tuples to add to the database.
    """

    # Stores the current time, for the created_at field
    now = dt.utcnow()

    # Use requests and BeautifulSoup to download tje list of S&P500 companies
    # and obtain the symbol table
    response = requests.get(
        "http://en.wikipedia.org/wiki/List_of_S%26P_500_companies", timeout=10
    )
    soup = bs4.BeautifulSoup(response.text, features="html.parser")

    # This select the first table, using CSS Selector syntax and then ignores
    # the header row ([1:])
    symbolslist = soup.select("table")[0].select("tr")[1:]

    # Obtain the symbol information for each row in the S&P500 constituent
    # table
    wiki_symbols = []
    for dummy, symbol in enumerate(symbolslist):
        tds = symbol.select("td")
        wiki_symbols.append(
            (
                tds[0].select("a")[0].text,  # Ticker
                "stock",
                tds[1].select("a")[0].text,  # Name
                tds[3].text,  # Sector
                "USD",
                now,
                now,
            )
        )
    return wiki_symbols


def insert_snp500_symbols(conn, insert_symbols):
    """
    Insert the S&P symbols into the PostgreSQL database
    """
    # Create the insert strings
    column_str = (
        "ticker, instrument, name, sector, currency, " "created_date, last_updated_date"
    )

    insert_str = ("%s, " * 7)[:-2]
    final_str = f"INSERT INTO equity.symbol ({column_str}) " f"VALUES ({insert_str})"

    # Using the PostgreSQL connection, carry out
    # an INSERT INTO for every sumbol
    cur = conn.cursor()
    cur.executemany(final_str, insert_symbols)
    conn.commit()
