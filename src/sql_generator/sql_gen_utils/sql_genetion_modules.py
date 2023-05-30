# import sql_genetion_utils
from sql_gen_utils.sql_genetion_utils import *


def nesting_type_selector(args, rng, only_nested=False, only_nonnested=False, inner_query_obj=None):
    assert not (
        only_nested and only_nonnested
    ), "Only nested and only nonnested options cannot be activated at the same time."

    nesting_type_origin = ["non-nested", "type-n", "type-a", "type-j", "type-ja"]
    if args.set_nested_query_type:
        nesting_type_origin = ["non-nested"]
        if args.has_type_n:
            nesting_type_origin.append("type-n")
        if args.has_type_a:
            nesting_type_origin.append("type-a")
        if args.has_type_j:
            nesting_type_origin.append("type-j")
        if args.has_type_ja:
            nesting_type_origin.append("type-ja")

    if inner_query_obj:
        if inner_query_obj["use_agg_sel"]:
            if "*" in inner_query_obj["select"][0] or "COUNT" in inner_query_obj["select"][0]:
                nesting_type_origin = ["non-nested", "type-ja"]
            else:
                nesting_type_origin = ["non-nested", "type-a", "type-ja"]
        else:
            if inner_query_obj["select"][0] == "*":
                nesting_type_origin = ["non-nested", "type-j"]
            else:
                nesting_type_origin = ["non-nested", "type-n", "type-j"]

    if only_nested:
        nesting_type = nesting_type_origin[rng.randint(1, len(nesting_type_origin))]
    elif only_nonnested:
        nesting_type = "non-nested"
    else:
        nesting_type = nesting_type_origin[rng.randint(0, len(nesting_type_origin))]

    return nesting_type


def nesting_position_selector(args, rng, nesting_type, inner_query_obj=None):
    # Nesting Types:
    # - WHERE <column> <operator> <Inner query>
    # - WHERE <column> <IN/NOT IN> <Inner query>
    # - WHERE <EXISTS/NOT EXISTS> <Inner query>
    # - WHERE <Inner query> <operator> <value>

    if nesting_type == "type-n":
        return rng.randint(0, 2)

    elif nesting_type == "type-a":
        return 0

    elif nesting_type == "type-j":
        if inner_query_obj:
            if inner_query_obj["select"][0] == "*":
                return 2
        return rng.randint(0, 4)

    elif nesting_type == "type-ja":
        if inner_query_obj:
            if "*" in inner_query_obj["select"][0] or "COUNT" in inner_query_obj["select"][0]:
                return 3
        return rng.choice([0, 3])


def non_nested_query_form_selector(args, rng):
    only_spj = args.query_type in ["spj-non-nested", "spj-nested", "spj-mix"]
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
            if args.has_order or args.has_limit:
                sql_type["order"] = True
            if args.has_limit:
                sql_type["limit"] = True
        else:
            prob = 0.8
            sql_type = {
                "where": bool(rng.choice([0, 1], p=[prob, 1 - prob])),
                "group": bool(rng.randint(0, 2)),
                "having": bool(rng.randint(0, 2)),
                "order": bool(rng.randint(0, 2)),
                "limit": bool(rng.randint(0, 2)),
            }
    if not sql_type["group"]:
        sql_type["having"] = False
    if not sql_type["order"]:
        sql_type["limit"] = False

    if args.used_for_inner_query and (not sql_type["having"]) and (not sql_type["where"]):
        sql_type["where"] = bool(rng.randint(0, 2))
        if not sql_type["where"]:
            sql_type["group"] = True
            sql_type["having"] = True

    if DEBUG_ERROR:
        sql_type["having"] = True
        sql_type["where"] = True

    return sql_type


def agg_selector(rng, use_agg, dtype_dict, join_key_list, col, outer_nesting_position=-1, outer_operator=None):
    if use_agg:
        if dtype_dict[col] in ["bool", "str"]:
            agg = rng.choice(TEXTUAL_AGGS)
        elif dtype_dict[col] == "date":
            agg = rng.choice(DATE_AGGS)
        else:
            # (FIX #1, C6) Not use AVG/SUM/MIN/MAX for key columns
            if col in IDS or is_column_id(col, join_key_list):  # join_key_list:
                agg = rng.choice(KEY_AGGS)
            else:
                # (FIX #7) Not use COUNT/SUM for <col> <op> <val> shaped outer query
                if outer_nesting_position == 0:
                    possible_aggs = POSSIBLE_AGGREGATIONS_PER_OPERATOR[outer_operator]
                    agg = rng.choice(possible_aggs)
                else:
                    agg = rng.choice(NUMERIC_AGGS)
    else:
        agg = "NONE"

    return agg


def select_generator(
    args,
    rng,
    cols,
    dtype_dict,
    join_key_list,
    tables,
    used_tables,
    group_columns,
    group_columns_origin,
    group=False,
    having=False,
    outer_inner=None,
    nesting_type="non-nested",
    nesting_column=None,
    outer_nesting_position=-1,
    outer_operator=None,
    prefix=None,
):
    columns = []
    agg_cols = []

    # use_distinct = bool(rng.randint(0, 2))
    use_distinct = 0  # disabled distinct
    # (FIX #11) Use aggregation function for type-a, type-ja query and not use for type-n, type-j query
    if nesting_type in ["type-a", "type-ja"]:
        use_agg = True
    elif nesting_type in ["type-n", "type-j"]:
        use_agg = False
    else:
        tmp_prob = 0.2
        # use_agg = True if group else bool(rng.randint(0, 2))
        use_agg = True if group else bool(rng.choice([0, 1], p=[1 - tmp_prob, tmp_prob]))

    initial_sel_size = 0

    if group:
        if having:
            project_all = rng.choice([False, True])
        else:
            project_all = True

        if project_all:
            columns = list(group_columns)
            agg_cols = [("NONE", group_col) for group_col in group_columns_origin]
            initial_sel_size = len(columns)
        else:
            columns = list(group_columns)
            use_agg = False
            agg_cols = [("NONE", group_col) for group_col in group_columns_origin]
            initial_sel_size = len(columns)

    if outer_nesting_position != -1:
        num_select = 1
    else:
        min_select, max_select = args.num_select_min, args.num_select_max
        num_select = rng.randint(min_select, max_select + 1)

    candidate_cols = [col for col in cols if col not in group_columns_origin]

    if outer_inner == "outer":
        if prefix is None:
            prefix = "O_"
    elif outer_inner == "inner":
        if prefix is None:
            prefix = "I_"
    else:
        if prefix is None:
            prefix = ""

    if num_select == 0:
        if use_agg:
            # agg = rng.choice(NUMERIC_AGGS)
            agg = rng.choice(TEXTUAL_AGGS)
        else:
            agg = "NONE"

        col_rep = agg + "(*)" if agg != "NONE" else "*"
        columns.append(col_rep)
        agg_cols.append((agg, "*"))
    elif outer_nesting_position == 2:
        first_table = tables[0]
        agg = "NONE"
        col = PRIMARY_KEYS[first_table]
        col_rep = prefix + col

        columns.append(col_rep)
        agg_cols.append((agg, col))
        used_tables.add(col.split(".")[0])
    else:
        if nesting_column is not None:
            col = nesting_column
            agg = agg_selector(
                rng,
                use_agg,
                dtype_dict,
                join_key_list,
                col,
                outer_nesting_position=outer_nesting_position,
                outer_operator=outer_operator,
            )

            col_rep = agg + "(" + prefix + col + ")" if agg != "NONE" else prefix + col

            columns.append(col_rep)
            agg_cols.append((agg, col))
            used_tables.add(col.split(".")[0])

        while len(columns) < num_select + initial_sel_size:
            if not use_agg and len(columns) == len(candidate_cols):
                break
            col = rng.choice(candidate_cols)
            agg = agg_selector(rng, use_agg, dtype_dict, join_key_list, col)

            distinct = ""
            if agg == "COUNT" and col not in IDS:  # Use distinct if COUNT + non_key_column
                # distinct = "DISTINCT "
                pass  # disabled distinct

            col_rep = agg + "(" + distinct + prefix + col + ")" if agg != "NONE" else prefix + col

            if col_rep in columns:
                continue
            else:
                columns.append(col_rep)
                agg_cols.append((agg, col))
                used_tables.add(col.split(".")[0])

    return columns, agg_cols, (used_tables, use_agg)


