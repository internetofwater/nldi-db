#!/bin/bash 

# Restart postgres to make sure we can connect
gosu postgres pg_ctl -D "$PGDATA" -m fast -o "$LOCALONLY" -w restart

${LIQUIBASE_HOME}/liquibase --defaultsFile=${LIQUIBASE_HOME}/liquibase.properties --changeLogFile=${JENKINS_WORKSPACE}/nldi-liquibase/src/main/resources/liquibase/changeLog.xml update > $LIQUIBASE_HOME/liquibase.log

