#!/bin/bash

# The CI database should be completely cleared of data.
# The crawler_source table has data injected from the liquibase
# changelogs, so it needs to be truncated.
psql --host=127.0.0.1 \
	--port=5432 \
	--username=postgres \
	--no-password \
	--dbname=${NLDI_DATABASE_NAME} \
	--command='truncate table nldi_data.crawler_source;'

exit 0
