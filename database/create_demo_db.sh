#!/bin/bash

set -e
set -u

# for database in imdb dataset
psql -c "CREATE DATABASE demo"
psql -d demo -f cars.sql
