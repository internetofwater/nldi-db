#!/bin/bash 

# Restart postgres to make sure we can connect
pg_ctl -D "$PGDATA" -m fast -o "$LOCALONLY" -w restart

# create the nldi project user and database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	create role nldi with login createrole password '${NLDI_PASSWORD}';
	alter database nldi owner to nldi;
EOSQL

# commands requiring superuser
java -jar ${LIQUIBASE_HOME}/liquibase.jar \
	--defaultsFile=${LIQUIBASE_HOME}/liquibasePostgres.properties \
	--classpath=${LIQUIBASE_HOME}/lib/postgresql-9.4.1212.jar \
	--changeLogFile=${JENKINS_WORKSPACE}/nldi-liquibase/src/main/resources/liquibase/postgres/changeLog.xml \
	update > $LIQUIBASE_HOME/liquibasePostgres.log

# remaining creation scripts
java -DNLDI_DATA_PASSWORD=$NLDI_DATA_PASSWORD -DNLDI_USER_PASSWORD=$NLDI_USER_PASSWORD -jar ${LIQUIBASE_HOME}/liquibase.jar \
	--defaultsFile=${LIQUIBASE_HOME}/liquibase.properties \
	--classpath=${LIQUIBASE_HOME}/lib/postgresql-9.4.1212.jar \
	--changeLogFile=${JENKINS_WORKSPACE}/nldi-liquibase/src/main/resources/liquibase/changeLog.xml \
	--contexts=demo \
	update > $LIQUIBASE_HOME/liquibase.log
