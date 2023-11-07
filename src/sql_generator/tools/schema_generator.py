import numpy as np
import pandas as pd
import os
import sys
import argparse
import datetime
import time
import json
import logging
import copy
from requests.structures import CaseInsensitiveDict
import src.sql_generator.sql_gen_utils.utils as utils
from src.sql_generator.sql_gen_utils.sql_genetion_utils import (
    is_categorical_column,
    is_id_column,
    get_truncated_geometric_distribution,
    get_truncated_normal_distribution,
    get_table_from_clause,
    get_table_join_key_from_join_clause,
    find_join_path_target,
    get_possible_join,
    set_col_info,
)
from src.config import config


def get_query_token(
    args,
    all_table_set,
    join_key_list,
    data_manager,
    join_clause_list,
    sql_type_dict,
    rng,
    inner_query_tables=None,
):
    df_columns = []
    for table in all_table_set:
        columns = args.table_info[table]
        # columns = data_manager.fetch_column_names(table)
        df_columns += [table + "." + column for column in columns]

    df_columns_not_null = []
    for column in df_columns:
        table = column.split(".")[0]
        data_manager.execute(f"SELECT * FROM {table} WHERE {column} IS NOT NULL LIMIT 1")
        result = data_manager.fetchall()
        if len(result) > 0:
            df_columns_not_null.append(column)

    ### sampling tables

    avaliable_join_keys = list()
    avaliable_pred_cols = list(df_columns)
    for col in df_columns_not_null:
        if col in join_key_list:
            avaliable_join_keys.append(col)

    avaliable_join_list = list()
    avaliable_table_set = set()
    for join_clause in join_clause_list:
        A, B = join_clause.split("=")
        if A in avaliable_join_keys and B in avaliable_join_keys:
            avaliable_table_set.add(A.split(".")[0])
            avaliable_table_set.add(B.split(".")[0])
            avaliable_join_list.append(join_clause)

    if len(avaliable_table_set) == 0:
        for col in df_columns_not_null:
            table = col.split(".")[0]
            avaliable_table_set.add(table)

    avaliable_tables = list(avaliable_table_set)

    max_join = min(args.hyperparams["num_join_max"], len(avaliable_join_list) + 1)
    min_join = args.hyperparams["num_join_min"]
    if min_join > max_join:
        args.logger.warning(
            f"Sampling table is failed: minimum number of joins is greater than maximum number of joins"
        )
        assert False
    prob = get_truncated_geometric_distribution(max_join - min_join + 1, 1 - args.hyperparams["prob_join"])
    num_join_clause = rng.choice(range(min_join, max_join + 1), p=prob)

    table_set = set()
    tables = list()
    joins = list()
    candiate_cols = list()
    predicates_cols = list()
    candidate_cols_projection = list()

    if sql_type_dict["group"]:
        # choose table having categorical columns
        candidate_root_tables = set()
        for column in df_columns_not_null:
            if is_categorical_column(args, column):
                candidate_root_tables.add(column.split(".")[0])
        candidate_root_tables = list(candidate_root_tables)

        if len(candidate_root_tables) == 0:
            args.logger.warning("No table has a categorical column but we will generate GROUP BY clause")
            candidate_root_tables = avaliable_tables
        table = rng.choice(candidate_root_tables)
    else:
        table = rng.choice(avaliable_tables)

    table_set.add(table)

    if num_join_clause > 0:
        available_init_join = []
        for join_clause in avaliable_join_list:
            t1, t2 = get_table_from_clause(join_clause)
            if t1 == table or t2 == table:
                available_init_join.append(join_clause)

        init_join = rng.choice(available_init_join)
        avaliable_join_list.remove(init_join)
        joins.append(init_join)

        t1, t2 = get_table_from_clause(init_join)
        table_set.add(t1)
        table_set.add(t2)

        while len(joins) < num_join_clause:
            candidate_joins = get_possible_join(joins, avaliable_join_list)
            if len(candidate_joins) == 0:
                break
            next_join = rng.choice(candidate_joins)
            avaliable_join_list.remove(next_join)
            joins.append(next_join)

            t1, t2 = get_table_from_clause(next_join)
            table_set.add(t1)
            table_set.add(t2)

    if inner_query_tables is not None:
        for inner_table in inner_query_tables:
            if inner_table not in table_set:
                edges = copy.deepcopy(avaliable_join_list)
                nodes = copy.deepcopy(table_set)
                target = copy.deepcopy(inner_table)
                new_tables, new_joins = find_join_path_target(edges, nodes, target)
                for new_table in new_tables:
                    table_set.add(new_table)
                joins += new_joins

    ### Sampling columns

    key_cols = []
    candidate_cols = []
    candidate_cols_projection = []
    for col in avaliable_pred_cols:
        if col.split(".")[0] in table_set:
            candidate_cols_projection.append(col)
            if is_id_column(args, col, join_key_list):
                key_cols.append(col)
                continue
            candidate_cols.append(col)

    max_column = min(args.hyperparams["num_column_max"], len(candidate_cols))
    min_column = args.hyperparams["num_column_min"]
    if min_column > max_column or len(candidate_cols) == 0:
        args.logger.warning(
            f"Sampling column is failed: no candidate column or minimum number of columns is greater than maximum number of columns"
        )
        assert False
    prob = get_truncated_normal_distribution(max_column - min_column + 1)
    num_columns = rng.choice(range(min_column, max_column + 1), p=prob)

    sampled_cols = list()
    for tab in table_set:
        candidate_cols_per_tab = [col for col in candidate_cols if col.split(".")[0] == tab]
        num_columns_per_tab = min(len(candidate_cols_per_tab), num_columns)
        if num_columns_per_tab > 0:
            sampled_cols_per_tab = list(rng.choice(candidate_cols_per_tab, num_columns_per_tab, replace=False))
            sampled_cols += sampled_cols_per_tab

    if sql_type_dict["group"]:
        has_categories = False
        for column in sampled_cols:
            if is_categorical_column(args, column):
                has_categories = True
                break
        if not has_categories:
            max_group = 3
            min_group = 1
            # categorical column should be included
            candidate_categories = []
            for column in candidate_cols:
                if is_categorical_column(args, column):
                    candidate_categories.append(column)
            if len(candidate_categories) == 0:
                args.logger.warning("No table has a categorical column but we will generate GROUP BY clause")
            else:
                max_group = min(len(candidate_categories), max_group)
                prob = get_truncated_geometric_distribution(max_group - min_group + 1, 0.8)
                num_group = rng.choice(range(min_group, max_group + 1), p=prob)
                sampled_cols += list(rng.choice(candidate_categories, num_group, replace=False))

    sampled_cols_projection = key_cols + sampled_cols
    tables = list(table_set)

    return tables, joins, sampled_cols_projection, sampled_cols


