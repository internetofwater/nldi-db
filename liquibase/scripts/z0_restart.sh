#!/bin/bash 

# Restart postgres to make sure we can connect
pg_ctl -D "$PGDATA" -m fast -o "$LOCALONLY" -w restart