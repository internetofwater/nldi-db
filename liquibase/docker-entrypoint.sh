#!/usr/bin/env bash

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
