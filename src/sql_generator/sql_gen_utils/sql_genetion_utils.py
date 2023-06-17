from src.pylogos.query_graph.koutrika_query_graph import (
    Attribute,
    Function,
    FunctionType,
    OperatorType,
    Query_graph,
    Relation,
    Value,
    operatorNameToType,
    aggregationNameToType,
)
from src.query_tree.query_tree import QueryTree, QueryBlock, BaseTable, get_global_index
from src.query_tree.operator import (
    Aggregation,
    Clause,
    Condition,
    Foreach,
    Projection,
    Selection,
    Grouping,
    Ordering,
    Limit,
)
from hashlib import new
import numpy as np
from numpy.lib.shape_base import column_stack
import pandas as pd
import json
import copy
import networkx as nx
import pandasql as ps
from ast import literal_eval
import dateutil.parser
from numpy import inf
import math


DEBUG_ERROR = False  # [NOTE] This should be disabled

TEXTUAL_OPERATORS_PROBABILITY = [0.4, 0.1, 0.15, 0.1, 0.15, 0.1]
TEXTUAL_OPERATORS = ["=", "!=", "LIKE", "NOT LIKE", "IN", "NOT IN"]
NUMERIC_OPERATORS_PROBABILITY = [0.2, 0.2, 0.2, 0.2, 0.1, 0.1]
NUMERIC_OPERATORS = ["<=", "<", ">=", ">", "=", "!="]

KEY_OPERATORS_PROBABILITY = [0.8, 0.2]
KEY_OPERATORS = ["=", "!="]
NOTE_OPERATORS_PROBABILITY = [0.8, 0.2]
NOTE_OPERATORS = ["LIKE", "NOT LIKE"]

# (CONSIDERATION) larger/smaller than sum without condition is wierd? what if negative values exist
NUMERIC_AGGS = ["COUNT", "MIN", "MAX", "AVG", "SUM"]
TEXTUAL_AGGS = ["COUNT"]
DATE_AGGS = ["COUNT", "MIN", "MAX"]
KEY_AGGS = ["COUNT"]
LOGICAL_OPERATORS = ["AND", "OR"]


def get_view_name(type, args):
    if type == "main":
        db_name = args[0]
        sample_name = args[1]
        return (db_name + "__" + sample_name).lower()
    elif type == "where_generator":
        main_view_name = args[0]
        prefix = args[1]
        dnf_idx = args[2]
        cond_idx = args[3]
        return (main_view_name + "___" + prefix + "___w" + str(dnf_idx) + "___" + str(cond_idx)).lower()
    elif type == "having_generator":
        main_view_name = args[0]
        prefix = args[1]
        dnf_idx = args[2]
        cond_idx = args[3]
        return (main_view_name + "___" + prefix + "___h" + str(dnf_idx) + "___" + str(cond_idx)).lower()
    else:
        main_view_name = args[0]
        prefix = args[1]
        suffix = args[2]
        return (main_view_name + "___" + prefix + "___" + str(suffix)).lower()

    return ""


def are_relation_node_equivalent(node1, node2):
    return (
        node1.node_name == node2.node_name
        and node1.entity_name == node2.entity_name
        and node1.is_primary == node2.is_primary
    )


def get_date_time(date):
    return dateutil.parser.parse(date)


def get_tab_name_alias(tab_name):
    return tab_name


def check_condB_contain_condA(colA, opA, valA, typeA, colB, opB, valB, typeB, args):
    if colA != colB:
        return False

    if typeA not in ("str", "bool"):  # numeric
        if isinstance(opA, tuple):
            range_opA = (opA[0], opA[1], "and")
            range_valA = valA
        elif opA == "=":
            range_opA = (">=", "<=", "and")
            range_valA = (valA, valA)
        elif opA in (">", ">="):
            range_opA = (opA, "<", "and")

            range_valA = (valA, math.inf)
        elif opA in ("<", "<="):
            range_opA = (">", opA, "and")
            range_valA = (-math.inf, valA)
        elif opA == "!=":
            range_opA = (">", "<", "or")
            range_valA = (valA, valA)
        else:
            args.logger.error(f"Not implemented operator {opA}")
            assert False

        if isinstance(opB, tuple):
            range_opB = (opB[0], opB[1], "and")
            range_valB = valB
        elif opB == "=":
            range_opB = (">=", "<=", "and")
            range_valB = (valB, valB)
        elif opB in (">", ">="):
            range_opB = (opB, "<", "and")
            range_valB = (valB, inf)
        elif opB in ("<", "<="):
            range_opB = (">", opB, "and")
            range_valB = (-inf, valB)
        elif opB == "!=":
            range_opB = (">", "<", "or")
            range_valB = (valB, valB)
        else:
            args.logger.error(f"Not implemented operator {opB}")
            assert False

        if range_opA[2] == "and" and range_opB[2] == "and":
            # A in (val1, val2) or B in (val3, val4)
            # if val3 > val1 or val4 < val2, B does not contain A
            # else if val3 == val1 and op3 == ">" and op1 == ">=", B does not contain A
            # else if val4 == val2 and op4 == "<" and op2 == "<=", B does not contain A
            # otherwise, B contain A
            if range_valB[0] > range_valA[0] or range_valB[1] < range_valA[1]:
                return False
            if range_valB[0] == range_valA[0] and range_opA[0] == ">=" and range_opB[0] == ">":
                return False
            if range_valB[1] == range_valA[1] and range_opA[1] == "<=" and range_opB[1] == "<":
                return False
        elif range_opA[2] == "and" and range_opB[2] == "or":
            # A in (val1, val2) or B != val3
            # if not val3 in (val1, val2), B contain A
            str_pred = (
                str(range_valB[0])
                + range_opA[0]
                + str(range_valA[0])
                + " and "
                + str(range_valB[0])
                + range_opA[1]
                + str(range_valA[1])
            )
            if eval(str_pred):
                return False
        elif range_opA[2] == "or" and range_opB[2] == "and":
            # A != val1 or B in (val3, val4)
            # if B cover (-inf, inf), then B contain A
            # But this never occur
            return False
        else:
            # range_opA[2] == "or" and range_opB[2] == "or"
            # A != val1 or B != val3
            # if val3 == val1, B contain A
            if range_valA[0] != range_valB[0]:
                return False
    else:
        if valA[0] == '"' and valA[-1] == '"':
            valA = valA[1:-1]
        if valB[0] == '"' and valB[-1] == '"':
            valB = valB[1:-1]

        if opA in ("IN", "NOT IN"):
            valsetA = list(eval(valA))
        elif opA in ("LIKE", "NOT LIKE"):
            if valA[0] == "%" and valA[-1] == "%":
                valsetA = [valA[1:-1]]
                opsetA = "find"
                opsetA_suffix = " + 1 "
            elif valA[0] == "%":
                valsetA = [valA[1:]]
                opsetA = "endswith"
                opsetA_suffix = ""
            else:
                valsetA = [valA[:-1]]
                opsetA = "startswith"
                opsetA_suffix = ""
        else:
            valsetA = [valA]

        if opB in ("IN", "NOT IN"):
            valsetB = list(eval(valB))
        elif opB in ("LIKE", "NOT LIKE"):
            if valB[0] == "%" and valB[-1] == "%":
                valsetB = [valB[1:-1]]
                opsetB = "find"
                opsetB_suffix = " + 1 "
            elif valB[0] == "%":
                valsetB = [valB[1:]]
                opsetB = "endswith"
                opsetB_suffix = ""
            else:
                valsetB = [valB[:-1]]
                opsetB = "startswith"
                opsetB_suffix = ""
        else:
            valsetB = [valB]

        if opB == "LIKE":
            if opA in ("LIKE"):
                # A LIKE "a" or B LIKE "b"
                # If B LIKE "%val%" or opA == opB and valB is substring of valA, B contain A
                # A LIKE "ss%" or B LIKE "%s%"
                if opsetB == "find" or opsetB == opsetA:
                    if valsetA[0].find(valsetB[0]) == -1:
                        return False
                else:
                    return False
            elif opA in ("=", "IN"):
                # A IN ("a", "b", "c") OR B LIKE "valB"
                # any value in the set of A not like valB, then B does not contain A
                # ex) A IN ("b", "a") OR B LIKE "b%"
                for valAc in valsetA:
                    str_pred = '"' + str(valAc) + '".' + opsetB + '("' + str(valsetB[0]) + '")' + opsetB_suffix
                    cond = eval(str_pred)
                    if not cond:
                        return False
            else:
                # A NOT IN ("a", "b") OR B LIKE "valB"
                # set of A is equal to NOT LIKE "valB", then B contain A
                # But this never occur
                # ex) A NOT IN ("a", "c") OR B LIKE "b%".. A NOT LIKE "c%" OR B LIKE "b%".. always False
                return False
        elif opB == "NOT LIKE":
            if opA in ("LIKE"):
                # A LIKE "a" or B NOT LIKE "b"
                return False
            elif opA in ("NOT LIKE"):
                # A NOT LIKE "a" or B NOT LIKE "b"
                # If A NOT LIKE "%val%" or opA == opB and valB is substring of valA, B contain A
                # A NOT LIKE "%s%" or B NOT LIKE "ss%"
                if opsetA == "find" or opsetB == opsetA:
                    if valsetB[0].find(valsetA[0]) == -1:
                        return False
                else:
                    return False
                pass
            elif opA in ("=", "IN"):
                # A IN ("a", "b", "c") OR B NOT LIKE "valB"
                # any value in the set of A like valB, then B does not contain A
                # ex) A IN ("b", "a") OR B NOT LIKE "b%"
                for valAc in valsetA:
                    str_pred = '"' + str(valAc) + '".' + opsetB + '("' + str(valsetB[0]) + '")' + opsetB_suffix
                    cond = eval(str_pred)
                    if cond:
                        return False
                pass
            else:
                # A NOT IN ("a", "b") OR B NOT LIKE "valB"
                # all values in the set of A like valB, then B contain A
                # set of A is equal to LIKE "valB", then B contain A
                # But this never occur
                # ex) A NOT IN ("b") OR B NOT LIKE ("b%").. A NOT IN ("c") OR B NOT LIKE ("b%").. always False
                return False
        elif opB in ("=", "IN"):
            # A ... or B in ("a", "b")
            if opA in ("=", "IN"):
                # if value set A is a equi or subset of value set B, B contain A
                # otherwise, B does not contain A
                if not set(valsetA) <= set(valsetB):
                    return False
            else:
                if opA not in ("NOT LIKE", "NOT IN", "!=", "LIKE"):
                    args.logger.error("This cannot be happend")
                assert opA in ("NOT LIKE", "NOT IN", "!=", "LIKE")
                return False
        elif opB in ("NOT IN", "!="):
            # B != "valueB"
            if opA in ("NOT LIKE", "NOT IN", "!="):
                # if value set of A have all of valueB, B contain A
                # ex) A NOT IN ("a", "b", "c") OR B NOT IN ("a", "b"), A NOT LIKE "b%" OR B NOT IN ("b", "bb")
                # Otherwise, B does not contain A
                if opA == "NOT LIKE":
                    for valBc in valsetB:
                        str_pred = '"' + str(valBc) + '".' + opsetA + '("' + str(valsetA[0]) + '")' + opsetA_suffix
                        cond = eval(str_pred)
                        if not cond:
                            return False
                elif opA in ("!=", "NOT IN") and not set(valsetB) <= set(valsetA):
                    return False
            else:
                # if value set of A does not have valueB, B contain A
                # Otherwise, B does not contain A
                # ex) A IN ("A", "B") OR B != "B"
                if opA in ("=", "IN") and len(set(valsetB).union(set(valsetA))) > 0:
                    return False
                if opA in ("LIKE"):
                    for valBc in valsetB:
                        str_pred = '"' + str(valBc) + '".' + opsetA + '("' + str(valsetA[0]) + '")' + opsetA_suffix
                        cond = eval(str_pred)
                        if cond:
                            return False
        else:
            args.logger.error(f"Not implemented operator {opB}")
            assert False

    return True


