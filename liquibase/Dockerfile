ARG LIQUIBASE_DOCKER_VERSION=3.10

FROM liquibase/liquibase:${LIQUIBASE_DOCKER_VERSION}

LABEL maintainer="[gs-w_eto_eb_federal_employees@usgs.gov](mailto:gs-w_eto_eb_federal_employees@usgs.gov)"

ENV LIQUIBASE_HOME /liquibase
ENV LIQUIBASE_WORKSPACE $LIQUIBASE_HOME/workspace
ENV LOCALONLY "-c listen_addresses='127.0.0.1, ::1'"

USER root
COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
USER liquibase

ENTRYPOINT ["docker-entrypoint.sh"]
