FROM usgswma/iow_test_db:postgis11-jre11

LABEL maintainer=gs-w_eto_eb_federal_employees@usgs.gov

ARG DEFAULT_PASSWORD=changeMe
ARG DEFAULT_DATABASE_NAME=nldi_db_name
ARG DEFAULT_DATABASE_ADDRESS=127.0.0.1
ARG DEFAULT_DB_OWNER_USERNAME=nldi
ARG POSTGRES_PASSWORD="${DEFAULT_PASSWORD}"
ENV POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"
ARG NLDI_DATABASE_ADDRESS="${DEFAULT_DATABASE_ADDRESS}"
ENV NLDI_DATABASE_ADDRESS="${NLDI_DATABASE_ADDRESS}"
ARG NLDI_DATABASE_NAME="${DEFAULT_DATABASE_NAME}"
ENV NLDI_DATABASE_NAME="${NLDI_DATABASE_NAME}"
ARG NLDI_DB_OWNER_USERNAME="${DEFAULT_DB_OWNER_USERNAME}"
ENV NLDI_DB_OWNER_USERNAME="${NLDI_DB_OWNER_USERNAME}"
ARG NLDI_DB_OWNER_PASSWORD="${DEFAULT_PASSWORD}"
ENV NLDI_DB_OWNER_PASSWORD="${NLDI_DB_OWNER_PASSWORD}"
ARG NLDI_SCHEMA_OWNER_USERNAME=nldi_schema_owner
ENV NLDI_SCHEMA_OWNER_USERNAME="${NLDI_SCHEMA_OWNER_USERNAME}"
ARG NLDI_SCHEMA_OWNER_PASSWORD="${DEFAULT_PASSWORD}"
ENV NLDI_SCHEMA_OWNER_PASSWORD="${NLDI_SCHEMA_OWNER_PASSWORD}"
ARG NLDI_READ_ONLY_USERNAME=read_only_user
ENV NLDI_READ_ONLY_USERNAME="${NLDI_READ_ONLY_USERNAME}"
ARG NLDI_READ_ONLY_PASSWORD="${DEFAULT_PASSWORD}"
ENV NLDI_READ_ONLY_PASSWORD="${NLDI_READ_ONLY_PASSWORD}"
ARG NHDPLUS_SCHEMA_OWNER_USERNAME=nhdplus
ENV NHDPLUS_SCHEMA_OWNER_USERNAME="${NLDI_SCHEMA_OWNER_USERNAME}"
ARG NHDPLUS_SCHEMA_OWNER_PASSWORD="${DEFAULT_PASSWORD}"
ENV NHDPLUS_SCHEMA_OWNER_PASSWORD="${NLDI_SCHEMA_OWNER_PASSWORD}"

############################################
# Grab files for initializing the database
############################################

COPY ./liquibase/changeLogs $LIQUIBASE_WORKSPACE
COPY ./liquibase/scripts/*.sh /docker-entrypoint-initdb.d/
COPY ./liquibase/scripts/dbInit /docker-entrypoint-initdb.d/
COPY ./liquibase/scripts/dbCi /docker-entrypoint-initdb.d/

RUN curl --verbose  "https://artifactory.wma.usgs.gov/artifactory/wma-binaries/iow/nldi/nhdplus.yahara.pgdump.gz" -o $LIQUIBASE_HOME/nhdplus.yahara.pgdump.gz
RUN curl --verbose  "https://artifactory.wma.usgs.gov/artifactory/wma-binaries/iow/nldi/characteristic_data.yahara.pgdump.gz" -o $LIQUIBASE_HOME/characteristic_data.yahara.pgdump.gz
