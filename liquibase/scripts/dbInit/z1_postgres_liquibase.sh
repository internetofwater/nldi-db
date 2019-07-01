#!/bin/bash 

# create the nldi project user and database
#psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
#	create role nldi with login createrole password '${NLDI_PASSWORD}';
#	alter database nldi owner to nldi;
#EOSQL

# postgres to postgres db scripts
${LIQUIBASE_HOME}/liquibase \
	--classpath=${LIQUIBASE_HOME}/lib/${JDBC_JAR} \
	--changeLogFile=${LIQUIBASE_WORKSPACE}/postgres/postgres/changeLog.yml \
	--driver=org.postgresql.Driver \
	--url=jdbc:postgresql://${NLDI_DATABASE_ADDRESS}:5432/postgres \
	--username=postgres \
	--password=${POSTGRES_PASSWORD} \
	--contexts=${CONTEXTS} \
	--logLevel=debug \
	--liquibaseCatalogName=public \
	--liquibaseSchemaName=public \
	update \
	-DNLDI_DATABASE_NAME=${NLDI_DATABASE_NAME} \
	-DNLDI_DB_OWNER_USERNAME=${NLDI_DB_OWNER_USERNAME} \
	-DNLDI_DB_OWNER_PASSWORD=${NLDI_DB_OWNER_PASSWORD} \
	-DNLDI_SCHEMA_OWNER_USERNAME=${NLDI_SCHEMA_OWNER_USERNAME} \
	-DNLDI_SCHEMA_OWNER_PASSWORD=${NLDI_SCHEMA_OWNER_PASSWORD} \
	-DNHDPLUS_SCHEMA_OWNER_USERNAME=${NHDPLUS_SCHEMA_OWNER_USERNAME} \
	-DNLDI_READ_ONLY_USERNAME=${NLDI_READ_ONLY_USERNAME} \
	-DNLDI_READ_ONLY_PASSWORD=${NLDI_READ_ONLY_PASSWORD}

# postgres to nldi db scripts
${LIQUIBASE_HOME}/liquibase \
	--classpath=${LIQUIBASE_HOME}/lib/${JDBC_JAR} \
	--changeLogFile=${LIQUIBASE_WORKSPACE}/postgres/nldi/changeLog.yml \
	--driver=org.postgresql.Driver \
	--url=jdbc:postgresql://${NLDI_DATABASE_ADDRESS}:5432/${NLDI_DATABASE_NAME} \
	--username=postgres \
	--password=${POSTGRES_PASSWORD} \
	--contexts=demo \
	--logLevel=debug \
	--liquibaseCatalogName=public \
	--liquibaseSchemaName=public \
	update \
	-DNLDI_SCHEMA_OWNER_USERNAME=${NLDI_SCHEMA_OWNER_USERNAME} \
	-DNHDPLUS_SCHEMA_OWNER_USERNAME=${NHDPLUS_SCHEMA_OWNER_USERNAME} \
	-DNLDI_READ_ONLY_USERNAME=${NLDI_READ_ONLY_USERNAME}

# remaining creation scripts
#java -DNLDI_DATA_PASSWORD=$NLDI_DATA_PASSWORD -DNLDI_USER_PASSWORD=$NLDI_USER_PASSWORD -jar ${LIQUIBASE_HOME}/liquibase.jar \
#	--defaultsFile=${LIQUIBASE_HOME}/liquibase.properties \
#	--classpath=${LIQUIBASE_HOME}/lib/postgresql-9.4.1212.jar \
#	--changeLogFile=${JENKINS_WORKSPACE}/nldi-liquibase/src/main/resources/liquibase/changeLog.xml \
#	--contexts=demo \
#	update
