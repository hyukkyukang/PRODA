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


DEBUG_ERROR = False  # [NOTE] This should be disabled


# if is_null_support:
# TEXTUAL_OPERATORS = ['=','!=','LIKE','NOT LIKE','IN','NOT IN','IS_NOT_NULL']
TEXTUAL_OPERATORS_PROBABILITY = [0.4, 0.1, 0.15, 0.1, 0.15, 0.1]
TEXTUAL_OPERATORS = ["=", "!=", "LIKE", "NOT LIKE", "IN", "NOT IN"]
NUMERIC_OPERATORS_PROBABILITY = [0.2, 0.2, 0.2, 0.2, 0.1, 0.1]
NUMERIC_OPERATORS = ["<=", "<", ">=", ">", "=", "!="]

KEY_OPERATORS_PROBABILITY = [0.8, 0.2]
KEY_OPERATORS = ["=", "!="]
HASHCODE_OPERATORS_PROBABILITY = [0.8, 0.2]
HASHCODE_OPERATORS = ["LIKE", "NOT LIKE"]
POSSIBLE_AGGREGATIONS_PER_OPERATOR = {
    "=": ["MIN", "MAX", "AVG", "SUM"],
    "!=": ["MIN", "MAX", "AVG", "SUM"],
    "=_w": ["MIN", "MAX", "AVG", "SUM"],
    "!=_w": ["MIN", "MAX", "AVG", "SUM"],
    "<=": ["AVG", "SUM"],
    "<": ["MAX", "AVG", "SUM"],
    ">=": ["AVG", "SUM"],
    ">": ["MIN", "AVG", "SUM"],
    "<=_w": ["MAX", "AVG", "SUM"],
    "<_w": ["MAX", "AVG", "SUM"],
    ">=_w": ["MIN", "AVG", "SUM"],
    ">_w": ["MIN", "AVG", "SUM"],
}

# (CONSIDERATION) larger/smaller than sum without condition is wierd? what if negative values exist
NUMERIC_AGGS = ["COUNT", "MIN", "MAX", "AVG", "SUM"]
TEXTUAL_AGGS = ["COUNT"]
DATE_AGGS = ["COUNT", "MIN", "MAX"]
# KEY_AGGS = ['MIN', 'MAX', 'COUNT']
KEY_AGGS = ["COUNT"]
LOGICAL_OPERATORS = ["AND", "OR"]

# [TODO]: remove
imdb_col_info = json.load(open("/home/hjkim/shpark/PRODA/src/sql_generator/data/imdb_dtype_dict.json"))
HASH_CODES = imdb_col_info["hash_codes"]
NOTES = imdb_col_info["notes"]
IDS = imdb_col_info["ids"]
PRIMARY_KEYS = imdb_col_info["primary_keys"]
CATEGORIES = imdb_col_info["categories"]


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


def get_truncated_geometric_distribution(N, p):
    geomet = [p * (1 - p) ** i for i in range(N)]
    sum_prob = sum(geomet)
    prob = [i / sum_prob for i in geomet]
    return prob


def get_possibie_inner_query_idxs(args, inner_query_objs):
    idxs = []

    for idx in range(len(inner_query_objs)):
        select_columns = inner_query_objs[idx]["select"]
        if len(select_columns) == 1 and not inner_query_objs[idx]["is_having_child"]:
            idxs.append(idx)

    return idxs


def get_col_info(dbname):
    col_info = json.load(open("data/{dbname}_dtype_dict.json"))
    global IDS
    global HASH_CODES
    global NOTES
    global PRIMARY_KEYS
    global CATEGORIES

    IDS = col_info["ids"]
    HASH_CODES = col_info["hash_codes"]
    NOTES = col_info["notes"]
    PRIMARY_KEYS = col_info["primary_keys"]
    CATEGORIES = col_info["categories"]

    return IDS, HASH_CODES, NOTES, PRIMARY_KEYS, CATEGORIES


def alias_generator(args):
    # [TODO]: make alias generators when given a table namd and the current nested block index
    ALIAS_TO_TABLE_NAME = None

    if ALIAS_TO_TABLE_NAME:
        TABLE_NAME_TO_ALIAS = dict()
        for k, v in ALIAS_TO_TABLE_NAME.items():
            TABLE_NAME_TO_ALIAS[v] = k
    else:
        TABLE_NAME_TO_ALIAS = None

    return ALIAS_TO_TABLE_NAME, TABLE_NAME_TO_ALIAS


