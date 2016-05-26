FROM nldidb_nldi_db

MAINTAINER David Steinich <drsteini@usgs.gov>

############################################
# Grab Files to Load the Demo Database Data
############################################

COPY ./3_load_demo.sh /docker-entrypoint-initdb.d/

COPY ./crawler_source.backup.gz $LIQUIBASE_HOME/
COPY ./feature_wqp_yahara.backup.gz $LIQUIBASE_HOME/
COPY ./feature_huc12pp_yahara.backup.gz $LIQUIBASE_HOME/
COPY ./feature_np21_nwis_yahara.backup.gz $LIQUIBASE_HOME/