def get_val_alias(op, val):
    alias = val
    if op in ["IN", "NOT IN"]:
        try:
            alias = literal_eval(alias)
            if isinstance(alias, tuple):
                alias = [str(inst) for inst in alias]
                alias = "{" + ", ".join(alias) + "}"
        except:
            alias = val
    if op in ["LIKE", "NOT LIKE"]:
        if val[-1] == "%" and val[0] == "%":
            alias = val[1:-1] + " as substring"
        elif val[-1] == "%":
            alias = val[:-1] + " as prefix"
        elif val[0] == "%":
            alias = val[1:] + " as suffix"
    return alias


def get_col_name_alias(tab_name, col_name, agg):
    alias = ""
    if agg != "NONE":
        alias += agg.lower() + " of "
    if col_name == "*":
        col_name = "all"
    alias += col_name
    return alias


def get_tree_header(prefix, table_name, column_name, agg):
    if agg != "NONE":
        if column_name == "*":
            column_name = "all"
        column_name = agg.lower() + "_" + column_name

    if column_name != "*" and table_name != None:
        column_name = table_name + "_" + column_name

    if column_name != "*" and prefix != None:
        column_name = prefix + column_name

    return column_name


def get_prefix(nesting_level, nesting_block_idx, having=None):
    return "N" + str(nesting_level) + "_" + str(nesting_block_idx) + "_"


def get_random_tables(args, rng, tables, max_size):
    selected_tables = rng.choice(tables, size=max_size, replace=False)
    return selected_tables


def get_truncated_normal_distribution(N):
    norm = [int((math.factorial(N - 1)) / ((math.factorial(r)) * math.factorial(N - 1 - r))) for r in range(N)]
    sum_prob = sum(norm)
    prob = [i / sum_prob for i in norm]
    return prob


def get_truncated_geometric_distribution(N, p):
    geomet = [p * (1 - p) ** i for i in range(N)]
    sum_prob = sum(geomet)
    prob = [i / sum_prob for i in geomet]
    return prob


def get_possible_inner_query_idxs(args, inner_query_objs):
    idxs = []

    for idx in range(len(inner_query_objs)):
        select_columns = inner_query_objs[idx]["select"]
        if len(select_columns) == 1 and not inner_query_objs[idx]["is_having_child"]:
            idxs.append(idx)

    return idxs


def set_col_info(col_info):
    IDS = col_info["ids"]
    HASH_CODES = col_info["hash_codes"]
    NOTES = col_info["notes"]
    CATEGORIES = col_info["categories"]
    FOREIGN_KEYS = col_info["foreign_keys"]

    return IDS, HASH_CODES, NOTES, CATEGORIES, FOREIGN_KEYS


def get_str_op_values(op, val, vs, rng, num_word_in_like_max, num_in_max):
    if op == "=" or op == "!=":
        return val
    elif op == "LIKE" or op == "NOT LIKE":
        val = str(rng.choice(val.split(" ")))
        candidate_op_idx = rng.choice([0, 1, 2])
        if len(val) > num_word_in_like_max:
            if candidate_op_idx == 0:
                val = val[:num_word_in_like_max]
            elif candidate_op_idx == 1:
                val = val[-num_word_in_like_max:]
            elif candidate_op_idx == 2:
                start_idx = rng.randint(0, len(val) - num_word_in_like_max)
                val = val[start_idx : start_idx + num_word_in_like_max]

        candidate_vals = [f"{val}%", f"%{val}", f"%{val}%"]

        return candidate_vals[candidate_op_idx].replace('"', '\\"')
    elif op == "IN" or op == "NOT IN":
        num_in_values = rng.randint(2, num_in_max + 1)  # param
        all_candidate_values = copy.deepcopy(vs)
        all_candidate_values = np.delete(all_candidate_values, np.where(all_candidate_values == val))
        in_values = [val]
        for i in range(num_in_values - 1):
            if len(all_candidate_values) < 1:
                break
            candidate_val = rng.choice(all_candidate_values)
            in_values.append(candidate_val)
            all_candidate_values = np.delete(all_candidate_values, np.where(all_candidate_values == candidate_val))
        num_in_values = len(in_values)

        if type(in_values[0]) == str:
            in_value_txt = ",".join(["'%s'" % (v.strip().replace("'", "''")) for v in in_values])
        else:
            in_values = list(map(lambda i: "'%s'" % (str(i).strip().replace("'", "''")), in_values))
            in_value_txt = ",".join(in_values)
        in_value_txt = f"({in_value_txt})"
        return in_value_txt, num_in_values