def non_nested_predicate_generator(
    args, rng, result_guarantee_tuples, table_columns, dvs, vs, dtype_dict, join_key_list
):
    tuple_idx = rng.randint(0, len(result_guarantee_tuples))
    column_idx = rng.randint(0, len(table_columns))

    col = table_columns[column_idx]
    vals = result_guarantee_tuples[[col]].iloc[tuple_idx]
    val = vals[0]

    if col in IDS or is_column_id(col, join_key_list):  # Not generate any condition using id/hash code/note columns
        return False, None, None, None

    if dtype_dict[col] == "str":
        v = str(val).strip()
        if val == "nan" or pd.isnull(val) or len(dvs[col]) < 2:
            return False, None, None, None
        else:
            # (FIX C3) NO =, !=, IN, NOT IN operators for hash codes and notes
            if col in HASH_CODES + NOTES:
                op = rng.choice(HASHCODE_OPERATORS, p=HASHCODE_OPERATORS_PROBABILITY)
            else:
                op = rng.choice(TEXTUAL_OPERATORS, p=TEXTUAL_OPERATORS_PROBABILITY)

            v = get_str_op_values(op, v, dvs[col], vs[col], rng, num_in_max=args.num_in_max)

            if op == "IS_NOT_NULL":
                val = v
            else:
                if op in ["IN", "NOT IN"]:
                    v, num_val = v
                    if num_val <= 1:
                        op = "=" if op == "IN" else "!="
                        v = v[1:-1]
                        val = f'''\"{v}\"'''
                    else:
                        val = v
                else:
                    val = f'''\"{v}\"'''

    elif dtype_dict[col] == "date":
        if val == "nan" or pd.isnull(val) or len(dvs[col]) < 2:
            # op = 'IS_NULL'
            # vals[0] = 'None'
            return False, None, None, None
        else:
            op = rng.choice(NUMERIC_OPERATORS, p=NUMERIC_OPERATORS_PROBABILITY)
            if op == "!=":
                v = val
                # v = rng.choice(vs[col])
                # while (len(vs[col]) > 1) and (v == val):
                #    v = rng.choice(vs[col])
            elif op != "=":
                is_range = rng.choice([0, 1], p=[0.8, 0.2])
                if is_range:
                    tuple_idx2 = rng.randint(0, len(result_guarantee_tuples))
                    vals2 = result_guarantee_tuples[[col]].iloc[tuple_idx2]
                    v = vals2[0]

                    v_date = get_date_time(v)
                    val_date = get_date_time(val)
                    if v_date == val_date:
                        op = "="
                    else:
                        if op in [">", ">="]:
                            op2 = rng.choice(["<", "<="])
                            op = (op, op2)
                        else:
                            op2 = rng.choice([">", ">="])
                            op = (op2, op)
                        if v_date < val_date:
                            v = (v, val)
                        else:
                            v = (val, v)
                else:
                    v = val
            else:
                v = val

            val = v

    else:
        if np.isnan(val) or len(dvs[col]) < 2:
            # op = 'IS_NULL'
            # vals[0] = 'None'
            return False, None, None, None
        else:
            # (FIX #4) Not choose lte, lt, gte, gt for key column
            if col in join_key_list or dtype_dict[col] == "bool":
                op = rng.choice(KEY_OPERATORS, p=KEY_OPERATORS_PROBABILITY)
            else:
                op = rng.choice(NUMERIC_OPERATORS, p=NUMERIC_OPERATORS_PROBABILITY)

            if op == "!=":
                v = val
                # v = rng.choice(vs[col])
                # while (len(vs[col]) > 1) and (v == val):
                #    v = rng.choice(vs[col])
            elif op != "=":
                is_range = rng.choice([0, 1], p=[0.8, 0.2])
                if is_range:
                    tuple_idx2 = rng.randint(0, len(result_guarantee_tuples))
                    vals2 = result_guarantee_tuples[[col]].iloc[tuple_idx2]
                    v = vals2[0]
                    if v == val:
                        op = "="
                    else:
                        if op in [">", ">="]:
                            op2 = rng.choice(["<", "<="])
                            op = (op, op2)
                        else:
                            op2 = rng.choice([">", ">="])
                            op = (op2, op)

                        if v < val:
                            v = (v, val)
                        else:
                            v = (val, v)
                else:
                    v = val
            else:
                v = val

            if dtype_dict[col] == "int":
                if isinstance(v, tuple):
                    val = (int(v[0]), int(v[1]))
                else:
                    val = int(v)
            else:
                val = v
    return True, col, op, val


def having_generator(
    args,
    rng,
    table_columns,
    join_key_list,
    table_columns_all,
    group_columns,
    dtype_dict,
    df,
    n,
    used_tables,
    grouping_query_elements,
    outer_inner="non-nested",
    prefix=None,
):
    min_pred_num = args.num_having_min
    max_pred_num = args.num_having_max

    _, df_query_grouping = sql_formation(
        args,
        grouping_query_elements["sql_type_dict"],
        grouping_query_elements["necessary_tables"],
        grouping_query_elements["necessary_joins"],
        outer_inner,
        grouping_query_elements["select_columns"],
        grouping_query_elements["where_predicates"],
        grouping_query_elements["group_columns"],
        grouping_query_elements["having_predicates"],
        grouping_query_elements["order_columns"],
        grouping_query_elements["limit_num"],
        select_agg_cols=grouping_query_elements["agg_cols"],
        tree_predicates_origin=grouping_query_elements["tree_predicates_origin"],
        predicates_origin=grouping_query_elements["predicates_origin"],
        nesting_level=grouping_query_elements["nesting_level"],
        nesting_block_idx=grouping_query_elements["global_unique_query_idx"],
    )
    df_query_grouping_string = "SELECT " + df_query_grouping["SELECT"] + " FROM " + df_query_grouping["FROM"]
    if grouping_query_elements["sql_type_dict"]["where"]:
        df_query_grouping_string += " WHERE " + df_query_grouping["WHERE"]
    if grouping_query_elements["sql_type_dict"]["group"]:
        df_query_grouping_string += " GROUP BY " + df_query_grouping["GROUPBY"]
    result_guarantee_tuples = ps.sqldf(df_query_grouping_string, locals())
    assert (
        not result_guarantee_tuples.empty
    ), "[having generator] result guarantee tuples is empty after group by and where"

    dvs = {}
    vs = {}
    for df_col in result_guarantee_tuples.columns[len(group_columns) :]:
        dvs[df_col] = get_value_set(result_guarantee_tuples[df_col].value_counts(dropna=False).index.values)
        vs[df_col] = get_value_set(result_guarantee_tuples[df_col])

    # having_candidate_columns_origin = [
    #    table_column for table_column in table_columns if table_column not in list(group_columns)
    # ] + ["*"] # [WARING] NEED TO BE MODIFIED!!!!!!

    having_candidate_columns_origin = [
        table_column
        for table_column in table_columns_all
        if table_column not in list(group_columns)
        and dtype_dict[table_column] not in ["bool", "str"]
        and table_column not in IDS
        and not is_column_id(table_column, join_key_list)
    ] + ["*"]

    having_candidate_columns = []
    for col in having_candidate_columns_origin:
        agg_col_idx = -1
        for i, (group_query_agg, group_query_col) in enumerate(grouping_query_elements["agg_cols"]):
            if group_query_agg == "COUNT" and group_query_col == col:
                agg_col_idx = i
                break
        assert agg_col_idx != -1

        df_column = result_guarantee_tuples.columns[agg_col_idx]
        query_predicate = predicate_generator(df_column, ">", str(1))

        count = result_guarantee_tuples.query(query_predicate)
        if len(count) > 1:
            having_candidate_columns.append(col)
    if DEBUG_ERROR:
        having_candidate_columns = having_candidate_columns_origin
    else:
        pass

    result_guarantee_tuples_origin = result_guarantee_tuples.copy(deep=True)
    is_updated_result_guarantee_tuples = False

    assert len(having_candidate_columns) > 0, "[having generator] No candidate column for having"

    num_predicate = rng.randint(min_pred_num, min(len(having_candidate_columns), max_pred_num) + 1)

    tree_predicates = build_predicate_tree_dnf(rng, [[x] for x in range(num_predicate)])
    tree_predicates, _ = renumbering_tree_predicates(tree_predicates, 0)
    tree_predicates_origin = copy.deepcopy(tree_predicates)
    if len(tree_predicates) == 1:
        tree_predicates.append(False)
    else:
        split_predicate_tree_with_condition_dnf(tree_predicates)
    flatten_tree = flatten_condition_predicate_tree(tree_predicates)
    sorted_conditions = sorted(flatten_tree, key=lambda x: x[0])

    if outer_inner == "outer":
        if prefix is None:
            prefix = "O_"
    elif outer_inner == "inner":
        if prefix is None:
            prefix = "I_"
    else:
        if prefix is None:
            prefix = ""

    # [TODO]
    continue_cnt = 0
    cond_idx = 0
    predicates = [None] * num_predicate
    predicates_origin = [None] * num_predicate
    visited_columns = []
    visited_agg_col = {}

    while cond_idx < num_predicate:
        if continue_cnt > 100:
            raise Exception("[having generator] Too many continue during having predicate generation")

        result_condition = sorted_conditions[cond_idx][1]
        if not result_condition and is_updated_result_guarantee_tuples:
            result_guarantee_tuples_origin = pd.concat(
                [result_guarantee_tuples_origin, result_guarantee_tuples]
            ).drop_duplicates(keep=False)
            result_guarantee_tuples = result_guarantee_tuples_origin
            is_updated_result_guarantee_tuples = False
            visited_columns = []
            visited_agg_col = {}
        cur_candidate_columns = [col for col in having_candidate_columns if col not in visited_columns]
        column_idx = rng.randint(0, len(cur_candidate_columns))
        tuple_idx = rng.randint(0, len(result_guarantee_tuples))

        col = cur_candidate_columns[column_idx]

        if col == "*":
            assert col not in visited_agg_col.keys(), "[having generator] * cannot be visited more than once"
            original_agg_candidates = TEXTUAL_AGGS
        elif dtype_dict[col] in ["bool", "str"] or col in IDS or is_column_id(col, join_key_list):
            continue
        elif dtype_dict[col] == "date":
            original_agg_candidates = DATE_AGGS[1:]
        else:
            original_agg_candidates = NUMERIC_AGGS[1:]

        if col in visited_agg_col.keys():
            agg_candidates = [agg for agg in original_agg_candidates if agg not in visited_agg_col[col]]
        else:
            agg_candidates = original_agg_candidates

        agg = rng.choice(agg_candidates)

        agg_col_idx = -1
        for i, (group_query_agg, group_query_col) in enumerate(grouping_query_elements["agg_cols"]):
            if group_query_agg == agg and group_query_col == col:
                agg_col_idx = i
                break
        assert agg_col_idx != -1

        df_column = result_guarantee_tuples.columns[agg_col_idx]
        df_val = result_guarantee_tuples[[df_column]].iloc[tuple_idx]
        val = df_val[0]
        if val == "nan" or pd.isnull(val):
            # op = 'IS_NULL'
            # vals[0] = 'None'
            continue_cnt += 1
            continue

        new_dtype = None
        if agg in ["NONE", "MAX", "MIN", "AVG", "SUM"]:
            new_dtype = dtype_dict[col]
        else:
            new_dtype = "int"

        val_stored = val

        if new_dtype in ["bool", "str"]:
            assert False, "[Having generator] It can't be string type column"
            pass
        elif new_dtype == "date":
            op = rng.choice(NUMERIC_OPERATORS, p=NUMERIC_OPERATORS_PROBABILITY)
            if len(dvs[df_column]) < 2:
                continue
            if op == "!=":
                v = val
                # v = rng.choice(vs[df_column])
                # while (len(vs[df_column]) > 1) and (v == val):
                #     v = rng.choice(vs[df_column])
                # v = val
            elif op != "=":
                is_range = rng.choice([0, 1], p=[0.8, 0.2])
                if is_range:
                    tuple_idx2 = rng.randint(0, len(result_guarantee_tuples))
                    df_val2 = result_guarantee_tuples[[df_column]].iloc[tuple_idx2]
                    v = df_val2[0]

                    v_date = get_date_time(v)
                    val_date = get_date_time(val)
                    if v_date == val_date:
                        is_range = False
                    else:
                        if op in [">", ">="]:
                            op2 = rng.choice(["<", "<="])
                            op = (op, op2)
                        else:
                            op2 = rng.choice([">", ">="])
                            op = (op2, op)
                        if v_date < val_date:
                            v = (v, val)
                        else:
                            v = (val, v)
                else:
                    v = val
            else:
                v = val
            val_stored = v
        else:
            op = rng.choice(NUMERIC_OPERATORS, p=NUMERIC_OPERATORS_PROBABILITY)
            if agg == "COUNT":
                val_stored = int(val)
            else:
                if len(dvs[df_column]) < 2:
                    continue
                if op == "!=":
                    v = val
                    # v = rng.choice(vs[df_column])
                    # while (len(vs[df_column]) > 1) and (v == val):
                    #    v = rng.choice(vs[df_column])
                elif op != "=":
                    is_range = rng.choice([0, 1], p=[0.8, 0.2])
                    if is_range:
                        tuple_idx2 = rng.randint(0, len(result_guarantee_tuples))
                        df_val2 = result_guarantee_tuples[[df_column]].iloc[tuple_idx2]
                        v = df_val2[0]

                        if v == val:
                            is_range = False
                        else:
                            if op in [">", ">="]:
                                op2 = rng.choice(["<", "<="])
                                op = (op, op2)
                            else:
                                op2 = rng.choice([">", ">="])
                                op = (op2, op)

                            if v < val:
                                v = (v, val)
                            else:
                                v = (val, v)
                    else:
                        v = val
                else:
                    v = val

                if new_dtype == "int":
                    if isinstance(op, tuple):
                        val_stored = (int(v[0]), int(v[1]))
                    else:
                        val_stored = int(v)
                else:
                    val_stored = v

        if isinstance(op, tuple):
            query_predicate = predicate_generator(df_column, op, (str(val_stored[0]), str(val_stored[1])))
        else:
            query_predicate = predicate_generator(df_column, op, str(val_stored))

        # num_result = len(df.query(' AND '.join(result_guarantee_predicates)))
        new_result_guarantee_tuples = result_guarantee_tuples.query(query_predicate)
        num_result = len(new_result_guarantee_tuples)
        if num_result < 1 or num_result == len(result_guarantee_tuples):
            continue_cnt += 1
            continue  # WARNING!!!!!!! NEED TO BE UNSTATED
        result_guarantee_tuples = new_result_guarantee_tuples  # WARNING!!!!!!! NEED TO BE UNSTATED
        is_updated_result_guarantee_tuples = True

        assert agg != "NONE"

        if isinstance(op, tuple):
            additional_pred_idx = len(predicates)
            if col == "*":
                predicate_str2 = agg + "(" + col + ") " + op[1] + " " + str(val_stored[1])
            else:
                predicate_str2 = agg + "(" + prefix + col + ") " + op[1] + " " + str(val_stored[1])
            predicate_tuple_origin2 = (prefix, agg, col, op[1], str(val_stored[1]))

            tree_predicates = restore_predicate_tree_one(
                tree_predicates, cond_idx, [[cond_idx, result_condition], "AND", [additional_pred_idx, "TRUE"]]
            )
            tree_predicates_origin = restore_predicate_tree_one(
                tree_predicates_origin, cond_idx, [[cond_idx], "AND", [additional_pred_idx]]
            )
            predicates_origin.append(predicate_tuple_origin2)
            predicates.append(predicate_str2)
            op = op[0]
            val_stored = val_stored[0]

        if col == "*":
            predicates[cond_idx] = agg + "(" + col + ") " + op + " " + str(val_stored)
        else:
            predicates[cond_idx] = agg + "(" + prefix + col + ") " + op + " " + str(val_stored)
        predicate_tuple_origin = (prefix, agg, col, op, str(val_stored))
        predicates_origin[cond_idx] = predicate_tuple_origin

        if col in visited_agg_col.keys():
            visited_agg_col[col].append(agg)
        else:
            visited_agg_col[col] = [agg]
        if len(visited_agg_col[col]) == len(original_agg_candidates):
            visited_columns.append(col)

        if col != "*":
            used_tables.add(col.split(".")[0])
        cond_idx += 1

    tree_predicates = restore_predicate_tree(tree_predicates, predicates)

    return tree_predicates, predicates_origin, tree_predicates_origin, used_tables


