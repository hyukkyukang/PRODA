from src.sql_generator.tools.storage.db import PostgreSQLDatabase
import src.table_excerpt.table_excerpt
from src.sql_generator.sql_gen_utils.sql_genetion_utils import (
    preorder_traverse_to_replace_alias,
    preorder_traverse_to_get_graph,
    get_view_name,
    get_prefix,
    get_table_join_key_from_join_clause,
    get_operations_with_updated_global_idx,
)
import src.query_tree.query_tree as QueryTree
import src.query_tree.operator as QueryTreeOperator
import numpy as np
import copy

SAMPLE_GROUPS = 6
SAMPLE_TUPLES = 24


def get_used_table_cols(obj, prefix, correlation_column):
    used_table_cols = {}
    for table in obj["tables"]:
        used_table_cols[table] = set()

    for join in obj["joins"]:
        T1, K1, T2, K2 = get_table_join_key_from_join_clause(join)
        used_table_cols[T1].add(K1)
        used_table_cols[T2].add(K2)

    for agg_col in obj["agg_cols"]:
        col = agg_col[1]
        if col != "*":
            t = col.split(".")[0]
            c = col.split(".")[1]
            used_table_cols[t].add(c)

    if obj["type"]["where"]:
        for predicate in obj["predicates_origin"]:
            if predicate[0] != None:
                col = predicate[1]
                t = col.split(".")[0]
                c = col.split(".")[1]
                used_table_cols[t].add(c)

    if obj["type"]["group"]:
        for group in obj["group"]:
            group_org = group.replace(prefix, "")
            t = group_org.split(".")[0]
            c = group_org.split(".")[1]
            used_table_cols[t].add(c)

    if obj["type"]["having"]:
        # HAVING query do not have any base table
        assert False

    if obj["type"]["order"]:
        for order in obj["order"]:
            if "(" in order and ")" in order:
                order_org = order.split("(")[1].split(")")[0]
            else:
                order_org = order
            order_org = order_org.replace(prefix, "")
            if order_org != "*":
                t = order_org.split(".")[0]
                c = order_org.split(".")[1]
                used_table_cols[t].add(c)

    if obj["correlation_predicates_origin"] is not None and len(obj["correlation_predicates_origin"]) > 0:
        for cor_pred in obj["correlation_predicates_origin"]:
            inner_cor = cor_pred[1]
            inner_cor_tab = inner_cor.split(".")[0]
            inner_cor_col = inner_cor.split(".")[1]
            used_table_cols[inner_cor_tab].add(inner_cor_col)

    if correlation_column is not None:
        cor_tab = correlation_column.split(".")[0]
        cor_col = correlation_column.split(".")[1]
        used_table_cols[cor_tab].add(cor_col)

    return used_table_cols


def transpose(matrix):
    return list(map(list, zip(*matrix)))


def get_view_query(
    data_manager,
    inner_join_view_name,
    obj,
    prefix,
    where_condition=None,
    having_condition=None,
    negated=[],
    ignored=[],
    use_agg_sel=False,
    additional_group_col=None,
):
    group_columns = obj["group"]
    order_columns = obj["order"]
    select_columns = obj["select"]
    having_predicates = obj["having"]

    select_col_view = ", ".join(
        [select_col.replace(".", "__").replace(prefix, f"{inner_join_view_name}.") for select_col in select_columns]
    )
    select_clause = f"""SELECT {select_col_view} """

    additional_conditions = ""

    if where_condition is not None:
        additional_conditions = f""" WHERE {where_condition} """

    if obj["type"]["group"]:
        # IF there is group by, it will return # of groups row

        group_col_view = [
            group_col.replace(".", "__").replace(prefix, f"{inner_join_view_name}.") for group_col in group_columns
        ]
        group_col_view_string = ", ".join(group_col_view)
        additional_conditions += f""" GROUP BY {group_col_view_string} """
        if additional_group_col is not None:
            additional_conditions += (
                f""", {additional_group_col.replace(".", "__").replace(prefix, f"{inner_join_view_name}.")}"""
            )

        if obj["type"]["having"]:
            having_view = preorder_traverse_to_replace_alias(
                having_predicates, [".", prefix], ["__", f"{inner_join_view_name}."]
            )
            if "having" in ignored:
                pass
            elif "having" in negated:
                additional_conditions += f""" HAVING NOT ( {having_view} ) """
            else:
                additional_conditions += f""" HAVING {having_view} """
    elif use_agg_sel and additional_group_col is not None:
        additional_conditions += (
            f""" GROUP BY {additional_group_col.replace(".", "__").replace(prefix, f"{inner_join_view_name}.")} """
        )

    if "having" not in ignored:
        if obj["type"]["having"] and having_condition is not None:
            additional_conditions += f""" AND {having_condition} """
        elif having_condition is not None:
            additional_conditions += f""" HAVING {having_condition} """

    # IF there is order by / limit --
    if obj["type"]["order"] and not "order" in ignored:
        order_col_view = ", ".join(
            [order_col.replace(".", "__").replace(prefix, f"{inner_join_view_name}.") for order_col in order_columns]
        )
        additional_conditions += f""" ORDER BY {order_col_view} """
    if obj["type"]["limit"] and not "limit" in ignored:
        additional_conditions += f""" LIMIT {obj["limit"]} """

    return select_clause, additional_conditions