def renumbering_tree_predicates(predicates, idx):
    if not isinstance(predicates, list):
        args.logger.error(f"{predicates} is not supported format of predicate")
        assert False
    if len(predicates) < 2:
        predicates[0] = idx
        return predicates, idx + 1

    if len(predicates) != 3:
        args.logger.error(f"{predicates} is not supported format of predicate")
    assert len(predicates) == 3

    predicates[0], left_idx = renumbering_tree_predicates(predicates[0], idx)
    predicates[2], right_idx = renumbering_tree_predicates(predicates[2], left_idx)
    return predicates, right_idx


def split_predicate_tree_with_condition_dnf(predicates):
    if not isinstance(predicates, list) or len(predicates) < 2:
        return
    if predicates[1] not in ["AND", "OR"]:
        return

    parent_cond = False
    if len(predicates) == 4:
        parent_cond = predicates[3]

    if predicates[1] == "AND":
        predicates[0].append(parent_cond)
        predicates[2].append(True)
    else:
        predicates[0].append(False)
        predicates[2].append(False)

    split_predicate_tree_with_condition_dnf(predicates[0])
    split_predicate_tree_with_condition_dnf(predicates[2])


def split_predicate_tree_with_condition(predicates):
    if not isinstance(predicates, list) or len(predicates) < 2:
        return
    if predicates[1] not in ["AND", "OR"]:
        return

    parent_cond = True
    if len(predicates) == 4:
        parent_cond = predicates[3]

    if predicates[1] == "AND":
        predicates[0].append(parent_cond)
        predicates[2].append(parent_cond)
    else:
        predicates[0].append(parent_cond)
        predicates[2].append(False)

    split_predicate_tree_with_condition(predicates[0])
    split_predicate_tree_with_condition(predicates[2])


def flatten_condition_predicate_tree(predicates):
    if not isinstance(predicates, list) or len(predicates) <= 2:
        return [predicates]
    if predicates[1] not in ["AND", "OR"]:
        return [predicates]

    p1 = flatten_condition_predicate_tree(predicates[0])
    p2 = flatten_condition_predicate_tree(predicates[2])

    return p1 + p2


def build_predicate_tree(rng, predicates):
    while len(predicates) > 1:
        selected_idx = rng.choice(range(len(predicates)), 2, replace=False)
        selected_predicates = [predicates[i] for i in selected_idx]
        op = rng.choice(LOGICAL_OPERATORS)

        connected_predicates = [selected_predicates[0], op, selected_predicates[1]]

        new_predicates = [p for idx, p in enumerate(predicates) if idx not in selected_idx] + [connected_predicates]
        predicates = new_predicates

    return predicates[0]


def build_predicate_tree_dnf(args, rng, predicates):  # [ [ [A OR B] AND [C OR D] ] AND [E OR F] ] [ [A AND B] ]
    while len(predicates) > 1:
        selected_idx = rng.choice(range(len(predicates)), 2, replace=False)
        selected_predicates = [predicates[i] for i in selected_idx]
        if len(selected_predicates[0]) > 1 and selected_predicates[0][1] == "OR":
            op = "OR"
        elif len(selected_predicates[1]) > 1 and selected_predicates[1][1] == "OR":
            op = "OR"
        else:
            prob = args.hyperparams["prob_or"]
            op = rng.choice(LOGICAL_OPERATORS, p=[1 - prob, prob])

        connected_predicates = [selected_predicates[0], op, selected_predicates[1]]

        new_predicates = [p for idx, p in enumerate(predicates) if idx not in selected_idx] + [connected_predicates]
        predicates = new_predicates

    return predicates[0]


def restore_predicate_tree_one(tree, idx_origin, predicate):
    if len(tree) <= 2:
        idx = tree[0]
        if idx == idx_origin:
            return predicate
        else:
            return tree

    left = restore_predicate_tree_one(tree[0], idx_origin, predicate)
    right = restore_predicate_tree_one(tree[2], idx_origin, predicate)

    return [left, tree[1], right]


def restore_predicate_tree(tree, predicates):
    if len(tree) <= 2:
        idx = tree[0]
        return predicates[idx]

    left = restore_predicate_tree(tree[0], predicates)
    right = restore_predicate_tree(tree[2], predicates)

    return [left, tree[1], right]


def preorder_traverse_to_get_graph(tree, dnf_idx):
    if not isinstance(tree, tuple) and not isinstance(tree, list):
        operations = [(tree, dnf_idx)]
        return operations, dnf_idx
    if len(tree) == 1:
        operations, new_dnf_idx = preorder_traverse_to_get_graph(tree[0], dnf_idx)
        return operations, new_dnf_idx

    elif len(tree) == 3:
        left, op, right = tree

    left_operations, after_left_dnf_idx = preorder_traverse_to_get_graph(left, dnf_idx)
    if op == "OR":
        after_left_dnf_idx += 1
    right_operations, after_right_dnf_idx = preorder_traverse_to_get_graph(right, after_left_dnf_idx)

    operations = left_operations + right_operations

    return operations, after_right_dnf_idx


def get_grouping_query_elements(
    args,
    rng,
    sql_type_dict,
    dtype_dict,
    prefix,
    table_columns,
    joins,
    tables,
    used_tables,
    where_predicates,
    tree_predicates_origin,
    predicates_origin,
    group_columns,
    group_columns_origin,
    join_key_list,
):
    grouping_query_elements = {}

    grouping_query_elements["sql_type_dict"] = {}
    grouping_query_elements["sql_type_dict"]["where"] = sql_type_dict["where"]
    grouping_query_elements["sql_type_dict"]["group"] = sql_type_dict["group"]
    grouping_query_elements["sql_type_dict"]["having"] = False
    grouping_query_elements["sql_type_dict"]["order"] = False
    grouping_query_elements["sql_type_dict"]["limit"] = False

    grouping_query_elements["where_predicates"] = where_predicates
    grouping_query_elements["tree_predicates_origin"] = tree_predicates_origin
    grouping_query_elements["predicates_origin"] = predicates_origin

    grouping_query_elements["group_columns"] = group_columns

    grouping_query_elements["having_predicates"] = []
    grouping_query_elements["order_columns"] = []
    grouping_query_elements["limit_num"] = 0

    # Add all possible columns to project
    # Consider all possible aggregation for each selected columns
    # DOES NOT CONSIDER not used tables
    grouping_query_used_tables = copy.deepcopy(used_tables)
    grouping_query_used_tables = get_updated_used_tables(used_tables, group_columns_origin)

    having_candidate_columns = [
        table_column
        for table_column in table_columns
        if table_column not in list(group_columns) and table_column.split(".")[0] in grouping_query_used_tables
    ] + ["*"]
    grouping_query_agg_cols = []
    grouping_query_select_columns = []

    for col in having_candidate_columns:
        if col == "*":  # COUNT is only availble for star
            aggs = TEXTUAL_AGGS
        elif dtype_dict[col] in ["bool", "str"] or is_id_column(args, col, join_key_list):
            continue
        elif dtype_dict[col] == "date":
            aggs = DATE_AGGS
        else:
            aggs = NUMERIC_AGGS
        for agg in aggs:
            if agg == "NONE":
                args.logger.error("This cannot be happend")
            assert agg != "NONE"
            if col == "*":
                col_rep = agg + "(*)"
                grouping_query_select_columns.append(col_rep)
                grouping_query_agg_cols.append((agg, "*"))
            else:
                col_rep = agg + "(" + prefix + col + ")"
                grouping_query_select_columns.append(col_rep)
                grouping_query_agg_cols.append((agg, col))
                grouping_query_used_tables.add(col.split(".")[0])
    grouping_query_select_columns = list(group_columns) + grouping_query_select_columns
    grouping_query_agg_cols = [("NONE", group_col) for group_col in group_columns_origin] + grouping_query_agg_cols

    grouping_query_elements["select_columns"] = grouping_query_select_columns
    grouping_query_elements["agg_cols"] = grouping_query_agg_cols

    if len(grouping_query_used_tables) == 0:
        grouping_query_used_tables = get_random_tables(args, rng, tables, 1)

    grouping_query_elements["necessary_tables"], grouping_query_elements["necessary_joins"] = find_join_path(
        joins, tables, grouping_query_used_tables
    )

    return grouping_query_elements


