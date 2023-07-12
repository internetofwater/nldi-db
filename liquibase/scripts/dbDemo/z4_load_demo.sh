#!/bin/bash 

gunzip -c ${LIQUIBASE_HOME}/nhdplus.yahara.pgdump.gz | pg_restore -h 127.0.0.1 -p 5432 -U postgres -w -a -d ${NLDI_DATABASE_NAME}
gunzip -c ${LIQUIBASE_HOME}/characteristic_data.yahara.pgdump.gz | pg_restore -h 127.0.0.1 -p 5432 -U postgres -w -a -d ${NLDI_DATABASE_NAME} -n characteristic_data
gunzip -c ${LIQUIBASE_HOME}/feature_wqp.yahara.pgdump.gz | pg_restore -h 127.0.0.1 -p 5432 -U ${NLDI_DB_OWNER_USERNAME} -w -a -d ${NLDI_DATABASE_NAME}
gunzip -c ${LIQUIBASE_HOME}/feature_huc12pp.yahara.pgdump.gz | pg_restore -h 127.0.0.1 -p 5432 -U ${NLDI_DB_OWNER_USERNAME} -w -a -d ${NLDI_DATABASE_NAME}
gunzip -c ${LIQUIBASE_HOME}/feature_nwissite.yahara.pgdump.gz | pg_restore -h 127.0.0.1 -p 5432 -U ${NLDI_DB_OWNER_USERNAME} -w -a -d ${NLDI_DATABASE_NAME}