if __name__ == "__main__":
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

    rng = np.random.RandomState(args.seed)

    SCHEMA = json.load(open(f"{args.data_dir}/{args.db}/schema_origin.json"))
    schema = CaseInsensitiveDict(utils.lower_case_schema_data(SCHEMA[args.db]))

    COL_INFO = json.load(open(f"{args.data_dir}/{args.db}/dtype_dict.json"))
    column_info = COL_INFO[schema["dataset"]]

    args.IDS, args.HASH_CODES, args.NOTES, args.CATEGORIES, args.FOREIGN_KEYS = set_col_info(column_info)

    IP = config["DB"]["IP"]
    port = config["DB"]["Port"]
    DBUserID = config["DB"]["data"]["UserID"]
    DBUserPW = config["DB"]["data"]["UserPW"]

    data_manager, table_info = utils.connect_data_manager(IP, port, DBUserID, DBUserPW, schema)
    args.table_info = CaseInsensitiveDict(table_info)
    args.column_info = column_info

    schema_updated = {}
    schema_updated["dataset"] = schema["dataset"]
    schema_updated["join_how"] = "outer"
    schema_updated["use_cols"] = schema["use_cols"] + f"_{args.idx}"

    # Sample table
    all_table_set = set(schema["join_tables"])
    join_clause_list = schema["join_clauses"]
    join_keys = schema["join_keys"]
    join_key_list = list()
    for table, cols in join_keys.items():
        for col in cols:
            join_key_list.append(f"{table}.{col}")
    sql_type_dict = {"group": True}

    sampled_tables, sampled_joins, sampled_cols_projection, sampled_cols = get_query_token(
        args, all_table_set, join_key_list, data_manager, join_clause_list, sql_type_dict, rng
    )
    schema_updated["join_root"] = sampled_tables[0]
    schema_updated["join_tables"] = sampled_tables
    schema_updated["join_clauses"] = sampled_joins
    schema_updated["join_keys"] = {}
    for table in sampled_tables:
        schema_updated["join_keys"][table] = set()
    for join_clause in sampled_joins:
        t1, k1, t2, k2 = get_table_join_key_from_join_clause(join_clause)
        schema_updated["join_keys"][t1].add(k1)
        schema_updated["join_keys"][t2].add(k2)
    for table in sampled_tables:
        schema_updated["join_keys"][table] = list(schema_updated["join_keys"][table])

    # Sample column
    print(table_info)
    schema_updated["columns"] = {}
    for table in sampled_tables:
        schema_updated["columns"][table] = []
    for sampled_col in sampled_cols_projection:
        table = sampled_col.split(".")[0]
        col = sampled_col.split(".")[1]
        schema_updated["columns"][table].append(col)

    schema_store = {schema_updated["use_cols"]: schema_updated}

    with open(f"{args.data_dir}/{args.db}/schema_new.json", "w") as wf:
        json.dump(schema_store, wf, indent=3)
