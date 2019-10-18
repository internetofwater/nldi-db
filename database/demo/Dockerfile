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

RUN curl "https://cida.usgs.gov/artifactory/nldi/datasets/nhdplus.yahara.pgdump.gz" -o $LIQUIBASE_HOME/nhdplus.yahara.pgdump.gz
RUN curl "https://cida.usgs.gov/artifactory/nldi/datasets/characteristic_data.yahara.pgdump.gz" -o $LIQUIBASE_HOME/characteristic_data.yahara.pgdump.gz
RUN curl "https://cida.usgs.gov/artifactory/nldi/datasets/nldi_data.crawler_source.pgdump.gz" -o $LIQUIBASE_HOME/nldi_data.crawler_source.pgdump.gz
RUN curl "https://cida.usgs.gov/artifactory/nldi/datasets/feature_wqp_yahara.backup.gz" -o $LIQUIBASE_HOME/feature_wqp_yahara.backup.gz
RUN curl "https://cida.usgs.gov/artifactory/nldi/datasets/feature_huc12pp_yahara.backup.gz" -o $LIQUIBASE_HOME/feature_huc12pp_yahara.backup.gz
RUN curl "https://cida.usgs.gov/artifactory/nldi/datasets/feature_np21_nwis_yahara.backup.gz" -o $LIQUIBASE_HOME/feature_np21_nwis_yahara.backup.gz
