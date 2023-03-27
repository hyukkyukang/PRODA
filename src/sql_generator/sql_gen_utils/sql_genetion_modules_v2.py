from src.sql_generator.sql_gen_utils.sql_genetion_utils_v2 import *


def non_nested_query_generator(
    args, df, n, rng, all_table_set, join_key_list, join_clause_list, join_key_pred, dtype_dict, dvs
):
    sql_type_dict = non_nested_query_form_selector(args, rng)

    df_columns_not_null = df.columns[df.notna().iloc[n]]
    tables, joins, table_columns_projection, table_columns = get_query_token(
        all_table_set,
        join_key_list,
        df.columns,
        df_columns_not_null,
        join_clause_list,
        rng,
        join_key_pred=join_key_pred,
    )

    select_columns, agg_cols, (used_tables, use_agg_sel) = select_generator(
        args, rng, table_columns_projection, dtype_dict, join_key_list, tables, group=sql_type_dict["group"]
    )
    if sql_type_dict["where"]:
        where_predicates, _, used_tables, _, tree_predicates_origin, predicates_origin = where_generator(
            args,
            rng,
            table_columns,
            dtype_dict,
            join_key_list,
            all_table_set,
            join_clause_list,
            join_key_pred,
            df,
            dvs,
            n,
            used_tables,
        )
    else:
        where_predicates = []

    group_columns_origin, group_columns = group_generator(
        args, rng, table_columns, dtype_dict, group=sql_type_dict["group"]
    )
    having_predicates, _, used_tables = having_generator(
        args, rng, table_columns, group_columns_origin, dtype_dict, df, dvs, n, used_tables
    )
    order_columns_origin, order_columns = order_generator(
        args, rng, table_columns, dtype_dict, group=sql_type_dict["group"], group_columns=group_columns_origin
    )
    limit_num = limit_generator(args, rng)

    used_tables = get_updated_used_tables(used_tables, group_columns_origin)
    used_tables = get_updated_used_tables(used_tables, order_columns_origin)

    necessary_tables, necessary_joins = find_join_path(joins, tables, used_tables)

    if sql_type_dict["group"]:
        select_columns = list(group_columns) + select_columns
        agg_cols = [("NONE", group_col) for group_col in group_columns] + agg_cols

    line, graph = sql_formation(
        args,
        sql_type_dict,
        necessary_tables,
        necessary_joins,
        "non-nested",
        select_columns,
        where_predicates,
        group_columns,
        having_predicates,
        order_columns,
        limit_num,
        make_graph=True,
        select_agg_cols=agg_cols,
        tree_predicates_origin=tree_predicates_origin,
        predicates_origin=predicates_origin,
    )
    obj = {
        "type": sql_type_dict,
        "select": select_columns,
        "where": where_predicates,
        "group": group_columns,
        "having": having_predicates,
        "order": order_columns,
        "limit": limit_num,
        "tables": necessary_tables,
        "joins": necessary_joins,
        "agg_cols": agg_cols,
        "use_agg_sel": use_agg_sel,
        "tree_predicates_origin": tree_predicates_origin,
        "predicates_origin": predicates_origin,
    }

    return line, graph, obj


