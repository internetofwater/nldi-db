FROM usgswma/openjdk:debian-stretch-openjdk-11

LABEL maintainer="[gs-w_eto_eb_federal_employees@usgs.gov](mailto:gs-w_eto_eb_federal_employees@usgs.gov)"

############################################
# Install Liquibase
############################################

ARG LIQUIBASE_VERSION
ARG A_JDBC_JAR
ENV JDBC_JAR=$A_JDBC_JAR
ENV LIQUIBASE_HOME $HOME
ENV LIQUIBASE_WORKSPACE $LIQUIBASE_HOME/workspace
ENV LOCALONLY "-c listen_addresses='127.0.0.1, ::1'"

ADD https://github.com/liquibase/liquibase/releases/download/liquibase-parent-$LIQUIBASE_VERSION/liquibase-$LIQUIBASE_VERSION-bin.tar.gz $LIQUIBASE_HOME/

ADD https://jdbc.postgresql.org/download/$JDBC_JAR $LIQUIBASE_HOME/lib/

RUN tar -xzf $LIQUIBASE_HOME/liquibase-$LIQUIBASE_VERSION-bin.tar.gz -C $LIQUIBASE_HOME/

RUN chmod -R 777 $LIQUIBASE_HOME

COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