def where_generator(
    args,
    rng,
    table_columns,
    table_columns_projection,
    dtype_dict,
    join_key_list,
    all_table_set,
    join_clause_list,
    join_key_pred,
    df,
    dvs,
    vs,
    n,
    used_tables,
    outer_inner=None,
    nesting_position=-1,
    nesting_type="non-nested",
    prefix=None,
    chosen_inner_queries=None,
    num_nested_predicates=0,
    inner_query_objs=None,
    inner_query_graphs=None,
):
    min_pred_num = args.num_pred_min
    max_pred_num = args.num_pred_max

    assert len(table_columns) > 0, "[where generator] No candidate column for where"

    num_predicates = rng.randint(min_pred_num, min(len(table_columns), max_pred_num) + 1) + num_nested_predicates
    num_nonnest_predicates = num_predicates - num_nested_predicates

    tree_predicates = build_predicate_tree_dnf(rng, [[x] for x in range(num_predicates)])
    tree_predicates, _ = renumbering_tree_predicates(tree_predicates, 0)
    tree_predicates_origin = copy.deepcopy(tree_predicates)
    if len(tree_predicates) == 1:
        tree_predicates.append(False)
    else:
        split_predicate_tree_with_condition_dnf(tree_predicates)
    flatten_tree = flatten_condition_predicate_tree(tree_predicates)
    sorted_conditions = sorted(flatten_tree, key=lambda x: x[0])
    nest_or_not = [True for _ in range(num_nested_predicates)] + [False for _ in range(num_nonnest_predicates)]
    rng.shuffle(nest_or_not)

    predicates = [None] * num_predicates
    predicates_origin = [None] * num_predicates

    result_guarantee_predicates = list()
    original_result_guarantee_tuples = df.copy(deep=True)
    result_guarantee_tuples = original_result_guarantee_tuples.copy(deep=True)
    is_updated_result_guarantee_tuples = False

    if outer_inner == "outer":
        if prefix is None:
            prefix = "O_"
    elif outer_inner == "inner":
        if prefix is None:
            prefix = "I_"
    else:
        if prefix is None:
            prefix = ""

    continue_cnt = 0
    vals = [-1 for _ in range(num_nonnest_predicates)]
    current_nonnest_idx = 0
    current_nested_idx = 0
    cond_idx = 0
    nested_predicates_graphs = {}
    correlation_predicates_origin = []
    visited_columns = []

    while cond_idx < num_predicates:
        if continue_cnt > 100:
            raise Exception("[where generator] Too many continue during where predicate generation")

        result_condition = sorted_conditions[cond_idx][1]
        if not nest_or_not[cond_idx]:
            if not result_condition and is_updated_result_guarantee_tuples:
                original_result_guarantee_tuples = pd.concat(
                    [original_result_guarantee_tuples, result_guarantee_tuples]
                ).drop_duplicates(keep=False)
                result_guarantee_tuples = original_result_guarantee_tuples
                is_updated_result_guarantee_tuples = False
                visited_columns = []
            current_columns = [col for col in table_columns if col not in visited_columns]
            done, col, op, val = non_nested_predicate_generator(
                args, rng, result_guarantee_tuples, current_columns, dvs, vs, dtype_dict, join_key_list
            )
            if not done:
                continue_cnt += 1
                continue

            vals[current_nonnest_idx] = val

            is_bool = dtype_dict[col] == "bool"
            if isinstance(op, tuple):
                query_predicate = predicate_generator(
                    col, op, (str(vals[current_nonnest_idx][0]), str(vals[current_nonnest_idx][1])), is_bool
                )
            else:
                query_predicate = predicate_generator(col, op, str(vals[current_nonnest_idx]), is_bool)

            # num_result = len(df.query(' AND '.join(result_guarantee_predicates)))
            new_result_guarantee_tuples = result_guarantee_tuples.query(query_predicate)
            num_result = len(new_result_guarantee_tuples)
            if num_result < 1 or num_result == len(result_guarantee_tuples):
                continue_cnt += 1
                continue
            if DEBUG_ERROR:
                pass
            else:
                result_guarantee_tuples = new_result_guarantee_tuples
            is_updated_result_guarantee_tuples = True
            visited_columns.append(col)
            result_guarantee_predicates.append(query_predicate)

            used_tables.add(col.split(".")[0])

            if isinstance(op, tuple):
                additional_pred_idx = len(predicates)
                predicate_str2 = prefix + col + " " + op[1] + " " + str(val[1])
                predicate_tuple_origin2 = (prefix, col, op[1], str(val[1]))

                tree_predicates = restore_predicate_tree_one(
                    tree_predicates, cond_idx, [[cond_idx, result_condition], "AND", [additional_pred_idx, "TRUE"]]
                )
                tree_predicates_origin = restore_predicate_tree_one(
                    tree_predicates_origin, cond_idx, [[cond_idx], "AND", [additional_pred_idx]]
                )
                predicates_origin.append(predicate_tuple_origin2)
                predicates.append(predicate_str2)
                op = op[0]
                val = val[0]

            if op in ["IS_NULL", "IS_NOT_NULL"]:
                predicate_str = prefix + col + " " + op
                predicate_tuple_origin = (prefix, col, op, None)
            else:
                predicate_str = prefix + col + " " + op + " " + str(val)
                predicate_tuple_origin = (prefix, col, op, str(val))
            predicates_origin[cond_idx] = predicate_tuple_origin
            predicates[cond_idx] = predicate_str
            cond_idx += 1
            current_nonnest_idx += 1
        else:
            inner_query_idx = chosen_inner_queries[current_nested_idx]
            obj = inner_query_objs[inner_query_idx]

            nesting_type = nesting_type_selector(args, rng, only_nested=True, only_nonnested=False, inner_query_obj=obj)
            nesting_position = nesting_position_selector(args, rng, nesting_type, inner_query_obj=obj)
            if not result_condition and is_updated_result_guarantee_tuples:
                original_result_guarantee_tuples = pd.concat(
                    [original_result_guarantee_tuples, result_guarantee_tuples]
                ).drop_duplicates(keep=False)
                result_guarantee_tuples = original_result_guarantee_tuples
                is_updated_result_guarantee_tuples = False
                visited_column = []
            (
                done,
                nested_predicate,
                used_tables_nested,
                new_result_guarantee_tuples,
                nested_predicate_graph,
                nested_predicate_origin,
                correlation_predicate_origin,
            ) = nested_predicate_generator(
                args,
                rng,
                table_columns,
                table_columns_projection,
                dtype_dict,
                join_key_list,
                all_table_set,
                join_clause_list,
                join_key_pred,
                result_guarantee_tuples,
                dvs,
                vs,
                n,
                prefix,
                nesting_position=nesting_position,
                nesting_type=nesting_type,
                inner_query_obj=obj,
                inner_query_graph=inner_query_graphs[inner_query_idx],
            )
            if not done:
                continue_cnt += 1
                continue
            if DEBUG_ERROR:
                pass
            else:
                result_guarantee_tuples = new_result_guarantee_tuples
                is_updated_result_guarantee_tuples = True
            if correlation_predicate_origin:
                correlation_predicates_origin.append(correlation_predicate_origin)

            used_tables = used_tables.union(used_tables_nested)
            inner_prefix = get_prefix(obj["nesting_level"], obj["unique_alias"])
            nested_predicates_graphs[inner_prefix] = nested_predicate_graph
            predicates[cond_idx] = nested_predicate
            predicates_origin[cond_idx] = nested_predicate_origin
            cond_idx += 1
            current_nested_idx += 1

    tree_predicates = restore_predicate_tree(tree_predicates, predicates)

    return (
        tree_predicates,
        nested_predicates_graphs,
        used_tables,
        result_guarantee_tuples,
        tree_predicates_origin,
        predicates_origin,
        correlation_predicates_origin,
    )


