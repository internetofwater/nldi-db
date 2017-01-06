FROM nldidb_nldi_db

MAINTAINER David Steinich <drsteini@usgs.gov>

############################################
# Grab Files to Load the Demo Database Data
############################################

COPY ./3_load_demo.sh /docker-entrypoint-initdb.d/

RUN curl "https://cida.usgs.gov/artifactory/nldi/datasets/crawler_source.backup.gz" -o $LIQUIBASE_HOME/crawler_source.backup.gz
RUN curl "https://cida.usgs.gov/artifactory/nldi/datasets/feature_wqp_yahara.backup.gz" -o $LIQUIBASE_HOME/feature_wqp_yahara.backup.gz
RUN curl "https://cida.usgs.gov/artifactory/nldi/datasets/feature_huc12pp_yahara.backup.gz" -o $LIQUIBASE_HOME/feature_huc12pp_yahara.backup.gz
RUN curl "https://cida.usgs.gov/artifactory/nldi/datasets/feature_np21_nwis_yahara.backup.gz" -o $LIQUIBASE_HOME/feature_np21_nwis_yahara.backup.gz