def get_str_op_values(op, val, distinct_values, all_values, rng, num_in_max):
    if op == "=":
        return val
    elif op == "!=":
        v = val
        # v = rng.choice(all_values)
        # while (len(all_values) > 1) and (v is val):
        #    v = rng.choice(all_values)  # not test yet
        return str(v).strip()
    elif op == "LIKE":
        val = str(rng.choice(val.split(" ")))
        candidate_op_idx = rng.choice([0, 1, 2])
        if len(val) > 7:
            if candidate_op_idx == 0:
                val = val[:7]
            elif candidate_op_idx == 1:
                val = val[-7:]
            elif candidate_op_idx == 2:
                start_idx = rng.randint(0, len(val) - 7)
                val = val[start_idx : start_idx + 7]

        candidate_vals = [f"{val}%", f"%{val}", f"%{val}%"]

        # val = val.replace('"', '\\\"')
        # return rng.choice([f"{val}%",f"%{val}",f"%{val}%"])

        return candidate_vals[candidate_op_idx].replace('"', '\\"')
    elif op == "NOT LIKE":
        for i in range(10):  # param
            if len(distinct_values) == 1:
                return rng.choice([f"{val}%", f"%{val}", f"%{val}%"])
            # distinct_values = distinct_values
            candidate_val = str(rng.choice(all_values)).strip()

            candidate_val = str(rng.choice(candidate_val.split(" ")))
            if len(candidate_val) > 7:
                start_idx = rng.randint(0, len(candidate_val) - 7)
                candidate_val = candidate_val[start_idx : start_idx + 7]

            candidate_op_idx = rng.choice([0, 1, 2])
            candidate_vals = [f"{candidate_val}%", f"%{candidate_val}", f"%{candidate_val}%"]

            if candidate_op_idx == 0:
                if val.startswith(candidate_val):
                    continue
            elif candidate_op_idx == 1:
                if val.endswith(candidate_val):
                    continue
            elif candidate_op_idx == 2:
                if candidate_val in val:
                    continue

            return candidate_vals[candidate_op_idx].replace('"', '\\"')

        return candidate_vals[candidate_op_idx].replace('"', '\\"')
    elif op == "IN":
        num_in_values = rng.randint(1, num_in_max + 1)  # param
        all_candidate_values = copy.deepcopy(all_values)
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
            in_value_txt = ",".join(["'%s'" % (v.strip().replace("'", "\\'").replace('"', '\\"')) for v in in_values])
        else:
            in_values = list(
                map(lambda i: "'%s'" % (str(i).strip().replace("'", "\\'").replace('"', '\\"')), in_values)
            )
            in_value_txt = ",".join(in_values)
        in_value_txt = f"({in_value_txt})"
        return in_value_txt, num_in_values

    elif op == "NOT IN":
        num_in_values = rng.randint(1, num_in_max + 1)  # param
        all_candidate_values = copy.deepcopy(all_values)
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
            in_value_txt = ",".join(["'%s'" % (v.strip().replace("'", "\\'").replace('"', '\\"')) for v in in_values])
        else:
            in_values = list(
                map(lambda i: "'%s'" % (str(i).strip().replace("'", "\\'").replace('"', '\\"')), in_values)
            )
            in_value_txt = ",".join(in_values)
        in_value_txt = f"({in_value_txt})"
        return in_value_txt, num_in_values
    elif op == "IS_NULL":
        return "None"
    elif op == "IS_NOT_NULL":
        return "None"


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


def renumbering_tree_predicates(predicates, idx):
    if not isinstance(predicates, list):
        assert False, "[renumbering tree predicates], {} is not supported format of predicate".format(predicates)
    if len(predicates) < 2:
        predicates[0] = idx
        return predicates, idx + 1

    assert len(predicates) == 3, "[renumbering tree predicates], {} is not supported format of predicate".format(
        predicates
    )
    predicates[0], left_idx = renumbering_tree_predicates(predicates[0], idx)
    predicates[2], right_idx = renumbering_tree_predicates(predicates[2], left_idx)
    return predicates, right_idx


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


def build_predicate_tree_dnf(rng, predicates):  # [ [ [A OR B] AND [C OR D] ] AND [E OR F] ] [ [A AND B] ]
    while len(predicates) > 1:
        selected_idx = rng.choice(range(len(predicates)), 2, replace=False)
        selected_predicates = [predicates[i] for i in selected_idx]
        if len(selected_predicates[0]) > 1 and selected_predicates[0][1] == "OR":
            op = "OR"
        elif len(selected_predicates[1]) > 1 and selected_predicates[1][1] == "OR":
            op = "OR"
        else:
            prob = 0.9
            op = rng.choice(LOGICAL_OPERATORS, p=[prob, 1 - prob])

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


