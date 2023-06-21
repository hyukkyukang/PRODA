# Progressive Data Augmentation for Natural Language to SQL (PRODA)

This is a software to collect natural language and SQL pair data

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[<img src="https://img.shields.io/badge/dockerHub-image-important.svg?logo=Docker">](https://hub.docker.com/repository/docker/hyukkyukang/proda)
[![PRODA:EVQA Unittest](https://github.com/hyukkyukang/proda/actions/workflows/test_EVQA.yml/badge.svg)](https://github.com/hyukkyukang/PRODA/actions/workflows/test_EVQA.yml)
[![PRODA:Deployment](https://github.com/hyukkyukang/proda/actions/workflows/deployment_main.yml/badge.svg)](https://github.com/hyukkyukang/PRODA/actions/workflows/deployment_main.yml)

# How to run

1. Setup docker container
2. Run server and client programs
3. Access through web browser:
    - {ip}:{port}/collection
    - {ip}:{port}/tutorial
    - {ip}:{port}/admin

# Docker

Use Docker compose to setup two containers (i.e., proda and postgresql).

```bash
docker compose up -d
```


# Data Generation

## SQL Generation

<!-- TODO: Need to add description for SQL generation -->

## NL Generation

Prerequisite: Note that NL text is generated from a query graph. To translate a SQL query, a corresponding query graph should be given, which is generated along _SQL Geneartion_ process.

Below code snippet shows an example that generates NL text for a SQL query with a single query block.

```python
from typing import List, Tuple
from src.pylogos.translate import translate
from src.sql_generator.sql_gen_utils.utils import load_graphs, load_objs
from src.pylogos.query_graph.koutrika_query_graph import Query_graph

NUM_OF_QUERY_TO_READ = 10

# Prerequisite: SQL file should be generated with src.sql_generator.query_generator_v2.py
sql_out_file_path: str = None

# Load SQL and query graph
objs = load_objs(filepath + ".obj", NUM_OF_QUERY_TO_READ)
graphs: List[Query_graph] = load_graphs(filepath + ".graph", NUM_OF_QUERY_TO_READ)

# Translate each SQL query
sql_nl_pairs: List[Tuple[str, str]] = []
for obj, graph in zip(objs, graphs):
    sql = obj["sql"]
    nl, _ = translate(graph[1])
    sql_nl_pairs.append((sql, nl))
```

Below code snippet shows an example that generates NL text for a SQL query with multiple query blocks.

```python
from typing import List, Tuple
from src.utils.rewrite_sentence_gpt import set_openai
from src.pylogos.translate_progressive import translate_progressive
from src.sql_generator.sql_gen_utils.utils import load_graphs, load_objs
from src.pylogos.query_graph.koutrika_query_graph import Query_graph
from src.sql_generator.sql_gen_utils.sql_genetion_utils import get_prefix

# Setup for OpenAI API calls
set_openai()

# Prerequisite: Query block files should be generated with src.sql_generator.query_generator_v2.py
sql_out_file_paths: List[str] = None

query_objs = {}
query_graphs = {}
query_trees = []
sql_nl_pair: List[Tuple[str, str]] = []
# Load each query block information from files
for sql_out_file_path in sql_out_file_paths:
    # Get number of queries saved in the file
    with open(sql_out_file_path, "r") as fp:
        num_of_queries = len(fp.readlines())
    # Load query objs and graphs
    objs = load_objs(f"{query_path}.obj", num_of_queries)
    graphs = load_graphs(f"{query_path}.graph", num_of_queries)
    # Format input datas
    for obj, graph in zip(objs, graphs):
        # Get block name
        block_name = get_prefix(loaded_obj["nesting_level"], loaded_obj["unique_alias"])[:-1]
        query_objs[block_name] = obj
        query_graphs[block_name] = graph[1]
        query_trees.append((block_name, graph[0]))

# Translate each query blocks
sql_nl_pairs: List[Tuple[str, str]] = []
for key, query_tree in query_trees:
    if key.startswith("N1"): # hkkang: Not sure what this means.
        sql = query_objs[query_tree[0]]["sql"]
        gpt_input_text, result_text = translate_progressive(query_tree, key, query_objs, query_graphs)
        sql_nl_pairs.append((sql, result_text))
```

# Web Server (Front-end)

The code for the Front-end server are in the `client` directory.

## Setup configs

Please check the environment variables in the `.env` file and change them if necessary.

## Run the server
```bash
cd ./client
yarn install
yarn build
yarn start
```

# API Server (Back-end)

The code for the Front-end server are in the `server` directory.

```bash
cd ./server
npm install
node app.js
```

# Creating Human Intelligence Tasks (HITs) with Amazon Mechanical Turk (AMT)

Below script will create a new HIT and its address will be printed on the console.

```
cd ./src/task/
python hit_generator.py
```
