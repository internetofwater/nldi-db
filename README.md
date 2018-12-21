# NLDI Database Setup

[![Build Status](https://travis-ci.org/ACWI-SSWD/nldi-db.svg?branch=master)](https://travis-ci.org/ACWI-SSWD/nldi-db)

This repository contains Liquibase scripts for setting up the NLDI PostGIS database.

It also includes Docker Compose scripts to setup a developer environment including a development PostGIS database, a subset of the data, and a continuous integration PostGIS database.

##Developer Environment

You will need to install Docker and Docker Compose.
Docker/Docker Compose commands need to be run in the project directory.
Helpful commands include:
* __docker-compose up__ to create and start the containers
* __docker-compose ps__ to list the containers
* __docker-compose stop__ to stop the containers
* __docker-compose start__ to start the containers
* __docker network inspect nldidb_default__ to get the ip addresses of the running containers
* __docker-compose ps -q__ to get the Doocker Compose container ids
* __docker ps -a__ to list all the Docker containers
* __docker rm <containerId>__ to remove a container
* __docker rmi <imageId>__ to remove an image
* __docker logs <containerID>__ to view the Docker Compose logs in a container

###Continuous Integration Database

The PostGIS database will be available on port 5433. This can be changed in the docker-compose.yml file. The default username and password are nldi/nldi.

###Development Database

The PostGIS database will be available on port 5434. This can be changed in the docker-compose.yml file. The default username and password are nldi/nldi. It includes data from the Yahara River (near Madison WI - upstream of comid 13297246).


docker run -p 127.0.0.1:5435:5432/tcp --env-file=.env usgswma/nldi-db:ci
