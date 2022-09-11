#!/bin/bash

set -e
set -u

psql -c "CREATE DATABASE dataLog"
psql -d datalog -f datalog.sql