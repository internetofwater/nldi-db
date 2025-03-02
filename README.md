# NLDI Database

This repository contains Liquibase changelogs for creating and managing the NLDI PostGIS database. The [package registry](https://github.com/internetofwater/nldi-db/pkgs/container/nldi-db) has three pre-built Docker images that are ready to use.  

1. The demo image contains a subset of data to use for small scale testing.  
1. The Liquibase image can be used to run the Liquibase changelogs against any PostGIS database.  
1. The CI database is a blank database (schema only) that is used for integration tests in the [NLDI Services](https://github.com/internetofwater/nldi-services) and [NLDI Crawler](https://github.com/internetofwater/nldi-crawler) projects.  

Full scale data is available from an open, requester pays, s3 bucket and can be loaded using the same pattern as the demo image but using different table artifacts:  
`s3://nhgf-development/dev/nldi-database-load/`

Details of how to install this project for small scale (demo) or large scale are included below.

## Table of Contents

- [NLDI Database](#nldi-database)
	- [Table of Contents](#table-of-contents)
	- [Contributing](#contributing)
	- [Development](#development)
		- [Configuration](#configuration)
		- [Running](#running)
			- [Liquibase](#liquibase)
			- [CI](#ci)
			- [Demo Database](#demo-database)
			- [At Scale Database](#at-scale-database)
		- [Docker Compose](#docker-compose)
		- [Environment Variables](#environment-variables)
			- [Definitions](#definitions)


## Contributing

To contribute a new data source to the NLDI, add a new line to [this TSV file](liquibase/changeLogs/nldi/nldi_data/update_crawler_source/crawler_source.tsv) and submit a new pull request.

## Development

The only requirement to set up a development environment is to have [Docker](https://docs.docker.com/get-docker/) installed on your system. Changes to any scripts or Liquibase changelogs can be tested with Docker as outline in the [running](#running) section below.

### Configuration

The database and Liquibase Docker containers utilize various environment variables for passwords and connections. These must be set up prior to any use of these containers.

See the [Environment Variables](#environment-variables) section for a full description.

### Running

Each Docker image can be built and run using the provided Docker Compose yaml file. If you run the images without building first, the latest image will be pulled from the GitHub registry.

#### Liquibase

The Liquibase changelogs can be tested locally by spinning up the generic PostGIS database (db) and the Liquibase container.

```shell
docker compose up -d db
docker compose run liquibase
```

The local file system is mounted into the liquibase container. This allows you to change the liquibase and shell scripts and run the changes by just re-launching the liquibase container. Note that all standard Liquibase caveats apply.

The PostGIS database will be available on your localhost's port `$DB_PORT`, allowing for visual inspection of the results.

#### CI

```shell
docker compose up ci
```

It will be available on you localhost's port `$DB_CI_PORT`.

This database does not contain any data and is used to insert mock data for testing the NLDI services and NLDI Crawler.

#### Demo Database

```shell
docker compose up demo
```

It will be available on your localhost's port `$DB_DEMO_PORT`.

#### At Scale Database

While not necessary for development, it can be useful to load and run the NLDI with full production data. The full production table data is available in this requester pays S3 bucket. `s3://nhgf-development.s3.amazonaws.com/dev/nldi-database-load/full-scale/`

The `load-data.sh` script reads environment variables from a `.env` file accoring the the specification below, downloads production artifacts with the `aws` CLI, and uses `pg_restore` to load them. The script expects the postgres user's password to be available in a location like a .pgpass file.

To run the services with an at scale database, starting from a stand alone database from the this project can be accomplished with minor alterations to the docker-compose.yml to allow the two docker-compose projects to communicate on the same network. 

```
      environment:
        serverContextPath: /nldi
        serverPort: 8080
        nldiProtocol: http
        nldiHost: "localhost:8080"
        nldiPath: /nldi
        springFrameworkLogLevel: debug
        nldiDbHost: localhost
        nldiDbPort: 5432
        nldiDbUsername: nldi_data
        nldiDbPassword: changeMe
        nldiDbName: nldi
        pygeoapiUrl: "https://labs.waterdata.usgs.gov/api/nldi/pygeoapi/"
```

TODO: get the `load-data.sh` script to run via `docker compose run load-data` rather than it being run in a developers environment.

### Docker Compose

It is highly recommended to use Docker Compose to run the included Docker images, although they may also be run with typical Docker commands and additonal parameters.

There are several commands that you will find useful during your testing.

If you have started a container with `docker compose up -d <container name>`, it can be stopped by pressing ctrl+C, or your machines equivalent, in the terminal that it was started from. Alternatively, you can run `docker compose stop <container name>` from a separate terminal.

Using `docker compose run <container name>` is useful for running containers that will not remain running after execution.

See the [Docker Compose documentation](https://docs.docker.com/compose/reference/) for other commands.


### Environment Variables

Docker Compose will automatically grab an `.env` file at the top level of this project. This file is ignored in `.gitignore` and **SHOULD NOT** be commited to the git repository. Below is an example of the contents for the `.env` file.

```sh
POSTGRES_PASSWORD=changeMe
NLDI_DATABASE_ADDRESS=127.0.0.1
NLDI_DATABASE_NAME=nldi
NLDI_DB_OWNER_USERNAME=nldi
NLDI_DB_OWNER_PASSWORD=changeMe
NLDI_SCHEMA_OWNER_USERNAME=nldi_schema_owner
NLDI_SCHEMA_OWNER_PASSWORD=changeMe
NHDPLUS_SCHEMA_OWNER_USERNAME=nhdplus
NLDI_READ_ONLY_USERNAME=nldi_data
NLDI_READ_ONLY_PASSWORD=changeMe
DB_CI_PORT=5445
DB_DEMO_PORT=5432
DB_PORT=5432
DOCKER_MIRROR=mirror.url.com/
NLDI_BUCKET_NAME=nhgf-development.s3.amazonaws.com/dev/nldi-database-load/full-scale
```

#### Definitions

Descriptions for each environment variable. The "Require For" column indicates which container images utilize and require that variable.

L = Liquibase\
D = Demo\
C = CI (continuous integration)\
G = Generic PostGIS database\
N = None (optional)

| Name | Description | Required For |
|---|---|:---:|
| POSTGRES_PASSWORD | Password for the postgres user. | L,D,C,G |
| NLDI_DATABASE_ADDRESS | Host name or IP address of the PostgreSQL database. | L,D,C |
| NLDI_DATABASE_NAME | Name of the PostgreSQL database to create for containing the schema. | L,D,C |
| NLDI_DB_OWNER_USERNAME | Role which will own the database. | L,D,C |
| NLDI_DB_OWNER_PASSWORD | Password for the `NLDI_DB_OWNER_USERNAME` role. | L,D,C |
| NLDI_SCHEMA_OWNER_USERNAME | Role which will own the NLDI database objects. | L,D,C |
| NLDI_SCHEMA_OWNER_PASSWORD | Password for the `NLDI_SCHEMA_OWNER_USERNAME` role. | L,D,C |
| NHDPLUS_SCHEMA_OWNER_USERNAME | Role which will own the NHDPLUS database objects. | L,D,C |
| NLDI_READ_ONLY_USERNAME | The limited privilege role used by applications to access this schema. | L,D,C |
| NLDI_READ_ONLY_PASSWORD | Password for the `NLDI_READ_ONLY_USERNAME` role. | L,D,C |
| DB_CI_PORT | The localhost port on which to expose the CI database. | C |
| DB_DEMO_PORT | The localhost port on which to expose the Demo database. | D |
| DB_PORT | The localhost port on which to expose the script testing database container. | G |
| DOCKER_MIRROR | Optional mirror URL that is prefixed when pulling Docker images. | N |
| NLDI_BUCKET_NAME | Optional bucket where data tables can be downloaded. | N |
