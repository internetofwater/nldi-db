FROM liquibase/liquibase:3.10 as Liquibase

FROM postgis/postgis:12-3.0 AS Postgres

LABEL maintainer=gs-w_eto_eb_federal_employees@usgs.gov

ENV LIQUIBASE_HOME /liquibase
ENV LIQUIBASE_WORKSPACE /liquibase
COPY --from=Liquibase ${LIQUIBASE_WORKSPACE} ${LIQUIBASE_WORKSPACE}
ENV JAVA_HOME /usr/local/openjdk-11
COPY --from=Liquibase ${JAVA_HOME} ${JAVA_HOME}

############################################
# Grab files for initializing the database
############################################

COPY ./liquibase/changeLogs $LIQUIBASE_WORKSPACE
COPY ./liquibase/scripts/*.sh /docker-entrypoint-initdb.d/
COPY ./liquibase/scripts/dbInit /docker-entrypoint-initdb.d/
COPY ./liquibase/scripts/dbCi /docker-entrypoint-initdb.d/

RUN apt-get update && apt-get install -y curl
RUN curl -L --verbose  "https://github.com/ACWI-SSWD/nldi-db/releases/download/artifacts-1.0.0/nhdplus.yahara.pgdump.gz" -o $LIQUIBASE_HOME/nhdplus.yahara.pgdump.gz
RUN curl -L --verbose  "https://github.com/ACWI-SSWD/nldi-db/releases/download/artifacts-1.0.0/characteristic_data.yahara.pgdump.gz" -o $LIQUIBASE_HOME/characteristic_data.yahara.pgdump.gz
