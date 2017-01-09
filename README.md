# NLDI Database Setup

[![Build Status](https://travis-ci.org/ACWI-SSWD/nldi-db.svg?branch=master)](https://travis-ci.org/ACWI-SSWD/nldi-db)

This repository contains Liquibase scripts for setting up the NLDI PostGIS database.

It also includes Docker Compose scripts to setup a developer environment including a development PostGIS database, a subset of the data, a Jenkins server preconfigured to run the Liquibase scripts, and a continuous integration PostGIS database.

##Developer Environment

You will need to install Docker and Docker Compose.
Docker/Docker Compose commands need to be run in the project directory.
Helpful commands include:
* __docker-compose up__ to create and start the containers
* __docker-compose ps__ to list the containers
* __docker-compose stop__ to stop the containers
* __docker-compose start__ to start the containers
* __docker network inspect nldidb_default__ to get the ip addresses of the running containers

###Continuous Integration Database

The PostGIS database will be available on port 5433. This can be changed in the docker-compose.yml file. The default username and password are nldi/nldi.

###Development Database

The PostGIS database will be available on port 5434. This can be changed in the docker-compose.yml file. The default username and password are nldi/nldi. It includes data from the Yahara River (near Madison WI - upstream of comid 13297246).

###Jenkins

The Jenkins applications will be available on port 8889. This can be changed in the docker-compose.yml file.

It contains the job __LiquibaseNLDI__ to pull and run the current Liquibase scripts from GitHub. For testing, you can change the job's configuration to have it pull from your fork of this project.

