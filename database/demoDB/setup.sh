#!/bin/bash

set -e
set -u

# for database in imdb dataset
psql -c "CREATE DATABASE proda_demo"
psql -d proda_demo -f cars.sql

# Create user
psql -c "DROP ROLE IF EXISTS demo_user"
psql -c "CREATE USER demo_user WITH PASSWORD 'demo_user_pw'"
psql -c "GRANT CONNECT ON DATABASE proda_demo TO demo_user"

# Grant privileges
psql << EOF
GRANT CONNECT ON DATABASE proda_demo TO demo_user;
\c proda_demo;
GRANT insert, delete, update, select on cars to demo_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO demo_user;
EOF