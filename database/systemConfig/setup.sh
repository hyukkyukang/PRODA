#!/bin/bash

set -e
set -u

psql -c "CREATE DATABASE proda_config"
psql -d proda_config -f init.sql

# Create user
psql -c "DROP ROLE IF EXISTS config_user"
psql -c "CREATE USER config_user WITH PASSWORD 'config_user_pw'"

# Grant privileges
psql << EOF
GRANT CONNECT ON DATABASE proda_config TO config_user;
\c proda_config;
GRANT insert, delete, update, select on config to config_user;
GRANT insert, delete, update, select on query_goal to config_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO config_user;
EOF