def nested_predicate_generator(
    args,
    rng,
    table_columns_except_id,
    table_columns,
    dtype_dict,
    join_key_list,
    all_table_set,
    join_clause_list,
    join_key_pred,
    df,
    dvs,
    vs,
    n,
    prefix,
    nesting_position=-1,
    nesting_type="non-nested",
    outer_correlation_column=None,
    inner_query_obj=None,
    inner_query_graph=None,
):
    num_predicate = 1
    used_tables = set()

    tree_predicates = build_predicate_tree_dnf(rng, [[x] for x in range(num_predicate)])
    tree_predicates, _ = renumbering_tree_predicates(tree_predicates, 0)
    tree_predicates_origin = copy.deepcopy(tree_predicates)
    if len(tree_predicates) == 1:
        tree_predicates.append(False)
    else:
        split_predicate_tree_with_condition_dnf(tree_predicates)
    flatten_tree = flatten_condition_predicate_tree(tree_predicates)
    sorted_conditions = sorted(flatten_tree, key=lambda x: x[0])

    predicates = list()
    cond_idx = 0
    nesting_col = None
    result_guarantee_predicates = list()
    result_guarantee_tuples = df.copy(deep=True)

    continue_cnt = 0

    result_condition = sorted_conditions[-1][1]
    done = False
    nested_predicate_origin = tuple()
    while not done:
        if continue_cnt > 100:
            return False, None, None, None, None, None, None
        if nesting_type in ["type-j", "type-ja"]:
            if inner_query_obj:
                inner_query_tables = inner_query_obj["tables"]
                inner_query_columns = [
                    table_column for table_column in table_columns if table_column.split(".")[0] in inner_query_tables
                ]
                correlation_column = rng.choice(inner_query_columns)
            else:
                correlation_column = rng.choice(table_columns)
        else:
            correlation_column = None
        if nesting_position == 0:
            if inner_query_obj:
                assert len(inner_query_obj["agg_cols"]) == 1
                col = inner_query_obj["agg_cols"][0][1]  # col
            else:
                column_idx = rng.randint(0, len(table_columns))
                col = table_columns[column_idx]
            if correlation_column and col == correlation_column:
                continue_cnt += 1
                continue

            # (FIX #5) Non-textual column for type-a, type-ja nested query
            # for <col> <op> <inner query> form

            if nesting_type in ["type-a", "type-ja"] and dtype_dict[col] == "str":
                continue_cnt += 1
                continue
            if nesting_type in ["type-a", "type-ja"] and col not in table_columns_except_id:
                continue_cnt += 1
                continue

            is_bool = False
            if dtype_dict[col] == "str" and nesting_type not in ["type-a", "type-ja"]:
                sum_p = sum(TEXTUAL_OPERATORS_PROBABILITY[0:3])
                op = rng.choice(TEXTUAL_OPERATORS[0:3], p=[i / sum_p for i in TEXTUAL_OPERATORS_PROBABILITY[0:3]])
            elif dtype_dict[col] == "bool" and nesting_type not in ["type-a", "type-ja"]:
                op = rng.choice(KEY_OPERATORS, p=KEY_OPERATORS_PROBABILITY)
                is_bool = True
            else:
                op = rng.choice(NUMERIC_OPERATORS, p=NUMERIC_OPERATORS_PROBABILITY)

            (
                inner_query,
                inner_query_result,
                inner_obj_updated,
                inner_graph_updated,
                correlation_predicate_origin,
            ) = inner_query_obj_to_inner_query(
                args,
                result_guarantee_tuples,
                n,
                rng,
                inner_query_obj,
                inner_query_graph,
                dtype_dict,
                dvs,
                vs,
                prefix,
                nesting_column=col,
                correlation_column=correlation_column,
            )
            if inner_query_result is None:
                return False, None, None, None, None, None, None
            if len(inner_query_result) > 1:
                nesting_position = 1
                continue
            # assert len(inner_query_result) == 1, "The number of result of inner query should be 1"

            if not result_condition:
                result_guarantee_tuples = df.copy(deep=True)

            if nesting_type in ["type-j", "type-ja"]:
                new_result_guarantee_tuples = pd.DataFrame([], columns=result_guarantee_tuples.columns)
                for tid in range(len(result_guarantee_tuples)):
                    tpl = result_guarantee_tuples.iloc[[tid]]

                    cur_group = None
                    for key, item in inner_query_result:
                        if key == tpl[correlation_column].iloc[0]:
                            cur_group = item
                            break
                    if cur_group is None or (type(cur_group.iloc[0, 1]) != str and np.isnan(cur_group.iloc[0, 1])):
                        continue

                    result_val = cur_group.iloc[0, 1]
                    if dtype_dict[col] == "str" and nesting_type != "type-ja":
                        if op in ["=", "!="]:
                            result_val = '"' + result_val + '"'
                        else:
                            result_val = '"' + rng.choice(["%", ""]) + result_val + rng.choice(["%", ""]) + '"'
                    query_predicate = predicate_generator(col, op, str(result_val), is_bool)
                    query_result = tpl.query(query_predicate)
                    if len(query_result) > 0:
                        new_result_guarantee_tuples = pd.concat([new_result_guarantee_tuples, tpl])
            else:
                result_val = inner_query_result.iloc[0, 0]  # Get the value of the inner query
                if type(result_val) != str and np.isnan(result_val):
                    continue_cnt += 1
                    continue

                if dtype_dict[col] == "str" and nesting_type != "type-a":
                    if op in ["=", "!="]:
                        result_val = '"' + result_val + '"'
                    else:
                        result_val = '"' + rng.choice(["%", ""]) + result_val + rng.choice(["%", ""]) + '"'
                query_predicate = predicate_generator(col, op, str(result_val), is_bool)
                new_result_guarantee_tuples = result_guarantee_tuples.query(query_predicate)

            num_result = len(new_result_guarantee_tuples)
            if num_result < 1 or num_result == len(result_guarantee_tuples):
                continue_cnt += 1
                continue
            result_guarantee_tuples = new_result_guarantee_tuples
            # result_guarantee_predicates.append(query_predicate)
            if correlation_column is not None:
                used_tables.add(correlation_column.split(".")[0])
            used_tables.add(col.split(".")[0])
            predicate_str = prefix + col + " " + op + " (" + inner_query + ")"
            nested_predicate_origin = tuple([prefix, col, op, "(" + inner_query + ")", inner_obj_updated])
            nesting_col = col
            done = True

        elif nesting_position == 1:
            if inner_query_obj:
                assert len(inner_query_obj["agg_cols"]) == 1
                col = inner_query_obj["agg_cols"][0][1]  # col
            else:
                column_idx = rng.randint(0, len(table_columns))
                col = table_columns[column_idx]

            if correlation_column and col == correlation_column:
                continue_cnt += 1
                continue
            op = rng.choice(["IN", "NOT IN"], p=[0.8, 0.2])

            (
                inner_query,
                inner_query_result,
                inner_obj_updated,
                inner_graph_updated,
                correlation_predicate_origin,
            ) = inner_query_obj_to_inner_query(
                args,
                result_guarantee_tuples,
                n,
                rng,
                inner_query_obj,
                inner_query_graph,
                dtype_dict,
                dvs,
                vs,
                prefix,
                nesting_column=col,
                correlation_column=correlation_column,
            )
            if inner_query_result is None:
                return False, None, None, None, None, None, None
            # assert len(inner_query_result) == 1, "The number of column of inner query should be 1"
            if not result_condition:
                result_guarantee_tuples = df.copy(deep=True)

            new_result_guarantee_tuples = pd.DataFrame([], columns=result_guarantee_tuples.columns)
            if nesting_type in ["type-j", "type-ja"]:
                for tid in range(len(result_guarantee_tuples)):
                    tpl = result_guarantee_tuples.iloc[[tid]]

                    cur_group = None
                    for key, item in inner_query_result:
                        if key == tpl[correlation_column].iloc[0]:
                            cur_group = item
                            break
                    if cur_group is None:
                        continue
                    result_val = list(cur_group.iloc[:, 1])

                    column_value = tpl[col].iloc[0]
                    if (column_value in result_val and op == "IN") or (
                        column_value not in result_val and op == "NOT IN"
                    ):
                        new_result_guarantee_tuples = pd.concat([new_result_guarantee_tuples, tpl])

            else:
                result_val = list(inner_query_result.iloc[:, 0])  # Get the values of the inner query
                for tid in range(len(result_guarantee_tuples)):
                    tpl = result_guarantee_tuples.iloc[[tid]]
                    column_value = tpl[col].iloc[0]
                    if (column_value in result_val and op == "IN") or (
                        column_value not in result_val and op == "NOT IN"
                    ):
                        new_result_guarantee_tuples = pd.concat([new_result_guarantee_tuples, tpl])

            num_result = len(new_result_guarantee_tuples)
            if num_result < 1 or num_result == len(result_guarantee_tuples):
                continue_cnt += 1
                if DEBUG_ERROR:
                    pass
                else:
                    continue
            result_guarantee_tuples = new_result_guarantee_tuples
            # result_guarantee_predicates.append(query_predicate)

            if correlation_column is not None:
                used_tables.add(correlation_column.split(".")[0])
            used_tables.add(col.split(".")[0])
            predicate_str = prefix + col + " " + op + " (" + inner_query + ")"
            nested_predicate_origin = tuple([prefix, col, op, "(" + inner_query + ")", inner_obj_updated])
            nesting_col = col
            done = True
            break

        elif nesting_position == 2:
            op = rng.choice(["EXISTS", "NOT EXISTS"], p=[0.8, 0.2])
            (
                inner_query,
                inner_query_result,
                inner_obj_updated,
                inner_graph_updated,
                correlation_predicate_origin,
            ) = inner_query_obj_to_inner_query(
                args,
                result_guarantee_tuples,
                n,
                rng,
                inner_query_obj,
                inner_query_graph,
                dtype_dict,
                dvs,
                vs,
                prefix,
                correlation_column=correlation_column,
            )
            if inner_query_result is None:
                return False, None, None, None, None, None, None

            if not result_condition:  # Always correlation condition
                result_guarantee_tuples = df.copy(deep=True)
            new_result_guarantee_tuples = pd.DataFrame([], columns=result_guarantee_tuples.columns)
            for tid in range(len(result_guarantee_tuples)):
                tpl = result_guarantee_tuples.iloc[[tid]]

                cur_group = None
                for key, item in inner_query_result:
                    if key == tpl[correlation_column].iloc[0]:
                        cur_group = item
                        break

                num_result = len(cur_group) if cur_group is not None else 0
                if (num_result > 0 and op == "EXISTS") or (num_result < 1 and op == "NOT EXISTS"):
                    new_result_guarantee_tuples = pd.concat([new_result_guarantee_tuples, tpl])

            num_result = len(new_result_guarantee_tuples)
            if num_result < 1 or num_result == len(result_guarantee_tuples):
                continue_cnt += 1
                if DEBUG_ERROR:
                    pass
                else:
                    continue

            predicate_str = op + " (" + inner_query + ")"
            nested_predicate_origin = tuple([None, None, op, "(" + inner_query + ")", inner_obj_updated])
            if correlation_column is not None:
                used_tables.add(correlation_column.split(".")[0])
            done = True
            break

        elif nesting_position == 3:
            if inner_query_obj:
                assert len(inner_query_obj["agg_cols"]) == 1
                col = inner_query_obj["agg_cols"][0][1]  # col
            else:
                column_idx = rng.randint(0, len(table_columns))
                col = table_columns[column_idx]
            # if correlation_column and col == correlation_column:
            #    continue

            is_bool = False
            if "*" not in col and dtype_dict[col] == "str" and nesting_type not in ["type-a", "type-ja"]:
                sum_p = sum(TEXTUAL_OPERATORS_PROBABILITY[0:3])
                op = rng.choice(TEXTUAL_OPERATORS[0:3], p=[i / sum_p for i in TEXTUAL_OPERATORS_PROBABILITY[0:3]])
            elif dtype_dict[col] == "bool" and nesting_type not in ["type-a", "type-ja"]:
                op = rng.choice(KEY_OPERATORS, p=KEY_OPERATORS_PROBABILITY)
                is_bool = True
            else:
                op = rng.choice(NUMERIC_OPERATORS, p=NUMERIC_OPERATORS_PROBABILITY)

            # val = randomly_select_value_from_column()

            (
                inner_query,
                inner_query_result,
                inner_obj_updated,
                inner_graph_updated,
                correlation_predicate_origin,
            ) = inner_query_obj_to_inner_query(
                args,
                result_guarantee_tuples,
                n,
                rng,
                inner_query_obj,
                inner_query_graph,
                dtype_dict,
                dvs,
                vs,
                prefix,
                nesting_column=col,
                correlation_column=correlation_column,
            )
            if inner_query_result is None:
                return False, None, None, None, None, None, None
            # Always correlation condition

            if len(inner_query_result) == 0:
                continue_cnt += 1
                continue

            if op in ["=", ">=", "<="]:
                cur_group = None
                for key, item in inner_query_result:
                    if key == result_guarantee_tuples[correlation_column].iloc[0]:
                        cur_group = item
                        break
                if cur_group is None:
                    continue_cnt += 1
                    continue
                if col == "*":
                    col = correlation_column
                val = cur_group[col].iloc[0]
                if type(val) != str and np.isnan(val):
                    continue_cnt += 1
                    continue
            else:
                tid = rng.randint(0, len(inner_query_result))
                val = inner_query_result[tid][1].iloc[0, 0]
                if type(val) != str and np.isnan(val):
                    continue_cnt += 1
                    continue

            if "*" not in col and dtype_dict[col] == "str" and nesting_type not in ["type-a", "type-ja"]:
                if op in ["=", "!="]:
                    val = '"' + val + '"'
                else:
                    val = '"' + rng.choice(["%", ""]) + val + rng.choice(["%", ""]) + '"'

            if not result_condition:  # (TODO) Add correlation checker
                result_guarantee_tuples = df.copy(deep=True)
            new_result_guarantee_tuples = pd.DataFrame([], columns=result_guarantee_tuples.columns)
            for tid in range(len(result_guarantee_tuples)):
                tpl = result_guarantee_tuples.iloc[[tid]]

                cur_group = None
                for key, item in inner_query_result:
                    if key == tpl[correlation_column].iloc[0]:
                        cur_group = item
                        break
                if cur_group is None:
                    continue_cnt += 1
                    continue

                if col == "*":
                    col = correlation_column

                query_predicate = predicate_generator(col, op, str(val), is_bool)
                predicate_result = cur_group.query(query_predicate)
                num_result = len(predicate_result)
                if num_result > 0:
                    new_result_guarantee_tuples = pd.concat([new_result_guarantee_tuples, tpl])

            num_result = len(new_result_guarantee_tuples)
            if num_result < 1 or num_result == len(result_guarantee_tuples):
                continue_cnt += 1
                if DEBUG_ERROR:
                    pass
                else:
                    continue
            result_guarantee_tuples = new_result_guarantee_tuples
            # result_guarantee_predicates.append(query_predicate)

            predicate_str = "(" + inner_query + ") " + op + " " + str(val)
            nested_predicate_origin = tuple([None, "(" + inner_query + ")", op, str(val), inner_obj_updated])
            if correlation_column is not None:
                used_tables.add(correlation_column.split(".")[0])
            done = True
            break

    if not done:
        return False, None, None, None, None, None, None
    predicates.append(predicate_str)

    tree_predicates = restore_predicate_tree(tree_predicates, predicates)

    query_graph = inner_graph_updated

    return (
        True,
        tree_predicates,
        used_tables,
        result_guarantee_tuples,
        query_graph,
        nested_predicate_origin,
        correlation_predicate_origin,
    )


