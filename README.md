# NLDI Database Setup

[![Build Status](https://travis-ci.org/ACWI-SSWD/nldi-db.svg?branch=master)](https://travis-ci.org/ACWI-SSWD/nldi-db)

This repository contains Liquibase scripts for setting up the NLDI PostGIS database.

It also includes Docker Compose scripts to setup a developer environment including the PostGIS database, a subset of the data, and a Jenkins server preconfigured to run the Liquibase scripts.

##Developer Environment

You will need to install Docker and Docker Compose.
Docker/Docker Compose commands need to be run in the project directory.
Helpful commands include:
* __docker-compose up__ to create and start the containers
* __docker-compose ps__ to list the containers
* __docker-compose stop__ to stop the containers
* __docker-compose start__ to start the containers
* __docker network inspect bridge__ to get the ip addresses of the running containers

###Database

The PostGIS database will be available on port 5432 of the NLDI_Database container. The default username and password are nldi/nldi.

###Jenkins

The Jenkins applications will be available on port 8080 of the NLDI_Jenkins container. For example: http://172.17.0.2:8080/

It contains the job __LiquibaseNLDI__ which will need to be configured to access your local PostGIS database. You may also want to have it pull from your fork of this project.

