ARG DOCKER_MIRROR
ARG LIQUIBASE_DOCKER_VERSION

FROM ${DOCKER_MIRROR:-""}liquibase/liquibase:${LIQUIBASE_DOCKER_VERSION:-"3.10"}

LABEL org.opencontainers.image.authors="gs-w_eto_eb_federal_employees@usgs.gov"
LABEL org.opencontainers.image.title="NLDI Liquibase"
LABEL org.opencontainers.image.description="Liquibase container for configuring the NLDI database."

ENV LIQUIBASE_HOME /liquibase
ENV LIQUIBASE_WORKSPACE $LIQUIBASE_HOME/workspace

ENV NLDI_DATABASE_ADDRESS=missing_db_address
ENV NLDI_DATABASE_NAME=nldi
ENV NLDI_DB_OWNER_USERNAME=missing_owner_username
ENV NLDI_DB_OWNER_PASSWORD=missing_owner_password
ENV NLDI_SCHEMA_OWNER_USERNAME=missing_nldi_schema_owner_username
ENV NLDI_SCHEMA_OWNER_PASSWORD=missing_nldi_schema_owner_password
ENV NHDPLUS_SCHEMA_OWNER_USERNAME=missing_nhdplus_schema_owner_username
ENV NLDI_READ_ONLY_USERNAME=missing_read_only_username
ENV NLDI_READ_ONLY_PASSWORD=missing_read_only_password
ENV POSTGRES_PASSWORD=missing_postgres_password

USER root
COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
USER liquibase

COPY ./changeLogs /liquibase/workspace/.
COPY ./scripts/dbInit/* /docker-entrypoint-initdb.d/

ENTRYPOINT ["docker-entrypoint.sh"]