def group_generator(args, rng, cols, dtype_dict, dvs, group=False, outer_inner="non-nested", prefix=None):
    min_group, max_group = args.num_group_min, args.num_group_max

    categorical_cols = [col for col in cols if col in CATEGORIES]
    if not categorical_cols:
        categorical_cols = [col for col in cols if len(dvs[col]) > 1]
    candidate_cols = [col for col in categorical_cols]

    assert len(candidate_cols) > 0, "[group generator] No candidate column for group by"
    max_group = min(len(candidate_cols), max_group)

    prob = get_truncated_geometric_distribution(max_group - min_group + 1, 0.8)
    num_group = rng.choice(range(min_group, max_group + 1), p=prob)

    if outer_inner == "outer":
        if prefix is None:
            prefix = "O_"
    elif outer_inner == "inner":
        if prefix is None:
            prefix = "I_"
    else:
        if prefix is None:
            prefix = ""

    columns = rng.choice(candidate_cols, num_group, replace=False)

    columns_with_prefix = [prefix + col for col in columns]

    return columns, columns_with_prefix


def order_generator(
    args,
    rng,
    cols,
    dtype_dict,
    agg_cols,
    group=False,
    group_columns=False,
    outer_inner="non-nested",
    prefix=None,
):
    min_order, max_order = args.num_order_min, args.num_order_max
    max_order = min(len(agg_cols), max_order)

    assert len(agg_cols) > 0, "[order generator] No candidate column for order by"

    prob = get_truncated_geometric_distribution(max_order - min_order + 1, 0.8)
    num_order = rng.choice(range(min_order, max_order + 1), p=prob)

    columns = []
    if outer_inner == "outer":
        if prefix is None:
            prefix = "O_"
    elif outer_inner == "inner":
        if prefix is None:
            prefix = "I_"
    else:
        if prefix is None:
            prefix = ""

    columns_with_prefix = []
    aggregated_order = False
    while len(columns) < num_order:
        agg_col_idx = rng.randint(0, len(agg_cols))
        agg_col = agg_cols[agg_col_idx]

        agg = agg_col[0]
        col = agg_col[1]
        if agg != "NONE":
            aggregated_order = True

        if agg == "NONE" and col == "*":
            return False, None, None, None

        # col_rep = agg + "(" + col + ")" if agg != "NONE" else col
        if col == "*":
            col_rep_with_prefix = agg + "(" + col + ")" if agg != "NONE" else col
        else:
            col_rep_with_prefix = agg + "(" + prefix + col + ")" if agg != "NONE" else prefix + col
        if col_rep_with_prefix in columns_with_prefix:
            continue
        else:
            columns.append(col)
            columns_with_prefix.append(col_rep_with_prefix)

    return True, columns, columns_with_prefix, aggregated_order


