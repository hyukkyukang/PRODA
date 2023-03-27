from src.sql_generator.sql_gen_utils.query_graph import Relation, Attribute, Value, Function, Query_graph
from src.sql_generator.sql_gen_utils.query_graph import (
    OperatorType,
    AggregationType,
    operatorNameToType,
    aggregationNameToType,
)

from hashlib import new
import numpy as np
from numpy.lib.shape_base import column_stack
import pandas as pd
import json
import copy
import networkx as nx


def non_nested_query_form_selector(args, rng):
    only_spj = args.query_type in ["spj-non-nested"]
    if only_spj:
        sql_type = {"where": bool(rng.randint(0, 2)), "group": False, "having": False, "order": False, "limit": False}
    else:
        if args.set_clause_by_clause:
            sql_type = {"where": False, "group": False, "having": False, "order": False, "limit": False}
            if args.has_where:
                sql_type["where"] = True
            if args.has_group or args.has_having:
                sql_type["group"] = True
            if args.has_having:
                sql_type["having"] = True
            if args.has_order:
                sql_type["order"] = True
            if args.has_limit:
                sql_type["limit"] = True
        else:
            sql_type = {
                "where": bool(rng.randint(0, 2)),
                "group": bool(rng.randint(0, 2)),
                "having": bool(rng.randint(0, 2)),
                "order": bool(rng.randint(0, 2)),
                "limit": bool(rng.randint(0, 2)),
            }

    if not sql_type["group"]:
        sql_type["having"] = False

    # if not sql_type["order"]:
    #    sql_type["limit"] = False

    return sql_type


def get_query_token(
    all_table_set, join_key_list, df_columns, df_columns_not_null, join_clause_list, rng, join_key_pred=True
):
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
    num_join_clause = rng.randint(0, len(avaliable_join_list) + 1)

    table_set = set()
    tables = list()
    joins = list()
    candiate_cols = list()
    predicates_cols = list()
    candidate_cols_projection = list()
    prob = 0.5

    table = rng.choice(avaliable_tables)
    table_set.add(table)
    cont = rng.choice([0, min(1, len(avaliable_join_list))], p=[1 - prob, prob])

    if cont == 1:
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

        cont = rng.choice([0, 1], p=[1 - prob, prob])
        while cont == 1:
            candidate_joins = get_possible_join(joins, avaliable_join_list)
            if len(candidate_joins) == 0:
                break
            next_join = rng.choice(candidate_joins)
            avaliable_join_list.remove(next_join)
            joins.append(next_join)

            t1, t2 = get_table_from_clause(next_join)
            table_set.add(t1)
            table_set.add(t2)

            cont = rng.choice([0, 1], p=[1 - prob, prob])

    for col in avaliable_pred_cols:
        if col.split(".")[0] in table_set:
            candidate_cols_projection.append(col)
            # if (not join_key_pred) and (col in join_key_list): # or "id" in col.split('.')[1].lower()): # [TODO] Correction: id
            if (not join_key_pred) and (
                col in join_key_list or "id" in col.split(".")[1].lower()
            ):  # [TODO] Correction: id
                continue
            candiate_cols.append(col)

    tables = list(table_set)

    return tables, joins, candidate_cols_projection, candiate_cols
