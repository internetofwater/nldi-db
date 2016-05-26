FROM jenkins:1.651.2

MAINTAINER David Steinich <drsteini@usgs.gov>

USER root

############################################
# Install Liquibase
############################################

ENV LIQUIBASE_HOME /opt/liquibase

ADD https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.4.2/liquibase-3.4.2-bin.tar.gz $LIQUIBASE_HOME/

ADD https://jdbc.postgresql.org/download/postgresql-9.4-1204.jdbc42.jar $LIQUIBASE_HOME/lib/

RUN chmod 664 $LIQUIBASE_HOME/lib/postgresql-9.4-1204.jdbc42.jar

RUN tar -xzf $LIQUIBASE_HOME/liquibase-3.4.2-bin.tar.gz -C $LIQUIBASE_HOME/

############################################
# Configure Jenkins
############################################

USER jenkins

# Manage Plugins
COPY plugins.txt /var/jenkins_home/plugins.txt
RUN /usr/local/bin/plugins.sh /var/jenkins_home/plugins.txt

# Add Jobs
COPY jobs/LiquibaseNLDI.xml /usr/share/jenkins/ref/jobs/LiquibaseNLDI/config.xml

# Jenkins settings
COPY config/config.xml /usr/share/jenkins/ref/config.xml
