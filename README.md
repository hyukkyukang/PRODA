# Progressive Data Augmentation for Natural Language to SQL (PRODA)

This is a software to collect natural language and SQL pair data

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[<img src="https://img.shields.io/badge/dockerHub-image-important.svg?logo=Docker">](https://hub.docker.com/repository/docker/hyukkyukang/proda)
[![PRODA:EVQL Unittest](https://github.com/hyukkyukang/proda/actions/workflows/test_EVQL.yml/badge.svg)](https://github.com/hyukkyukang/PRODA/actions/workflows/test_EVQL.yml)
[![PRODA:Deployment](https://github.com/hyukkyukang/proda/actions/workflows/deployment_main.yml/badge.svg)](https://github.com/hyukkyukang/PRODA/actions/workflows/deployment_main.yml)

# Docker

Using Dockerfile

```bash
docker pull hyukkyukang/proda:latest
docker run -it -p 3000:3000 -p 4000:4000 -p 5432:5432 -v ./:/app --name proda hyukkyukang/proda:latest /bin/bash
```

or using docker-compose

```bash
docker-compose up -d
```

# Setting system Databases

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

# Web Client

1. cd ./client
2. yarn install
3. yarn start

# Web Server

1. cd ./server
2. npm install
3. node app.js

# Docker Image

docker pull hyukkyukang/proda:0.4