def get_view_ctids(
    data_manager,
    inner_join_view_name,
    obj,
    prefix,
    grouped=False,
    group_columns=None,
    additional_condition=None,
    having_condition=None,
    correlated=False,
    correlation_column=None,
    ordered=False,
    order_columns=None,
    limited=False,
    limit_num=-1,
    having_negated=False,
):
    if correlated:
        outer_where_clause = ""
        having_projection_str = ""
        outer_where_strings = []
        additional_projections = set()
        if obj["type"]["having"]:
            for h in obj["having_predicates_origin"]:
                h_agg = h[1]
                h_col = h[2].replace(".", "__")
                additional_projections.add(f""" {h_agg}({h_col}) AS {h_agg}_{h_col.replace("*", "all")}_ """)
            outer_where_string = preorder_traverse_to_replace_alias(
                obj["having"], [".", prefix, "(", ")", "*"], ["__", f"T.", "_", "_", "all"]
            )
            having_projection_str = ", " + ", ".join(list(additional_projections))
            if having_negated:
                outer_where_string = f"NOT {outer_where_string} "
            outer_where_strings.append(outer_where_string)
        if obj["use_agg_sel"]:
            additional_projections_agg_sel = set()
            for agg_col in obj["agg_cols"]:
                s_agg = agg_col[0]
                s_col = agg_col[1].replace(".", "__")
                s_col_alias = f""" {s_agg}({s_col}) AS {s_agg}_{s_col.replace("*", "all")}_ """
                if s_agg != "NONE" and s_col_alias not in additional_projections:
                    additional_projections_agg_sel.add(s_col_alias)
            having_projection_str += ", " + ", ".join(list(additional_projections_agg_sel))
        if having_condition:
            outer_where_string_2 = having_condition
            # outer_where_string_2 = (
            #    having_condition.replace(".", "__")
            #    .replace(prefix, "T.")
            #    .replace("(", "_")
            #    .replace(")", "_")
            #    .replace("*", "all")
            # )
            outer_where_strings.append(outer_where_string_2)
        if len(outer_where_strings) > 0:
            outer_where_clause = f""" WHERE {" AND ".join(outer_where_strings)}"""

        if ordered:
            additional_inner_sql_select = ", " + ", ".join(
                [
                    o_col.replace(".", "__").replace(prefix, f"{inner_join_view_name}.") + f" AS O{o_idx}"
                    for o_idx, o_col in enumerate(order_columns)
                ]
            )
            ordered_col_alias = ", ".join([f"T.O{o_idx}" for o_idx in range(len(order_columns))])
        else:
            additional_inner_sql_select = ""
        assert correlation_column is not None

        correlation_col_ref = correlation_column.replace(".", "__").replace(prefix, f"{inner_join_view_name}.")
        if grouped:
            group_col_views = [
                group_col.replace(".", "__").replace(prefix, f"{inner_join_view_name}.") for group_col in group_columns
            ]
            group_col_view_string = ", ".join(
                [group_col_view + f" AS G{g_idx}" for g_idx, group_col_view in enumerate(group_col_views)]
            )
            group_col_alias = ", ".join([f"T.G{g_idx}" for g_idx in range(len(group_columns))])
            view_inner_sql_select = f"""{correlation_col_ref} AS Cc, {group_col_view_string}, array_agg(CTID) AS C2 {additional_inner_sql_select} {having_projection_str} """
        else:
            # [TODO] Check if distinct needed
            
            if additional_condition is not None and obj["use_agg_sel"]:
                view_inner_sql_select = f""" {distinct_cond} {correlation_col_ref} AS Cc, unnest(array_agg(CTID)) AS C1 {additional_inner_sql_select} {having_projection_str}"""
            else:
                view_inner_sql_select = f""" {distinct_cond} {correlation_col_ref} AS Cc, CTID AS C1 {additional_inner_sql_select} {having_projection_str}"""

        view_inner_sql = f"SELECT {view_inner_sql_select} FROM {inner_join_view_name}"

        if additional_condition is not None:
            view_inner_sql += additional_condition

        if grouped:
            Cidx_ref = f"""array_agg( ARRAY[({group_col_alias}, T.C2)] )"""
            if ordered:
                Cidx_ref = (
                    f"array_agg( ARRAY[({group_col_alias}, {ordered_col_alias}, T.C2)] ORDER BY {ordered_col_alias})"
                )
            if limited:
                Cidx_ref = f"({Cidx_ref})[1:{limit_num}]"

            view_sql = f"""SELECT T.Cc, {Cidx_ref} FROM ( {view_inner_sql} ) AS T {outer_where_clause} GROUP BY T.Cc"""
        else:
            Cidx_ref = "array_agg(T.C1)"
            if ordered:
                Cidx_ref = f"array_agg( ARRAY[({ordered_col_alias}, T.C1)] ORDER BY {ordered_col_alias})"
            if limited:
                Cidx_ref = f"({Cidx_ref})[1:{limit_num}]"

            view_sql = f"""SELECT T.Cc, {Cidx_ref} FROM ( {view_inner_sql}) AS T {outer_where_clause} GROUP BY T.Cc """
    else:
        assert not ordered
        if grouped:
            group_col_view = [
                group_col.replace(".", "__").replace(prefix, f"{inner_join_view_name}.") for group_col in group_columns
            ]
            group_col_view_string = ", ".join(group_col_view)
            view_sql = f"""SELECT {group_col_view_string}, array_agg(CTID) FROM {inner_join_view_name} """
            # IF there is group by, it will return # of groups row
        else:
            proj_view = [agg_col[1].replace(".", "__") for agg_col in obj["agg_cols"] if agg_col[0] == "NONE" and agg_col[1] != "*"]
            if len(proj_view) == 0:
                proj_view = []
                for table in obj["tables"]:
                    primary_keys = data_manager.get_primary_keys(table)
                    proj_view += [ f"{table}__{primary_key}" for primary_key in primary_keys ]
            
            if len(proj_view) > 0:
                distinct_cond = f"""DISTINCT ON ({", ".join(proj_view)})"""
            else:
                assert False, f"We assume that there is at least on table having primary key"
                
            view_sql = f"""SELECT {distinct_cond} CTID FROM {inner_join_view_name} """
            # IF there is no group by, it will return # of inner join view rows

        if additional_condition is not None:
            view_sql += additional_condition

    data_manager.execute(view_sql)
    result = data_manager.fetchall()

    return result


def get_child_condition_from_parents(condition):
    return condition[0], condition[1]