def nested_query_generator(
    args,
    df,
    n,
    rng,
    all_table_set,
    join_key_list,
    join_clause_list,
    join_key_pred,
    dtype_dict,
    dvs,
    nesting_type,
    inner_query_objs=None,
    inner_query_graphs=None,
):
    df_columns_not_null = df.columns[df.notna().iloc[n]]
    tables, joins, table_columns_projection, table_columns = get_query_token(
        all_table_set,
        join_key_list,
        df.columns,
        df_columns_not_null,
        join_clause_list,
        rng,
        join_key_pred=join_key_pred,
    )

    # Random select the number of inner queries
    min_nested_pred_num = args.num_nestd_pred_min
    max_nested_pred_num = args.num_nested_pred_max

    candidate_idxs = get_possbie_inner_query_idxs(
        args, inner_query_objs
    )  # [TODO] If it projects multiple columns, modify the SELECT clause
    num_nested_predicate = rng.randint(min_nested_pred_num, min(len(candidate_idxs), max_nested_pred_num) + 1)
    chosen_inner_queries = rng.choice(candidate_idxs, num_nested_predicate, replace=False)

    nested_predicates = []
    nested_predicate_graphs = []

    for i in range(num_nesetd_predicates):
        inner_query_idx = chosen_inner_queries[i]
        nesting_type = nesting_type_selector(
            args,
            rng,
            only_nested=only_nested,
            only_nonnested=only_nonnested,
            inner_query_obj=inner_query_objs[inner_query_idx],
        )
        nesting_position = nesting_position_selector(
            args, rng, nesting_type, inner_query_obj=inner_query_objs[inner_query_idx]
        )
        nested_predicate, nesting_column, used_tables, _, nested_predicate_graph = nested_predicate_generator(
            args,
            rng,
            table_columns,
            dtype_dict,
            join_key_list,
            all_table_set,
            join_clause_list,
            join_key_pred,
            df,
            dvs,
            n,
            used_tables,
            outer_inner="outer",
            nesting_position=nesting_position,
            nesting_type=nesting_type,
            inner_query_obj=inner_query_objs[inner_query_idx],
            inner_query_graph=inner_query_graphs[inner_query_idx],
        )
        if i != 0:
            nested_predicates.append("AND")
        nested_predicates.append(nested_predicate)
        nested_predicate_graphs.append(nested_predicate_graph)

    sql_type_dict = non_nested_query_form_selector(args, rng)

    # Step 1. Outer query generation
    select_columns, agg_cols, (used_tables, use_agg_sel) = select_generator(
        args,
        rng,
        table_columns_projection,
        dtype_dict,
        join_key_list,
        tables,
        group=sql_type_dict["group"],
        outer_inner="outer",
    )
    if sql_type_dict["where"]:
        where_predicates, _, used_tables, _, tree_predicates_origin, predicates_origin = where_generator(
            args,
            rng,
            table_columns,
            dtype_dict,
            join_key_list,
            join_clause_list,
            join_key_pred,
            df,
            dvs,
            n,
            used_tables,
        )
    else:
        where_predicates = []
        result_tuples = df

    # Always generate where clause for nested query
    sql_type_dict["where"] = True
    if len(where_predicates) > 0:
        where_predicates += ["AND"]
    where_predicates += nested_predicates

    group_columns_origin, group_columns = group_generator(
        args, rng, table_columns, dtype_dict, group=sql_type_dict["group"]
    )
    if sql_type_dict["having"]:
        having_predicates, _, used_tables = hainvg_generator(
            args, rng, table_columns, group_columns_origin, dtype_dict, df, dvs, n, used_tables
        )
    else:
        having_predicates = []
    order_columns_origin, order_columns = order_generator(
        args, rng, table_columns, dtype_dict, group=sql_type_dict["group"], group_columns=group_columns_origin
    )
    limit_num = limit_generator(args, rng)

    used_tables = get_updated_used_tables(used_tables, group_columns_origin)
    used_tables = get_updated_used_tables(used_tables, order_columns_origin)

    # (FIX C4) Remove unncessary tables & joins
    necessary_tables, necessary_joins = find_join_path(joins, tables, used_tables)

    line, _ = sql_formation(
        args,
        sql_type_dict,
        necessary_tables,
        necessary_joins,
        "outer",
        select_columns,
        where_predicates,
        group_columns,
        having_predicates,
        order_columns,
        limit_num,
        select_agg_cols=agg_cols,
    )
    graph = []
    obj = {
        "type": sql_type_dict,
        "select": select_columns,
        "where": where_predicates,
        "group": group_columns,
        "having": having_predicates,
        "order": order_columns,
        "limit": limit_num,
        "tables": necessary_tables,
        "joins": necessary_joins,
        "agg_cols": agg_cols,
        "use_agg_sel": use_agg_sel,
        "tree_predicates_origin": tree_predicates_origin,
        "predicates_origin": predicates_origin,
    }

    return line, graph, obj


def query_generator(
    args,
    df,
    n,
    rng,
    all_table_set,
    join_key_list,
    join_clause_list,
    join_key_pred,
    dtype_dict,
    dvs,
    inner_query_objs=None,
    inner_query_graphs=None,
):
    nested = args.query_type in ["spj-nested", "nested"]

    if not nested:
        query, graph, obj = non_nested_query_generator(
            args, df, n, rng, all_table_set, join_key_list, join_clause_list, join_key_pred, dtype_dict, dvs
        )
    else:
        query, graph, obj = nested_query_generator(
            args,
            df,
            n,
            rng,
            all_table_set,
            join_key_list,
            join_clause_list,
            join_key_pred,
            dtype_dict,
            dvs,
            inner_query_objs,
            inner_query_graphs,
        )
        graph = []

    return query, graph, obj