def preorder_traverse_to_make_df_query(tree, values, df_name):
    if not isinstance(tree, tuple) and not isinstance(tree, list):
        value = values[tree]
        prefix = value[0]
        col = value[1]
        op = value[2]
        val = value[3]
        query_string = None
        correal = None

        if len(value) == 5:
            obj = value[4]
            df_query = obj["df_query"]
            query_string = "SELECT " + df_query["SELECT"] + " FROM " + df_query["FROM"]
            if "WHERE" in df_query.keys():
                query_string += " WHERE " + df_query["WHERE"]
            if "GROUPBY" in df_query.keys():
                query_string += " GROUP BY " + df_query["GROUPBY"]
            if "HAVING" in df_query.keys():
                query_string += " HAVING " + df_query["HAVING"]
            if "ORDERBY" in df_query.keys():
                query_string += " ORDER BY " + df_query["ORDERBY"]
            if "LIMIT" in df_query.keys():
                query_string += " LIMIT " + df_query["LIMIT"]
        if len(value) == 6:
            prefix_outer = value[5]
            val = prefix_outer + "df.`" + val + "`"
        if prefix is not None:
            col = df_name + ".`" + col + "`"
            if query_string is not None:
                val = "(" + query_string + ")"
        else:
            if query_string is not None:
                if col is None:
                    col = ""
                    val = "(" + query_string + ")"
                else:
                    col = "(" + query_string + ")"
                    if val is None:
                        val = ""
            else:
                assert False

        return col + " " + op + " " + val

    if len(tree) == 1:
        return preorder_traverse_to_make_df_query(tree[0], values, df_name)
    elif len(tree) == 3:
        left, op, right = tree

    return (
        "("
        + preorder_traverse_to_make_df_query(left, values, df_name)
        + " "
        + op
        + " "
        + preorder_traverse_to_make_df_query(right, values, df_name)
        + ")"
    )


def preorder_traverse_to_make_df_query_having(tree, values, df_name):
    if not isinstance(tree, tuple) and not isinstance(tree, list):
        value = values[tree]
        prefix = value[0]
        agg = value[1]
        col = value[2]
        op = value[3]
        val = value[4]
        assert len(value) == 5

        if agg != "NONE":
            if col != "*":
                tree = agg + "(" + df_name + ".`" + col + "`)"
            else:
                tree = agg + "(" + col + ")"
        else:
            tree = df_name + ".`" + col + "`"

        tree += " " + op + " " + val

        return tree

    assert len(tree) == 3 or len(tree) == 1

    if len(tree) == 1:
        return preorder_traverse_to_make_df_query_having(tree[0], values, df_name)
    elif len(tree) == 3:
        left, op, right = tree

    return (
        "("
        + preorder_traverse_to_make_df_query_having(left, values, df_name)
        + " "
        + op
        + " "
        + preorder_traverse_to_make_df_query_having(right, values, df_name)
        + ")"
    )


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
    having_candidate_columns = [
        table_column for table_column in table_columns if table_column not in list(group_columns)
    ] + ["*"]
    grouping_query_agg_cols = []
    grouping_query_select_columns = []
    grouping_query_used_tables = copy.deepcopy(used_tables)
    for col in having_candidate_columns:
        if col == "*":  # COUNT is only availble for star
            aggs = TEXTUAL_AGGS
        elif dtype_dict[col] in ["bool", "str"] or col in IDS or is_column_id(col, join_key_list):
            continue
        elif dtype_dict[col] == "date":
            aggs = DATE_AGGS
        else:
            aggs = NUMERIC_AGGS
        for agg in aggs:
            assert agg != "NONE"
            if col == "*":
                col_rep = agg + "(*)"
                grouping_query_select_columns.append(col_rep)
                grouping_query_agg_cols.append((agg, "*"))
            else:
                distinct = ""
                if agg == "COUNT" and col not in IDS:  # Use distinct if COUNT + non_key_column
                    # distinct = "DISTINCT "
                    pass  # disabled distinct
                col_rep = agg + "(" + distinct + prefix + col + ")"
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


def get_value_set(all_values):
    is_nan = pd.isnull(all_values)
    contains_nan = np.any(is_nan)
    dv_no_nan = all_values[~is_nan]

    vs_all = np.sort(dv_no_nan)
    if contains_nan and np.issubdtype(all_values.dtype, np.datetime64):
        vs_all = np.insert(vs_all, 0, np.datetime64("NaT"))
    elif contains_nan:
        vs_all = np.insert(vs_all, 0, np.nan)

    return vs_all


