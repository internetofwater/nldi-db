FROM anapsix/alpine-java

MAINTAINER David Steinich <drsteini@usgs.gov>

ENV LIQUIBASE_HOME /opt/liquibase

ADD https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.4.2/liquibase-3.4.2-bin.tar.gz $LIQUIBASE_HOME/

ADD https://jdbc.postgresql.org/download/postgresql-9.4-1204.jdbc42.jar $LIQUIBASE_HOME/lib/

COPY run_liquibase.sh $LIQUIBASE_HOME/run_liquibase.sh

COPY rerun_liquibase.sh $LIQUIBASE_HOME/rerun_liquibase.sh

RUN chmod 755 $LIQUIBASE_HOME/run_liquibase.sh
RUN chmod 755 $LIQUIBASE_HOME/rerun_liquibase.sh

COPY liquibase.properties $LIQUIBASE_HOME/
#RUN sed -i -e "s/DB_HOSTNAME/$NLDI_DB_PORT_5432_TCP_ADDR/" $LIQUIBASE_HOME/liquibase.properties

#COPY download-liquibase.sh $LIQUIBASE_HOME/
COPY ./liquibase $LIQUIBASE_HOME/nldi/

RUN tar -xzf $LIQUIBASE_HOME/liquibase-3.4.2-bin.tar.gz -C $LIQUIBASE_HOME/

#RUN chmod 755 $LIQUIBASE_HOME/download-liquibase.sh \
#    && sleep 1 \
#	&& $LIQUIBASE_HOME/download-liquibase.sh
#RUN $LIQUIBASE_HOME/run_liquibase.sh
