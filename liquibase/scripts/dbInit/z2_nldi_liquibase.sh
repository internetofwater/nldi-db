#!/bin/bash

${LIQUIBASE_HOME}/liquibase \
	--classpath=${LIQUIBASE_HOME}/lib/${JDBC_JAR} \
	--changeLogFile=${LIQUIBASE_WORKSPACE}/nldi/changeLog.xml \
	--driver=org.postgresql.Driver \
	--url=jdbc:postgresql://${NLDI_DATABASE_ADDRESS}:5432/${NLDI_DATABASE_NAME} \
	--username=${NLDI_DB_OWNER_USERNAME} \
	--password=${NLDI_DB_OWNER_PASSWORD} \
	--contexts=${CONTEXTS} \
	--logLevel=${LOG_LEVEL:-info} \
	--liquibaseCatalogName=nldi_data \
	--liquibaseSchemaName=nldi_data \
	update \
	-DNLDI_DB_OWNER_USERNAME=${NLDI_DB_OWNER_USERNAME} \
	-DNLDI_SCHEMA_OWNER_USERNAME=${NLDI_SCHEMA_OWNER_USERNAME} \
	-DNHDPLUS_SCHEMA_OWNER_USERNAME=${NHDPLUS_SCHEMA_OWNER_USERNAME} \
	-DNLDI_READ_ONLY_USERNAME=${NLDI_READ_ONLY_USERNAME}
