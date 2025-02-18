ARG DOCKER_MIRROR
ARG LIQUIBASE_DOCKER_VERSION
ARG POSTGIS_DOCKER_VERSION

FROM ${DOCKER_MIRROR:-""}liquibase/liquibase:${LIQUIBASE_DOCKER_VERSION:-"3.10"} as Liquibase

FROM ${DOCKER_MIRROR:-""}postgis/postgis:${POSTGIS_DOCKER_VERSION:-"16-3.5"} AS Postgres

LABEL org.opencontainers.image.authors="gs-w_eto_eb_federal_employees@usgs.gov"
LABEL org.opencontainers.image.title="NLDI Demo Database"
LABEL org.opencontainers.image.description="A demo of the NLDI database containing sample data."

ENV CONTEXTS=demo
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
COPY ./liquibase/scripts/dbInit/*.sh /docker-entrypoint-initdb.d/
COPY ./liquibase/scripts/dbDemo/*.sh /docker-entrypoint-initdb.d/

RUN curl -L --verbose "https://github.com/internetofwater/nldi-db/releases/download/artifacts-2.0.0/crawler_source.yahara.tsv" -o $LIQUIBASE_HOME/nldi/nldi_data/update_crawler_source/crawler_source.tsv
RUN curl -L --verbose "https://github.com/internetofwater/nldi-db/releases/download/artifacts-2.0.0/mainstem_lookup.yahara.csv" -o $LIQUIBASE_HOME/mainstem_lookup.csv

RUN curl -L --verbose "https://github.com/internetofwater/nldi-db/releases/download/artifacts-2.0.0/nhdplus.yahara.pgdump.gz" -o $LIQUIBASE_HOME/nhdplus.yahara.pgdump.gz
RUN curl -L --verbose "https://github.com/internetofwater/nldi-db/releases/download/artifacts-2.0.0/characteristic_data.yahara.pgdump.gz" -o $LIQUIBASE_HOME/characteristic_data.yahara.pgdump.gz
RUN curl -L --verbose "https://github.com/internetofwater/nldi-db/releases/download/artifacts-2.0.0/feature_wqp.yahara.pgdump.gz" -o $LIQUIBASE_HOME/feature_wqp.yahara.pgdump.gz
RUN curl -L --verbose "https://github.com/internetofwater/nldi-db/releases/download/artifacts-2.0.0/feature_huc12pp.yahara.pgdump.gz" -o $LIQUIBASE_HOME/feature_huc12pp.yahara.pgdump.gz
RUN curl -L --verbose "https://github.com/internetofwater/nldi-db/releases/download/artifacts-2.0.0/feature_nwissite.yahara.pgdump.gz" -o $LIQUIBASE_HOME/feature_nwissite.yahara.pgdump.gz

