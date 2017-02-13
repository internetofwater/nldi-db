#!/bin/bash 

# Restart postgres to make sure we can connect
pg_ctl -D "$PGDATA" -m fast -o "$LOCALONLY" -w restart

# ci creation scripts
java -DNLDI_DATA_PASSWORD=$NLDI_DATA_PASSWORD -DNLDI_USER_PASSWORD=$NLDI_USER_PASSWORD -jar ${LIQUIBASE_HOME}/liquibase.jar \
	--defaultsFile=${LIQUIBASE_HOME}/liquibase.properties \
	--classpath=${LIQUIBASE_HOME}/lib/postgresql-9.4.1212.jar \
	--changeLogFile=${JENKINS_WORKSPACE}/nldi-liquibase/src/main/resources/liquibase/changeLog.xml \
	--contexts=ci \
	update > $LIQUIBASE_HOME/liquibase.log

