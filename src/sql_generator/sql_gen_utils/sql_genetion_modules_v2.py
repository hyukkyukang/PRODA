from src.sql_generator.sql_gen_utils.sql_genetion_utils import *


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