def preorder_traverse_to_replace_alias(tree, org, rep):
    if not isinstance(tree, tuple) and not isinstance(tree, list):
        if isinstance(org, list):
            tree_replaced = tree
            for o, r in zip(org, rep):
                tree_replaced = tree_replaced.replace(o, r)
            return tree_replaced
        return tree.replace(org, rep)

    assert len(tree) == 3 or len(tree) == 1

    if len(tree) == 1:
        assert len(tree[0]) == 3
        left, op, right = tree[0]
    elif len(tree) == 3:
        left, op, right = tree

    return (
        "("
        + preorder_traverse_to_replace_alias(left, org, rep)
        + " "
        + op
        + " "
        + preorder_traverse_to_replace_alias(right, org, rep)
        + ")"
    )


def preorder_traverse(tree):
    if not isinstance(tree, tuple) and not isinstance(tree, list):
        return tree

    assert len(tree) == 3 or len(tree) == 1

    if len(tree) == 1:
        assert len(tree[0]) == 3
        left, op, right = tree[0]
    elif len(tree) == 3:
        left, op, right = tree

    return "(" + preorder_traverse(left) + " " + op + " " + preorder_traverse(right) + ")"


def get_updated_used_tables(used_tables, columns):
    for col in columns:
        if col == "*":
            continue
        used_tables.add(col.split(".")[0])

    return used_tables


def find_existing_rel_node(rel_nodes, cur_rel_node):
    equi_idx = -1
    for idx, rel_node in enumerate(rel_nodes):
        if are_relation_node_equivalent(rel_node, cur_rel_node):
            assert equi_idx == -1
            equi_idx = idx
    return equi_idx


