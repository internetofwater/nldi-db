# NLDI Database Setup

[![Build Status](https://travis-ci.org/ACWI-SSWD/nldi-db.svg?branch=master)](https://travis-ci.org/ACWI-SSWD/nldi-db)

This repository contains Liquibase scripts for creating the NLDI PostGIS database.

## Docker
Also included are Docker Compose scripts to:
* Create PostgreSQL and Liquibase containers for testing the scripts.
* Create a continuous integration PostgreSQL database container.
* Create a PostgreSQL database container for local development containing a sampling of data.

### Docker Network
A named Docker Network is required for local running of the containers. Creating this network allows you to run all of the NLDI locally in individual containers without having to maintain a massive Docker Compose script encompassing all of the required pieces. (It is also possible to run portions of the system locally against remote services.) The name of this network is provided by the __LOCAL_NETWORK_NAME__ environment variable. The following is a sample command for creating your own local network. In this example the name is nldi and the ip addresses will be 172.26.0.x

```
docker network create --subnet=172.26.0.0/16 nldi
```

### Environment variables
In order to use the docker compose scripts, you will need to create a .env file in the project directory containing

the following (shown are example values):

```
POSTGRES_PASSWORD=<changeMe>

NLDI_DATABASE_ADDRESS=<nldi_database_address>
NLDI_DATABASE_NAME=<nldi_database_name>
NLDI_DB_OWNER_USERNAME=<nldi_db_owner_username>
NLDI_DB_OWNER_PASSWORD=<changeMe>

NLDI_SCHEMA_OWNER_USERNAME=<nldi_schema_owner_username>
NLDI_SCHEMA_OWNER_PASSWORD=<changeMe>

NHDPLUS_SCHEMA_OWNER_USERNAME=<nhdplus_schema_owner_username>

NLDI_READ_ONLY_USERNAME=<read_only_username>
NLDI_READ_ONLY_PASSWORD=<changeMe>

LOCAL_NETWORK_NAME=<nldi>

DB_IPV4=<172.26.0.2>
DB_PORT=<5444>
LIQUIBASE_IPV4=<172.26.0.3>

LIQUIBASE_VERSION=<3.6.3>
JDBC_JAR=<postgresql-42.2.5.jar>

DB_CI_IPV4=<172.26.0.4>
DB_CI_PORT=<5445>

DB_DEMO_IPV4=<172.26.0.5>
DB_DEMO_PORT=<5446>
```

#### Environment variable definitions

* **POSTGRES_PASSWORD** - Password for the postgres user.

* **NLDI_DATABASE_ADDRESS** - Host name or IP address of the PostgreSQL database.
* **NLDI_DATABASE_NAME** - Name of the PostgreSQL database to create for containing the schema.
* **NLDI_DB_OWNER_USERNAME** - Role which will own the database.
* **NLDI_DB_OWNER_PASSWORD** - Password for the **NLDI_DB_OWNER_USERNAME** role.

* **NLDI_SCHEMA_OWNER_USERNAME** - Role which will own the NLDI database objects.
* **NLDI_SCHEMA_OWNER_PASSWORD** - Password for the **NLDI_SCHEMA_OWNER_USERNAME** role.

* **NHDPLUS_SCHEMA_OWNER_USERNAME** - Role which will own the NHDPLUS database objects.

* **NLDI_READ_ONLY_USERNAME** - The limited privilege role used by applications to access this schema.
* **NLDI_READ_ONLY_PASSWORD** - Password for the **NLDI_READ_ONLY_USERNAME** role.

* **LOCAL_NETWORK_NAME** - The name of the local Docker Network you have created for using these images/containers.
* **DB_IPV4** - The IP address in your Docker Network you would like assigned to the database container used for testing the Liquibase scripts.
* **DB_PORT** - The localhost port on which to expose the script testing database container.
* **LIQUIBASE_IPV4** - The IP address you would like assigned to the Liquibase runner container.

* **LIQUIBASE_VERSION** - The version of Liquibase to install.
* **JDBC_JAR** - The jdbc driver to install.

* **DB_CI_PORT** - The localhost port on which to expose the CI database.
* **DB_CI_IPV4** - The IP address for the CI database container.

* **DB_DEMO_PORT** - The localhost port on which to expose the Demo database.
* **DB_DEMO_IPV4** - The IP address for the Demo database container.

### Testing Liquibase scripts
The Liquibase scripts can be tested locally by spinning up the generic database (db) and the liquibase container.

```
% docker-compose up -d db
% docker-compose up liquibase
```
The local file system is mounted into the liquibase container. This allows you to change the liquibase and shell scripts and run the changes by just re-launching the liquibase container. Note that all standard Liquibase caveats apply.

The PostGIS database will be available on your localhost's port $DB_PORT, allowing for visual inspection of the results.

### CI Database
```
docker-compose up ciDB
```
It will be available on you localhost's port $DB_CI_PORT

You can also pull the image from Docker Hub and run it with

```
docker run -it --env-file ./.env -p 127.0.0.1:5445:5432 usgswma/wqp_db:ci
```
where __./.env__ is the environment variable file you have locally and __5445__ can be changed to the port you wish to access it via.

### Demo Database

```
docker-compose up demoDB
```

It will be available on your localhost's port $DB_DEMO_PORT


You can also pull the image from Docker Hub and run it with

```
docker run -it --env-file ./.env -p 127.0.0.1:5446:5432 usgswma/wqp_db:demo
```

where __./.env__ is the environment variable file you have locally and __5446__ can be changed to the port you wish to access it via.

### Other Helpful commands include:
* __docker-compose up__ to create and start the containers
* __docker-compose ps__ to list the containers
* __docker-compose stop__ or __docker-compose kill__ to stop the containers
* __docker-compose start__ to start the containers
* __docker-compose rm__ to remove all containers
* __docker network ls__ to get a list of local docker network names
* __docker network inspect XXX__ to get the ip addresses of the running containers
* __docker-compose ps -q__ to get the Docker Compose container ids
* __docker ps -a__ to list all the Docker containers
* __docker rm <containerId>__ to remove a container
* __docker rmi <imageId>__ to remove an image
* __docker logs <containerID>__ to view the Docker Compose logs in a container
