#!/bin/bash 

gunzip -c ${LIQUIBASE_HOME}/nhdplus.yahara.pgdump.gz | pg_restore -h 127.0.0.1 -p 5432 -U ${NLDI_DB_OWNER_USERNAME} -w -a -d ${NLDI_DATABASE_NAME}
gunzip -c ${LIQUIBASE_HOME}/characteristic_data.yahara.pgdump.gz | pg_restore -h 127.0.0.1 -p 5432 -U ${NLDI_DB_OWNER_USERNAME} -w -a -d ${NLDI_DATABASE_NAME} -n characteristic_data
gunzip -c ${LIQUIBASE_HOME}/nldi_data.crawler_source.pgdump.gz | pg_restore -h 127.0.0.1 -p 5432 -U ${NLDI_DB_OWNER_USERNAME} -w -a -d ${NLDI_DATABASE_NAME}
gunzip -c ${LIQUIBASE_HOME}/feature_wqp_yahara.backup.gz | pg_restore -h 127.0.0.1 -p 5432 -U ${NLDI_DB_OWNER_USERNAME} -w -a -d ${NLDI_DATABASE_NAME}
gunzip -c ${LIQUIBASE_HOME}/feature_huc12pp_yahara.backup.gz | pg_restore -h 127.0.0.1 -p 5432 -U ${NLDI_DB_OWNER_USERNAME} -w -a -d ${NLDI_DATABASE_NAME}
gunzip -c ${LIQUIBASE_HOME}/feature_np21_nwis_yahara.backup.gz | pg_restore -h 127.0.0.1 -p 5432 -U ${NLDI_DB_OWNER_USERNAME} -w -a -d ${NLDI_DATABASE_NAME}