def tree_and_graph_formation(
    args,
    sql_type_dict,
    tables,
    joins,
    select,
    where=None,
    group=None,
    having=None,
    order=None,
    limit=None,
    used_tables=None,
    make_graph=False,
    select_agg_cols=None,
    tree_predicates_origin=None,
    predicates_origin=None,
    having_tree_predicates_origin=None,
    having_predicates_origin=None,
    nesting_level=None,
    nesting_block_idx=None,
    inner_select_nodes=None,
    sql=None,
    childs=None,
    child_query_graphs=None,
    correlation_predicates_origin=None,
):
    prefix = get_prefix(nesting_level, nesting_block_idx)

    graph = Query_graph(prefix[:-1])
    rel_nodes = []

    if sql_type_dict["having"] or sql_type_dict["aggregated_order"]:
        assert len(childs) == 1
        child_prefix = get_prefix(childs[0][0], childs[0][1])
        child_tree = child_query_graphs[child_prefix][0]
        base_tables = [child_tree.root]
        tab_name_graph = child_prefix[:-1]
        tab_name_alias = child_prefix + "results"

        projections = []
        # normal projection
        for col_info in select_agg_cols:
            agg = col_info[0]
            col = col_info[1]
            table_idx = 0
            if col != "*":
                tab_name = col.split(".")[0]
                col_name = col.split(".")[1]
            else:
                tab_name = None
                col_name = col

            col_name_tree = get_tree_header(child_prefix, tab_name, col_name, agg)
            new_col_name_tree = get_tree_header(prefix, tab_name, col_name, agg)

            projection = Projection(get_global_index(base_tables, table_idx, col_name_tree), alias=new_col_name_tree)
            projections.append(projection)

            ##### GRAPH START #######
            cur_rel_node = Relation(tab_name_graph, tab_name_alias, is_primary=True)
            idx = find_existing_rel_node(rel_nodes, cur_rel_node)
            if idx == -1:
                rel_nodes.append(cur_rel_node)
            else:
                cur_rel_node = rel_nodes[idx]

            col_name_graph = "s_" + get_tree_header(child_prefix, tab_name, col_name, agg)
            col_name_alias = get_col_name_alias(tab_name, col_name, agg)
            cur_col_node = Attribute(col_name_graph, col_name_alias)

            graph.connect_membership(cur_rel_node, cur_col_node)
            ##### GRAPH END   #######

        operations = projections
        # having
        if sql_type_dict["having"]:
            predicates, max_dnf_idx = preorder_traverse_to_get_graph(having_tree_predicates_origin, 0)
            conditions = [[] for _ in range(max_dnf_idx + 1)]

            for operation_idx, dnf_idx in predicates:
                operation = having_predicates_origin[operation_idx]
                prefix_stored = operation[0]
                agg = operation[1]
                col = operation[2]
                op = operation[3]
                val = operation[4]

                if col != "*":
                    tab_name = col.split(".")[0]
                    col_name = col.split(".")[1]
                else:
                    tab_name = None
                    col_name = col
                col_name_tree = get_tree_header(child_prefix, tab_name, col_name, agg)

                table_idx = 0
                where_condition = Condition(
                    l_operand=get_global_index(base_tables, table_idx, col_name_tree),
                    operator=op,
                    r_operand=val,
                )
                conditions[dnf_idx].append(where_condition)

                ###### GRAPH START ######
                val_name_graph = val
                val_alias_graph = get_val_alias(op, val)
                cur_val_node = Value(val_name_graph, val_alias_graph)

                cur_operator_graph = operatorNameToType[op]

                cur_rel_node = Relation(tab_name_graph, tab_name_alias, is_primary=True)  # Nesting level is always 0
                idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                if idx == -1:
                    rel_nodes.append(cur_rel_node)
                else:
                    cur_rel_node = rel_nodes[idx]

                col_name_graph = "h_" + get_tree_header(child_prefix, tab_name, col_name, agg)
                col_name_alias = get_col_name_alias(tab_name, col_name, agg)
                cur_col_node = Attribute(col_name_graph, col_name_alias)

                graph.connect_selection(cur_rel_node, cur_col_node)
                graph.connect_predicate(cur_col_node, cur_val_node, cur_operator_graph, dnf_idx)
                ###### GRAPH END   ######
            clauses = []
            for condition in conditions:
                clauses.append(Clause(conditions=condition))
            selection_operation = Selection(clauses=clauses)
            operations.append(selection_operation)

        if sql_type_dict["order"]:
            for order_col_raw in order:
                order_col = order_col_raw
                agg = "NONE"
                table_idx = 0
                for candidate_agg in NUMERIC_AGGS:
                    if candidate_agg + "(" in order_col_raw:
                        assert ")" in order_col_raw
                        agg = candidate_agg
                        order_col = order_col_raw.split(agg + "(")[1].split(")")[0]
                        break

                if order_col != "*":
                    order_alias = order_col.split(".")[0]
                    tab_name = order_alias.split(prefix)[1]
                    col_name = order_col.split(".")[1]
                else:
                    col_name = order_col
                    tab_name = None
                col_name_tree = get_tree_header(child_prefix, tab_name, col_name, agg)
                operations.append(Ordering(get_global_index(base_tables, table_idx, col_name_tree)))
                ###### GRAPH START ######

                cur_rel_node = Relation(tab_name_graph, tab_name_alias, is_primary=True)  # Nesting level is always 0
                idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                if idx == -1:
                    rel_nodes.append(cur_rel_node)
                else:
                    cur_rel_node = rel_nodes[idx]

                col_name_graph = "o_" + get_tree_header(child_prefix, tab_name, col_name, agg)
                col_name_alias = get_col_name_alias(tab_name, col_name, agg)
                cur_col_node = Attribute(col_name_graph, col_name_alias)
                graph.connect_order(cur_rel_node, cur_col_node)
                ###### GRAPH END   ######
        if sql_type_dict["limit"]:
            operations.append(Limit(limit))
            ###### GRAPH START ######
            graph.set_limit(limit)
            ###### GRAPH END   ######

        node = QueryBlock(child_tables=base_tables, operations=operations, sql=sql, name=prefix[:-1])
        tree = QueryTree(root=node, sql=sql)
    else:
        # base table define
        base_tables = []
        table_name_to_idx = {}
        for i, table_name in enumerate(tables):
            headers = args.table_info[table_name]
            table_obj = BaseTable(headers, [], name=table_name)
            base_tables.append(table_obj)
            table_name_to_idx[table_name] = i

        if childs:
            num_base_tables = len(base_tables)
            for i, child in enumerate(childs):
                child_prefix = get_prefix(child[0], child[1])
                child_table_name = child_prefix[:-1]
                child_tree = child_query_graphs[child_prefix][0]
                base_tables.append(child_tree.root)
                table_name_to_idx[child_table_name] = i + num_base_tables

        # Get primary relations
        primary_relations = set()
        for col_info in select_agg_cols:
            agg = col_info[0]
            col = col_info[1]
            if col != "*":
                tab_name = col.split(".")[0]
                table_idx = table_name_to_idx[tab_name]
                col_name = col.split(".")[1]
            else:
                table_idx = 0
                tab_name = tables[0]
                col_name = col
            primary_relations.add(tab_name)

        # join condition found
        join_conditions = []
        for join in joins:
            table1, col1, table2, col2 = get_table_join_key_from_join_clause(join)
            join_obj = Selection(
                clauses=[
                    Clause(
                        conditions=[
                            Condition(
                                get_global_index(base_tables, table_name_to_idx[table1], col1),
                                "=",
                                get_global_index(base_tables, table_name_to_idx[table2], col2),
                            )
                        ]
                    )
                ]
            )
            join_conditions.append(join_obj)
            ##### GRAPH START #######
            rel_name_A = table1
            rel_name_A_alias = get_tab_name_alias(table1)
            is_primary = table1 in primary_relations
            cur_rel_node_A = Relation(rel_name_A, rel_name_A_alias, is_primary=is_primary)  # Nesting level is always 0
            idx = find_existing_rel_node(rel_nodes, cur_rel_node_A)
            if idx == -1:
                rel_nodes.append(cur_rel_node_A)
            else:
                cur_rel_node_A = rel_nodes[idx]

            rel_name_B = table2
            rel_name_B_alias = get_tab_name_alias(table2)
            is_primary = table2 in primary_relations
            cur_rel_node_B = Relation(rel_name_B, rel_name_B_alias, is_primary=is_primary)
            idx = find_existing_rel_node(rel_nodes, cur_rel_node_B)
            if idx == -1:
                rel_nodes.append(cur_rel_node_B)
            else:
                cur_rel_node_B = rel_nodes[idx]

            graph.connect_simplified_join(cur_rel_node_A, cur_rel_node_B)
            ##### GRAPH END   #######

        # correlation condition found
        if correlation_predicates_origin:
            for predicate in correlation_predicates_origin:
                assert len(predicate) == 6
                prefix_inner = predicate[0]
                inner_col = predicate[1]
                op = predicate[2]
                col = predicate[3]
                mark = predicate[4]
                prefix_outer = predicate[5]
                assert mark == "correal"

                inner_tab_name = inner_col.split(".")[0]
                inner_col_name = inner_col.split(".")[1]

                outer_tab_name = col.split(".")[0]
                outer_col_name = col.split(".")[1]

                inner_table_block_name = prefix_inner[:-1]
                inner_col_name_tree = get_tree_header(prefix_inner, inner_tab_name, inner_col_name, "NONE")

                # [TODO] add projection and ForEach to child node

                operations = []
                query_block = base_tables[table_name_to_idx[inner_table_block_name]]
                headers = query_block.get_headers()
                found_global_idx = -1
                for idx, header in enumerate(headers):
                    if inner_col_name_tree == header:
                        found_global_idx = idx

                if found_global_idx != -1:
                    for_each = Foreach(column_id=found_global_idx)
                    operations.append(for_each)
                else:
                    child_tables = query_block.get_child_tables()

                    # IF correlated column is not in the projection columns of child query
                    child_table_names = [child_table.get_name() for child_table in child_tables]
                    if inner_tab_name not in child_table_names:
                        if len(child_table_names) != 1:
                            args.logger.error("This is impossible")
                            assert False
                        grandchild_query_block = child_tables[0]
                        great_grandchild_tables = grandchild_query_block.get_child_tables()
                        gg_table_names = [gg_table.get_name() for gg_table in great_grandchild_tables]
                        if inner_tab_name not in gg_table_names:
                            args.logger.error("This is impossible")
                            assert False

                        prefix_grandinner = child_table_names[0] + "_"
                        grandinner_col_name_tree = get_tree_header(
                            prefix_grandinner, inner_tab_name, inner_col_name, "NONE"
                        )

                        gg_inner_table_idx = gg_table_names.index(inner_tab_name)

                        grandchild_operations = []
                        # add for_each to grand_child
                        grandchild_for_each = Foreach(
                            get_global_index(great_grandchild_tables, gg_inner_table_idx, inner_col_name)
                        )
                        grandchild_operations.append(grandchild_for_each)

                        grandchild_projection = Projection(
                            column_id=get_global_index(great_grandchild_tables, gg_inner_table_idx, inner_col_name),
                            alias=grandinner_col_name_tree,
                        )
                        grandchild_operations.append(grandchild_projection)
                        grandchild_query_block.add_operations(grandchild_operations)
                        query_block.update_child_table(0, grandchild_query_block)

                        child_tables = query_block.get_child_tables()
                        inner_table_idx = 0
                        test = query_block.get_headers()

                        for_each = Foreach(get_global_index(child_tables, inner_table_idx, grandinner_col_name_tree))
                        operations.append(for_each)

                        projection = Projection(
                            column_id=get_global_index(child_tables, inner_table_idx, grandinner_col_name_tree),
                            alias=inner_col_name_tree,
                        )
                        operations.append(projection)

                    else:
                        inner_table_idx = [child_table.get_name() for child_table in child_tables].index(inner_tab_name)

                        for_each = Foreach(get_global_index(child_tables, inner_table_idx, inner_col_name))
                        operations.append(for_each)

                        projection = Projection(
                            column_id=get_global_index(child_tables, inner_table_idx, inner_col_name),
                            alias=inner_col_name_tree,
                        )
                        operations.append(projection)

                query_block.add_operations(operations)
                base_tables[table_name_to_idx[inner_table_block_name]] = query_block

                join_obj = Selection(
                    clauses=[
                        Clause(
                            conditions=[
                                Condition(
                                    get_global_index(
                                        base_tables, table_name_to_idx[inner_table_block_name], inner_col_name_tree
                                    ),
                                    "=",
                                    get_global_index(base_tables, table_name_to_idx[outer_tab_name], outer_col_name),
                                )
                            ]
                        )
                    ]
                )
                join_conditions.append(join_obj)

                ##### GRAPH START #######
                rel_name_A = outer_tab_name
                rel_name_A_alias = get_tab_name_alias(outer_tab_name)
                is_primary = outer_tab_name in primary_relations
                cur_rel_node_A = Relation(
                    rel_name_A, rel_name_A_alias, is_primary=is_primary
                )  # Nesting level is always 0
                idx = find_existing_rel_node(rel_nodes, cur_rel_node_A)
                if idx == -1:
                    rel_nodes.append(cur_rel_node_A)
                else:
                    cur_rel_node_A = rel_nodes[idx]

                rel_name_B = inner_table_block_name
                rel_name_B_alias = get_tab_name_alias(inner_table_block_name)
                is_primary = inner_table_block_name in primary_relations
                cur_rel_node_B = Relation(rel_name_B, rel_name_B_alias, is_primary=is_primary)
                idx = find_existing_rel_node(rel_nodes, cur_rel_node_B)
                if idx == -1:
                    rel_nodes.append(cur_rel_node_B)
                else:
                    cur_rel_node_B = rel_nodes[idx]

                graph.connect_simplified_join(cur_rel_node_A, cur_rel_node_B)
                ##### GRAPH END   #######

        projections = []
        projected_columns = []
        aggregations = []
        # normal projection
        for col_info in select_agg_cols:
            agg = col_info[0]
            col = col_info[1]
            if col != "*":
                tab_name = col.split(".")[0]
                table_idx = table_name_to_idx[tab_name]
                col_name = col.split(".")[1]
            else:
                table_idx = 0
                tab_name = None
                col_name = col
            # if col not in projected_columns:
            projected_columns.append(col)
            new_col_name = get_tree_header(prefix, tab_name, col_name, agg)
            projection = Projection(get_global_index(base_tables, table_idx, col_name), alias=new_col_name)
            projections.append(projection)

            if agg != "NONE":
                aggregation = Aggregation(get_global_index(base_tables, table_idx, col_name), agg.lower())
                aggregations.append(aggregation)

            ##### GRAPH START #######
            if tab_name == None:
                tab_name = tables[0]
            tab_name_alias = get_tab_name_alias(tab_name)
            is_primary = tab_name in primary_relations
            cur_rel_node = Relation(tab_name, tab_name_alias, is_primary=is_primary)
            idx = find_existing_rel_node(rel_nodes, cur_rel_node)
            if idx == -1:
                rel_nodes.append(cur_rel_node)
            else:
                cur_rel_node = rel_nodes[idx]

            col_name_graph = "s_" + get_tree_header(prefix, tab_name, col_name, "NONE")
            col_name_alias = get_col_name_alias(tab_name, col_name, agg)
            cur_col_node = Attribute(col_name_graph, col_name_alias)
            if agg != "NONE":
                cur_agg_node = Function(aggregationNameToType[agg.capitalize()])
            else:
                cur_agg_node = None

            graph.connect_membership(cur_rel_node, cur_col_node)
            if cur_agg_node is not None:
                graph.connect_transformation(cur_col_node, cur_agg_node)
            ##### GRAPH END   #######

        # operations found
        operations = projections + aggregations
        if sql_type_dict["where"]:
            predicates, max_dnf_idx = preorder_traverse_to_get_graph(tree_predicates_origin, 0)
            conditions = [[] for _ in range(max_dnf_idx + 1)]
            # Q: how to know correlation
            for operation_idx, dnf_idx in predicates:
                operation = predicates_origin[operation_idx]
                prefix_cur = operation[0]
                col = operation[1]
                op = operation[2]
                val = operation[3]
                if len(operation) == 5:  # nested query
                    obj = operation[4]
                    inner_query_global_idx = (obj["nesting_level"], obj["unique_alias"])
                    inner_table_prefix = get_prefix(inner_query_global_idx[0], inner_query_global_idx[1])
                    inner_table_block_name = inner_table_prefix[:-1]
                    if prefix_cur is not None:  # comparison operator
                        tab_name = col.split(".")[0]
                        col_name = col.split(".")[1]

                        assert len(obj["agg_cols"]) == 1
                        inner_agg_col = obj["agg_cols"][0]
                        inner_agg = inner_agg_col[0]
                        inner_col = inner_agg_col[1]
                        inner_tab_name = col.split(".")[0]
                        inner_col_name = col.split(".")[1]

                        inner_col_name_tree = get_tree_header(
                            inner_table_prefix, inner_tab_name, inner_col_name, inner_agg
                        )
                        where_condition = Condition(
                            l_operand=get_global_index(base_tables, table_name_to_idx[tab_name], col_name),
                            operator=op,
                            r_operand=get_global_index(
                                base_tables, table_name_to_idx[inner_table_block_name], inner_col_name_tree
                            ),
                        )
                        conditions[dnf_idx].append(where_condition)

                        ###### GRAPH START ######
                        inner_col_name_graph = (
                            "w_" + str(operation_idx) + "_" + inner_col_name_tree
                        )  # In WHERE clause, same column can be used more than once so operation_idx is used for labeling
                        inner_col_name_alias = get_col_name_alias(inner_tab_name, inner_col_name, inner_agg)
                        cur_inner_col_node = Attribute(inner_col_name_graph, inner_col_name_alias)

                        inner_tab_name_graph = inner_table_block_name
                        inner_tab_name_alias = get_tab_name_alias(inner_table_block_name)
                        is_primary_inner = inner_table_block_name in primary_relations
                        cur_inner_rel_node = Relation(
                            inner_tab_name_graph, inner_tab_name_alias, is_primary=is_primary_inner
                        )  # Q: can I mark inner tables? (nesting level) user_study_queries example 화인
                        idx = find_existing_rel_node(rel_nodes, cur_inner_rel_node)
                        if idx == -1:
                            rel_nodes.append(cur_inner_rel_node)
                        else:
                            cur_inner_rel_node = rel_nodes[idx]

                        cur_operator_graph = operatorNameToType[op]

                        tab_name_graph = tab_name
                        tab_name_alias = get_tab_name_alias(tab_name)
                        is_primary = tab_name in primary_relations
                        cur_rel_node = Relation(tab_name_graph, tab_name_alias, is_primary=is_primary)
                        idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                        if idx == -1:
                            rel_nodes.append(cur_rel_node)
                        else:
                            cur_rel_node = rel_nodes[idx]

                        cur_col_name_graph = "w_" + str(operation_idx) + "_" + col_name
                        cur_col_name_alias = get_col_name_alias(tab_name, col_name, "NONE")
                        cur_col_node = Attribute(cur_col_name_graph, cur_col_name_alias)

                        graph.connect_selection(cur_rel_node, cur_col_node)
                        graph.connect_predicate(cur_col_node, cur_inner_col_node, cur_operator_graph, dnf_idx)
                        graph.connect_membership(cur_inner_rel_node, cur_inner_col_node)

                        ###### GRAPH END   ######
                    else:
                        if col is None:  # EXISTS / NOT EXISTS
                            assert len(obj["agg_cols"]) == 1
                            inner_agg_col = obj["agg_cols"][0]
                            inner_agg = inner_agg_col[0]
                            inner_col = inner_agg_col[1]
                            if inner_col != "*":
                                inner_tab_name = inner_col.split(".")[0]
                                inner_col_name = inner_col.split(".")[1]
                            else:
                                inner_tab_name = None
                                inner_col_name = inner_col

                            inner_col_name_tree = get_tree_header(
                                inner_table_prefix, inner_tab_name, inner_col_name, inner_agg
                            )
                            where_condition = Condition(
                                l_operand=-1,
                                operator=op,
                                r_operand=get_global_index(
                                    base_tables, table_name_to_idx[inner_table_block_name], inner_col_name_tree
                                ),
                            )
                            conditions[dnf_idx].append(where_condition)

                            ###### GRAPH START ######
                            inner_tables = obj["tables"]
                            if inner_tab_name == None:
                                inner_tab_name = list(set(inner_tables) & set(tables))[0]
                            inner_col_name_graph = "w_" + str(operation_idx) + "_" + inner_col_name_tree
                            inner_col_name_alias = get_col_name_alias(inner_tab_name, inner_col_name, inner_agg)
                            cur_inner_col_node = Attribute(inner_col_name_graph, inner_col_name_alias)

                            inner_tab_name_graph = inner_table_block_name
                            inner_tab_name_alias = get_tab_name_alias(inner_table_block_name)
                            is_primary_inner = inner_table_block_name in primary_relations
                            cur_inner_rel_node = Relation(
                                inner_tab_name_graph, inner_tab_name_alias, is_primary=is_primary_inner
                            )  # Q: can I mark inner tables? (nesting level) user_study_queries example check
                            idx = find_existing_rel_node(rel_nodes, cur_inner_rel_node)
                            if idx == -1:
                                rel_nodes.append(cur_inner_rel_node)
                            else:
                                cur_inner_rel_node = rel_nodes[idx]

                            cur_operator_graph = operatorNameToType[op]

                            tab_name_graph = inner_tab_name
                            tab_name_alias = get_tab_name_alias(inner_tab_name)
                            is_primary = inner_tab_name in primary_relations
                            cur_rel_node = Relation(tab_name_graph, tab_name_alias, is_primary=is_primary)
                            idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                            if idx == -1:
                                rel_nodes.append(cur_rel_node)
                            else:
                                cur_rel_node = rel_nodes[idx]

                            star_node_name_out = "w_" + str(operation_idx) + "_*_out"
                            star_node_name_in = "w_" + str(operation_idx) + "_*_in"

                            star_node1 = Attribute(star_node_name_out, " ")
                            star_node2 = Attribute(star_node_name_in, " ")
                            graph.connect_selection(cur_rel_node, star_node1)
                            graph.connect_predicate(star_node1, star_node2, cur_operator_graph, dnf_idx)
                            graph.connect_membership(cur_inner_rel_node, star_node2)
                            ###### GRAPH END   ######
                        else:  # ( SELECT ... ) op value
                            assert len(obj["agg_cols"]) == 1
                            inner_agg_col = obj["agg_cols"][0]
                            inner_agg = inner_agg_col[0]
                            inner_col = inner_agg_col[1]
                            if inner_col != "*":
                                inner_tab_name = inner_col.split(".")[0]
                                inner_col_name = inner_col.split(".")[1]
                            else:
                                inner_tab_name = None
                                inner_col_name = inner_col

                            inner_col_name_tree = get_tree_header(
                                inner_table_prefix, inner_tab_name, inner_col_name, inner_agg
                            )
                            where_condition = Condition(
                                l_operand=get_global_index(
                                    base_tables, table_name_to_idx[inner_table_block_name], inner_col_name_tree
                                ),
                                operator=op,
                                r_operand=val,
                            )
                            conditions[dnf_idx].append(where_condition)

                            ###### GRAPH START ######
                            inner_col_name_graph = (
                                "w_" + str(operation_idx) + "_" + inner_col_name_tree
                            )  # Q: 중복이 있으면 어떡하지? and/or 구분은 어떻게 하지?
                            inner_col_name_alias = get_col_name_alias(inner_tab_name, inner_col_name, inner_agg)
                            cur_inner_col_node = Attribute(inner_col_name_graph, inner_col_name_alias)

                            inner_tab_name_graph = inner_table_block_name
                            inner_tab_name_alias = get_tab_name_alias(inner_table_block_name)
                            is_primary_inner = inner_table_block_name in primary_relations
                            cur_inner_rel_node = Relation(
                                inner_tab_name_graph, inner_tab_name_alias, is_primary=is_primary_inner
                            )  # Q: can I mark inner tables? (nesting level) user_study_queries example check
                            idx = find_existing_rel_node(rel_nodes, cur_inner_rel_node)
                            if idx == -1:
                                rel_nodes.append(cur_inner_rel_node)
                            else:
                                cur_inner_rel_node = rel_nodes[idx]

                            cur_operator_graph = operatorNameToType[op]

                            val_name_graph = val
                            val_alias_graph = get_val_alias(op, val)
                            cur_val_node = Value(val_name_graph, val_alias_graph)

                            graph.connect_selection(cur_inner_rel_node, cur_inner_col_node)
                            graph.connect_predicate(cur_inner_col_node, cur_val_node, cur_operator_graph, dnf_idx)
                            ###### GRAPH END   ######

                elif len(operation) == 6:  # correlated predicate
                    # Correlated predicate is in inner query but inner query does not call this function
                    pass
                else:
                    tab_name = col.split(".")[0]
                    col_name = col.split(".")[1]

                    where_condition = Condition(
                        l_operand=get_global_index(base_tables, table_name_to_idx[tab_name], col_name),
                        operator=op,
                        r_operand=val,
                    )
                    conditions[dnf_idx].append(where_condition)

                    ###### GRAPH START ######
                    val_name_graph = val
                    val_alias_graph = get_val_alias(op, val)
                    cur_val_node = Value(val_name_graph, val_alias_graph)

                    cur_operator_graph = operatorNameToType[op]
                    tab_name_graph = tab_name
                    tab_name_alias = get_tab_name_alias(tab_name_graph)
                    is_primary = tab_name in primary_relations
                    cur_rel_node = Relation(
                        tab_name_graph, tab_name_alias, is_primary=is_primary
                    )  # Nesting level is always 0
                    idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                    if idx == -1:
                        rel_nodes.append(cur_rel_node)
                    else:
                        cur_rel_node = rel_nodes[idx]

                    col_name_graph = "w_" + str(operation_idx) + "_" + col_name
                    col_name_alias = get_col_name_alias(tab_name, col_name, "NONE")
                    cur_col_node = Attribute(col_name_graph, col_name_alias)

                    graph.connect_selection(cur_rel_node, cur_col_node)
                    graph.connect_predicate(cur_col_node, cur_val_node, cur_operator_graph, dnf_idx)
                    ###### GRAPH END   ######
            clauses = []
            for condition in conditions:
                clauses.append(Clause(conditions=condition))
            selection_operation = Selection(clauses=clauses)
            operations.append(selection_operation)

        if sql_type_dict["group"]:
            for group_col in group:
                group_alias = group_col.split(".")[0]
                tab_name = group_alias.split(prefix)[1]
                col_name = group_col.split(".")[1]
                agg = "NONE"
                operations.append(Grouping(get_global_index(base_tables, table_name_to_idx[tab_name], col_name)))

                ###### GRAPH START ######
                tab_name_graph = tab_name
                tab_name_alias = get_tab_name_alias(tab_name)
                is_primary = tab_name in primary_relations
                cur_rel_node = Relation(
                    tab_name_graph, tab_name_alias, is_primary=is_primary
                )  # Nesting level is always 0
                idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                if idx == -1:
                    rel_nodes.append(cur_rel_node)
                else:
                    cur_rel_node = rel_nodes[idx]

                col_name_graph = "g_" + col_name
                col_name_alias = get_col_name_alias(tab_name, col_name, agg)
                cur_col_node = Attribute(col_name_graph, col_name_alias)
                graph.connect_grouping(cur_rel_node, cur_col_node)
                ###### GRAPH END   ######

        # normal order by
        if sql_type_dict["order"]:
            for order_col_raw in order:
                order_col = order_col_raw
                agg = "NONE"
                for candidate_agg in NUMERIC_AGGS:
                    if candidate_agg + "(" in order_col_raw:
                        assert ")" in order_col_raw
                        agg = candidate_agg
                        order_col = order_col_raw.split(agg + "(")[1].split(")")[0]
                        break
                if agg != "NONE":
                    raise Exception("[tree and graph formation] aggregated order cannot be in this code")

                if order_col != "*":
                    order_alias = order_col.split(".")[0]
                    tab_name = order_alias.split(prefix)[1]
                    col_name = order_col.split(".")[1]
                    table_idx = table_name_to_idx[tab_name]
                else:
                    table_idx = 0
                    col_name = order_col
                operations.append(Ordering(get_global_index(base_tables, table_idx, col_name)))

                ###### GRAPH START ######
                tab_name_graph = tab_name
                tab_name_alias = get_tab_name_alias(tab_name)
                is_primary = tab_name in primary_relations
                cur_rel_node = Relation(
                    tab_name_graph, tab_name_alias, is_primary=is_primary
                )  # Nesting level is always 0
                idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                if idx == -1:
                    rel_nodes.append(cur_rel_node)
                else:
                    cur_rel_node = rel_nodes[idx]

                col_name_graph = "o_" + col_name
                col_name_alias = get_col_name_alias(tab_name, col_name, agg)
                cur_col_node = Attribute(col_name_graph, col_name_alias)
                graph.connect_order(cur_rel_node, cur_col_node)
                ###### GRAPH END   ######

        if sql_type_dict["limit"]:
            operations.append(Limit(limit))
            ###### GRAPH START ######
            graph.set_limit(limit)
            ###### GRAPH END   ######

        node = QueryBlock(
            child_tables=base_tables, join_conditions=join_conditions, operations=operations, sql=sql, name=prefix[:-1]
        )
        tree = QueryTree(root=node, sql=sql)

    graph_obj = (tree, graph)
    return graph_obj


