ARG DOCKER_MIRROR
ARG LIQUIBASE_DOCKER_VERSION
ARG POSTGIS_DOCKER_VERSION

FROM ${DOCKER_MIRROR:-""}liquibase/liquibase:${LIQUIBASE_DOCKER_VERSION:-"3.10"} as Liquibase

FROM ${DOCKER_MIRROR:-""}postgis/postgis:${POSTGIS_DOCKER_VERSION:-"16-3.5"} AS Postgres

LABEL org.opencontainers.image.authors="gs-w_eto_eb_federal_employees@usgs.gov"
LABEL org.opencontainers.image.title="NLDI CI Database"
LABEL org.opencontainers.image.description="A sample NLDI database used for continuous integration testing."

ENV CONTEXTS=ci
ENV LIQUIBASE_HOME /liquibase
ENV LIQUIBASE_WORKSPACE /liquibase
COPY --from=Liquibase ${LIQUIBASE_WORKSPACE} ${LIQUIBASE_WORKSPACE}
ENV JAVA_HOME /usr/local/openjdk-11
COPY --from=Liquibase ${JAVA_HOME} ${JAVA_HOME}
RUN apt-get update && apt-get install -y curl

############################################
# Grab files for initializing the database
############################################

COPY ./liquibase/changeLogs $LIQUIBASE_WORKSPACE
COPY ./liquibase/scripts/*.sh /docker-entrypoint-initdb.d/
COPY ./liquibase/scripts/dbInit /docker-entrypoint-initdb.d/
