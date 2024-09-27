# Setup

## Database

1. Install postgresql
1. Log in to  pgAdmin4:
    1. Create user: "securities_dba"
    1. Create database: "securities" with UTF8 and "securities_dba" as the owner.
1. Create project folder C:\projects\securities
1. Open vscode in C:\projects\securities
1. Using the command palette create a conda python environment using "Python: Create Environment..."
1. Install extension PostgreSQL from Microsoft
1. Using the command palette create a connection to the securities database using "PostgreSQL: Connect
1. Create a database folder under securities
1. Create a create_tables.sql file
1. Enter the various sql create commands
1. To execute the SQL right click on the file and select Execute query

### Run sql files using psql

PSQL can be used to execute files containing SQL. The following is an example of a command that can be used:

```bash
(airflow_env) ubuntuuser@laptopBeast:~$ psql -U securities -d securities -h localhost -f ~/karra/securities/database/create_portfolio_tables.sql
```

The password will need to be entered. It is possible to put the password in a file. See .pgpass file for more info.

### Set up a password in the .pgpass file

Create a file in the home directory called .pgpass

Populate it with the following:

# hostname:port:database:username:password
localhost:5432:securities:securities:your_password

The access must disallow any access to world or group otherwise it will not work. To do this change the access to it with:

```bash
chmod 0600 ~/.pgpass
```
 
## Install python libraries

We need to install several python libraries. To install them:

1. Open a Command prompt. Make sure the conda environment gets activated.
1. Enter `conda install psycopg2` - psycopg is a PostgreSQL adapter for python.
1. Enter `conda install requests` - sends http requests
1. Enter `conda install beautifulsoup4` - extracts data from HTML and XML
1. Enter `conda install conda-forge::yfinance` - gets data from Yahoo Finance
1. Enter `conda install conda-forge::polygon-api-client` - gets polygon python client
1. Enter `conda install conda-forge::python-dotenv` - gets dotenv


define environment variables

# Structure

There will be one database called **'securities'**. It will use PostgreSQL running on Linux.

## Schemas

There will be one primary schema, **'securities'**, that holds a set of information for all securities and will be the schema that is used for day to day analysis, trade journal, automated trading etc.

The primary schema will contain a set of generic code tables that cater for all data.

There will be multiple secondary schemas that will be used for loading data. In general there will be one secondary schema for each data source. For example **'polygon'**, **'yahoo'**, **'interactive brokers'** etc. The secondary schemas will have raw tables, that mimic the structure of the data source to allow easy initial loading, and may have additional tables to cater for transforming the data in such a way that it can easily be loaded into the primary schema.

Data will initially be loaded into the secondary schemas in a raw state. It will then be transformed in the secondary schema, where necessary, before being loaded into the primary schema. The data must be transformed to match the generic code tables of the primary schema.

In general code tables will be updated on a weekly basis. The transaction tables will be updated on a daily basis. The OHLCV table will have special consideration for performance and size reasons. Data for the OHLCV table may get loaded directly into the primary schema as it has a reasonably fixed format.

## Programming

Mutiple interface will be used. They are:

### PGAdmin4

PGAdmin4 will be used for looking at the structure of the database and running queries against the database.

### Python

Python will be used as the main programming language for loading data, automated analysis, automated trading etc.

### Airflow

Airflow will be used for scheduling batch jobs.

### Jupyter

Jupyter will be used for interactive analysis.

### Budibase

Budibase will be used as a CRUD type front end to the database.

### VS Code

All programming will be done in VS Code

### DBeaver

DBeaver will be used to draw up an ERD for the database.