def sql_formation(
    args,
    sql_type_dict,
    tables,
    joins,
    select,
    where=None,
    group=None,
    having=None,
    order=None,
    limit=None,
    select_agg_cols=None,
    tree_predicates_origin=None,
    predicates_origin=None,
    having_tree_predicates_origin=None,
    having_predicates_origin=None,
    nesting_level=None,
    nesting_block_idx=None,
    inner_select_nodes=None,
):
    prefix = "N" + str(nesting_level) + "_" + str(nesting_block_idx) + "_"

    select_clause = "SELECT DISTINCT " + ", ".join(select)

    # FROM clause generation
    # Check ALL table in tables has join_c
    if len(tables) > 1:
        joined_tables = set()
        for join_c in joins:
            t1, k1, t2, k2 = get_table_join_key_from_join_clause(join_c)
            joined_tables.add(t1)
            joined_tables.add(t2)
        given_tables = set(tables)
        assert joined_tables == given_tables

        table_string = ""
        visited_tables = set([tables[0]])
        root_table_ref = f"{tables[0]} AS {prefix}{tables[0]}"
        table_string += root_table_ref

        remaining_joins = copy.deepcopy(joins)
        while len(remaining_joins) > 0:
            new_remaining_joins = []
            for join_c in remaining_joins:
                t1, k1, t2, k2 = get_table_join_key_from_join_clause(join_c)
                t1_ref = f"{t1} AS {prefix}{t1}"
                t2_ref = f"{t2} AS {prefix}{t2}"
                join_c_ref = alias_join_clause(join_c, prefix)

                if t1 in visited_tables:
                    if t2 in visited_tables:
                        table_string += f" AND {join_c_ref}"
                    else:
                        table_string += f" JOIN {t2_ref} ON {join_c_ref}"
                        visited_tables.add(t2)
                elif t2 in visited_tables:
                    if t1 in visited_tables:
                        table_string += f" AND {join_c_ref}"
                    else:
                        table_string += f" JOIN {t1_ref} ON {join_c_ref}"
                        visited_tables.add(t1)
                else:
                    new_remaining_joins.append(join_c)
            assert new_remaining_joins != remaining_joins
            remaining_joins = copy.deepcopy(new_remaining_joins)
    else:
        table_string = f"{tables[0]} AS {prefix}{tables[0]}"

    from_clause = " FROM " + table_string

    # WHERE clause generation
    if sql_type_dict["where"]:
        where_clause = " WHERE " + preorder_traverse(where)
    else:
        where_clause = ""

    # GROUP BY clause generation
    if sql_type_dict["group"]:
        group_clause = " GROUP BY " + ", ".join(group)
    else:
        group_clause = ""

    # HAVING clause generation
    if sql_type_dict["having"]:
        having_clause = " HAVING " + preorder_traverse(having)
    else:
        having_clause = ""

    # ORDER BY clause generation
    if sql_type_dict["order"]:
        order_clause = " ORDER BY " + ", ".join(order)
    else:
        order_clause = ""

    # LIMIT clause generation
    if sql_type_dict["limit"]:
        limit_clause = " LIMIT " + str(limit)
    else:
        limit_clause = ""

    line = select_clause + from_clause + where_clause + group_clause + having_clause + order_clause + limit_clause

    return line


