#!/bin/bash

gunzip -c ${LIQUIBASE_HOME}/nhdplus.yahara.pgdump.gz | pg_restore -h 127.0.0.1 -p 5432 -U postgres -w -a -d ${NLDI_DATABASE_NAME}
gunzip -c ${LIQUIBASE_HOME}/characteristic_data.yahara.pgdump.gz | pg_restore -h 127.0.0.1 -p 5432 -U postgres -w -a -d ${NLDI_DATABASE_NAME} -n characteristic_data
