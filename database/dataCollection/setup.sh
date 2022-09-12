#!/bin/bash

# Exit if a command exits with an error
set -e
# Treat explanding an unset parameter an error (help to catch typos in variable)
set -u

# Create database
psql -c "CREATE DATABASE collection"
psql -d collection -f collection.sql

# Create user
psql -c "DROP ROLE IF EXISTS collection_user"
psql -c "CREATE USER collection_user WITH PASSWORD 'collection_user_pw'"

# Grant privileges
psql << EOF
GRANT CONNECT ON DATABASE collection TO collection_user;
\c collection;
GRANT insert, delete, update, select on workerlog to collection_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO collection_user;
EOF
