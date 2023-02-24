# Progressive Data Augmentation for Natural Language to SQL (PRODA)

This is a software to collect natural language and SQL pair data

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[<img src="https://img.shields.io/badge/dockerHub-image-important.svg?logo=Docker">](https://hub.docker.com/repository/docker/hyukkyukang/proda)
[![PRODA:EVQL Unittest](https://github.com/hyukkyukang/proda/actions/workflows/test_EVQL.yml/badge.svg)](https://github.com/hyukkyukang/PRODA/actions/workflows/test_EVQL.yml)
[![PRODA:Deployment](https://github.com/hyukkyukang/proda/actions/workflows/deployment_main.yml/badge.svg)](https://github.com/hyukkyukang/PRODA/actions/workflows/deployment_main.yml)

# How to run

1. Setup docker container 
2. Install and setup database
3. Run server and client programs
4. Access through web browser:
    - {ip}:{port}/collection
    - {ip}:{port}/tutorial
    - {ip}:{port}/admin

# Docker

Using Dockerfile

```bash
docker pull hyukkyukang/proda:latest
docker run -it -p 3000:3000 -p 4001:4001 -p 5432:5432 -v ./:/app --name proda hyukkyukang/proda:latest /bin/bash
```

or using docker-compose

```bash
docker-compose up -d
```

# Setting system DBs

0. Install and start Postgresql
```
apt update
apt install postgresql postgresql-contrib
service postgresql start
pip install -r src/requirements.txt
```


1. change user to get privilege

```bash
su postgres
```

2. set config DB

```bash
cd database/systemConfig
sh setup.sh
```

3. set Demo DB

```bash
cd database/demoDB
sh setup.sh
```

4. set data collection DB

```bash
cd database/dataCollection
sh setup.sh
```

# Web Server (Front-end)

The code for the Front-end server are in the `client` directory.
Please change the working directory `cd ./client` and follow the below instructions.
## Setup configs

Please check the environment variables in the `.env` file and change them if necessary.

## Run the server

1. yarn install
2. yarn start

## Development
Please use `yarn dev` or `yarn dev-https`, according to the protocol you desire.

# API Server (Back-end)

The code for the Front-end server are in the `server` directory.
Please change the working directory `cd ./client` and follow the below instructions.

1. npm install
2. node app.js

# Creating Human Intelligence Tasks (HITs) with Amazon Mechanical Turk (AMT)

Below script will create a new HIT and its address will be printed on the console.
```
cd src/task/
python hit_generator.py
```