def preorder_traverse_dataframe(tree):
    if not isinstance(tree, tuple) and not isinstance(tree, list):
        return tree

    assert len(tree) == 3 or len(tree) == 1

    if len(tree) == 1:
        assert len(tree[0]) == 3
        left, op, right = tree[0]
    elif len(tree) == 3:
        left, op, right = tree

    return "(" + preorder_traverse_dataframe(left) + " " + op.lower() + " " + preorder_traverse_dataframe(right) + ")"


def preorder_traverse_to_replace_alias(tree, org, rep):
    if not isinstance(tree, tuple) and not isinstance(tree, list):
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
    outer_inner,
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

        node = QueryBlock(child_tables=base_tables, operations=operations, sql=sql)
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
    outer_inner,
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
    ALIAS_TO_TABLE_NAME, TABLE_NAME_TO_ALIAS = alias_generator(args)
    prefix = "N" + str(nesting_level) + "_" + str(nesting_block_idx) + "_"

    select_clause = "SELECT " + ", ".join(select)

    df_query = {}

    select_cols_df = []
    for col_info in select_agg_cols:
        agg = col_info[0]
        col = col_info[1]
        if col != "*":
            col_df = prefix + "df" + ".'" + col + "'"
        else:
            col_df = col
        if agg != "NONE":
            col_df = agg + "(" + col_df + ")"
        select_cols_df.append(col_df)
    df_query["SELECT"] = ", ".join(select_cols_df)
    df_query["FROM"] = "df " + prefix + "df"

    # FROM clause generation
    if TABLE_NAME_TO_ALIAS:
        table_token = sorted([f"{table} {prefix}{TABLE_NAME_TO_ALIAS[table]}" for table in tables])
    else:
        if prefix:
            table_token = sorted([f"{table} {prefix}{table}" for table in tables])
        else:
            table_token = sorted([f"{table}" for table in tables])

    table_string = " JOIN ".join(table_token)

    join_token = sorted([alias_join_clause(join_c, TABLE_NAME_TO_ALIAS, prefix) for join_c in joins])
    join_string = " AND ".join(join_token)

    from_clause = " FROM " + table_string
    if len(join_token) >= 1:
        from_clause += " ON " + join_string

    # WHERE clause generation
    if sql_type_dict["where"]:
        where_clause = " WHERE " + preorder_traverse(where)
        if outer_inner == "non-nested":
            df_query["WHERE"] = preorder_traverse_to_make_df_query(
                tree_predicates_origin, predicates_origin, prefix + "df"
            )
        elif outer_inner == "outer":
            df_query["WHERE"] = preorder_traverse_to_make_df_query(
                tree_predicates_origin, predicates_origin, prefix + "df"
            )
        elif outer_inner == "inner":
            df_query["WHERE"] = preorder_traverse_to_make_df_query(
                tree_predicates_origin, predicates_origin, prefix + "df"
            )
        else:
            assert False, "[sql_fomation] Not implemented types of queries"
    else:
        where_clause = ""

    # GROUP BY clause generation
    if sql_type_dict["group"]:
        group_clause = " GROUP BY " + ", ".join(group)
        group_df = []
        for group_col in group:
            group_alias = group_col.split(".")[0]
            rel_name = group_alias.split(prefix)[1]
            col_name = group_col.split(".")[1]
            col_df = prefix + "df" + ".`" + rel_name + "." + col_name + "`"
            group_df.append(col_df)
        df_query["GROUPBY"] = ", ".join(group_df)
    else:
        group_clause = ""

    # HAVING clause generation
    if sql_type_dict["having"]:
        having_clause = " HAVING " + preorder_traverse(having)
        df_query["HAVING"] = preorder_traverse_to_make_df_query_having(
            having_tree_predicates_origin, having_predicates_origin, prefix + "df"
        )
    else:
        having_clause = ""

    # ORDER BY clause generation
    if sql_type_dict["order"]:
        order_clause = " ORDER BY " + ", ".join(order)
        order_df = []
        for order_col_raw in order:
            order_col = order_col_raw
            agg = "NONE"
            for candidate_agg in NUMERIC_AGGS:
                if candidate_agg + "(" in order_col_raw:
                    assert ")" in order_col_raw
                    agg = candidate_agg
                    order_col = order_col_raw.split(agg + "(")[1].split(")")[0]
                    break
            if order_col != "*":
                order_alias = order_col.split(".")[0]
                rel_name = order_alias.split(prefix)[1]
                col_name = order_col.split(".")[1]
                col_df = prefix + "df" + ".`" + rel_name + "." + col_name + "`"
            else:
                col_df = order_col
            if agg != "NONE":
                col_df = agg + "(" + col_df + ")"
            order_df.append(col_df)
        df_query["ORDERBY"] = ", ".join(order_df)
    else:
        order_clause = ""

    # LIMIT clause generation
    if sql_type_dict["limit"]:
        limit_clause = " LIMIT " + str(limit)
        df_query["LIMIT"] = str(limit)
    else:
        limit_clause = ""

    line = select_clause + from_clause + where_clause + group_clause + having_clause + order_clause + limit_clause

    return line, df_query


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


