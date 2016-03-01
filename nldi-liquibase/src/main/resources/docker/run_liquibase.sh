
#cat $LIQUIBASE_HOME/liquibase.properties | envsubst > $LIQUIBASE_HOME/tmp.properties
#mv $LIQUIBASE_HOME/tmp.properties $LIQUIBASE_HOME/liquibase.properties

# Allow to skip liquibase by exporting the SKIP_LIQUIBASE variable, setting it to anything
if [ -z "$SKIP_LIQUIBASE" ]; then
        echo "Running Liquibase..."
        cat ${LIQUIBASE_HOME}/liquibase.properties
		$LIQUIBASE_HOME/liquibase --defaultsFile=${LIQUIBASE_HOME}/liquibase.properties --changeLogFile=${LIQUIBASE_HOME}/nldi/changeLog.xml update > $LIQUIBASE_HOME/liquibase.log
else
        echo "Skipping Liquibase"
fi
