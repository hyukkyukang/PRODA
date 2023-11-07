import numpy as np
import pandas as pd
import os
import sys
import argparse
import datetime
import time
import json
import logging
from requests.structures import CaseInsensitiveDict
import src.sql_generator.sql_gen_utils.utils as utils
from src.config import config


def get_equi_bin_sql_selective(column, table, bin_size, max_count, min_count):
    return f"""SELECT floor({column}/{bin_size})*{bin_size}::float as buckets,
         COUNT(*),
         {bin_size}::float as bin_size
        FROM {table}
        GROUP BY buckets
        HAVING COUNT(*) > {min_count} AND COUNT(*) < {max_count}
        ORDER BY buckets;"""


def get_frequency_sql_selective(column, table, max_count, min_count):
    return f"""SELECT {column},
         COUNT(*)
        FROM {table}
        GROUP BY {column}
        HAVING COUNT(*) > {min_count} AND COUNT(*) < {max_count}
        ORDER BY {column};"""


def create_histogram(args, data_manager, table, row_count):
    hist = {}

    max_count = args.selectivity_max * row_count
    min_count = args.selectivity_min * row_count

    for column in table_info[table]:
        full_column_name = f"{table}.{column}"
        if args.column_info["dtype_dict"][full_column_name] in ("int", "float"):
            value_count = data_manager.get_distinct_value_counts(table, column)
            if value_count > 20:
                data_manager.execute(f"""SELECT MIN({column}) FROM {table}""")
                min_val = data_manager.fetchall()[0][0]

                data_manager.execute(f"""SELECT MAX({column}) FROM {table}""")
                max_val = data_manager.fetchall()[0][0]

                bin_size = max((max_val - min_val) / 20, 1)
                sql = get_equi_bin_sql_selective(column, table, bin_size, max_count, min_count)
            else:
                sql = get_frequency_sql_selective(column, table, max_count, min_count)
        else:
            sql = get_frequency_sql_selective(column, table, max_count, min_count)

        data_manager.execute(sql)
        vals = data_manager.fetchall()
        hist[column] = vals

    return hist


def get_selective_predicates(args, data_manager, schema):
    selective_predicates = {}
    for table in table_info.keys():
        row_count = data_manager.get_row_counts(table)
        if row_count < args.rows_min:
            continue
        selective_predicates[table] = create_histogram(args, data_manager, table, row_count)

    return selective_predicates


if __name__ == "__main__":
    # argument
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--infile",
        type=str,
        default="data/database/nba/schema_generation_guide.json",
    )
    args = parser.parse_args()
    if args.infile:
        with open(args.infile, "rt") as f:
            t_args = argparse.Namespace()
            t_args.__dict__.update(json.load(f))
            args = parser.parse_args(namespace=t_args)

    SCHEMA = json.load(open(f"{args.data_dir}/{args.db}/schema_origin.json"))
    schema = CaseInsensitiveDict(utils.lower_case_schema_data(SCHEMA[args.db]))

    COL_INFO = json.load(open(f"{args.data_dir}/{args.db}/dtype_dict.json"))
    column_info = COL_INFO[schema["dataset"]]

    IP = config["DB"]["IP"]
    port = config["DB"]["Port"]
    DBUserID = config["DB"]["data"]["UserID"]
    DBUserPW = config["DB"]["data"]["UserPW"]

    data_manager, table_info = utils.connect_data_manager(IP, port, DBUserID, DBUserPW, schema)
    args.table_info = CaseInsensitiveDict(table_info)
    args.column_info = column_info
    selective_predicates = get_selective_predicates(args, data_manager, schema)

    with open(f"{args.data_dir}/{args.db}/selective_histogram.json", "w") as wf:
        json.dump(selective_predicates, wf)