def is_column_id(col, join_key_list):
    if col == "*":
        return False
    return col in join_key_list or "id" in col.split(".")[1].lower()


def get_query_token(
    all_table_set,
    join_key_list,
    df_columns,
    df_columns_not_null,
    join_clause_list,
    rng,
    join_key_pred=True,
    inner_query_tables=None,
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

    cont = rng.choice([0, 1], p=[1 - prob, prob])

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

    for col in avaliable_pred_cols:
        if col.split(".")[0] in table_set:
            candidate_cols_projection.append(col)
            # if (not join_key_pred) and (col in join_key_list): # or "id" in col.split('.')[1].lower()): # [TODO] Correction: id
            if (not join_key_pred) and is_column_id(col, join_key_list):  # [TODO] Correction: id
                continue
            candiate_cols.append(col)

    tables = list(table_set)

    return tables, joins, candidate_cols_projection, candiate_cols


def determine_degree_1_table(tables, joins):
    degrees = {k: 0 for k in tables}
    for join_c in joins:
        tc1, tc2 = join_c.split("=")
        t1, c1 = tc1.split(".")
        t2, c2 = tc2.split(".")

        degrees[t1] += 1
        degrees[t2] += 1

    d1_table = [k for k in degrees.keys() if degrees[k] == 1]

    return d1_table


def get_table_join_key_from_join_clause(txt):
    token = txt.split("=")
    assert len(token) == 2
    t1, k1 = token[0].split(".")
    t2, k2 = token[1].split(".")
    return t1, k1, t2, k2


def alias_join_clause(txt, TABLE_NAME_TO_ALIAS, prefix):
    t1, k1, t2, k2 = get_table_join_key_from_join_clause(txt)

    if TABLE_NAME_TO_ALIAS:
        t1 = TABLE_NAME_TO_ALIAS[t1]
        t2 = TABLE_NAME_TO_ALIAS[t2]
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


def convert_agg_to_func(agg):
    if agg == "AVG":
        return "mean"
    else:
        return agg.lower()


def is_numeric(val):
    try:
        float(val)
    except ValueError:
        return False
    else:
        return True


def predicate_generator(col, op, val, is_bool=False):
    if isinstance(op, tuple):
        query_predicate = "`" + col + "` " + op[0] + " " + val[0] + " and " + "`" + col + "` " + op[1] + " " + val[1]
    elif op == "IS_NULL":
        query_predicate = "`" + col + "`.isnull()"
    elif op == "IS_NOT_NULL":
        query_predicate = "not `" + col + "`.isnull()"
    elif op == "LIKE" or op == "NOT LIKE":
        if val[1] == "%" and val[-2] == "%":
            query_predicate = "`" + col + '`.str.contains("' + eval('"' + val[2:-2] + '"') + '", na=False)'
        elif val[1] == "%":
            query_predicate = "`" + col + '`.str.endswith("' + eval('"' + val[2:]) + '", na=False)'
        elif val[-2] == "%":
            query_predicate = "`" + col + '`.str.startswith("' + eval(val[:-2] + '"') + '", na=False)'
        else:
            query_predicate = "`" + col + "` == " + val
        if op == "NOT LIKE":
            query_predicate = "not " + query_predicate
    elif op == "=":
        if not is_numeric(val) and not (val[0] == '"' and val[-1] == '"') and not is_bool:
            query_predicate = "`" + col + '` == "' + val + '"'
        else:
            query_predicate = "`" + col + "` == " + val
    elif op == "!=":
        if not is_numeric(val) and not (val[0] == '"' and val[-1] == '"') and not is_bool:
            query_predicate = "`" + col + '` == "' + val + '"'
        else:
            query_predicate = "`" + col + "` == " + val
    elif op == "IN":
        query_predicate = "`" + col + "` == " + str(list(eval(val[1:-1])))
    elif op == "NOT IN":
        query_predicate = "`" + col + "` != " + str(list(eval(val[1:-1])))
    else:
        query_predicate = "`" + col + "` " + op + " " + val

    return query_predicate
