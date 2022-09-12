#!/bin/bash

set -e
set -u

psql -c "CREATE DATABASE dataLog"
psql -d datalog -f datalog.sql

psql -c "DROP ROLE IF EXISTS my_user"
psql -c "CREATE USER datalog_user WITH PASSWORD 'datalog_user_password'"
psql -c "GRANT CONNECT ON DATABASE datalog TO datalog_user"
psql -c "GRANT insert, delete, update, select on tasklog to datalog_user;"