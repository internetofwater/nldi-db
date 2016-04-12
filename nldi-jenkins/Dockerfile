FROM jenkins:1.642.4

MAINTAINER David Steinich <drsteini@usgs.gov>

USER root
#RUN apt-get update \
#      && apt-get install -y sudo \
#      && rm -rf /var/lib/apt/lists/*
#RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

############################################
# Install Liquibase
############################################

ENV LIQUIBASE_HOME /opt/liquibase
#ENV POSTGRES /usr/lib/postgresql/9.4/bin/postgres
#ENV CONF  /etc/postgresql/9.4/main/postgresql.conf
#ENV LOCALONLY "-c listen_addresses='127.0.0.1, ::1'"

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

## Jenkins settings
COPY config/config.xml /usr/share/jenkins/ref/config.xml

## Jenkins Settings, i.e. Maven, Groovy, ...
#COPY config/hudson.tasks.Maven.xml /usr/share/jenkins/ref/hudson.tasks.Maven.xml
#COPY config/hudson.plugins.groovy.Groovy.xml /usr/share/jenkins/ref/hudson.plugins.groovy.Groovy.xml
#COPY config/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml

## SSH Keys & Credentials
#COPY config/credentials.xml /usr/share/jenkins/ref/credentials.xml
#COPY config/ssh-keys/cd-demo /usr/share/jenkins/ref/.ssh/id_rsa
#COPY config/ssh-keys/cd-demo.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub
