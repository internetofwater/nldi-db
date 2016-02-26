#!/bin/bash 

# Pull down the latest snapshot
group="gov.usgs.cida.dsas"
artifact="dsas-liquibase"
nexusUrl="http://cida.usgs.gov/maven/service/local/artifact/maven/"
artifact="?r=cida-public-snapshots&g=${group}&a=${artifact}&v=LATEST&e=jar"
fileLocation="/dsas-liquibase.jar"
finalJarLocation="/opt/liquibase/dsas-liquibase.jar"
remoteSHA1=$(curl "${nexusUrl}resolve${artifact}" | xmllint --xpath "string(//sha1)" -)

# Check to see if we already have the artifact and if so, verify that it's the same
# file as the remote version
if [ -f $finalJarLocation ]; then
    echo "${finalJarLocation} already exists"
    existingSHA1=$(sha1sum $finalJarLocation | cut -d ' ' -f 1)
    if [ $remoteSHA1 == $existingSHA1 ]; then
        # This is the same file as remote. We're done
        exit 0
    fi
    echo "${finalJarLocation} differs from remote version. Remote version will be downloaded"
fi

echo "Getting artifact from CIDA Nexus"
wget "${nexusUrl}redirect${artifact}" -O $fileLocation

echo "Validating download"
localSHA1=$(sha1sum $fileLocation | cut -d ' ' -f 1)
if [ $remoteSHA1 == $localSHA1 ]; then 
    mv $fileLocation $finalJarLocation
else 
    echo "Remote file SHA1 differs from downloaded version."
    exit 1
fi

unzip -o $LIQUIBASE_HOME/dsas-liquibase.jar -d $LIQUIBASE_HOME/dsas_liquibase
