# Adminer docker autologin

## Quickstart

``` yaml
services:
    db:
        image: postgres
        environment:
            POSTGRES_DB: db_name
            POSTGRES_USER: db_user
            POSTGRES_PASSWORD: db_password
            
    adminer:
        image: mast3rm1lk/adminer-autologin
        environment:
            ADMINER_AUTOLOGIN: 1
            ADMINER_DB: db_name
            ADMINER_USERNAME: db_user
            ADMINER_PASSWORD: db_password
            ADMINER_NAME: My Postgres Manager
            ADMINER_DRIVER: pgsql            
            ADMINER_SERVER: db       
        depends_on:
            - db 
``` 

## Configuration

### ADMINER_AUTOLOGIN

Enable / Disable auto login.

Default: `0`

### ADMINER_DB

Database name.

#### ADMINER_USERNAME

Database username.

#### ADMINER_PASSWORD

Database password.

#### ADMINER_NAME

Adminer name. This value will be in the title and heading.

#### ADMINER_DRIVER

Database driver.

Current possible values are:

- `sqlite`
- `sqlite2`
- `pgsql`
- `oracle`
- `mssql`
- `firebird`
- `simpledb`
- `mongo`
- `elastic`
- `clickhouse`

@see [Adminer documentation](https://www.adminer.org/)

#### ADMINER_SERVER

Database server.

## Use cases

### How to use SQLite driver

``` yaml
services:
    adminer:
        image: mast3rm1lk/adminer-autologin
        environment:
              ADMINER_AUTOLOGIN: 1
              ADMINER_DRIVER: sqlite
              ADMINER_DB: "/db.sqlite"
        volumes:
            - /local/path/to/db.sqlite:/db.sqlite  
``` 

## Credits

Inspired by Sources [adminer-docker](https://github.com/michalhosna/adminer-docker) and Docker hub [michalhosna/adminer](https://hub.docker.com/r/michalhosna/adminer).
Thanks to [michalhosna](https://github.com/michalhosna) !