def limit_generator(args, rng):
    min_limit, max_limit = args.num_limit_min, args.num_limit_max
    num_limit = rng.randint(min_limit, max_limit + 1)

    return num_limit


def inner_query_obj_to_inner_query(
    args,
    df,
    n,
    rng,
    inner_query_obj_org,
    inner_query_graph_org,
    dtype_dict,
    dvs,
    vs,
    prefix,
    nesting_column=None,
    correlation_column=None,
):
    # obj to sql
    inner_query_obj = copy.deepcopy(inner_query_obj_org)

    sql_type_dict = inner_query_obj["type"]
    agg_cols = inner_query_obj["agg_cols"]
    use_agg_sel = inner_query_obj["use_agg_sel"]
    select_columns = inner_query_obj["select"]
    where_predicates = inner_query_obj["where"]
    group_columns = inner_query_obj["group"]
    having_predicates = inner_query_obj["having"]
    order_columns = inner_query_obj["order"]
    limit_num = inner_query_obj["limit"]
    necessary_tables = inner_query_obj["tables"]
    necessary_joins = inner_query_obj["joins"]
    predicates_origin = inner_query_obj["predicates_origin"]
    tree_predicates_origin = inner_query_obj["tree_predicates_origin"]
    having_tree_predicates_origin = inner_query_obj["having_tree_predicates_origin"]
    having_predicates_origin = inner_query_obj["having_predicates_origin"]
    df_query = inner_query_obj["df_query"]
    nesting_level = inner_query_obj["nesting_level"]
    unique_alias = inner_query_obj["unique_alias"]
    childs = inner_query_obj["childs"]
    correlation_predicates_origin = inner_query_obj["correlation_predicates_origin"]
    is_having_child = inner_query_obj["is_having_child"]
    graph = inner_query_graph_org

    # [TODO] Add correlated columns
    # "tree_predicates_origin": tree_predicates_origin,
    # "predicates_origin": predicates_origin,
    query_string = "SELECT * FROM " + df_query["FROM"]

    if sql_type_dict["having"]:
        query_string += "_outer"
        alias = df_query["FROM"].split(" ")[1] + "_outer"
        grouping_columns = df_query["GROUPBY"].split(",")
        outer_predicates = []
        for grouping_column in grouping_columns:
            inner_predicate = " ( SELECT " + grouping_column
            inner_predicate += " FROM " + df_query["FROM"]
            if sql_type_dict["where"]:
                inner_predicate += " WHERE " + df_query["WHERE"]
            inner_predicate += " GROUP BY " + df_query["GROUPBY"]
            inner_predicate += " HAVING " + df_query["HAVING"]
            if sql_type_dict["limit"]:
                if sql_type_dict["order"]:
                    inner_predicate += " ORDER BY " + df_query["ORDERBY"]
                inner_predicate += " LIMIT " + df_query["LIMIT"]
            inner_predicate += " ) "
            grouping_column_corrected_alias = alias + "." + ".".join(grouping_column.split(".")[1:])
            outer_predicates.append(grouping_column_corrected_alias + " IN " + inner_predicate)
        outer_predicate_all = " AND ".join(outer_predicates)
        query_string += " WHERE " + outer_predicate_all
    else:
        if sql_type_dict["where"]:
            query_string += " WHERE " + df_query["WHERE"]
        if sql_type_dict["limit"]:
            if sql_type_dict["order"]:
                query_string += " ORDER BY " + df_query["ORDERBY"]
            query_string += " LIMIT " + df_query["LIMIT"]

    result_guarantee_tuples = ps.sqldf(query_string, locals())
    if result_guarantee_tuples.empty:
        return None, None, None, None, None

    # (FIX #12): Make correlation predicate as the top level predicate
    correlation_predicate_origin = None
    prefix_inner = "N" + str(nesting_level) + "_" + str(unique_alias) + "_"
    if correlation_column is not None:  # (TODO) nned to identify whether it's generating outer query or inner query
        correlation_predicate = prefix + correlation_column + " = " + prefix_inner + correlation_column
        correlation_predicate_origin = tuple(
            [prefix_inner, correlation_column, "=", correlation_column, "correal", prefix]
        )
        if sql_type_dict["where"]:
            where_predicates = [(correlation_predicate, "AND", where_predicates)]
            predicates_origin = predicates_origin + [correlation_predicate_origin]
            tree_predicates_origin = [[len(predicates_origin) - 1], "AND", tree_predicates_origin]
        else:
            where_predicates = correlation_predicate
            predicates_origin = [correlation_predicate_origin]
            tree_predicates_origin = [0]
        result_guarantee_tuples = result_guarantee_tuples.groupby(correlation_column)
        sql_type_dict["where"] = True

    result_tuples = result_guarantee_tuples

    if correlation_column is not None:
        if not use_agg_sel:
            if agg_cols[0][1] == "*":
                selected_columns = [correlation_column]
            else:
                selected_columns = [correlation_column] + [col for agg, col in agg_cols]
            new_result_tuples = []

            for key, item in result_tuples:
                new_result_tuples.append((key, item[selected_columns]))
            result_tuples = new_result_tuples
        else:
            new_result_tuples = []
            for key, item in result_tuples:
                new_item = item[[correlation_column]].iloc[[0]]
                for i in range(len(agg_cols)):
                    agg, col = agg_cols[i]
                    func = convert_agg_to_func(agg)
                    # col_rep = select_columns[i]
                    if col == "*":
                        col = correlation_column
                    new_item[col] = [item[col].aggregate(func=func)]
                new_result_tuples.append((key, new_item))
            result_tuples = new_result_tuples
    else:
        if not use_agg_sel:
            if agg_cols[0][1] != "*":
                result_tuples = result_tuples[[col for agg, col in agg_cols]]
        else:
            new_result_tuples = pd.DataFrame([])
            for i in range(len(agg_cols)):
                agg, col = agg_cols[i]
                func = convert_agg_to_func(agg)
                if col == "*":
                    col = nesting_column
                new_result_tuples[col] = [result_tuples[col].aggregate(func=func)]

            result_tuples = new_result_tuples

    line, df_query = sql_formation(
        args,
        sql_type_dict,
        necessary_tables,
        necessary_joins,
        "inner",
        select_columns,
        where_predicates,
        group_columns,
        having_predicates,
        order_columns,
        limit_num,
        select_agg_cols=agg_cols,
        tree_predicates_origin=tree_predicates_origin,
        predicates_origin=predicates_origin,
        having_tree_predicates_origin=having_tree_predicates_origin,
        having_predicates_origin=having_predicates_origin,
        nesting_level=nesting_level,
        nesting_block_idx=unique_alias,
    )

    obj = {
        "sql": line,
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
        "having_tree_predicates_origin": having_tree_predicates_origin,
        "having_predicates_origin": having_predicates_origin,
        "correlation_column": correlation_column,
        "df_query": df_query,
        "nesting_level": nesting_level,
        "unique_alias": unique_alias,
        "childs": childs,
        "correlation_predicates_origin": correlation_predicates_origin,
        "is_having_child": is_having_child,
    }

    return line, result_tuples, obj, graph, correlation_predicate_origin


