FROM usgswma/iow_test_db:postgis11-jre11

LABEL maintainer=gs-w_eto_eb_federal_employees@usgs.gov

############################################
# Grab files for initializing the database
############################################

COPY ./liquibase/changeLogs $LIQUIBASE_WORKSPACE
COPY ./liquibase/scripts/*.sh /docker-entrypoint-initdb.d/
COPY ./liquibase/scripts/dbInit /docker-entrypoint-initdb.d/
COPY ./liquibase/scripts/dbCi /docker-entrypoint-initdb.d/
COPY ./liquibase/scripts/dbDemo /docker-entrypoint-initdb.d/


RUN curl --verbose "https://github.com/ACWI-SSWD/nldi-db/releases/download/artifacts-1.0.0/nhdplus.yahara.pgdump.gz" -o $LIQUIBASE_HOME/nhdplus.yahara.pgdump.gz
RUN curl --verbose "https://github.com/ACWI-SSWD/nldi-db/releases/download/artifacts-1.0.0/characteristic_data.yahara.pgdump.gz" -o $LIQUIBASE_HOME/characteristic_data.yahara.pgdump.gz
RUN curl --verbose "https://github.com/ACWI-SSWD/nldi-db/releases/download/artifacts-1.0.0/nldi_data.crawler_source.pgdump.gz" -o $LIQUIBASE_HOME/nldi_data.crawler_source.pgdump.gz
RUN curl --verbose "https://github.com/ACWI-SSWD/nldi-db/releases/download/artifacts-1.0.0/feature_wqp_yahara.backup.gz" -o $LIQUIBASE_HOME/feature_wqp_yahara.backup.gz
RUN curl --verbose "https://github.com/ACWI-SSWD/nldi-db/releases/download/artifacts-1.0.0/feature_huc12pp_yahara.backup.gz" -o $LIQUIBASE_HOME/feature_huc12pp_yahara.backup.gz
RUN curl --verbose "https://github.com/ACWI-SSWD/nldi-db/releases/download/artifacts-1.0.0/feature_np21_nwis_yahara.backup.gz" -o $LIQUIBASE_HOME/feature_np21_nwis_yahara.backup.gz
