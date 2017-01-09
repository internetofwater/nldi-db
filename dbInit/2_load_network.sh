#!/bin/bash 

# Restart postgres to make sure we can connect
gosu postgres pg_ctl -D "$PGDATA" -m fast -o "$LOCALONLY" -w restart

gunzip -c ${LIQUIBASE_HOME}/nhdplus_yahara.backup.gz | pg_restore -h 127.0.0.1 -p 5432 -U nldi -w -a -d nldi
gunzip -c ${LIQUIBASE_HOME}/characteristic_data_yahara.backup.gz | pg_restore -h 127.0.0.1 -p 5432 -U nldi -w -a -d nldi -n characteristic_data
