#!/bin/bash

SET=$(seq 0 0)
for i in $SET
do
    python query_generator_v2.py --num_queries 100 \
        --output imdb.sql \
        --schema_name imdb-full \
        --db imdb \
        --join_key_pred True \
        --seed ${i}
done