def get_table_from_clause(join_clause):
    A, B = join_clause.split("=")
    return A.split(".")[0], B.split(".")[0]


def get_possible_join(selected_joins, avaliable_joins):
    result = list()
    for join_clause in avaliable_joins:
        A, B = join_clause.split("=")
        t1, t2 = A.split(".")[0], B.split(".")[0]
        for selected_clause in selected_joins:
            A, B = selected_clause.split("=")
            t3, t4 = A.split(".")[0], B.split(".")[0]
            if t1 == t3 or t1 == t4 or t2 == t3 or t2 == t4:
                result.append(join_clause)
    return result


def get_initial_nesting_positions(args):
    return {"type-a": [0], "type-n": [0, 1], "type-j": [0, 1, 2, 3], "type-ja": [0, 3]}


def get_initial_nesting_types(args):
    return ["type-a", "type-n", "type-ja", "type-j"]


def is_hashcode_column(args, col):
    return col in args.HASH_CODES


def is_note_column(args, col):
    return col in args.NOTES


def is_correlatable_column(args, col):
    return True


def is_categorical_column(args, col):
    return col in args.CATEGORIES


def is_id_column(args, col, join_key_list):
    if col == "*":
        return False
    return col in join_key_list or "id" in col.split(".")[1].lower() or col in args.IDS


