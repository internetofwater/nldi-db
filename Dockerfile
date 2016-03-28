FROM postgres:9.5

MAINTAINER David Steinich <drsteini@usgs.gov>

############################################
# Install postgis
############################################

ENV POSTGIS_MAJOR 2.2
ENV POSTGIS_VERSION 2.2.1+dfsg-2.pgdg80+1

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgis=$POSTGIS_VERSION \
      && rm -rf /var/lib/apt/lists/*


############################################
# Required for JRE 8 - Java 8 is required to run the Liquibase JAR
############################################

RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list

RUN apt-get update \
	&& apt-get install -y gettext libxml2-utils wget curl unzip openjdk-8-jre


############################################
# Install Liquibase
############################################

ENV LIQUIBASE_HOME /opt/liquibase
ENV JENKINS_WORKSPACE /var/jenkins_home/jobs/LiquibaseNLDI/workspace
#ENV POSTGRES /usr/lib/postgresql/9.4/bin/postgres
#ENV CONF  /etc/postgresql/9.4/main/postgresql.conf
ENV LOCALONLY "-c listen_addresses='127.0.0.1, ::1'"

ADD https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.4.2/liquibase-3.4.2-bin.tar.gz $LIQUIBASE_HOME/

ADD https://jdbc.postgresql.org/download/postgresql-9.4-1204.jdbc42.jar $LIQUIBASE_HOME/lib/

RUN tar -xzf $LIQUIBASE_HOME/liquibase-3.4.2-bin.tar.gz -C $LIQUIBASE_HOME/


############################################
# Grab Files to Configure Database with Liquibase
############################################

COPY ./dbInit/a_run_liquibase.sh /docker-entrypoint-initdb.d/

COPY ./dbInit/liquibase.properties $LIQUIBASE_HOME/

COPY ./nldi-liquibase $JENKINS_WORKSPACE/nldi-liquibase

############################################
# Grab File to Load the CI Database Data
############################################

COPY ./dbInit/b_load_ci.sh /docker-entrypoint-initdb.d/

COPY ./dbInit/nhdplus_yahara.backup.gz $LIQUIBASE_HOME/