def finite_query_generation(
    args,
    sql_type_dict,
    necessary_tables,
    necessary_joins,
    outer_inner,
    select_columns,
    where_predicates,
    group_columns,
    having_predicates,
    order_columns,
    limit_num,
    agg_cols,
    tree_predicates_origin,
    predicates_origin,
    having_tree_predicates_origin,
    having_predicates_origin,
    current_nesting_level,
    global_unique_query_idx,
    use_agg_sel,
    used_tables,
    childs,
    child_predicates_graphs=None,
    correlation_predicates_origin=[],
    is_having_child=False,
):
    # dddqqq
    line, df_query = sql_formation(
        args,
        sql_type_dict,
        necessary_tables,
        necessary_joins,
        outer_inner,
        select_columns,
        where_predicates,
        group_columns,
        having_predicates,
        order_columns,
        limit_num,
        select_agg_cols=agg_cols,
        tree_predicates_origin=tree_predicates_origin,
        predicates_origin=predicates_origin,
        having_tree_predicates_origin=having_tree_predicates_origin,
        having_predicates_origin=having_predicates_origin,
        nesting_level=current_nesting_level,
        nesting_block_idx=global_unique_query_idx,
    )
    graph = tree_and_graph_formation(
        args,
        sql_type_dict,
        necessary_tables,
        necessary_joins,
        outer_inner,
        select_columns,
        where_predicates,
        group_columns,
        having_predicates,
        order_columns,
        limit_num,
        used_tables,
        make_graph=True,
        select_agg_cols=agg_cols,
        tree_predicates_origin=tree_predicates_origin,
        predicates_origin=predicates_origin,
        having_tree_predicates_origin=having_tree_predicates_origin,
        having_predicates_origin=having_predicates_origin,
        nesting_level=current_nesting_level,
        nesting_block_idx=global_unique_query_idx,
        sql=line,
        childs=childs,
        child_query_graphs=child_predicates_graphs,
        correlation_predicates_origin=correlation_predicates_origin,
    )
    obj = {
        "sql": line,
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
        "having_tree_predicates_origin": having_tree_predicates_origin,
        "having_predicates_origin": having_predicates_origin,
        "nesting_level": current_nesting_level,
        "unique_alias": global_unique_query_idx,
        "df_query": df_query,
        "childs": childs,
        "correlation_predicates_origin": correlation_predicates_origin,
        "is_having_child": is_having_child,
    }
    return line, graph, obj


def add_new_query_for_having(
    args,
    rng,
    joins,
    tables,
    sql_type_dict,
    used_tables,
    outer_inner,
    select_columns,
    where_predicates,
    group_columns,
    group_columns_origin,
    having_predicates,
    order_columns,
    limit_num,
    agg_cols,
    tree_predicates_origin,
    predicates_origin,
    having_tree_predicates_origin,
    having_predicates_origin,
    nesting_level,
    global_unique_query_idx,
    use_agg_sel,
    childs,
    child_predicates_graphs=None,
    correlation_predicates_origin=None,
):
    # SQL update
    unique_query_idx = global_unique_query_idx + 1
    prefix = get_prefix(nesting_level, unique_query_idx)
    original_prefix = get_prefix(nesting_level, global_unique_query_idx)
    select_columns_having = []
    for select_column in select_columns:
        select_columns_having.append(select_column.replace(original_prefix, prefix))
    if sql_type_dict["where"]:
        where_predicates_having = preorder_traverse_to_replace_alias(where_predicates, original_prefix, prefix)
    else:
        where_predicates_having = where_predicates
    predicates_origin_having = []
    for predicate in predicates_origin:
        if predicate[0] != None:
            predicates_origin_having.append((tuple([prefix]) + predicate[1:]))
        else:
            predicates_origin_having.append(predicate)
    group_columns_having = []
    for group_column in group_columns:
        group_columns_having.append(group_column.replace(original_prefix, prefix))
    if sql_type_dict["having"]:
        having_predicates_having = preorder_traverse_to_replace_alias(having_predicates, original_prefix, prefix)
    else:
        having_predicates_having = having_predicates
    having_predicates_origin_having = []
    for having_predicate in having_predicates_origin:
        having_predicates_origin_having.append((tuple([prefix]) + having_predicate[1:]))
    order_columns_having = []
    for order_column in order_columns:
        order_columns_having.append(order_column.replace(original_prefix, prefix))

    sql_type_dict_having = copy.deepcopy(sql_type_dict)
    sql_type_dict_having["having"] = False
    sql_type_dict_having["order"] = False
    sql_type_dict_having["limit"] = False
    sql_type_dict_having["aggregated_order"] = False

    # update select columns
    agg_cols_having = copy.deepcopy(agg_cols)
    use_agg_sel_having = True

    # alias change
    if sql_type_dict["having"]:
        for having_predicate in having_predicates_origin:
            agg = having_predicate[1]
            col = having_predicate[2]
            if (agg, col) not in agg_cols_having:
                agg_cols_having.append((agg, col))
                select_col = col
                if select_col != "*":
                    select_col = prefix + select_col
                if agg != "NONE":
                    select_col = agg + "(" + select_col + ")"
                select_columns_having.append(select_col)

    if sql_type_dict["aggregated_order"]:
        for order_col_raw in order_columns:
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
                rel_name = order_alias.split(original_prefix)[1]
                col_name = rel_name + "." + order_col.split(".")[1]
            else:
                col_name = order_col

            col = col_name
            if (agg, col) not in agg_cols_having:
                agg_cols_having.append((agg, col))
                select_col = col
                if select_col != "*":
                    select_col = prefix + col
                if agg != "NONE":
                    select_col = agg + "(" + select_col + ")"
                select_columns_having.append(select_col)

    # make header of having table
    header_having = []
    for agg, col in agg_cols_having:
        if col != "*":
            tab_name = col.split(".")[0]
            col_name = col.split(".")[1]
        else:
            tab_name = None
            col_name = col
        header_having.append(get_tree_header(prefix, tab_name, col_name, agg))
    args.table_info[prefix] = header_having

    # update used tables
    used_tables_having = copy.deepcopy(used_tables)
    used_tables_having = get_updated_used_tables(used_tables_having, group_columns_origin)
    if len(used_tables_having) == 0:
        used_tables_having = get_random_tables(args, rng, tables, 1)
    necessary_tables_having, necessary_joins_having = find_join_path(joins, tables, used_tables_having)

    line_having, graph_having, obj_having = finite_query_generation(
        args,
        sql_type_dict_having,
        necessary_tables_having,
        necessary_joins_having,
        outer_inner,
        select_columns_having,
        where_predicates_having,
        group_columns_having,
        having_predicates_having,
        order_columns_having,
        limit_num,
        agg_cols_having,
        tree_predicates_origin,
        predicates_origin_having,
        having_tree_predicates_origin,
        having_predicates_origin_having,
        nesting_level,
        unique_query_idx,
        use_agg_sel_having,
        used_tables_having,
        childs,
        child_predicates_graphs=child_predicates_graphs,
        correlation_predicates_origin=correlation_predicates_origin,
        is_having_child=True,
    )

    return line_having, graph_having, obj_having