def is_foreign_key(args, tab_col):
    if tab_col == "*":
        return False
    tab, col = tab_col.split(".")
    return col in args.FOREIGN_KEYS[tab]


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
        columns = data_manager.fetch_column_names(table)
        df_columns += [table + "." + column for column in columns]

    df_columns_not_null = []
    for column in df_columns:
        alias = column.replace(".", "__")
        data_manager.execute(f"SELECT COUNT(*) FROM {args.fo_view_name} WHERE {alias} IS NOT NULL")
        result = data_manager.fetchall()
        if result[0][0] > 0:
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
            if (not args.constraints["join_key_pred"]) and (
                is_hashcode_column(args, col) or is_id_column(args, col, join_key_list)
            ):
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

    sampled_cols = list(rng.choice(candidate_cols, num_columns, replace=False))

    if sql_type_dict["group"]:
        has_categories = False
        for column in sampled_cols:
            if is_categorical_column(args, column):
                has_categories = True
                break
        if not has_categories:
            max_group = args.hyperparams["num_group_max"]
            min_group = args.hyperparams["num_group_min"]
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


def get_table_join_key_from_join_clause(txt):
    token = txt.split("=")
    assert len(token) == 2
    t1, k1 = token[0].split(".")
    t2, k2 = token[1].split(".")
    return t1, k1, t2, k2


def alias_join_clause(txt, prefix):
    t1, k1, t2, k2 = get_table_join_key_from_join_clause(txt)

    return f"{prefix}{t1}.{k1}={prefix}{t2}.{k2}"


def bfs(edges, parents, observed, targets):
    candidates = []
    cp_condition = {}
    for p in parents:
        childs = edges[p]
        for c, join_clause in childs:
            if c in targets:
                return [c, p], [join_clause]
            else:
                if c in observed:
                    continue
                else:
                    candidates.append(c)
                    observed.append(c)
                    cp_condition[c] = (p, join_clause)
    assert len(candidates) > 0
    path, joins = bfs(edges, candidates, observed, targets)
    src_parent, src_join = cp_condition[path[-1]]
    path.append(src_parent)
    joins.append(src_join)
    return path, joins


def find_join_path_target(joins, used_tables, target_table):
    # Step 1. Draw schema graph
    edges = {}
    for join_clause in joins:
        t1, t2 = get_table_from_clause(join_clause)
        if t1 in edges:
            edges[t1].append((t2, join_clause))
        else:
            edges[t1] = [(t2, join_clause)]
        if t2 in edges:
            edges[t2].append((t1, join_clause))
        else:
            edges[t2] = [(t1, join_clause)]

    used_tables = list(used_tables)
    for used_table in used_tables:
        if used_table not in edges.keys():
            edges[used_table] = []
    found_tables = [target_table]
    found_joins = []

    path, joins = bfs(edges, used_tables, [], found_tables)
    found_tables = list(set(found_tables) | set(path))
    found_joins = list(set(found_joins) | set(joins))

    return found_tables, found_joins


def find_join_path(joins, tables, used_tables):
    # Step 1. Draw schema graph
    edges = {}
    for join_clause in joins:
        t1, t2 = get_table_from_clause(join_clause)
        if t1 in edges:
            edges[t1].append((t2, join_clause))
        else:
            edges[t1] = [(t2, join_clause)]
        if t2 in edges:
            edges[t2].append((t1, join_clause))
        else:
            edges[t2] = [(t1, join_clause)]

    used_tables = list(used_tables)
    found_tables = [used_tables[0]]
    found_joins = []
    for tab in used_tables[1:]:
        path, joins = bfs(edges, [tab], [], found_tables)
        found_tables = list(set(found_tables) | set(path))
        found_joins = list(set(found_joins) | set(joins))

    return found_tables, found_joins


def view_predicate_generator(prefix, col, op, val, dtype, is_nested=False, inner_view_query=None):
    if is_nested:
        if prefix is not None:
            val = "(" + inner_view_query + ")"
            col_ref = col.replace(".", "__")
            if isinstance(op, tuple):
                query_predicate = col_ref + " " + op[0] + " " + val[0] + " and " + col_ref + " " + op[1] + " " + val[1]
            else:
                query_predicate = col_ref + " " + op + " " + val
        else:
            if col is None:
                query_predicate = op + " (" + inner_view_query + ")"
            else:
                query_predicate = "(" + inner_view_query + ")" + " " + op + " " + str(val)
    else:
        col_ref = col.replace(".", "__")
        if isinstance(op, tuple):
            query_predicate = (
                col_ref + " " + op[0] + " " + str(val[0]) + " and " + col_ref + " " + op[1] + " " + str(val[1])
            )
        else:
            if op not in ("IN", "NOT IN") and dtype == "str" and not val.startswith("'"):
                val = f"""\'{val}\'"""
            query_predicate = col_ref + " " + op + " " + str(val)

    return query_predicate


def get_removed_subset_clauses(subset_clauses, clauses_op_val, col, op, val, dtype_dict, args):
    removed_subset_clauses = []

    for clause_idx in subset_clauses:
        colA, opA, valA = None, None, None
        for colAr, opAr, valAr in clauses_op_val[clause_idx]:
            if col == colAr:
                colA, opA, valA = colAr, opAr, valAr
                break
        if colA == None:
            removed_subset_clauses.append(clause_idx)
            continue
        if not check_condB_contain_condA(colA, opA, valA, dtype_dict[colA], col, op, val, dtype_dict[col], args):
            removed_subset_clauses.append(clause_idx)
            continue

    return removed_subset_clauses
