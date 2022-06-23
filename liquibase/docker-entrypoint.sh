#!/usr/bin/env bash

bash /usr/local/bin/wait-for-it.sh $NLDI_DATABASE_ADDRESS:5432 -- echo "Postgres is up - executing command"

export JAVA_OPTS="${JAVA_OPTS} ${EXTRA_JAVA_OPTS}"

for f in /docker-entrypoint-initdb.d/*; do
	if [ -x "$f" ]; then
		echo "$0: running $f"
		"$f"
	else
		echo "$0: sourcing $f"
		. "$f"
	fi
	echo
done

exec "$@"