def non_nested_query_generator(
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
    vs,
    global_unique_query_idx,
):
    df_columns_not_null = df.columns[df.notna().iloc[n]]

    used_tables = set()
    tables, joins, table_columns_projection, table_columns = get_query_token(
        all_table_set,
        join_key_list,
        df.columns,
        df_columns_not_null,
        join_clause_list,
        rng,
        join_key_pred=join_key_pred,
    )
    prefix = get_prefix(1, global_unique_query_idx)

    sql_type_dict = non_nested_query_form_selector(args, rng)

    if sql_type_dict["where"]:
        where_predicates, _, used_tables, _, tree_predicates_origin, predicates_origin, _ = where_generator(
            args,
            rng,
            table_columns,
            table_columns_projection,
            dtype_dict,
            join_key_list,
            all_table_set,
            join_clause_list,
            join_key_pred,
            df,
            dvs,
            vs,
            n,
            used_tables,
            prefix=prefix,
        )
    else:
        where_predicates = []
        tree_predicates_origin = []
        predicates_origin = []

    if sql_type_dict["group"]:
        group_columns_origin, group_columns = group_generator(
            args, rng, table_columns, dtype_dict, dvs, group=sql_type_dict["group"], prefix=prefix
        )
    else:
        group_columns_origin = []
        group_columns = []

    if sql_type_dict["having"]:
        grouping_query_elements = get_grouping_query_elements(
            args,
            rng,
            sql_type_dict,
            dtype_dict,
            prefix,
            table_columns_projection,  # [WARING] NEED TO BE MODIFIED!!!!!!
            joins,
            tables,
            used_tables,
            where_predicates,
            tree_predicates_origin,
            predicates_origin,
            group_columns,
            group_columns_origin,
            join_key_list,
        )
        grouping_query_elements["nesting_level"] = 1
        grouping_query_elements["global_unique_query_idx"] = global_unique_query_idx
        having_predicates, having_predicates_origin, having_tree_predicates_origin, used_tables = having_generator(
            args,
            rng,
            table_columns,
            join_key_list,
            table_columns_projection,
            group_columns_origin,
            dtype_dict,
            df,
            n,
            used_tables,
            grouping_query_elements,
            prefix=prefix,
        )
    else:
        having_predicates = []
        having_predicates_origin = []
        having_tree_predicates_origin = []

    select_columns, agg_cols, (used_tables, use_agg_sel) = select_generator(
        args,
        rng,
        table_columns_projection,
        dtype_dict,
        join_key_list,
        tables,
        used_tables,
        group_columns,
        group_columns_origin,
        group=sql_type_dict["group"],
        having=sql_type_dict["having"],
        prefix=prefix,
    )

    if use_agg_sel == True and not sql_type_dict["group"]:
        sql_type_dict["order"] = False
        sql_type_dict["limit"] = False

    if sql_type_dict["order"]:
        done, order_columns_origin, order_columns, aggregated_order = order_generator(
            args,
            rng,
            table_columns,
            dtype_dict,
            agg_cols,
            group=sql_type_dict["group"],
            group_columns=group_columns_origin,
            prefix=prefix,
        )
        sql_type_dict["aggregated_order"] = aggregated_order
        if not done:
            order_columns_origin = []
            order_columns = []
            sql_type_dict["aggregated_order"] = False
            sql_type_dict["order"] = False
    else:
        order_columns_origin = []
        order_columns = []
        sql_type_dict["aggregated_order"] = False

    if sql_type_dict["limit"]:
        limit_num = limit_generator(args, rng)
    else:
        limit_num = 0

    childs = []
    if sql_type_dict["having"] or sql_type_dict["aggregated_order"]:
        line_having, graph_having, obj_having = line, graph, obj = add_new_query_for_having(
            args,
            rng,
            joins,
            tables,
            sql_type_dict,
            used_tables,
            "non-nested",
            select_columns,
            where_predicates,
            group_columns,
            group_columns_origin,
            having_predicates,
            order_columns,
            limit_num,
            agg_cols,
            tree_predicates_origin,
            predicates_origin,
            having_tree_predicates_origin,
            having_predicates_origin,
            1,
            global_unique_query_idx,
            use_agg_sel,
            childs,
        )
        childs = [(1, global_unique_query_idx + 1)]
        inner_prefix = get_prefix(1, global_unique_query_idx + 1)
        child_predicates_graphs = {inner_prefix: graph_having}
    else:
        line_having = None
        graph_having = None
        obj_having = None
        childs = []
        child_predicates_graphs = None

    used_tables = get_updated_used_tables(used_tables, group_columns_origin)
    used_tables = get_updated_used_tables(used_tables, order_columns_origin)
    if len(used_tables) == 0:
        used_tables = get_random_tables(args, rng, tables, 1)

    necessary_tables, necessary_joins = find_join_path(joins, tables, used_tables)

    line, graph, obj = finite_query_generation(
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
        agg_cols,
        tree_predicates_origin,
        predicates_origin,
        having_tree_predicates_origin,
        having_predicates_origin,
        1,
        global_unique_query_idx,
        use_agg_sel,
        used_tables,
        childs,
        child_predicates_graphs,
        is_having_child=False,
    )
    if line_having:
        lines = [line + "\n", line_having + "\n"]
        graphs = [graph, graph_having]
        objs = [obj, obj_having]
    else:
        lines = [line + "\n"]
        graphs = [graph]
        objs = [obj]

    return lines, graphs, objs


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
    vs,
    nesting_type,
    global_unique_query_idx,
    inner_query_objs=None,
    inner_query_graphs=None,
):
    if inner_query_objs is None:
        assert False, "Currently not implemented"

    min_nested_pred_num = args.num_nested_pred_min
    max_nested_pred_num = args.num_nested_pred_max

    candidate_idxs = get_possibie_inner_query_idxs(
        args, inner_query_objs
    )  # [TODO] If it projects multiple columns, modify the SELECT clause
    num_nested_predicates = rng.randint(min_nested_pred_num, min(len(candidate_idxs), max_nested_pred_num) + 1)
    chosen_inner_queries = rng.choice(candidate_idxs, num_nested_predicates, replace=False)

    inner_query_tables = set()
    max_inner_level = 0
    childs = []
    for idx in chosen_inner_queries:
        obj = inner_query_objs[idx]
        max_inner_level = max(max_inner_level, obj["nesting_level"])
        childs.append((obj["nesting_level"], obj["unique_alias"]))
        for table in obj["tables"]:
            inner_query_tables.add(table)
    current_nesting_level = max_inner_level + 1
    prefix = get_prefix(current_nesting_level, global_unique_query_idx)

    used_tables = set()

    df_columns_not_null = df.columns[df.notna().iloc[n]]
    tables, joins, table_columns_projection, table_columns = get_query_token(
        all_table_set,
        join_key_list,
        df.columns,
        df_columns_not_null,
        join_clause_list,
        rng,
        join_key_pred=join_key_pred,
        inner_query_tables=inner_query_tables,
    )

    sql_type_dict = non_nested_query_form_selector(args, rng)
    sql_type_dict["where"] = True

    # Step 1. Outer query generation

    (
        where_predicates,
        nested_predicates_graphs,
        used_tables,
        _,
        tree_predicates_origin,
        predicates_origin,
        correlation_predicates_origin,
    ) = where_generator(
        args,
        rng,
        table_columns,
        table_columns_projection,
        dtype_dict,
        join_key_list,
        all_table_set,
        join_clause_list,
        join_key_pred,
        df,
        dvs,
        vs,
        n,
        used_tables,
        outer_inner="outer",
        prefix=prefix,
        chosen_inner_queries=chosen_inner_queries,
        num_nested_predicates=num_nested_predicates,
        inner_query_objs=inner_query_objs,
        inner_query_graphs=inner_query_graphs,
    )

    if sql_type_dict["group"]:
        group_columns_origin, group_columns = group_generator(
            args,
            rng,
            table_columns,
            dtype_dict,
            dvs,
            group=sql_type_dict["group"],
            outer_inner="outer",
            prefix=prefix,
        )
    else:
        group_columns_origin = []
        group_columns = []

    if sql_type_dict["having"]:
        grouping_query_elements = get_grouping_query_elements(
            args,
            rng,
            sql_type_dict,
            dtype_dict,
            prefix,
            table_columns_projection,  # [WARING] NEED TO BE MODIFIED!!!!!!
            joins,
            tables,
            used_tables,
            where_predicates,
            tree_predicates_origin,
            predicates_origin,
            group_columns,
            group_columns_origin,
            join_key_list,
        )
        grouping_query_elements["nesting_level"] = current_nesting_level
        grouping_query_elements["global_unique_query_idx"] = global_unique_query_idx
        having_predicates, having_predicates_origin, having_tree_predicates_origin, used_tables = having_generator(
            args,
            rng,
            table_columns,
            join_key_list,
            table_columns_projection,
            group_columns_origin,
            dtype_dict,
            df,
            n,
            used_tables,
            grouping_query_elements,
            outer_inner="outer",
            prefix=prefix,
        )
    else:
        having_predicates = []
        having_predicates_origin = []
        having_tree_predicates_origin = []

    select_columns, agg_cols, (used_tables, use_agg_sel) = select_generator(
        args,
        rng,
        table_columns_projection,
        dtype_dict,
        join_key_list,
        tables,
        used_tables,
        group_columns,
        group_columns_origin,
        group=sql_type_dict["group"],
        having=sql_type_dict["having"],
        outer_inner="outer",
        prefix=prefix,
    )

    if use_agg_sel == True and not sql_type_dict["group"]:
        sql_type_dict["order"] = False
        sql_type_dict["limit"] = False

    if sql_type_dict["order"]:
        done, order_columns_origin, order_columns, aggregated_order = order_generator(
            args,
            rng,
            table_columns,
            dtype_dict,
            agg_cols,
            group=sql_type_dict["group"],
            group_columns=group_columns_origin,
            outer_inner="outer",
            prefix=prefix,
        )
        sql_type_dict["aggregated_order"] = aggregated_order
        if not done:
            order_columns_origin = []
            order_columns = []
            sql_type_dict["aggregated_order"] = False
            sql_type_dict["order"] = False
    else:
        order_columns_origin = []
        order_columns = []
        sql_type_dict["aggregated_order"] = False

    if sql_type_dict["limit"]:
        limit_num = limit_generator(args, rng)
    else:
        limit_num = 0

    if sql_type_dict["having"] or sql_type_dict["aggregated_order"]:
        line_having, graph_having, obj_having = line, graph, obj = add_new_query_for_having(
            args,
            rng,
            joins,
            tables,
            sql_type_dict,
            used_tables,
            "outer",
            select_columns,
            where_predicates,
            group_columns,
            group_columns_origin,
            having_predicates,
            order_columns,
            limit_num,
            agg_cols,
            tree_predicates_origin,
            predicates_origin,
            having_tree_predicates_origin,
            having_predicates_origin,
            current_nesting_level,
            global_unique_query_idx,
            use_agg_sel,
            childs,
            nested_predicates_graphs,
            correlation_predicates_origin,
        )
        childs = [(current_nesting_level, global_unique_query_idx + 1)]
        inner_prefix = get_prefix(current_nesting_level, global_unique_query_idx + 1)
        child_predicates_graphs = {inner_prefix: graph_having}

    else:
        line_having = None
        graph_having = None
        obj_having = None
        child_predicates_graphs = nested_predicates_graphs

    used_tables = get_updated_used_tables(used_tables, group_columns_origin)
    used_tables = get_updated_used_tables(used_tables, order_columns_origin)

    # (FIX C4) Remove unncessary tables & joins
    necessary_tables, necessary_joins = find_join_path(joins, tables, used_tables)

    line, graph, obj = finite_query_generation(
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
        agg_cols,
        tree_predicates_origin,
        predicates_origin,
        having_tree_predicates_origin,
        having_predicates_origin,
        current_nesting_level,
        global_unique_query_idx,
        use_agg_sel,
        used_tables,
        childs,
        child_predicates_graphs=child_predicates_graphs,
        correlation_predicates_origin=correlation_predicates_origin,
        is_having_child=False,
    )
    if line_having:
        lines = [line + "\n", line_having + "\n"]
        graphs = [graph, graph_having]
        objs = [obj, obj_having]
    else:
        lines = [line + "\n"]
        graphs = [graph]
        objs = [obj]

    return lines, graphs, objs


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
    vs,
    inner_query_objs=None,
    inner_query_graphs=None,
    global_unique_query_idx=0,
):
    only_nested = args.query_type in ["spj-nested", "nested"]
    only_nonnested = args.query_type in ["spj-non-nested", "non-nested"]
    nesting_type = nesting_type_selector(args, rng, only_nested=only_nested, only_nonnested=only_nonnested)

    if nesting_type == "non-nested":
        query, graph, obj = non_nested_query_generator(
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
            vs,
            global_unique_query_idx,
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
            vs,
            nesting_type,
            global_unique_query_idx,
            inner_query_objs,
            inner_query_graphs,
        )

    return query, graph, obj