def update_query_node_with_table_excerpt(
    rng, fo_view_name, query_tree_node, data_manager, view_name, query_objs, query_id, dtype_dict, args
):
    # sampled_te_row_view_name
    obj = query_objs[query_id]
    prefix = query_id + "_"
    assert get_prefix(obj["nesting_level"], obj["unique_alias"]) == prefix

    rows = [[]]
    result_tables = [[]]

    #### cor vals
    #### col vals
    #### If not correlated: -- result data's year value set [a,b,c,d,e,f] OP {column}
    #### If correlated:  -- (a, b) For each correlation value, a OP (INNER QUERY RESULT)
    #### where column

    correlation_column = None
    if len(args) > 1:
        correlation_column = args[1]

    all_correlation_values = None
    all_correlation_values_cond = None
    if len(args) > 2:
        all_correlation_values = args[2]

    ### >>>> positive data for child query block
    ## >> positive data for this block
    positive_where_condition = None
    positive_having_condition = None
    positive_having_condition_correal = None
    correlation_column_condition = None
    if len(args) > 0:
        condition_type, condition_value = get_child_condition_from_parents(args[0])
        if condition_type == "where":
            positive_where_condition = condition_value
        elif condition_type == "having":
            positive_having_condition = condition_value
        else:
            condition_alls = []
            condition_alls_correaled = []
            any_aggs = False
            any_not_aggs = False
            for idx in range(len(condition_value[1])):
                vals = [val[idx] for val in condition_value[2]]
                op = condition_value[1][idx]
                agg_col = condition_value[0][idx]
                agg = agg_col[0]
                col = agg_col[1]
                if col != "*":
                    if agg == "COUNT":
                        col_type = "int"
                    else:
                        col_type = dtype_dict[col]
                else:
                    col_type = "int"

                if agg != "NONE":
                    any_aggs = True
                    col_ref = agg + "(" + col.replace(".", "__").replace(prefix, f"{view_name}.") + ")"
                    col_ref_correaled = (
                        f"""{agg}_{col.replace(".", "__").replace(prefix, "T.").replace("*", "all")}_ """
                    )
                else:
                    any_not_aggs = True
                    col_ref = col.replace(".", "__").replace(prefix, f"{view_name}.")
                    col_ref_correaled = f"""T.Cc"""

                conditions = []
                conditions_correaled = []
                for val in vals:
                    if correlation_column is not None and idx >= 1:
                        val_arr = val
                        conds_for_one_correal_val = []
                        conds_correal_for_one_correal_val = []
                        for v in val_arr:
                            if col_type == "str":
                                val_ref = f"""'{v}'"""
                            elif col_type == "date":
                                val_ref = f"""'{v}'::date"""
                            else:
                                val_ref = f"""{v}"""
                            if op in ("IN", "NOT IN"):
                                val_ref = f"""({val_ref})"""
                            conds_for_one_correal_val.append(f"""{col_ref} {op} {val_ref}""")
                            conds_correal_for_one_correal_val.append(f"""{col_ref_correaled} {op} {val_ref}""")
                        if op in ("IN", "="):
                            conc = " OR "
                        else:
                            conc = " AND "
                        conditions.append("( " + f"{conc}".join(conds_for_one_correal_val) + " )")
                        conditions_correaled.append("( " + f"{conc}".join(conds_correal_for_one_correal_val) + " )")
                    else:
                        if col_type == "str":
                            val_ref = f"""'{val}'"""
                        elif col_type == "date":
                            val_ref = f"""'{val}'::date"""
                        else:
                            val_ref = f"""{val}"""

                        if op in ("IN", "NOT IN"):
                            val_ref = f"""({val_ref})"""
                        conditions.append(f"""{col_ref} {op} {val_ref}""")
                        conditions_correaled.append(f"""{col_ref_correaled} {op} {val_ref}""")
                condition_alls.append(conditions)
                condition_alls_correaled.append(conditions_correaled)
            condition_alls = transpose(condition_alls)
            condition_alls_correaled = transpose(condition_alls_correaled)

            if not any_aggs:
                condition_alls_strings = [f""" ( {" AND ".join(conditions)} ) """ for conditions in condition_alls]
                condition_string = f""" ( { " OR ".join(condition_alls_strings) } ) """
                if positive_where_condition is None:
                    positive_where_condition = ""
                else:
                    positive_where_condition += " AND "
                positive_where_condition += condition_string
            else:
                if any_not_aggs:  # Correal + selection
                    conditions_having_correal_strings = [
                        f""" ( {" AND ".join(conditions)} ) """ for conditions in condition_alls_correaled
                    ]
                    condition_string = f""" ( { " OR ".join(conditions_having_correal_strings) } ) """
                    positive_having_condition_correal = condition_string
                else:  # Not correlated
                    condition_alls_strings = [f""" ( {" AND ".join(conditions)} ) """ for conditions in condition_alls]
                    condition_string = f""" ( { " OR ".join(condition_alls_strings) } ) """
                    if positive_having_condition is None:
                        positive_having_condition = ""
                    else:
                        positive_having_condition += " AND "
                    positive_having_condition += condition_string

            if all_correlation_values is not None and len(all_correlation_values) > 0:
                if len(all_correlation_values) == 1:
                    all_correlation_values_string = str(all_correlation_values)[:-2] + ")"
                else:
                    all_correlation_values_string = str(all_correlation_values)
                if positive_where_condition is not None:
                    correlation_column_in_view = correlation_column.replace(".", "__").replace(prefix, view_name + ".")
                    positive_where_condition += f""" OR ( {correlation_column_in_view} IS NOT NULL AND {correlation_column_in_view} NOT IN {all_correlation_values_string} ) """

                if positive_having_condition_correal is not None:
                    positive_having_condition_correal += (
                        f""" OR ( T.Cc IS NOT NULL AND T.Cc NOT IN {all_correlation_values_string} ) """
                    )

    else:
        condition_type = None
        condition_value = None

    if len(obj["childs"]) > 0:
        # inner_correlation_column_should_be_not_null
        inner_correlation_columns = []
        inner_not_null_conditions = []
        for cor_pred in obj["correlation_predicates_origin"]:
            inner_correlation_column = cor_pred[1].replace(".", "__")
            inner_not_null_conditions.append(f" {inner_correlation_column} IS NOT NULL ")
        if len(inner_not_null_conditions) > 0:
            if positive_where_condition is not None:
                positive_where_condition = " AND ".join(
                    inner_not_null_conditions + ["( " + positive_where_condition + " )"]
                )
            else:
                positive_where_condition = " AND ".join(inner_not_null_conditions)

        # inner_column should be not null

    if correlation_column is not None:
        correlated = True
        ignored = ["order", "limit", "having"]
        ordered = obj["type"]["order"]
        order_columns = obj["order"]
        limited = obj["type"]["limit"]
        limit_num = obj["limit"]
    else:
        correlated = False
        correlation_column_ref = None
        ignored = []
        ordered = False
        order_columns = []
        limited = False
        limit_num = -1

    dnf_clauses = obj["where"]
    is_grouped = True if obj["type"]["group"] or (correlation_column is not None and obj["use_agg_sel"]) else False

    positive_ctids_raws = []
    if len(obj["clauses_view_predicates_origin"]) > 1 and not obj["type"]["having"]:
        for dnf_idx, view_predicates in enumerate(obj["clauses_view_predicates_origin"]):
            if positive_where_condition is not None:
                current_positive_where_condition = positive_where_condition + " AND "
            else:
                current_positive_where_condition = ""
            view_predicates_ref = [
                view_predicate.replace(fo_view_name + " ", view_name + " ").replace(fo_view_name + ".", view_name + ".")
                for view_predicate in view_predicates
            ]
            current_positive_where_condition += " AND ".join(view_predicates_ref)

            _, positive_additional_conditions = get_view_query(
                data_manager,
                view_name,
                obj,
                prefix,
                where_condition=current_positive_where_condition,
                having_condition=positive_having_condition,
                ignored=ignored,
                use_agg_sel=obj["use_agg_sel"],
                additional_group_col=correlation_column,
            )
            positive_ctids_raw_dnf = get_view_ctids(
                data_manager,
                view_name,
                obj,
                prefix,
                grouped=obj["type"]["group"],
                group_columns=obj["group"],
                additional_condition=positive_additional_conditions,
                having_condition=positive_having_condition_correal,
                correlated=correlated,
                correlation_column=correlation_column,
                ordered=ordered,
                order_columns=order_columns,
                limited=limited,
                limit_num=limit_num,
            )
            positive_ctids_raws.append(positive_ctids_raw_dnf)
    else:
        _, positive_additional_conditions = get_view_query(
            data_manager,
            view_name,
            obj,
            prefix,
            where_condition=positive_where_condition,
            having_condition=positive_having_condition,
            ignored=ignored,
            use_agg_sel=obj["use_agg_sel"],
            additional_group_col=correlation_column,
        )
        positive_ctids_raws = [
            get_view_ctids(
                data_manager,
                view_name,
                obj,
                prefix,
                grouped=obj["type"]["group"],
                group_columns=obj["group"],
                additional_condition=positive_additional_conditions,
                having_condition=positive_having_condition_correal,
                correlated=correlated,
                correlation_column=correlation_column,
                ordered=ordered,
                order_columns=order_columns,
                limited=limited,
                limit_num=limit_num,
            )
        ]

    ## >> negative data for having block
    if not correlated:
        ignored = ["order", "limit"]
    negative_ctids_2_raws = []
    if obj["type"]["having"] or obj["type"]["limit"]:
        if len(obj["clauses_view_predicates_origin"]) > 1 and not obj["type"]["having"]:
            for dnf_idx, view_predicates in enumerate(obj["clauses_view_predicates_origin"]):
                if positive_where_condition is not None:
                    current_positive_where_condition = positive_where_condition + " AND "
                else:
                    current_positive_where_condition = ""
                view_predicates_ref = [
                    view_predicate.replace(fo_view_name + " ", view_name + " ").replace(
                        fo_view_name + ".", view_name + "."
                    )
                    for view_predicate in view_predicates
                ]
                current_positive_where_condition += " AND ".join(view_predicates_ref)

                _, negative_positive_conditions = get_view_query(
                    data_manager,
                    view_name,
                    obj,
                    prefix,
                    where_condition=current_positive_where_condition,
                    having_condition=positive_having_condition,
                    negated=["having"],
                    ignored=ignored,
                    use_agg_sel=obj["use_agg_sel"],
                    additional_group_col=correlation_column,
                )
                if "having" in ignored:
                    having_negated = True
                else:
                    having_negated = False
                negative_ctids_2_raw_dnf = get_view_ctids(
                    data_manager,
                    view_name,
                    obj,
                    prefix,
                    grouped=obj["type"]["group"],
                    group_columns=obj["group"],
                    additional_condition=negative_positive_conditions,
                    having_condition=positive_having_condition_correal,
                    correlated=correlated,
                    correlation_column=correlation_column,
                    ordered=ordered,
                    order_columns=order_columns,
                    limited=limited,
                    limit_num=limit_num,
                    having_negated=having_negated,
                )
                negative_ctids_2_raws.append(negative_ctids_2_raw_dnf)
        else:
            _, negative_positive_conditions = get_view_query(
                data_manager,
                view_name,
                obj,
                prefix,
                where_condition=positive_where_condition,
                having_condition=positive_having_condition,
                negated=["having"],
                ignored=ignored,
                use_agg_sel=obj["use_agg_sel"],
                additional_group_col=correlation_column,
            )
            if "having" in ignored:
                having_negated = True
            else:
                having_negated = False
            negative_ctids_2_raws = [
                get_view_ctids(
                    data_manager,
                    view_name,
                    obj,
                    prefix,
                    grouped=obj["type"]["group"],
                    group_columns=obj["group"],
                    additional_condition=negative_positive_conditions,
                    having_condition=positive_having_condition_correal,
                    correlated=correlated,
                    correlation_column=correlation_column,
                    ordered=ordered,
                    order_columns=order_columns,
                    limited=limited,
                    limit_num=limit_num,
                    having_negated=having_negated,
                )
            ]
        if sum([len(negative_ctids_2_raw) for negative_ctids_2_raw in negative_ctids_2_raws]) == 0:
            print("WARNING: no results for negative having")
    elif obj["type"]["aggregated_order"]:
        # no negative data for order by
        pass
    else:
        # how to get negative data for where clause --> {view_name}__nagative_examples
        # sample from fo_view not in inner_query_view
        pass
    ## << negative data for this block

    assert (
        sum(
            [len(positive_ctids_raw) for positive_ctids_raw in positive_ctids_raws]
            + [len(negative_ctids_2_raw) for negative_ctids_2_raw in negative_ctids_2_raws]
        )
        > 0
    )
    assert sum([len(positive_ctids_raw) for positive_ctids_raw in positive_ctids_raws]) > 0

    def get_sample_ctids(all_ctids, obj, correlated, sampling_ratio=None, all_correlation_values=None):
        sample_ctids = []
        sample_group_ids = []
        sample_correl_ids = []
        if correlated:
            num_unseen_correlation_added = 0
            if obj["type"]["group"]:
                for cor_idx, ctids_for_each_correlation_val in enumerate(all_ctids):  # For each correlation value
                    cor_val = ctids_for_each_correlation_val[0]
                    if cor_val not in all_correlation_values:
                        if num_unseen_correlation_added > 3:
                            continue
                        num_unseen_correlation_added += 1
                    else:
                        pass
                    sample_correl_ids.append(cor_idx)

                    groups_ctids = ctids_for_each_correlation_val[1]
                    if sampling_ratio:
                        rand_group_size = int(len(groups_ctids) * sampling_ratio)
                    else:
                        rand_group_size = 2
                    sample_groups_id = rng.choice(
                        range(len(groups_ctids)), size=min(rand_group_size, len(groups_ctids)), replace=False
                    )
                    for group_id in sample_groups_id:
                        ctid_array = list(eval(groups_ctids[group_id][0][-1]))
                        if sampling_ratio:
                            rand_per_group_size = int(len(ctid_array) * sampling_ratio)
                        else:
                            rand_per_group_size = rng.randint(2, 4)
                        sample_ctids.extend(
                            rng.choice(ctid_array, size=min(rand_per_group_size, len(ctid_array)), replace=False)
                        )
                    sample_group_ids.append(sample_groups_id)
            elif obj["type"]["order"]:
                for cor_idx, ctids_for_each_correlation_val in enumerate(all_ctids):
                    cor_val = ctids_for_each_correlation_val[0]
                    if cor_val not in all_correlation_values:
                        if num_unseen_correlation_added > 3:
                            continue
                        num_unseen_correlation_added += 1
                    else:
                        pass
                    sample_correl_ids.append(cor_idx)

                    ctid_array = [cval[0][-1] for cval in ctids_for_each_correlation_val[-1]]
                    if sampling_ratio:
                        rand_size = int(len(ctid_array) * sampling_ratio)
                    else:
                        rand_size = rng.randint(2, 4)
                    sample_ctids.extend(rng.choice(ctid_array, size=min(rand_size, len(ctid_array)), replace=False))
            else:
                for cor_idx, ctids_for_each_correlation_val in enumerate(all_ctids):
                    cor_val = ctids_for_each_correlation_val[0]
                    if cor_val not in all_correlation_values:
                        if num_unseen_correlation_added > 3:
                            continue
                        num_unseen_correlation_added += 1
                    else:
                        pass
                    sample_correl_ids.append(cor_idx)

                    ctid_array = ctids_for_each_correlation_val[-1]
                    if sampling_ratio:
                        rand_size = int(len(ctid_array) * sampling_ratio)
                    else:
                        rand_size = rng.randint(2, 4)
                    sample_ctids.extend(rng.choice(ctid_array, size=min(rand_size, len(ctid_array)), replace=False))
        else:
            if obj["type"]["group"]:
                if sampling_ratio:
                    rand_group_size = int(len(all_ctids) * sampling_ratio)
                else:
                    rand_group_size = 2
                sample_groups_id = rng.choice(
                    range(len(all_ctids)), size=min(rand_group_size, len(all_ctids)), replace=False
                )
                for group_id in sample_groups_id:
                    ctid_array = all_ctids[group_id][-1]
                    if sampling_ratio:
                        rand_per_group_size = int(len(ctid_array) * sampling_ratio)
                    else:
                        rand_per_group_size = rng.randint(2, 4)
                    sample_ctids.extend(
                        rng.choice(ctid_array, size=min(rand_per_group_size, len(ctid_array)), replace=False)
                    )
                sample_group_ids = sample_groups_id
            else:
                ctid_array = [datum[0] for datum in all_ctids]
                if sampling_ratio:
                    rand_size = int(len(ctid_array) * sampling_ratio)
                else:
                    rand_size = rng.randint(3, 7)
                sample_ctids = list(rng.choice(ctid_array, size=min(rand_size, len(ctid_array)), replace=False))

        return sample_ctids, sample_group_ids, sample_correl_ids

    ## >> Sample rows
    sample_positive_ctids = []
    sample_positive_ctids_per_dnf_idx = []
    sample_positive_group_ids = []
    sample_positive_correal_ids = []
    for positive_ctids_raw in positive_ctids_raws:
        sampling_ratio = None
        if obj["is_having_child"]:
            sampling_ratio = 1
        sample_positive_ctid, sample_positive_group_id, sample_positive_correal_id = get_sample_ctids(
            positive_ctids_raw,
            obj,
            correlated,
            sampling_ratio=sampling_ratio,
            all_correlation_values=all_correlation_values,
        )
        sample_positive_ctids += [ctid for ctid in sample_positive_ctid if ctid not in sample_positive_ctids]
        sample_positive_ctids_per_dnf_idx.append(sample_positive_ctid)
        sample_positive_group_ids.append(sample_positive_group_id)
        sample_positive_correal_ids.append(sample_positive_correal_id)
    assert len(sample_positive_ctids) > 0

    sample_negative_ctids_2 = []  ### FOR HAVING
    sample_negative_group_ids_2 = []
    sample_negative_correal_ids_2 = []
    for negative_ctids_2_raw in negative_ctids_2_raws:
        sample_negative_ctid_2, sample_negative_group_id_2, sample_negative_correl_id_2 = get_sample_ctids(
            negative_ctids_2_raw, obj, correlated, all_correlation_values=all_correlation_values
        )
        sample_negative_ctids_2 += sample_negative_ctid_2
        sample_negative_group_ids_2.append(sample_negative_group_id_2)
        sample_negative_correal_ids_2.append(sample_negative_correl_id_2)

    all_sample_ctids = []
    all_sample_ctids.extend(sample_positive_ctids)
    all_sample_ctids.extend(sample_negative_ctids_2)
    all_sample_ctids = tuple(all_sample_ctids)
    sample_positive_ctids = tuple(sample_positive_ctids)
    ## << Sample rows
    ### <<<< For having: positive data for child query block

    if obj["type"]["group"]:
        if not correlated:
            positive_sample_groupids = []
            all_sample_groupids = []
            for dnf_idx in range(len(positive_ctids_raws)):
                positive_sample_groupid = [
                    positive_ctids_raws[dnf_idx][group_id][:-1] for group_id in sample_positive_group_ids[dnf_idx]
                ]
                if len(negative_ctids_2_raws) != 0:
                    negative_ctids_2_sample_groupid = [
                        negative_ctids_2_raws[dnf_idx][group_id][:-1]
                        for group_id in sample_negative_group_ids_2[dnf_idx]
                    ]
                else:
                    negative_ctids_2_sample_groupid = []
                positive_sample_groupids += [
                    gid for gid in positive_sample_groupid if gid not in positive_sample_groupids
                ]
                all_sample_groupid = positive_sample_groupid + negative_ctids_2_sample_groupid
                all_sample_groupids += [gid for gid in all_sample_groupid if gid not in all_sample_groupids]
        else:
            positive_sample_groupids = []
            negative_sample_groupids_2 = []
            for dnf_idx, positive_ctids_raw in enumerate(positive_ctids_raws):
                for idx, corval_idx in enumerate(sample_positive_correal_ids[dnf_idx]):
                    ctids_for_each_correlation_val = positive_ctids_raw[corval_idx]
                    for group_id in sample_positive_group_ids[dnf_idx][idx]:
                        group_d = ctids_for_each_correlation_val[1]
                        val = tuple([ctids_for_each_correlation_val[0]]) + group_d[group_id][0][0 : len(obj["group"])]
                        if val not in positive_sample_groupids:
                            positive_sample_groupids.append(val)

            for dnf_idx, negative_ctids_2_raw in enumerate(negative_ctids_2_raws):
                for idx, corval_idx in enumerate(sample_negative_correal_ids_2[dnf_idx]):
                    ctids_for_each_correlation_val = negative_ctids_2_raw[corval_idx]
                    for group_id in sample_negative_group_ids_2[dnf_idx][idx]:
                        group_d = ctids_for_each_correlation_val[1]
                        val = tuple([ctids_for_each_correlation_val[0]]) + group_d[group_id][0][0 : len(obj["group"])]
                        if val not in negative_sample_groupids_2:
                            negative_sample_groupids_2.append(val)

            all_sample_groupids = positive_sample_groupids + negative_sample_groupids_2
    else:
        positive_sample_groupids = []
        if correlated:
            for dnf_idx, positive_ctids_raw in enumerate(positive_ctids_raws):
                for idx, corval_idx in enumerate(sample_positive_correal_ids[dnf_idx]):
                    positive_sample_groupids.append(tuple([positive_ctids_raw[corval_idx][0]]))

    if obj["type"]["having"] or obj["type"]["aggregated_order"]:
        # Update current node and then just call the child node
        assert len(obj["childs"]) == 1
        child = obj["childs"][0]
        child_prefix = get_prefix(child[0], child[1])
        child_block_name = child_prefix[:-1]
        child_obj = query_objs[child_block_name]

        # INPUT data
        group_cols = obj["group"]
        group_col_types = [dtype_dict[group_col.replace(prefix, "")] for group_col in group_cols]

        select_cols = child_obj["select"]

        select_col_types = []
        for agg_col in child_obj["agg_cols"]:
            agg = agg_col[0]
            col = agg_col[1]
            if col != "*":
                if agg == "COUNT":
                    select_col_types.append("int")
                else:
                    select_col_types.append(dtype_dict[col])
            else:
                select_col_types.append("int")

        if correlation_column is not None:
            ### select_col_types = dtype_dict[correlation_column] + select_col_types
            correlation_column_ref = correlation_column.replace(".", "__")

            grouping_sql_select_clause = f"""unnest(array_agg({correlation_column_ref})) AS Cc, """
            grouping_sql_select_clause += ", ".join(
                [
                    col.replace(".", "__").replace(child_prefix, f"{view_name}.") + f" AS C{idx}"
                    for idx, col in enumerate(select_cols)
                ]
            )

            group_cols = [correlation_column] + group_cols
            group_col_types = [dtype_dict[correlation_column]] + group_col_types

            second_grouping_sql_select_clause = (
                "T.Cc"
                + ", array_agg(DISTINCT ARRAY[("
                + ", ".join([f"""T.C{idx}""" for idx, _ in enumerate(select_cols)])
                + ")])"
            )

        else:
            grouping_sql_select_clause = ", ".join(
                [col.replace(".", "__").replace(child_prefix, f"{view_name}.") for col in select_cols]
            )

        group_conditions = []
        for group_vals in all_sample_groupids:
            single_group_conditions = []
            for group_col, group_col_type, group_val in zip(group_cols, group_col_types, group_vals):
                if group_col_type == "str":
                    group_val_ref = f"""'{group_val}'"""
                elif group_col_type == "date":
                    group_val_ref = f"""'{group_val}'::date"""
                else:
                    group_val_ref = f"""{group_val}"""

                group_col_view = group_col.replace(".", "__").replace(prefix, f"{view_name}.")
                single_group_conditions.append(f"""{group_col_view} = {group_val_ref}""")
            group_conditions.append(" AND ".join(single_group_conditions))
        grouping_sql_where_clause = " OR ".join(group_conditions)

        if obj["use_agg_sel"] or obj["type"]["group"]:
            additional_group_col = correlation_column
        else:
            additional_group_col = None

        _, grouping_sql_additional_conditions = get_view_query(
            data_manager,
            view_name,
            obj,
            prefix,
            ignored=["having", "order", "limit"],
            use_agg_sel=obj["use_agg_sel"],
            additional_group_col=additional_group_col,
        )
        if correlation_column is None:
            grouping_sql = f"""SELECT DISTINCT {grouping_sql_select_clause} FROM {view_name} WHERE {grouping_sql_where_clause} {grouping_sql_additional_conditions}"""
            data_manager.execute(grouping_sql)
            rows = [list(datum) for datum in data_manager.fetchall()]
        else:
            grouping_inner_sql = f"""SELECT {grouping_sql_select_clause} FROM {view_name} WHERE {grouping_sql_where_clause} {grouping_sql_additional_conditions}"""

            grouping_sql = f"""SELECT DISTINCT {second_grouping_sql_select_clause} FROM ( {grouping_inner_sql} ) AS T GROUP BY T.Cc"""
            data_manager.execute(grouping_sql)
            rows_lawdata = data_manager.fetchall()
            for row in rows_lawdata:
                correlation_value = row[0]
                unpacked_values = [[] for _ in select_cols]
                for entity in row[1]:
                    if len(select_cols) > 1:
                        vals = entity[0]
                    else:
                        vals = tuple([entity[0]])  # vals = (a, b, c, d, e)
                    for i in range(len(select_cols)):
                        val_ref = vals[i]
                        if select_col_types[i] == "str":
                            val_ref = val_ref
                        elif select_col_types[i] == "date":
                            val_ref = val_ref
                        elif select_col_types[i] == "bool":
                            val_ref = bool(val_ref)
                        elif select_col_types[i] == "int":
                            val_ref = int(val_ref)
                        else:
                            val_ref = float(val_ref)
                        unpacked_values[i].append(val_ref)
                row_stored = [correlation_value] + unpacked_values
                rows.append(list(row_stored))

        # OUTPUT data
        select_cols = obj["select"]
        select_col_types = []
        for agg_col in obj["agg_cols"]:
            agg = agg_col[0]
            col = agg_col[1]
            if col != "*":
                if agg == "COUNT":
                    select_col_types.append("int")
                else:
                    select_col_types.append(dtype_dict[col])
            else:
                select_col_types.append("int")

        if correlation_column is not None:
            correlation_column_ref = correlation_column.replace(".", "__")
            # if obj["type"]["group"]:
            #    having_sql_select_clause = f"""unnest(array_agg({correlation_column_ref})) AS Cc, """
            # else:
            #    having_sql_select_clause = f"""{correlation_column_ref} AS Cc, """
            having_sql_select_clause = f"""{correlation_column_ref} AS Cc, """
            having_sql_select_clause += ", ".join(
                [
                    col.replace(".", "__").replace(prefix, f"{view_name}.") + f" AS C{idx}"
                    for idx, col in enumerate(select_cols)
                ]
            )

            if obj["type"]["order"]:
                order_cols = obj["order"]
                order_col_alias = []
                for idx, select_col in enumerate(select_cols):
                    if select_col in order_cols:
                        order_col_alias.append(f"T.C{idx}")
                order_having_sql_select_clause = ", ".join(order_col_alias)

                Cidx_print = (
                    "array_agg(ARRAY[("
                    + ", ".join([f"""T.C{idx}""" for idx, _ in enumerate(select_cols)])
                    + f")] ORDER BY {order_having_sql_select_clause})"
                )

                if obj["type"]["limit"]:
                    Cidx_print = f"""({Cidx_print})[1:{obj["limit"]}]"""
            else:
                Cidx_print = (
                    "array_agg(ARRAY[(" + ", ".join([f"""T.C{idx}""" for idx, _ in enumerate(select_cols)]) + ")])"
                )
            second_having_sql_select_clause = f"""T.Cc, {Cidx_print}"""
        else:
            having_sql_select_clause = ", ".join(
                [col.replace(".", "__").replace(prefix, f"{view_name}.") for col in select_cols]
            )
        group_conditions = []
        for group_vals in positive_sample_groupids:
            single_group_conditions = []
            for group_col, group_col_type, group_val in zip(group_cols, group_col_types, group_vals):
                if group_col_type == "str":
                    group_val_ref = f"""'{group_val}'"""
                elif group_col_type == "date":
                    group_val_ref = f"""'{group_val}'::date"""
                else:
                    group_val_ref = f"""{group_val}"""

                group_col_view = group_col.replace(".", "__").replace(prefix, f"{view_name}.")
                single_group_conditions.append(f"""{group_col_view} = {group_val_ref}""")
            group_conditions.append(" AND ".join(single_group_conditions))
        having_sql_where_clause = " OR ".join(group_conditions)

        if obj["use_agg_sel"] or obj["type"]["group"]:
            additional_group_col = correlation_column
        else:
            additional_group_col = None

        _, having_sql_additional_conditions = get_view_query(
            data_manager,
            view_name,
            obj,
            prefix,
            ignored=["having", "order", "limit"],
            use_agg_sel=obj["use_agg_sel"],
            additional_group_col=additional_group_col,
        )
        if correlation_column is None:
            having_sql = f"""SELECT DISTINCT {having_sql_select_clause} FROM {view_name} WHERE {having_sql_where_clause} {having_sql_additional_conditions}"""
            data_manager.execute(having_sql)
            result_tables = data_manager.fetchall()
        else:
            having_inner_sql = f"""SELECT {having_sql_select_clause} FROM {view_name} WHERE {having_sql_where_clause} {having_sql_additional_conditions}"""

            having_sql = (
                f"""SELECT DISTINCT {second_having_sql_select_clause} FROM ( {having_inner_sql} ) AS T GROUP BY T.Cc"""
            )
            data_manager.execute(having_sql)
            rows_lawdata = data_manager.fetchall()
            result_tables = []
            for row in rows_lawdata:
                correlation_value = row[0]
                unpacked_values = [[] for _ in select_cols]
                for entity in row[1]:
                    if len(select_cols) > 1:
                        vals = entity[0][0]
                    else:
                        vals = tuple([entity[0]])  # vals = (a, b, c, d, e)
                    for i in range(len(select_cols)):
                        val_ref = vals[i]
                        if select_col_types[i] == "str":
                            val_ref = val_ref
                        elif select_col_types[i] == "date":
                            val_ref = val_ref
                        elif select_col_types[i] == "bool":
                            val_ref = bool(val_ref)
                        elif select_col_types[i] == "int":
                            val_ref = int(val_ref)
                        else:
                            val_ref = float(val_ref)
                        unpacked_values[i].append(val_ref)
                row_stored = [correlation_value] + unpacked_values
                result_tables.append(list(row_stored))

        query_tree_node.add_rows(rows)
        query_tree_node.add_result_rows(result_tables)

        ctid_values = []
        for ctid in all_sample_ctids:
            ctid_values.append(f"'{ctid}'::tid")
        having_tighter_sql_where_clause = f"""CTID IN ( {", ".join(ctid_values)} )"""

        # Aggregation & correlation
        query_tree_node.child_tables[0], child_result_tables = update_query_node_with_table_excerpt(
            rng,
            fo_view_name,
            query_tree_node.child_tables[0],
            data_manager,
            view_name,
            query_objs,
            child_block_name,
            dtype_dict,
            [("where", having_tighter_sql_where_clause), correlation_column, all_correlation_values],
        )
        result_tables_to_attach = result_tables
    else:
        # >>>> Base table projection ----> NEED TO BE MOVED TO SQL GENERATOR
        ##### ALL GLOBAL INDEX USED IN THE QUERY TREE SHOULD BE UPDATED AS WELL
        used_table_cols = get_used_table_cols(obj, prefix, correlation_column)
        updated_query_tree_node = copy.deepcopy(query_tree_node)
        for idx, edge_to_child in enumerate(updated_query_tree_node.child_tables):
            if type(edge_to_child) == QueryTree.BaseTable:
                table_name = edge_to_child.name
                used_cols = list(used_table_cols[table_name])
                dtypes = [dtype_dict[f"{table_name}.{col}"] for col in used_cols]
                new_child_table = QueryTree.BaseTable(header=used_cols, dtype=dtypes, data=[], name=table_name)
                updated_query_tree_node.child_tables[idx] = new_child_table
                ### Modifying operations by updated global idx
        ## query_tree_node.global_idx_to_column(g_idx)
        updated_query_tree_node.operations = get_operations_with_updated_global_idx(
            query_tree_node.operations, query_tree_node, updated_query_tree_node
        )
        updated_query_tree_node.join_conditions = get_operations_with_updated_global_idx(
            query_tree_node.join_conditions, query_tree_node, updated_query_tree_node
        )

        query_tree_node = updated_query_tree_node
        # <<<< Base table projection

        # INPUT data
        # all_sample_ctids
        # schema
        ### Assumption: QueryBlock always appears after BaseTable
        input_select_cols = []
        queryblock_seen = False
        for child_table in query_tree_node.child_tables:
            if type(child_table) == QueryTree.QueryBlock:
                queryblock_seen = True
            else:
                if queryblock_seen:
                    assert False
                table_name = child_table.name
                headers = child_table.get_headers()
                for header in headers:
                    input_select_cols.append(f"""{table_name}.{header}""")

        inner_correlation_columns = []
        for idx, edge_to_child in enumerate(query_tree_node.child_tables):
            if type(edge_to_child) == QueryTree.QueryBlock:
                child_prefix = edge_to_child.name + "_"
                inner_correlation_column = "NULL"
                for cor_pred in obj["correlation_predicates_origin"]:
                    if cor_pred[0] == child_prefix:
                        inner_correlation_column = cor_pred[1]
                        break
                inner_correlation_columns.append(inner_correlation_column)

        select_col_string = ", ".join(
            [col.replace(".", "__") for col in input_select_cols]
            + [col.replace(".", "__") for col in inner_correlation_columns]
        )

        ctid_values = []
        for ctid in all_sample_ctids:
            ctid_values.append(f"'{ctid}'::tid")
        ctid_condition_string = f"""CTID IN ( {", ".join(ctid_values)} )"""

        input_sql = f"""SELECT {select_col_string} FROM {view_name} WHERE {ctid_condition_string}"""
        data_manager.execute(input_sql)
        rows = [list(datum) for datum in data_manager.fetchall()]  # NOTE: CTID is for attach nested query's results!!!!

        negative_examples_view_name = f"""{view_name}__negative_examples"""
        has_negative_view = False
        if data_manager.is_existing_view(negative_examples_view_name) and obj["type"]["where"]:
            has_negative_view = True
            conditions_for_negative_view = ""
            negative_input_sql = (
                f"""SELECT DISTINCT {select_col_string} FROM {negative_examples_view_name} {conditions_for_negative_view} LIMIT 5"""
            )
            data_manager.execute(negative_input_sql)
            negative_rows = [list(datum) for datum in data_manager.fetchall()]
            negative_rows_idxs = range(len(rows), len(rows) + len(negative_rows))
            if len(negative_rows) > 0:
                rows += negative_rows

        # OUTPUT data
        select_cols = obj["select"]
        select_col_types = []
        for agg_col in obj["agg_cols"]:
            agg = agg_col[0]
            col = agg_col[1]
            if col != "*":
                if agg == "COUNT":
                    select_col_types.append("int")
                elif agg == "AVG":
                    select_col_types.append("float")
                else:
                    select_col_types.append(dtype_dict[col])
            else:
                if agg == "COUNT":
                    select_col_types.append("int")
                else:
                    assert len(obj["agg_cols"]) == 1
                    pass

        if len(select_col_types) == 0:
            assert len(obj["agg_cols"]) == 1 and obj["agg_cols"][0][1] == "*"
            select_cols = input_select_cols
            select_col_types = [dtype_dict[col] for col in select_cols]

        if correlation_column is not None:
            correlation_column_ref = correlation_column.replace(".", "__")
            if obj["type"]["group"]:
                output_sql_select_clause = f"""unnest(array_agg({correlation_column_ref})) AS Cc, """
            else:
                output_sql_select_clause = f"""{correlation_column_ref} AS Cc, """
            output_sql_select_clause += ", ".join(
                [
                    col.replace(".", "__").replace(prefix, f"{view_name}.") + f" AS C{idx}"
                    for idx, col in enumerate(select_cols)
                ]
            )

            if obj["type"]["order"]:
                order_cols = obj["order"]
                order_col_alias = []
                for idx, select_col in enumerate(select_cols):
                    if select_col in order_cols:
                        order_col_alias.append(f"T.C{idx}")
                order_output_sql_select_clause = ", ".join(order_col_alias)

                Cidx_print = (
                    "array_agg(ARRAY[("
                    + ", ".join([f"""T.C{idx}""" for idx, _ in enumerate(select_cols)])
                    + f")] ORDER BY {order_output_sql_select_clause})"
                )

                if obj["type"]["limit"]:
                    Cidx_print = f"""({Cidx_print})[1:{obj["limit"]}]"""
            else:
                Cidx_print = (
                    "array_agg(ARRAY[(" + ", ".join([f"""T.C{idx}""" for idx, _ in enumerate(select_cols)]) + ")])"
                )
            second_output_sql_select_clause = f"""T.Cc, {Cidx_print}"""
        else:
            output_sql_select_clause = ", ".join(
                [col.replace(".", "__").replace(prefix, f"{view_name}.") for col in select_cols]
            )

        ctid_values = []
        for ctid in sample_positive_ctids:
            ctid_values.append(f"'{ctid}'::tid")
        ctid_condition_string = f"""CTID IN ( {", ".join(ctid_values)} )"""

        group_condition_string = ""
        if obj["type"]["group"] or correlation_column is not None:
            if obj["type"]["group"]:
                group_cols = obj["group"]
                group_col_types = [dtype_dict[group_col.replace(prefix, "")] for group_col in group_cols]
            else:
                group_cols = []
                group_col_types = []

            if correlation_column is not None:
                group_cols = [correlation_column] + group_cols
                group_col_types = [dtype_dict[correlation_column]] + group_col_types

            group_conditions = []
            for group_vals in positive_sample_groupids:
                single_group_conditions = []
                for group_col, group_col_type, group_val in zip(group_cols, group_col_types, group_vals):
                    if group_col_type == "str":
                        group_val_ref = f"""'{group_val}'"""
                    elif group_col_type == "date":
                        group_val_ref = f"""'{group_val}'::date"""
                    else:
                        group_val_ref = f"""{group_val}"""

                    group_col_view = group_col.replace(".", "__").replace(prefix, f"{view_name}.")
                    single_group_conditions.append(f"""{group_col_view} = {group_val_ref}""")
                group_conditions.append(" AND ".join(single_group_conditions))
            group_condition_string = " WHERE " + " OR ".join(group_conditions)

        if obj["use_agg_sel"] or obj["type"]["group"]:
            additional_group_col = correlation_column
        else:
            additional_group_col = None
        
        if correlation_column is None:
            _, output_sql_additional_conditions = get_view_query(
                data_manager,
                view_name,
                obj,
                prefix,
                use_agg_sel=obj["use_agg_sel"],
                additional_group_col=additional_group_col,
            )
            output_sql = f"""SELECT DISTINCT {output_sql_select_clause} FROM {view_name} WHERE {ctid_condition_string} {output_sql_additional_conditions}"""
            data_manager.execute(output_sql)
            result_tables = data_manager.fetchall()
        else:
            _, output_sql_additional_conditions = get_view_query(
                data_manager,
                view_name,
                obj,
                prefix,
                ignored=["order", "limit"],
                use_agg_sel=obj["use_agg_sel"],
                additional_group_col=additional_group_col,
            )
            output_inner_sql = f"""SELECT {output_sql_select_clause} FROM {view_name} WHERE {ctid_condition_string} {output_sql_additional_conditions}"""

            output_sql = (
                f"""SELECT DISTINCT {second_output_sql_select_clause} FROM ( {output_inner_sql} ) AS T GROUP BY T.Cc"""
            )
            data_manager.execute(output_sql)
            rows_lawdata = data_manager.fetchall()
            result_tables = []
            for row in rows_lawdata:
                correlation_value = row[0]
                unpacked_values = [[] for _ in select_cols]
                for entity in row[1]:
                    if len(select_cols) > 1:
                        vals = entity[0]
                    else:
                        vals = tuple([entity[0]])  # vals = (a, b, c, d, e)
                    for i in range(len(select_cols)):
                        val_ref = vals[i]
                        if select_col_types[i] == "str":
                            val_ref = val_ref
                        elif select_col_types[i] == "date":
                            val_ref = val_ref
                        elif select_col_types[i] == "bool":
                            val_ref = bool(val_ref)
                        elif select_col_types[i] == "int":
                            val_ref = int(val_ref)
                        else:
                            val_ref = float(val_ref)
                        unpacked_values[i].append(vals[i])
                row_stored = [correlation_value] + unpacked_values
                result_tables.append(list(row_stored))
        if obj["use_agg_sel"]:
            if correlation_column is None:
                output_sql = f"""SELECT DISTINCT {output_sql_select_clause} FROM {view_name} {group_condition_string} {output_sql_additional_conditions}"""
                data_manager.execute(output_sql)
                result_tables_to_attach = data_manager.fetchall()
            else:
                output_inner_sql = f"""SELECT {output_sql_select_clause} FROM {view_name} {group_condition_string} {output_sql_additional_conditions}"""

                output_sql = f"""SELECT DISTINCT {second_output_sql_select_clause} FROM ( {output_inner_sql} ) AS T GROUP BY T.Cc"""
                data_manager.execute(output_sql)
                rows_lawdata = data_manager.fetchall()
                result_tables_to_attach = []
                for row in rows_lawdata:
                    correlation_value = row[0]
                    unpacked_values = [[] for _ in select_cols]
                    for entity in row[1]:
                        if len(select_cols) > 1:
                            vals = entity[0]
                        else:
                            vals = tuple([entity[0]])  # vals = (a, b, c, d, e)
                        for i in range(len(select_cols)):
                            val_ref = vals[i]
                            if select_col_types[i] == "str":
                                val_ref = val_ref
                            elif select_col_types[i] == "date":
                                val_ref = val_ref
                            elif select_col_types[i] == "bool":
                                val_ref = bool(val_ref)
                            elif select_col_types[i] == "int":
                                val_ref = int(val_ref)
                            else:
                                val_ref = float(val_ref)
                            unpacked_values[i].append(vals[i])
                    row_stored = [correlation_value] + unpacked_values
                    result_tables_to_attach.append(list(row_stored))
        else:
            result_tables_to_attach = result_tables

        if len(obj["childs"]) > 0:  # Nested
            global_col_idx = len(rows[0]) - len(obj["childs"])
            for child in obj["childs"]:
                child_args = []
                child_prefix = get_prefix(child[0], child[1])
                child_block_name = child_prefix[:-1]
                child_condition = None
                inner_predicate = None
                inner_predicate_2 = None
                inner_predicate_dnf_idx = None
                # sample_positive_ctids_per_dnf_idx
                inner_predicates_dnf_idx, _ = preorder_traverse_to_get_graph(obj["tree_predicates_origin"], 0)
                for operation_idx, dnf_idx in inner_predicates_dnf_idx:
                    predicate = obj["predicates_origin"][operation_idx]
                    if len(predicate) == 5:  # nested predicate
                        inner_obj = predicate[4]
                        inner_query_global_idx = (inner_obj["nesting_level"], inner_obj["unique_alias"])
                        inner_table_prefix = get_prefix(inner_query_global_idx[0], inner_query_global_idx[1])
                        if inner_table_prefix == child_prefix:
                            if inner_predicate is not None:  # range query
                                assert inner_predicate_2 is None and inner_predicate_dnf_idx == dnf_idx
                                inner_predicate_2 = predicate
                            else:
                                inner_predicate_dnf_idx = dnf_idx
                                inner_predicate = predicate

                assert inner_predicate is not None

                inner_correlation_column = None
                for cor_pred in obj["correlation_predicates_origin"]:
                    if cor_pred[0] == child_prefix:
                        inner_correlation_column = cor_pred[1]
                        break

                inner_op = inner_predicate[2]
                if inner_predicate[0] is not None:  # comparison operator
                    col = inner_predicate[1]
                    inner_op = inner_predicate[2]

                    if inner_op == "<=":
                        inner_op = ">="
                    elif inner_op == "<":
                        inner_op = ">"
                    elif inner_op == ">=":
                        inner_op = "<="
                    elif inner_op == ">":
                        inner_op = "<"

                    inner_obj = inner_predicate[4]

                    col_ref = col.replace(".", "__")
                    if inner_correlation_column is not None:
                        inner_correlation_column_ref = inner_correlation_column.replace(".", "__")
                        if inner_op in ("=", "IN"):
                            all_sample_ctids_ref = [f"'{ctid}'" for ctid in all_sample_ctids]
                            ctid_set_str = f"""( {", ".join(all_sample_ctids_ref)} )"""
                        else:
                            # assert len(sample_positive_ctids_per_dnf_idx[inner_predicate_dnf_idx]) > 0
                            ### [TODO] fix logic
                            if len(sample_positive_ctids_per_dnf_idx[inner_predicate_dnf_idx]) > 0:
                                sample_positive_ctids_ref = [
                                    f"'{ctid}'" for ctid in sample_positive_ctids_per_dnf_idx[inner_predicate_dnf_idx]
                                ]
                            else:
                                sample_positive_ctids_ref = [f"'{ctid}'" for ctid in sample_positive_ctids]
                            ctid_set_str = f"""( {", ".join(sample_positive_ctids_ref)} )"""
                        where_condition_1 = f"""CTID in {ctid_set_str} AND {col_ref} IS NOT NULL and {inner_correlation_column_ref} IS NOT NULL """
                        sql = f"SELECT {inner_correlation_column_ref}, array_agg({col_ref}) FROM {view_name} WHERE {where_condition_1} GROUP BY {inner_correlation_column_ref}"
                        agg_col = [("NONE", inner_correlation_column), (inner_obj["agg_cols"][0][0], col)]
                        op = ["=", inner_op]

                    else:
                        if inner_op in ("=", "IN"):
                            all_sample_ctids_ref = [f"'{ctid}'" for ctid in all_sample_ctids]
                            ctid_set_str = f"""( {", ".join(all_sample_ctids_ref)} )"""
                        else:
                            assert len(sample_positive_ctids_per_dnf_idx[inner_predicate_dnf_idx]) > 0
                            sample_positive_ctids_ref = [
                                f"'{ctid}'" for ctid in sample_positive_ctids_per_dnf_idx[inner_predicate_dnf_idx]
                            ]
                            ctid_set_str = f"""( {", ".join(sample_positive_ctids_ref)} )"""
                        where_condition_1 = f"""CTID in {ctid_set_str} AND {col_ref} IS NOT NULL"""
                        sql = f"SELECT {col_ref} FROM {view_name} WHERE {where_condition_1}"
                        agg_col = [(inner_obj["agg_cols"][0][0], col)]
                        op = [inner_op]

                    data_manager.execute(sql)
                    vals = data_manager.fetchall()

                    # (Outer column) (Inner column)
                    # SELECT col WHERE CTID in all_ctids; outer column values
                    assert len(inner_obj["agg_cols"]) == 1
                    child_condition = (agg_col, op, vals)

                elif inner_predicate[1] is not None:  # ( inner query ) > value:
                    inner_correlation_column_ref = inner_correlation_column.replace(".", "__")
                    if inner_op in ("=", "IN"):
                        all_sample_ctids_ref = [f"'{ctid}'" for ctid in all_sample_ctids]
                        ctid_set_str = f"""( {", ".join(all_sample_ctids_ref)} )"""
                    else:
                        assert len(sample_positive_ctids_per_dnf_idx[inner_predicate_dnf_idx]) > 0
                        sample_positive_ctids_ref = [
                            f"'{ctid}'" for ctid in sample_positive_ctids_per_dnf_idx[inner_predicate_dnf_idx]
                        ]
                        ctid_set_str = f"""( {", ".join(sample_positive_ctids_ref)} )"""
                    where_condition_1 = f"""CTID in {ctid_set_str} AND {inner_correlation_column_ref} IS NOT NULL"""
                    sql = f"SELECT DISTINCT {inner_correlation_column_ref} FROM {view_name} WHERE {where_condition_1}"
                    data_manager.execute(sql)
                    vals = data_manager.fetchall()

                    inner_obj = inner_predicate[4]
                    inner_op = inner_predicate[2]
                    inner_val = inner_predicate[3]
                    inner_agg_col = inner_obj["agg_cols"][0]
                    if inner_predicate_2 is not None:
                        inner_op_2 = inner_predicate_2[2]
                        inner_val_2 = inner_predicate_2[3]
                        agg_col = [
                            ("NONE", inner_correlation_column),
                            (inner_agg_col[0], inner_agg_col[1]),
                            (inner_agg_col[0], inner_agg_col[1]),
                        ]
                        op = ["=", inner_op, inner_op_2]
                        vals = [
                            (
                                val[0],
                                [inner_val],
                                [inner_val_2],
                            )
                            for val in vals
                        ]
                        child_condition = (agg_col, op, vals)
                    else:
                        vals = [
                            (
                                val[0],
                                [inner_val],
                            )
                            for val in vals
                        ]
                        agg_col = [("NONE", inner_correlation_column), (inner_agg_col[0], inner_agg_col[1])]
                        op = ["=", inner_op]
                        child_condition = (agg_col, op, vals)

                elif inner_correlation_column is not None:
                    inner_correlation_column_ref = inner_correlation_column.replace(".", "__")
                    all_sample_ctids_ref = [f"'{ctid}'" for ctid in all_sample_ctids]
                    ctid_set_str = f"""( {", ".join(all_sample_ctids_ref)} )"""
                    where_condition_1 = f"""CTID in {ctid_set_str}"""
                    sql = f"SELECT DISTINCT {inner_correlation_column_ref} FROM {view_name} WHERE {where_condition_1}"
                    data_manager.execute(sql)
                    vals = data_manager.fetchall()

                    agg_col = [("NONE", inner_correlation_column)]
                    op = ["="]
                    child_condition = (agg_col, op, vals)

                inner_all_correlation_values = None
                if inner_correlation_column is not None:
                    # [TODO] fix logic
                    if len(sample_positive_ctids_per_dnf_idx[inner_predicate_dnf_idx]) > 0:
                        sample_positive_ctids_ref = [
                            f"'{ctid}'" for ctid in sample_positive_ctids_per_dnf_idx[inner_predicate_dnf_idx]
                        ]
                        ctid_set_str = f"""( {", ".join(sample_positive_ctids_ref)} )"""
                    else:
                        # sample_positive_ctids_ref = [f"'{ctid}'" for ctid in sample_positive_ctids]
                        all_sample_ctids_ref = [f"'{ctid}'" for ctid in all_sample_ctids]
                        ctid_set_str = f"""( {", ".join(all_sample_ctids_ref)} )"""
                    where_condition_1 = f"""CTID in {ctid_set_str}"""
                    sql_get_all_correlation_values = (
                        f"SELECT DISTINCT {inner_correlation_column_ref} FROM {view_name} WHERE {where_condition_1}"
                    )
                    data_manager.execute(sql_get_all_correlation_values)
                    inner_all_correlation_values = tuple([datum[0] for datum in data_manager.fetchall()])

                assert child_condition is not None
                child_view_name = query_objs[child_block_name]["inner_join_view_name"]
                child_result_table = None
                for idx, edge_to_child in enumerate(query_tree_node.child_tables):
                    if type(edge_to_child) == QueryTree.QueryBlock and edge_to_child.name == child_block_name:
                        query_tree_node.child_tables[idx], child_result_table = update_query_node_with_table_excerpt(
                            rng,
                            fo_view_name,
                            query_tree_node.child_tables[idx],
                            data_manager,
                            child_view_name,
                            query_objs,
                            child_block_name,
                            dtype_dict,
                            [("nested", child_condition), inner_correlation_column, inner_all_correlation_values],
                        )
                        break

                if inner_correlation_column is not None:
                    # result_table[:][0] == inner_correlation_id
                    updated_rows = []
                    # len_transposed_joined_child_row = -1
                    len_joined_child_row = -1
                    for row_idx, row in enumerate(rows):
                        join_key = row[global_col_idx]
                        assert join_key != "NULL"
                        joined_child_row = None
                        for child_row in child_result_table:
                            assert len_joined_child_row == -1 or len_joined_child_row == len(child_row)
                            len_joined_child_row = len(child_row)
                            if child_row[0] == join_key:
                                joined_child_row = child_row
                                break
                        if joined_child_row is None:
                            # assert join_key not in inner_all_correlation_values or inner_op in ("NOT IN")
                            # Left outer join
                            # assert row_idx in negative_rows_idxs
                            ### THIS SHOULD BE negative example assert joined_child_row is not None
                            joined_child_row = [join_key] + [[None] for _ in range(len_joined_child_row - 1)]
                        # transposed_joined_child_row = transpose(joined_child_row)
                        # assert len_transposed_joined_child_row == -1 or len_transposed_joined_child_row == len(
                        #     transposed_joined_child_row
                        # )
                        # len_transposed_joined_child_row = len(transposed_joined_child_row)
                        # row[row_idx] = row[:global_col_idx] + transposed_joined_child_row + row[global_col_idx + 1 :]
                        new_row = row[:global_col_idx] + joined_child_row
                        if global_col_idx + 1 < len(row):
                            new_row += row[global_col_idx + 1 :]
                        rows[row_idx] = new_row
                        len_joined_child_row = len(joined_child_row)
                    global_col_idx += len_joined_child_row
                else:
                    transposed_child_result_table = transpose(child_result_table)

                    for row_idx, row in enumerate(rows):
                        assert row[global_col_idx] is None
                        new_row = row[:global_col_idx] + transposed_child_result_table
                        if global_col_idx + 1 < len(row):
                            new_row += row[global_col_idx + 1 :]
                        rows[row_idx] = new_row
                    global_col_idx += len(transposed_child_result_table)

        query_tree_node.add_rows(rows)
        query_tree_node.add_result_rows(result_tables)

    return query_tree_node, result_tables_to_attach


def update_query_tree_with_table_excerpt(
    dbname, use_cols, data_manager, dtype_dict, query_graphs, query_objs, query_tree, query_id
):
    fo_view_name = get_view_name("main", [dbname, use_cols])
    inner_join_view_name = get_view_name("te_generator", [fo_view_name, query_id + "_", "inner_view"])
    query_tree_node = query_tree.root
    rng = np.random.RandomState(0)

    new_query_tree_node, _ = update_query_node_with_table_excerpt(
        rng, fo_view_name, query_tree_node, data_manager, inner_join_view_name, query_objs, query_id, dtype_dict, []
    )
    new_tree = QueryTree.QueryTree(root=new_query_tree_node, sql=query_tree.sql)
    return new_tree


if __name__ == "__main__":
    pass
