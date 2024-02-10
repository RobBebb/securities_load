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
