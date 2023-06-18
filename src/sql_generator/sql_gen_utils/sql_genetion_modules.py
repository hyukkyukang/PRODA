# import sql_genetion_utils
from sql_gen_utils.sql_genetion_utils import *


def nesting_type_selector(args, rng, inner_query_obj, nesting_type_origin):
    if inner_query_obj["use_agg_sel"]:
        if inner_query_obj["select"][0] == "*" or inner_query_obj["agg_cols"][0][0] == "COUNT":
            nesting_type_selected = ["type-ja"]
        else:
            nesting_type_selected = ["type-a", "type-ja"]
    else:
        if inner_query_obj["select"][0] == "*":
            nesting_type_selected = ["type-j"]
        else:
            nesting_type_selected = ["type-n", "type-j"]

    if args.constraints["set_nested_query_type"]:
        if "type-n" in nesting_type_origin and not args.constraints["has_type_n"]:
            nesting_type_selected.remove("type-n")
        if "type-a" in nesting_type_origin and not args.constraints["has_type_a"]:
            nesting_type_selected.remove("type-a")
        if "type-j" in nesting_type_origin and args.constraints["has_type_j"]:
            nesting_type_selected.remove("type-j")
        if "type-ja" in nesting_type_origin and args.constraints["has_type_ja"]:
            nesting_type_selected.remove("type-ja")
        if len(nesting_type_origin) == 0:
            args.logger.error("Selected inner query cannot meet given set nested query type condition")
            assert False

    candidate_nesting_type = [p for p in nesting_type_selected if p in nesting_type_origin]
    if len(candidate_nesting_type) == 0:
        return False, None

    return True, rng.choice(candidate_nesting_type)


def nesting_position_selector(args, rng, nesting_type, join_key_list, inner_query_obj, nesting_position_origin):
    # Nesting Types:
    # - WHERE <column> <operator> <Inner query>
    # - WHERE <column> <IN/NOT IN> <Inner query>
    # - WHERE <EXISTS/NOT EXISTS> <Inner query>
    # - WHERE <Inner query> <operator> <value>

    if nesting_type == "type-n":
        nesting_position_selected = [1]
        if inner_query_obj["type"]["limit"] and inner_query_obj["limit"] == 1:
            nesting_position_selected = [0]

    elif nesting_type == "type-a":
        if inner_query_obj["agg_cols"][0][0] == "COUNT":
            args.logger.error("This cannot be happend")
            assert False
            # CANNOT BE GENERATED
        nesting_position_selected = [0]

    elif nesting_type == "type-j":
        if inner_query_obj["select"][0] == "*":
            nesting_position_selected = [2]
        elif is_id_column(args, inner_query_obj["agg_cols"][0][1], join_key_list) or is_hashcode_column(
            args, inner_query_obj["agg_cols"][0][1]
        ):
            nesting_position_selected = [1]
            if inner_query_obj["type"]["limit"] and inner_query_obj["limit"] == 1:
                nesting_position_selected = [0]
        else:
            nesting_position_selected = [1]
            if inner_query_obj["type"]["limit"] and inner_query_obj["limit"] == 1:
                nesting_position_selected = [0, 3]

    elif nesting_type == "type-ja":
        if inner_query_obj["select"][0] == "*" or inner_query_obj["agg_cols"][0][0] == "COUNT":
            nesting_position_selected = [3]
        else:
            nesting_position_selected = [0, 3]

    candidate_nesting_position = [p for p in nesting_position_selected if p in nesting_position_origin]
    if len(candidate_nesting_position) == 0:
        return False, None

    return True, rng.choice(candidate_nesting_position)


def non_nested_query_form_selector(args, rng):
    if args.constraints["set_clause_by_clause"]:
        sql_type = {"where": False, "group": False, "having": False, "order": False, "limit": False}
        if args.constraints["has_where"]:
            sql_type["where"] = True
        if args.constraints["has_group"] or args.constraints["has_having"]:
            sql_type["group"] = True
        if args.constraints["has_having"]:
            sql_type["having"] = True
        if args.constraints["has_order"] or args.constraints["has_limit"]:
            sql_type["order"] = True
        if args.constraints["has_limit"]:
            sql_type["limit"] = True
    else:
        prob_where = args.hyperparams["prob_where"]
        prob_group = args.hyperparams["prob_group"]
        prob_having = args.hyperparams["prob_having"]
        prob_order = args.hyperparams["prob_order"]
        prob_limit = args.hyperparams["prob_limit"]
        sql_type = {
            "where": bool(rng.choice([0, 1], p=[1 - prob_where, prob_where])),
            "group": bool(rng.choice([0, 1], p=[1 - prob_group, prob_group])),
            "having": bool(rng.choice([0, 1], p=[1 - prob_having, prob_having])),
            "order": bool(rng.choice([0, 1], p=[1 - prob_order, prob_order])),
            "limit": bool(rng.choice([0, 1], p=[1 - prob_limit, prob_limit])),
        }
    if not sql_type["group"]:
        sql_type["having"] = False
    if not sql_type["order"]:
        sql_type["limit"] = False

    if args.constraints["used_as_inner_query"]:
        if sql_type["order"]:  # no order by query without limit
            sql_type["limit"] = True

        if sql_type["group"]:
            sql_type["having"] = True

        if not sql_type["where"]:
            sql_type["group"] = True
            sql_type["having"] = True

    if DEBUG_ERROR:
        sql_type["group"] = True
        sql_type["having"] = True
        sql_type["where"] = True

    return sql_type


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
    sql_type_dict,
    prefix,
):
    columns = []
    agg_cols = []

    if sql_type_dict["group"]:
        use_agg = True
    elif sql_type_dict["order"]:
        use_agg = False
    else:
        tmp_prob = 0.2
        use_agg = bool(rng.choice([0, 1], p=[1 - tmp_prob, tmp_prob]))

    if sql_type_dict["group"]:
        if sql_type_dict["having"]:
            if args.constraints["used_as_inner_query"]:
                project_all = False
            else:
                project_all = rng.choice([False, True])
        else:
            project_all = True

        if project_all:
            columns = list(group_columns)
            agg_cols = [("NONE", group_col) for group_col in group_columns_origin]
        else:
            columns = list(group_columns)
            use_agg = False
            agg_cols = [("NONE", group_col) for group_col in group_columns_origin]
            return columns, agg_cols, (used_tables, use_agg)

    if args.constraints["used_as_inner_query"]:
        num_select = rng.randint(0, 2)  # * or single column
    else:
        min_select, max_select = args.hyperparams["num_select_min"], args.hyperparams["num_select_max"]
        num_select = rng.randint(min_select, max_select + 1)

    candidate_cols = [col for col in cols if col not in group_columns_origin]

    if num_select == 0:
        if use_agg:
            # agg = rng.choice(NUMERIC_AGGS)
            agg = rng.choice(TEXTUAL_AGGS)
        else:
            agg = "NONE"

        col_rep = agg + "(*)" if agg != "NONE" else "*"
        columns.append(col_rep)
        agg_cols.append((agg, "*"))
    else:
        candidate_agg_cols = []
        for col in candidate_cols:
            if use_agg:
                if dtype_dict[col] in ["bool", "str"]:
                    candidate_aggs = TEXTUAL_AGGS
                elif dtype_dict[col] == "date":
                    candidate_aggs = DATE_AGGS
                else:
                    # (FIX #1, C6) Not use AVG/SUM/MIN/MAX for key columns
                    if is_id_column(args, col, join_key_list) or is_hashcode_column(args, col):  # join_key_list:
                        candidate_aggs = KEY_AGGS
                    else:
                        candidate_aggs = NUMERIC_AGGS
                for agg in candidate_aggs:
                    candidate_agg_cols.append((agg, col))
            else:
                agg = "NONE"
                candidate_agg_cols.append((agg, col))

        num_select = min(num_select, len(candidate_agg_cols))
        if num_select == 0:
            args.logger.warning("No candidate columns for select clause; restart generation")
            assert False
        sampled_agg_cols_idx = rng.choice(range(len(candidate_agg_cols)), size=num_select, replace=False)
        additional_agg_cols = [candidate_agg_cols[idx] for idx in sampled_agg_cols_idx]
        agg_cols += additional_agg_cols
        for agg, col in additional_agg_cols:
            col_rep = agg + "(" + prefix + col + ")" if agg != "NONE" else prefix + col
            columns.append(col_rep)
            used_tables.add(col.split(".")[0])

    return columns, agg_cols, (used_tables, use_agg)


def non_nested_predicate_generator(args, rng, table_columns, data_manager, view_name, dtype_dict, join_key_list):
    col_idx = -1
    row_idx = -1
    sample_rows = []
    val = None
    col = None
    while len(table_columns) > 0:
        tmp_col_idx = rng.randint(0, len(table_columns))

        col = table_columns[tmp_col_idx]
        col_in_view = col.replace(".", "__")

        sample_rows, sample_schema = data_manager.sample_rows(view_name, 100)
        col_idx = -1
        for idx, col2 in enumerate(sample_schema):
            if col2 == col_in_view:
                col_idx = idx
                break
        # Find not null value
        val = None
        row_idx = -1
        for idx, sample_row in enumerate(sample_rows):
            if sample_rows[idx][col_idx] is None or sample_rows[idx][col_idx] == "null":
                continue
            else:
                row_idx = idx
                break

        if row_idx == -1:
            sample_rows, _ = data_manager.sample_rows_with_cond(view_name, f"""{col_in_view} IS NOT NULL""", 100)
            row_idx = 0

        if len(sample_rows) == 0:
            table_columns.remove(col)
            continue

        val = sample_rows[row_idx][col_idx]
        break

    if len(table_columns) == 0:
        args.logger.warning("CANNOT ADD PREDICATE ANYMORE")
        assert False
        # return False, None, None, None

    other_vals = [
        row[col_idx]
        for row in sample_rows
        if row[col_idx] is not None and row[col_idx] != "null" and row[col_idx] != val
    ]
    if len(other_vals) == 0:
        return False, None, None, None

    if is_id_column(args, col, join_key_list):  # Not generate any condition using id/hash code/note columns
        args.logger.error("Please set join_key_pred = False")
        assert False

    if dtype_dict[col] == "str":
        v = str(val).strip()

        # (FIX C3) NO =, !=, IN, NOT IN operators for hash codes and notes
        if is_note_column(args, col):
            op = rng.choice(NOTE_OPERATORS, p=NOTE_OPERATORS_PROBABILITY)
        else:
            op = rng.choice(TEXTUAL_OPERATORS, p=TEXTUAL_OPERATORS_PROBABILITY)
            if op in ("IN", "NOT IN") and len(other_vals) == 0:
                op = "=" if op == "IN" else "NOT IN"

        v = get_str_op_values(
            op,
            v,
            other_vals,
            rng,
            num_word_in_like_max=args.hyperparams["num_word_in_like_max"],
            num_in_max=args.hyperparams["num_in_max"],
        )

        if op in ["IN", "NOT IN"]:
            v, num_val = v
            if num_val <= 1:
                op = "=" if op == "IN" else "!="
                v = v[1:-1]
                val = f"""{v}"""
            else:
                val = v
        else:
            val = f"""\'{v}\'"""
    else:
        # (FIX #4) Not choose lte, lt, gte, gt for key column or boolean column
        if col in join_key_list or dtype_dict[col] == "bool":
            op = rng.choice(KEY_OPERATORS, p=KEY_OPERATORS_PROBABILITY)
        else:
            op = rng.choice(NUMERIC_OPERATORS, p=NUMERIC_OPERATORS_PROBABILITY)

        if op not in ("=", "!="):
            is_range = rng.choice([0, 1], p=[0.8, 0.2])
            if is_range:
                val_idx2 = rng.randint(0, len(other_vals))
                v = other_vals[val_idx2]

                if dtype_dict[col] == "date":
                    v_comp = get_date_time(v)
                    val_comp = get_date_time(val)
                else:
                    v_comp = v
                    val_comp = val

                if op in [">", ">="]:
                    op2 = rng.choice(["<", "<="])
                else:
                    op2 = rng.choice([">", ">="])

                if (
                    v_comp == val_comp
                    or (
                        dtype_dict[col] == "int"
                        and abs(v_comp - val_comp) == 1
                        and (op in ("<", ">") or op2 in ("<", ">"))
                    )
                    or (
                        dtype_dict[col] == "int"
                        and abs(v_comp - val_comp) == 2
                        and (op in ("<", ">") and op2 in ("<", ">"))
                    )
                ):
                    op = "="
                else:
                    if op in [">", ">="]:
                        op = (op, op2)
                    else:
                        op = (op2, op)
                    if v_comp < val_comp:
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
    data_manager,
    inner_join_view_name,
    used_tables,
    grouping_query_elements,
    prefix,
):
    min_pred_num = args.hyperparams["num_having_min"]
    max_pred_num = args.hyperparams["num_having_max"]

    # grouping_query_elements["agg_cols"]
    # grouping_query_elements["necessary_tables"]

    # # When we aggregate the data, we need to project full_outer_joined_view to inner_joined_view --> HOW TO DO THIS
    # ADD NOT NULL CONDITION AND THEN DISTINCT

    grouping_query_selects = []
    for agg_col in grouping_query_elements["agg_cols"]:
        agg = agg_col[0]
        col = agg_col[1]
        if agg == "NONE":
            col_ref = col.replace(".", "__")
            alias = col_ref
        else:
            col_ref = agg + "(" + col.replace(".", "__") + ")"
            alias = agg + "__" + col.replace(".", "__").replace("*", "star")
        grouping_query_selects.append(col_ref + " AS " + alias)
    grouping_query_select_string = ", ".join(grouping_query_selects)

    grouping_query_string = f"""SELECT DISTINCT {grouping_query_select_string} FROM {inner_join_view_name}"""

    grouping_query_groups = []
    for group_col in grouping_query_elements["group_columns"]:
        col_ref = group_col.replace(prefix, "").replace(".", "__")
        grouping_query_groups.append(col_ref)
    grouping_query_group_string = ", ".join(grouping_query_groups)

    grouping_query_string += f""" GROUP BY {grouping_query_group_string}"""

    dnf_idx = -1
    having_original_view_name = get_view_name("having_generator", [args.fo_view_name, prefix, "origin", 0])
    data_manager.create_view(
        args.logger, having_original_view_name, grouping_query_string, type="materialized", drop_if_exists=True
    )
    view_names = [having_original_view_name]

    current_view_name = having_original_view_name
    previous_view_name = ""

    having_candidate_columns_origin = [
        table_column
        for table_column in table_columns
        if table_column not in list(group_columns)
        and table_column.split(".")[0] in grouping_query_elements["necessary_tables"]
        and dtype_dict[table_column] not in ["bool", "str"]
        and is_id_column(args, col, join_key_list)
    ] + ["*"]

    having_original_view_column_names = data_manager.fetch_column_names(having_original_view_name)
    having_candidate_columns = []
    for col in having_candidate_columns_origin:
        col_ref = col.replace(".", "__")
        agg_col_ref = f"COUNT__{col_ref}".replace("*", "star").lower()
        agg_col_idx = having_original_view_column_names.index(agg_col_ref)

        count_dvs = data_manager.fetch_distinct_values(having_original_view_name, agg_col_ref)
        if len(count_dvs) > 1:
            having_candidate_columns.append(col)

    if len(having_candidate_columns) == 0:
        for idx in range(len(view_names)):
            data_manager.drop_view(args.logger, view_names[len(view_names) - idx - 1], type="materialized")
        args.logger.warning("No candidate column for having; restart generation")
        raise Exception("Cannot generate having clause")

    num_predicate = rng.randint(min_pred_num, min(len(having_candidate_columns), max_pred_num) + 1)

    tree_predicates = build_predicate_tree_dnf(args, rng, [[x] for x in range(num_predicate)])
    tree_predicates, _ = renumbering_tree_predicates(tree_predicates, 0)
    tree_predicates_origin = copy.deepcopy(tree_predicates)
    if len(tree_predicates) == 1:
        tree_predicates.append(False)
    else:
        split_predicate_tree_with_condition_dnf(tree_predicates)
    flatten_tree = flatten_condition_predicate_tree(tree_predicates)
    sorted_conditions = sorted(flatten_tree, key=lambda x: x[0])

    continue_cnt = 0
    cond_idx = 0
    predicates = [None] * num_predicate
    predicates_origin = [None] * num_predicate
    visited_columns = []
    visited_agg_col = {}

    clauses_op_val = []
    clauses_view_predicates = []
    subset_clauses = []

    updated_cond = True
    while cond_idx < num_predicate:
        if continue_cnt > 100:
            for idx in range(len(view_names)):
                data_manager.drop_view(args.logger, view_names[len(view_names) - idx - 1], type="materialized")
            args.logger.warning("Too many continue during having predicate generation")
            raise Exception("Too many continue during having predicate generation")

        result_condition = sorted_conditions[cond_idx][1]
        if updated_cond:
            previous_view_name = copy.deepcopy(current_view_name)
            if not result_condition:
                dnf_idx += 1
                current_view_name = get_view_name(
                    "having_generator", [args.fo_view_name, prefix, dnf_idx, cond_idx]
                )  # dnf idx
                if dnf_idx != 0:
                    where_clauses = ["( " + " AND ".join(predicate) + " )" for predicate in clauses_view_predicates]
                    view_sql_where = "NOT (" + " OR ".join(where_clauses) + ")"
                    view_sql = f"""SELECT DISTINCT * FROM {having_original_view_name} WHERE {view_sql_where}"""
                else:
                    view_sql = f"""SELECT DISTINCT * FROM {having_original_view_name}"""

                data_manager.create_view(
                    args.logger, current_view_name, view_sql, type="materialized", drop_if_exists=True
                )
                view_names.append(current_view_name)

                if data_manager.get_row_counts(current_view_name) <= 1:
                    for idx in range(len(view_names)):
                        data_manager.drop_view(args.logger, view_names[len(view_names) - idx - 1], type="materialized")
                    args.logger.warning("Previous having conditions cover almost all rows; regenerate query")
                    raise Exception(
                        "[having generator] Previous having conditions cover almost all rows; regenerate query"
                    )

                visited_columns = []
                visited_agg_col = {}
                clauses_op_val.append([])
                clauses_view_predicates.append([])
                subset_clauses = [idx for idx in range(len(clauses_op_val[:-1]))]
            else:
                if dnf_idx < 0:
                    args.logger.error("This cannot be happend")
                assert dnf_idx >= 0
                current_view_name = get_view_name(
                    "having_generator", [args.fo_view_name, prefix, dnf_idx, cond_idx]
                )  # dnf idx
                view_sql_where = " AND ".join(clauses_view_predicates[-1])
                view_sql = f"""SELECT DISTINCT * FROM {previous_view_name} WHERE {view_sql_where}"""

                data_manager.create_view(
                    args.logger, current_view_name, view_sql, type="materialized", drop_if_exists=True
                )
                view_names.append(current_view_name)

        updated_cond = False
        cur_candidate_columns = [col for col in having_candidate_columns if col not in visited_columns]
        column_idx = rng.randint(0, len(cur_candidate_columns))

        col = cur_candidate_columns[column_idx]

        if col == "*":
            if col in visited_agg_col.keys():
                args.logger.error("* cannot be visited more than once")
                assert False
            original_agg_candidates = TEXTUAL_AGGS
        elif (
            dtype_dict[col] in ["bool", "str"]
            or is_id_column(args, col, join_key_list)
            or is_hashcode_column(args, col)
        ):
            args.logger.error("ID or string or code in having? This cannot be possible")
            assert False
        elif dtype_dict[col] == "date":
            original_agg_candidates = DATE_AGGS[1:]
        else:
            original_agg_candidates = NUMERIC_AGGS[1:]

        if col in visited_agg_col.keys():
            agg_candidates = [agg for agg in original_agg_candidates if agg not in visited_agg_col[col]]
        else:
            agg_candidates = original_agg_candidates

        agg = rng.choice(agg_candidates)

        col_ref = col.replace(".", "__")
        agg_col_ref = f"{agg}__{col_ref}".replace("*", "star").lower()
        assert agg_col_ref in having_original_view_column_names
        agg_col_idx = having_original_view_column_names.index(agg_col_ref)

        # [TODO] get sample
        sample_rows, sample_schema = data_manager.sample_rows(current_view_name, 100)
        col_idx = agg_col_idx
        row_idx = 0
        # value in agg_col must not be null
        if len(sample_rows) <= 1:
            args.logger.warning("Generating a query is impossible; # of sampled rows is 0 or 1; restart generation")
            for idx in range(len(view_names)):
                data_manager.drop_view(args.logger, view_names[len(view_names) - idx - 1], type="materialized")
            raise Exception("")

        val = sample_rows[row_idx][col_idx]

        if val is None or val == "null":
            args.logger.error("This cannot be happend")

        assert val is not None and val != "null"

        other_vals = [
            row[col_idx]
            for row in sample_rows
            if row[col_idx] is not None and row[col_idx] != "null" and row[col_idx] != val
        ]
        # dvs = data_manager.fetch_all_distinct_values(current_view_name, agg_col_ref) # make it faster by using samples
        dvs = set(other_vals)
        if len(other_vals) == 0:
            continue_cnt += 1
            continue

        new_dtype = None
        if agg in ["NONE", "MAX", "MIN", "AVG", "SUM"]:
            if col == "*":
                args.logger.error("This is impossible")
                assert False
            new_dtype = dtype_dict[col]
        else:
            new_dtype = "int"

        val_stored = val

        if new_dtype in ["bool", "str"]:
            args.logger.error("It can't be string or boolean type column")
            assert False
        else:
            op = rng.choice(NUMERIC_OPERATORS, p=NUMERIC_OPERATORS_PROBABILITY)
            if len(dvs) < 2:
                continue_cnt += 1
                continue
            if op not in ("=", "!="):
                is_range = rng.choice([0, 1], p=[0.8, 0.2])
                if is_range:
                    val_idx2 = rng.randint(0, len(other_vals))
                    v = other_vals[val_idx2]

                    if col != "*" and dtype_dict[col] == "date":
                        v_comp = get_date_time(v)
                        val_comp = get_date_time(val)
                    else:
                        v_comp = v
                        val_comp = val

                    if op in [">", ">="]:
                        op2 = rng.choice(["<", "<="])
                    else:
                        op2 = rng.choice([">", ">="])

                    if (
                        v_comp == val_comp
                        or (
                            new_dtype == "int"
                            and abs(v_comp - val_comp) == 1
                            and (op in ("<", ">") or op2 in ("<", ">"))
                        )
                        or (
                            new_dtype == "int"
                            and abs(v_comp - val_comp) == 2
                            and (op in ("<", ">") and op2 in ("<", ">"))
                        )
                    ):
                        is_range = False
                    else:
                        if op in [">", ">="]:
                            op = (op, op2)
                        else:
                            op = (op2, op)
                        if v_comp < val_comp:
                            v = (v, val)
                        else:
                            v = (val, v)
                else:
                    v = val
            else:
                v = val

            val_stored = v
            if new_dtype == "int":
                if isinstance(op, tuple):
                    val_stored = (int(v[0]), int(v[1]))
                else:
                    val_stored = int(v)
            else:
                val_stored = v

        # EVAL op val

        satisfied = False
        unsatisfied = False

        for other_val in dvs:
            if isinstance(op, tuple):
                if col != "*" and dtype_dict[col] == "date":
                    other_val_comp = get_date_time(other_val)
                    val_stored_comp = (get_date_time(val_stored[0]), get_date_time(val_stored[1]))
                else:
                    other_val_comp = other_val
                    val_stored_comp = val_stored
                eval_string = f"""  {other_val_comp} {op[0]} {val_stored_comp[0]} and {other_val_comp} {op[1]} {val_stored_comp[1]} """
            else:
                if op == "=":
                    op_eval = "=="
                else:
                    op_eval = op
                if col != "*" and dtype_dict[col] == "date":
                    other_val_comp = get_date_time(other_val)
                    val_stored_comp = get_date_time(val_stored)
                else:
                    other_val_comp = other_val
                    val_stored_comp = val_stored
                eval_string = f""" {other_val_comp} {op_eval} {val_stored_comp} """
            result = eval(eval_string)
            if result:
                satisfied = True
            else:
                unsatisfied = True
            if satisfied and unsatisfied:
                break
        if not (satisfied and unsatisfied):
            continue_cnt += 1
            continue

        if agg == "NONE":
            args.logger.error("This cannot be happend")
        assert agg != "NONE"

        if isinstance(op, tuple):
            query_predicate = view_predicate_generator(
                prefix, agg_col_ref, op, (str(val_stored[0]), str(val_stored[1])), new_dtype
            )
        else:
            query_predicate = view_predicate_generator(prefix, agg_col_ref, op, str(val_stored), new_dtype)

        original_row_count = data_manager.get_row_counts(current_view_name)

        where_clause = f"WHERE {query_predicate}"
        updated_row_count = data_manager.get_row_counts(current_view_name, where_clause)

        if original_row_count == updated_row_count or updated_row_count == 0:
            continue_cnt += 1
            continue

        # Check if current clause is a superset of another clause
        if len(subset_clauses) > 0:
            removed_subset_clauses = []
            for clause_idx in subset_clauses:
                colA, opA, valA = None, None, None
                for colAr, opAr, valAr in clauses_op_val[clause_idx]:
                    if agg + "(" + col + ")" == colA:
                        colA, opA, valA = colAr, opAr, valAr
                        break
                if colA == None:
                    removed_subset_clauses.append(clause_idx)
                    continue
                if not check_condB_contain_condA(colA, opA, valA, new_dtype, col, op, val, new_dtype, args):
                    removed_subset_clauses.append(clause_idx)
                    continue
            if len(subset_clauses) - len(removed_subset_clauses) > 0 and (
                cond_idx == num_predicate - 1 or sorted_conditions[cond_idx + 1][1] == False
            ):
                continue_cnt += 1
                continue
            subset_clauses = [cidx for cidx in subset_clauses if cidx not in removed_subset_clauses]

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
            if dtype_dict[col] == "date":
                predicates[cond_idx] = agg + "(" + prefix + col + ") " + op + " " + f"""'{val_stored}'::date"""
            else:
                predicates[cond_idx] = agg + "(" + prefix + col + ") " + op + " " + str(val_stored)
            # predicates[cond_idx] = agg + "(" + prefix + col + ") " + op + " " + str(val_stored)
        predicate_tuple_origin = (prefix, agg, col, op, str(val_stored))
        predicates_origin[cond_idx] = predicate_tuple_origin
        clauses_op_val[-1].append((agg + "(" + col + ")", op, val))

        clauses_view_predicates[-1].append(query_predicate)

        if col in visited_agg_col.keys():
            visited_agg_col[col].append(agg)
        else:
            visited_agg_col[col] = [agg]
        if len(visited_agg_col[col]) == len(original_agg_candidates):
            visited_columns.append(col)

        if col != "*":
            used_tables.add(col.split(".")[0])
        updated_cond = True
        cond_idx += 1

    for idx in range(len(view_names)):
        data_manager.drop_view(args.logger, view_names[len(view_names) - idx - 1], type="materialized")
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
    data_manager,
    original_view_name,
    used_tables,
    prefix,
    chosen_inner_queries=None,
    num_nested_predicates=0,
    inner_query_objs=None,
    inner_query_graphs=None,
):
    min_pred_num = args.hyperparams["num_pred_min"]
    max_pred_num = args.hyperparams["num_pred_max"]

    if len(table_columns) == 0:
        args.logger.warning("No candidate column for where; restart generation")
        assert False

    max_pred_num = min(len(table_columns), max_pred_num)

    num_predicates = rng.randint(min_pred_num, max_pred_num + 1) + num_nested_predicates
    num_nonnest_predicates = num_predicates - num_nested_predicates

    tree_predicates = build_predicate_tree_dnf(args, rng, [[x] for x in range(num_predicates)])
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

    inner_queries_for_each_clauses = []
    temp_nest_idx = 0
    for idx, cond in enumerate(sorted_conditions):
        if cond[1] == False:
            inner_queries_for_each_clauses.append([])
        if nest_or_not[idx]:
            inner_queries_for_each_clauses[-1].append(temp_nest_idx)
            temp_nest_idx += 1

    predicates = [None] * num_predicates
    predicates_origin = [None] * num_predicates
    nested_predicates_graphs = {}
    correlation_predicates_origin = []

    if prefix is None:
        args.logger.error("This cannot be happend")
    assert prefix is not None

    dnf_idx = -1
    current_view_name = original_view_name
    previous_view_name = ""
    previous_clause_view_name = original_view_name
    EXCEPT_STATEMENT = ""

    continue_cnt = 0
    current_nonnest_idx = 0
    current_nested_idx = 0
    cond_idx = 0

    visited_columns = []
    clauses_op_val = []
    clauses_view_predicates = []
    clauses_view_predicates_origin = []
    subset_clauses = []

    view_names = []

    updated_cond = True
    nesting_type_origin = get_initial_nesting_types(args)
    nesting_position_origin = get_initial_nesting_positions(args)

    while cond_idx < num_predicates:
        if continue_cnt > 100:
            for idx in range(len(view_names)):
                data_manager.drop_view(args.logger, view_names[len(view_names) - idx - 1], type="materialized")
            args.logger.warning("Too many continue during where predicate generation")
            raise Exception("[where generator] Too many continue during where predicate generation")

        result_condition = sorted_conditions[cond_idx][1]  # AND/OR
        if updated_cond:
            previous_view_name = copy.deepcopy(current_view_name)
            if not result_condition:
                dnf_idx += 1
                current_view_name = get_view_name(
                    "where_generator", [original_view_name, prefix, dnf_idx, cond_idx]
                )  # dnf idx
                if dnf_idx != 0:
                    view_sql_where = clauses_view_predicates[-1][-1]
                    EXCEPT_STATEMENT = f"""SELECT DISTINCT * FROM {previous_clause_view_name} EXCEPT SELECT DISTINCT * FROM {previous_view_name} WHERE {view_sql_where}"""
                    # where_clauses = ["( " + " AND ".join(predicates) + " )" for predicates in clauses_view_predicates]
                    # view_sql_where = "NOT (" + " OR ".join(where_clauses) + ")"
                    # view_sql = f"""SELECT * FROM {original_view_name} WHERE {view_sql_where}"""
                    view_sql = EXCEPT_STATEMENT
                else:
                    view_sql = f"""SELECT DISTINCT * FROM {original_view_name}"""
                previous_clause_view_name = copy.deepcopy(current_view_name)

                data_manager.create_view(
                    args.logger, current_view_name, view_sql, type="materialized", drop_if_exists=True
                )
                view_names.append(current_view_name)

                count_rows = data_manager.get_row_counts(current_view_name)
                if count_rows <= 1:
                    for idx in range(len(view_names)):
                        data_manager.drop_view(args.logger, view_names[len(view_names) - idx - 1], type="materialized")

                    args.logger.warning("Selection condition cover almost all rows; regenerate query")
                    raise Exception("[where generator] Selection condition cover almost all rows; regenerate query")

                visited_columns = []
                # Nested query에서 사용되는 column을 candidate column에서 제외
                for idx in inner_queries_for_each_clauses[dnf_idx]:
                    inner_query_idx = chosen_inner_queries[idx]
                    obj = inner_query_objs[inner_query_idx]

                    visited_columns.append(inner_query_objs[idx]["agg_cols"][0][1])

                    inner_where = inner_query_objs[idx]["predicates_origin"]
                    for operation in inner_where:
                        col = operation[1]
                        if col is not None:
                            visited_columns.append(col)

                clauses_op_val.append([])
                clauses_view_predicates.append([])
                clauses_view_predicates_origin.append([])
                subset_clauses = [idx for idx in range(len(clauses_op_val[:-1]))]
            else:
                if dnf_idx < 0:
                    args.logger.error("This cannot be happend")
                assert dnf_idx >= 0
                current_view_name = get_view_name(
                    "where_generator", [original_view_name, prefix, dnf_idx, cond_idx]
                )  # dnf idx
                view_sql_where = clauses_view_predicates[-1][-1]
                view_sql = f"""SELECT DISTINCT * FROM {previous_view_name} WHERE {view_sql_where}"""

                data_manager.create_view(
                    args.logger, current_view_name, view_sql, type="materialized", drop_if_exists=True
                )
                view_names.append(current_view_name)

        updated_cond = False

        if not nest_or_not[cond_idx]:
            current_columns = [col for col in table_columns if col not in visited_columns]
            done, col, op, val = non_nested_predicate_generator(
                args, rng, current_columns, data_manager, current_view_name, dtype_dict, join_key_list
            )
            if not done:
                continue_cnt += 1
                continue

            if isinstance(op, tuple):
                query_predicate = view_predicate_generator(prefix, col, op, (str(val[0]), str(val[1])), dtype_dict[col])
            else:
                query_predicate = view_predicate_generator(prefix, col, op, str(val), dtype_dict[col])

            col_view = col.replace(".", "__")
            original_row_count = data_manager.get_row_counts(current_view_name, f" WHERE {col_view} IS NOT NULL")

            where_clause = f"WHERE {query_predicate}"
            updated_row_count = data_manager.get_row_counts(current_view_name, where_clause)

            if original_row_count == updated_row_count or updated_row_count == 0:
                continue_cnt += 1
                continue

            # Check if current clause is a superset of another clause
            if len(subset_clauses) > 0:
                removed_subset_clauses = get_removed_subset_clauses(
                    subset_clauses, clauses_op_val, col, op, val, dtype_dict, args
                )

                if len(subset_clauses) - len(removed_subset_clauses) > 0 and (
                    cond_idx == num_predicates - 1 or sorted_conditions[cond_idx + 1][1] == False
                ):
                    continue_cnt += 1
                    continue
                subset_clauses = [cidx for cidx in subset_clauses if cidx not in removed_subset_clauses]

            visited_columns.append(col)
            used_tables.add(col.split(".")[0])
            clauses_op_val[-1].append((col, op, val))
            clauses_view_predicates[-1].append(query_predicate)
            clauses_view_predicates_origin[-1].append(query_predicate)  # SAME FOR NON NESTED QUERIES

            if isinstance(op, tuple):
                additional_pred_idx = len(predicates)
                if dtype_dict[col] == "date":
                    predicate_str2 = prefix + col + " " + op[1] + " " + f"""'{val[1]}'::date"""
                else:
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

            # predicate_str = prefix + col + " " + op + " " + str(val)
            if dtype_dict[col] == "date":
                predicate_str = prefix + col + " " + op + " " + f"""'{val}'::date"""
            else:
                predicate_str = prefix + col + " " + op + " " + str(val)
            predicate_tuple_origin = (prefix, col, op, str(val))
            predicates_origin[cond_idx] = predicate_tuple_origin
            predicates[cond_idx] = predicate_str
            updated_cond = True
            cond_idx += 1
            current_nonnest_idx += 1
        else:
            inner_query_idx = chosen_inner_queries[current_nested_idx]
            obj = inner_query_objs[inner_query_idx]

            done, nesting_type = nesting_type_selector(args, rng, obj, nesting_type_origin)
            if not done:
                args.logger.warning("Cannot use the given nested query; restart generating query")
                assert False
            done, nesting_position = nesting_position_selector(
                args, rng, nesting_type, join_key_list, obj, nesting_position_origin[nesting_type]
            )
            if not done:
                nesting_type_origin.remove(nesting_type)
                continue_cnt += 1
                continue

            (
                done,
                nested_predicate,
                used_tables_nested,
                nested_predicate_graph,
                nested_predicate_origin,
                correlation_predicate_origin,
                inner_view_query,
                inner_view_query_origin,
            ) = nested_predicate_generator(
                args,
                rng,
                table_columns,
                table_columns_projection,
                dtype_dict,
                join_key_list,
                all_table_set,
                join_clause_list,
                data_manager,
                current_view_name,
                prefix,
                nesting_position,
                nesting_type,
                obj,
                inner_query_graphs[inner_query_idx],
            )
            if not done:
                nesting_position_origin[nesting_type].remove(nesting_position)
                continue_cnt += 1
                continue

            query_predicate = view_predicate_generator(
                nested_predicate_origin[0],
                nested_predicate_origin[1],
                nested_predicate_origin[2],
                nested_predicate_origin[3],
                None,
                is_nested=True,
                inner_view_query=inner_view_query,
            )

            query_predicate_origin = view_predicate_generator(
                nested_predicate_origin[0],
                nested_predicate_origin[1],
                nested_predicate_origin[2],
                nested_predicate_origin[3],
                None,
                is_nested=True,
                inner_view_query=inner_view_query_origin,
            )

            clauses_view_predicates[-1].append(query_predicate)
            clauses_view_predicates_origin[-1].append(query_predicate_origin)

            if correlation_predicate_origin:
                correlation_predicates_origin.append(correlation_predicate_origin)

            used_tables = used_tables.union(used_tables_nested)
            inner_prefix = get_prefix(obj["nesting_level"], obj["unique_alias"])
            nested_predicates_graphs[inner_prefix] = nested_predicate_graph
            predicates[cond_idx] = nested_predicate
            predicates_origin[cond_idx] = nested_predicate_origin
            updated_cond = True
            cond_idx += 1
            current_nested_idx += 1
            nesting_type_origin = get_initial_nesting_types(args)
            nesting_position_origin = get_initial_nesting_positions(args)

    for idx in range(len(view_names)):
        data_manager.drop_view(args.logger, view_names[len(view_names) - idx - 1], type="materialized")

    tree_predicates = restore_predicate_tree(tree_predicates, predicates)

    ## CORRELATION PREDICATE.... original_view_name.id =

    where_clauses = ["( " + (" AND ".join(predicates)) + " )" for predicates in clauses_view_predicates_origin]
    view_sql_where = "(" + " OR ".join(where_clauses) + ")"
    final_view_name = get_view_name("where_generator", [original_view_name, prefix, "f", "f"])
    view_sql = f"""SELECT DISTINCT * FROM {original_view_name} WHERE {view_sql_where}"""
    data_manager.create_view(args.logger, final_view_name, view_sql, type="materialized", drop_if_exists=True)
    where_view_predicate_string = view_sql_where

    return (
        tree_predicates,
        nested_predicates_graphs,
        used_tables,
        tree_predicates_origin,
        predicates_origin,
        correlation_predicates_origin,
        final_view_name,
        where_view_predicate_string,
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
    data_manager,
    view_name,
    prefix,
    nesting_position,
    nesting_type,
    inner_query_obj,
    inner_query_graph,
):
    used_tables = set()
    nesting_col = None
    continue_cnt = 0
    done = False
    nested_predicate_origin = tuple()
    correlation_column = None
    correlation_predicate_origin = None
    group_result = []
    other_vals = []

    col_in_view = inner_query_obj["agg_cols"][0][1].replace(".", "__")
    if col_in_view == "*":
        dvs = None
    else:
        dvs = set(data_manager.fetch_distinct_values(view_name, col_in_view))
    val = None
    cor_val = None
    cor_dvs = None
    group_result = None
    other_vals = None

    if nesting_type in ["type-n", "type-a"]:
        (
            inner_query,
            inner_query_result,
            correlation_predicate_origin,
            inner_view_query,
            inner_view_query_origin,
        ) = inner_query_obj_to_inner_query(
            args,
            data_manager,
            rng,
            inner_query_obj,
            dtype_dict,
            prefix,
            view_name,
        )
        assert nesting_position in (0, 1)

        if dvs is None:
            args.logger.error("This cannot be happened")
            assert False

        if len(inner_query_result) == 0:
            args.logger.error("Generating a query is impossible; inner query returns an empty table")
            assert False

        if (nesting_position == 0 and len(inner_query_result) != 1) or (
            (nesting_position == 1 and (len(inner_query_result) < 2 or dvs.issubset(set(inner_query_result))))
        ):
            args.logger.warning("Fail to find any possible correlated column")
            return False, None, None, None, None, None, None, None

        if nesting_position == 1:
            sample_rows, sample_schema = data_manager.sample_rows(view_name, 100)
            col_idx = -1
            for idx, col2 in enumerate(sample_schema):
                if col2 == col_in_view:
                    col_idx = idx
                    break
            # Find not null value
            val = None
            row_idx = -1
            for idx, sample_row in enumerate(sample_rows):
                if sample_rows[idx][col_idx] is None or sample_rows[idx][col_idx] == "null":
                    continue
                else:
                    row_idx = idx
                    break

            if row_idx == -1:
                sample_rows, _ = data_manager.sample_rows_with_cond(view_name, f"""{col_in_view} IS NOT NULL""", 100)
                row_idx = 0

            if len(sample_rows) == 0:
                args.logger.error("Generating a query is impossible; all values of inner query column are NULL")
                assert False

            val = sample_rows[row_idx][col_idx]
            cor_val = None
            group_result = inner_query_result
    else:
        inner_query_tables = inner_query_obj["tables"]
        select_column = inner_query_obj["agg_cols"][0][1]
        # [TODO] Join key column의 경우 둘 중 하나만 candidate에 넣어야 하는 게 아닌지
        inner_query_columns = [
            table_column
            for table_column in table_columns
            if table_column.split(".")[0] in inner_query_tables
            and table_column != select_column
            and (is_correlatable_column(args, table_column))
        ]

        while len(inner_query_columns) > 0:
            correlation_column = rng.choice(inner_query_columns)
            (
                inner_query,
                inner_query_result,
                correlation_predicate_origin,
                inner_view_query,
                inner_view_query_origin,
            ) = inner_query_obj_to_inner_query(
                args,
                data_manager,
                rng,
                inner_query_obj,
                dtype_dict,
                prefix,
                view_name,
                correlation_column=correlation_column,
            )

            cor_col_in_view = correlation_column.replace(".", "__")
            cor_dvs = data_manager.fetch_distinct_values(view_name, cor_col_in_view)
            if dvs is None:
                dvs = cor_dvs

            if len(inner_query_result) < 2:  # group size is less than 2
                inner_query_columns.remove(correlation_column)
                continue

            not_empty_groups = []
            selective_groups = []
            empty_groups = []
            data_vals = set()
            for group, data in inner_query_result:
                if len(data) < 1:
                    empty_groups.append(group)
                else:
                    not_empty_groups.append(group)
                    if nesting_position == 1 and not dvs.issubset(set(data)):
                        selective_groups.append(group)
                    if nesting_position in (0, 3):
                        if len(data) > 1:
                            args.logger.error("This cannot be happend")
                            assert False
                    if nesting_position == 3:
                        data_vals.add(data[0])
            if nesting_position == 2 and len(empty_groups) == 0:  # ALWAYS EXISTS
                inner_query_columns.remove(correlation_column)
                continue
            if nesting_position == 2 and len(not_empty_groups) == 0:  # ALWAYS NOT EXISTS
                inner_query_columns.remove(correlation_column)
                continue

            if nesting_position == 1 and len(selective_groups) == 0:  # We need a selective group
                inner_query_columns.remove(correlation_column)
                continue

            if nesting_position == 3:
                if len(data_vals) <= 1:
                    inner_query_columns.remove(correlation_column)
                    continue
            if nesting_position == 0 and len(not_empty_groups) == 0:
                inner_query_columns.remove(correlation_column)
                continue

            if nesting_position == 2:
                pass
            elif nesting_position == 1:
                cor_val = None
                val = None
                while len(selective_groups) > 0:
                    cor_val = rng.choice(selective_groups)
                    cor_col_predicate = view_predicate_generator(
                        prefix, correlation_column, "=", cor_val, dtype_dict[correlation_column]
                    )

                    sample_cond = f"""{col_in_view} is not null and {cor_col_predicate}"""
                    sample_rows, _ = data_manager.sample_rows_with_cond(view_name, sample_cond, 100)

                    vals = [datum[0] for datum in sample_rows]
                    if len(vals) == 0:
                        selective_groups.remove(cor_val)
                        continue
                    val = rng.choice(vals)
                    break

                if val is None:
                    inner_query_columns.remove(correlation_column)
                    continue

                for group, data in inner_query_result:
                    if group == cor_val:
                        group_result = data
                        break
            elif nesting_position == 0:
                col = inner_query_obj["agg_cols"][0][1]  # col
                if col == "*":
                    args.logger.error("This is impossible")
                    assert False

                if nesting_type in ["type-a", "type-ja"] and dtype_dict[col] == "str":
                    args.logger.error("This should not be happend")
                    assert False
                if nesting_type in ["type-a", "type-ja"] and col not in table_columns_except_id:
                    args.logger.error("This should not be happend")
                    assert False

                if dtype_dict[col] == "str" and nesting_type not in ["type-a", "type-ja"]:
                    op = "="
                elif dtype_dict[col] == "bool" and nesting_type not in ["type-a", "type-ja"]:
                    op = "="
                else:
                    op = ">"

                query_predicate = view_predicate_generator(
                    prefix,
                    col,
                    op,
                    None,
                    None,
                    is_nested=True,
                    inner_view_query=inner_view_query,
                )

                col_view = col.replace(".", "__")
                not_null_query_predicate = f" {col_view} IS NOT NULL"
                cor_col_view = correlation_column.replace(".", "__")
                not_null_query_predicate += f" AND {cor_col_view} IS NOT NULL"
                original_row_count = data_manager.get_row_counts(view_name, f" WHERE {not_null_query_predicate}")

                where_clause = f"WHERE {query_predicate} AND {not_null_query_predicate}"
                updated_row_count = data_manager.get_row_counts(view_name, where_clause)

                if original_row_count == updated_row_count or updated_row_count == 0:
                    inner_query_columns.remove(correlation_column)
                    continue
                pass
            else:  # 3
                other_vals = list(data_vals)
                val = rng.choice(other_vals)

                if val is None:
                    args.logger.error("This cannot be happend")
                    assert False
            break

        if len(inner_query_columns) < 1:
            args.logger.warning("Fail to find any possible correlated column")
            return False, None, None, None, None, None, None, None

    inner_obj_stored = {
        "agg_cols": inner_query_obj["agg_cols"],
        "nesting_level": inner_query_obj["nesting_level"],
        "unique_alias": inner_query_obj["unique_alias"],
        "tables": inner_query_obj["tables"],
    }
    while not done:
        if continue_cnt > 100:
            args.logger.warning("Too many continue during generating a single nested predicate")
            return False, None, None, None, None, None, None, None

        if nesting_position == 0:
            col = inner_query_obj["agg_cols"][0][1]  # col

            # (FIX #5) Non-textual column for type-a, type-ja nested query
            # for <col> <op> <inner query> form
            if col == "*":
                args.logger.error("This is impossible")
                assert False

            if nesting_type in ["type-a", "type-ja"] and dtype_dict[col] == "str":
                args.logger.error("This should not be happend")
                assert False
            if nesting_type in ["type-a", "type-ja"] and col not in table_columns_except_id:
                args.logger.error("This should not be happend")
                assert False

            if dtype_dict[col] == "str" and nesting_type not in ["type-a", "type-ja"]:
                sum_p = sum(TEXTUAL_OPERATORS_PROBABILITY[0:2])
                op = rng.choice(TEXTUAL_OPERATORS[0:2], p=[i / sum_p for i in TEXTUAL_OPERATORS_PROBABILITY[0:2]])
            elif dtype_dict[col] == "bool" and nesting_type not in ["type-a", "type-ja"]:
                op = rng.choice(KEY_OPERATORS, p=KEY_OPERATORS_PROBABILITY)
            else:
                op = rng.choice(NUMERIC_OPERATORS, p=NUMERIC_OPERATORS_PROBABILITY)

            query_predicate = view_predicate_generator(
                prefix,
                col,
                op,
                None,
                None,
                is_nested=True,
                inner_view_query=inner_view_query,
            )

            col_view = col.replace(".", "__")
            not_null_query_predicate = f" {col_view} IS NOT NULL"
            if correlation_column is not None:
                cor_col_view = correlation_column.replace(".", "__")
                not_null_query_predicate += f" AND {cor_col_view} IS NOT NULL"
            original_row_count = data_manager.get_row_counts(view_name, f" WHERE {not_null_query_predicate}")

            where_clause = f"WHERE {query_predicate} AND {not_null_query_predicate}"
            updated_row_count = data_manager.get_row_counts(view_name, where_clause)

            if original_row_count == updated_row_count or updated_row_count == 0:
                if op in ("=", ">", "<"):
                    args.logger.warning("We cannot generate a predicate (col) (op) ( SELECT .. ) ")
                    return False, None, None, None, None, None, None, None
                if dtype_dict[col] in ("str", "bool") and nesting_type not in ["type-a", "type-ja"]:
                    args.logger.warning("We cannot generate a predicate (col) (op) ( SELECT .. ) ")
                    return False, None, None, None, None, None, None, None

                continue_cnt += 1
                continue

            if correlation_column is not None:
                used_tables.add(correlation_column.split(".")[0])
            used_tables.add(col.split(".")[0])
            predicate_str = prefix + col + " " + op + " (" + inner_query + ")"
            nested_predicate_origin = tuple([prefix, col, op, "(" + inner_query + ")", inner_obj_stored])
            nesting_col = col
            done = True

        elif nesting_position == 1:
            col = inner_query_obj["agg_cols"][0][1]  # col

            if correlation_column and col == correlation_column:
                args.logger.error("This should not be happend")
                assert False

            op = rng.choice(["IN", "NOT IN"], p=[0.8, 0.2])

            if col == "*":
                args.logger.error("This is impossible")
                assert False

            if dtype_dict[col] == "str":
                val_ref = f"""\'{val}\'"""
            else:
                val_ref = val
            if not eval(f""" {val_ref} {op.lower()} {group_result} """):
                if op == "IN":
                    op = "NOT IN"
                else:
                    op = "IN"

            if not eval(f""" {val_ref} {op.lower()} {group_result} """):
                args.logger.error("This cannot be happend")
                assert False

            query_predicate = view_predicate_generator(
                prefix,
                col,
                op,
                None,
                None,
                is_nested=True,
                inner_view_query=inner_view_query,
            )

            col_view = col.replace(".", "__")
            not_null_query_predicate = f" {col_view} IS NOT NULL"
            if correlation_column is not None:
                cor_col_view = correlation_column.replace(".", "__")
                not_null_query_predicate += f" AND {cor_col_view} IS NOT NULL"
            original_row_count = data_manager.get_row_counts(view_name, f" WHERE {not_null_query_predicate}")

            where_clause = f"WHERE {query_predicate} AND {not_null_query_predicate}"
            updated_row_count = data_manager.get_row_counts(view_name, where_clause)

            if original_row_count == updated_row_count or updated_row_count == 0:
                continue_cnt += 1
                continue

            if correlation_column is not None:
                used_tables.add(correlation_column.split(".")[0])
            used_tables.add(col.split(".")[0])
            predicate_str = prefix + col + " " + op + " (" + inner_query + ")"
            nested_predicate_origin = tuple([prefix, col, op, "(" + inner_query + ")", inner_obj_stored])
            nesting_col = col
            done = True

        elif nesting_position == 2:
            op = rng.choice(["EXISTS", "NOT EXISTS"], p=[0.8, 0.2])

            query_predicate = view_predicate_generator(
                None,
                None,
                op,
                None,
                None,
                is_nested=True,
                inner_view_query=inner_view_query,
            )

            cor_col_view = correlation_column.replace(".", "__")
            not_null_query_predicate = f" {cor_col_view} IS NOT NULL"
            original_row_count = data_manager.get_distinct_value_counts(
                view_name, cor_col_view, f" WHERE {not_null_query_predicate} "
            )

            where_clause = f"WHERE {query_predicate} AND {not_null_query_predicate}"
            updated_row_count = data_manager.get_distinct_value_counts(
                view_name, cor_col_view, f" WHERE {not_null_query_predicate}"
            )

            if original_row_count == updated_row_count or updated_row_count == 0:
                continue_cnt += 1
                continue

            predicate_str = op + " (" + inner_query + ")"
            nested_predicate_origin = tuple([None, None, op, "(" + inner_query + ")", inner_obj_stored])
            if correlation_column is not None:
                used_tables.add(correlation_column.split(".")[0])
            done = True

        elif nesting_position == 3:
            col = inner_query_obj["agg_cols"][0][1]  # col

            if nesting_type in ["type-a", "type-ja"]:
                if inner_query_obj["agg_cols"][0][0] == "COUNT":
                    new_dtype = "int"
                else:
                    if col == "*":
                        args.logger.error("This is impossible")
                        assert False
                    new_dtype = dtype_dict[col]
            else:
                if col != "*":
                    new_dtype = dtype_dict[col]
                else:
                    args.logger.error("This cannot be happened")
                    assert False

            if is_note_column(args, col) and new_dtype == "str":
                op = rng.choice(NOTE_OPERATORS, p=NOTE_OPERATORS_PROBABILITY)
            elif "*" not in col and new_dtype == "str":
                op = rng.choice(TEXTUAL_OPERATORS, p=TEXTUAL_OPERATORS_PROBABILITY)
            elif "*" not in col and new_dtype == "bool":
                op = rng.choice(KEY_OPERATORS, p=KEY_OPERATORS_PROBABILITY)
            else:
                op = rng.choice(NUMERIC_OPERATORS, p=NUMERIC_OPERATORS_PROBABILITY)

            if new_dtype == "str":
                v = get_str_op_values(
                    op,
                    val,
                    other_vals,
                    rng,
                    num_word_in_like_max=args.hyperparams["num_word_in_like_max"],
                    num_in_max=args.hyperparams["num_in_max"],
                )

                if op in ["IN", "NOT IN"]:
                    v, num_val = v
                    if num_val <= 1:
                        op = "=" if op == "IN" else "!="
                        v = v[1:-1]
                        val = f"""{v}"""
                    else:
                        val = v
                else:
                    val = f"""\'{v}\'"""
            else:
                if op not in ("=", "!="):
                    is_range = rng.choice([0, 1], p=[0.8, 0.2])
                    if is_range:
                        val_idx2 = rng.randint(0, len(other_vals))
                        v = other_vals[val_idx2]

                        if op in [">", ">="]:
                            op2 = rng.choice(["<", "<="])
                        else:
                            op2 = rng.choice([">", ">="])

                        if new_dtype == "date":
                            v_comp = get_date_time(v)
                            val_comp = get_date_time(val)
                        else:
                            v_comp = v
                            val_comp = val

                        if (
                            v_comp == val_comp
                            or (
                                new_dtype == "int"
                                and abs(v_comp - val_comp) == 1
                                and (op in ("<", ">") or op2 in ("<", ">"))
                            )
                            or (
                                new_dtype == "int"
                                and abs(v_comp - val_comp) == 2
                                and (op in ("<", ">") and op2 in ("<", ">"))
                            )
                        ):
                            op = "="
                        else:
                            if op in [">", ">="]:
                                op = (op, op2)
                            else:
                                op = (op2, op)

                            if v_comp < val_comp:
                                v = (v, val)
                            else:
                                v = (val, v)
                    else:
                        v = val
                else:
                    v = val

                if new_dtype == "int":
                    if isinstance(v, tuple):
                        val = (int(v[0]), int(v[1]))
                    else:
                        val = int(v)
                else:
                    val = v

            query_predicate = view_predicate_generator(
                None,
                f"( {inner_query })",
                op,
                val,
                new_dtype,
                is_nested=True,
                inner_view_query=inner_view_query,
            )

            cor_col_view = correlation_column.replace(".", "__")
            not_null_query_predicate = f" {cor_col_view} IS NOT NULL"
            original_row_count = data_manager.get_row_counts(view_name, f" WHERE {not_null_query_predicate}")

            where_clause = f"WHERE {query_predicate} AND {not_null_query_predicate}"
            updated_row_count = data_manager.get_row_counts(view_name, where_clause)

            if original_row_count == updated_row_count or updated_row_count == 0:
                continue_cnt += 1
                continue

            if new_dtype == "date":
                predicate_str = "(" + inner_query + ") " + op + " " + f"""'{val}'::date"""
            else:
                predicate_str = "(" + inner_query + ") " + op + " " + str(val)

            # predicate_str = "(" + inner_query + ") " + op + " " + str(val)
            nested_predicate_origin = tuple([None, "(" + inner_query + ")", op, str(val), inner_obj_stored])
            if correlation_column is not None:
                used_tables.add(correlation_column.split(".")[0])
            done = True
            break

    if not done:
        return False, None, None, None, None, None, None, None

    query_graph = inner_query_graph

    return (
        True,
        predicate_str,
        used_tables,
        query_graph,
        nested_predicate_origin,
        correlation_predicate_origin,
        inner_view_query,
        inner_view_query_origin,
    )


def group_generator(args, rng, cols, used_tables, dtype_dict, data_manager, current_view_name, prefix):
    min_group, max_group = args.hyperparams["num_group_min"], args.hyperparams["num_group_max"]

    categorical_cols = [col for col in cols if is_categorical_column(args, col)]
    if len(categorical_cols) == 0:
        categorical_cols = []
        for col in cols:
            col_in_view = col.replace(".", "__")
            group_counts = data_manager.get_distinct_value_counts(current_view_name, col_in_view)
            row_counts = data_manager.get_row_counts(current_view_name)
            ratio = group_counts / row_counts
            if group_counts > 1 and ratio < 0.3:  # [TODO] make hyperparameter
                categorical_cols.append(col)

    foreign_keys = [col for col in cols if is_foreign_key(args, col)]
    groupable_cols = categorical_cols + foreign_keys

    if len(groupable_cols) == 0:
        args.logger.warning("CANNOT FIND ANY GROUPING COLUMN... USE ALL")
        groupable_cols = cols

    if len(groupable_cols) == 0:
        args.logger.warning("[group generator] No candidate column for group by")
        assert False
    max_group = min(len(groupable_cols), max_group)

    prob = get_truncated_geometric_distribution(max_group - min_group + 1, 0.8)
    num_group = rng.choice(range(min_group, max_group + 1), p=prob)

    if args.constraints["used_as_inner_query"]:
        num_group = 1
    assert prefix is not None

    columns = rng.choice(groupable_cols, num_group, replace=False)

    columns_with_prefix = [prefix + col for col in columns]

    return columns, columns_with_prefix


def order_generator(
    args,
    rng,
    cols,
    dtype_dict,
    agg_cols,
    group,
    group_columns,
    prefix,
):
    min_order, max_order = args.hyperparams["num_order_min"], args.hyperparams["num_order_max"]
    max_order = min(len(agg_cols), max_order)

    if len(agg_cols) == 0:
        args.logger.error("No candidate column for order by")

    assert len(agg_cols) > 0

    prob = get_truncated_geometric_distribution(max_order - min_order + 1, 0.8)
    num_order = rng.choice(range(min_order, max_order + 1), p=prob)

    columns = []

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
    min_limit, max_limit = args.hyperparams["limit_min"], args.hyperparams["limit_max"]
    num_limit = rng.randint(min_limit, max_limit + 1)

    return num_limit


def inner_query_obj_to_inner_query(
    args,
    data_manager,
    rng,
    inner_query_obj_org,
    dtype_dict,
    prefix,
    current_view_name,
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
    nesting_level = inner_query_obj["nesting_level"]
    unique_alias = inner_query_obj["unique_alias"]
    childs = inner_query_obj["childs"]
    correlation_predicates_origin = inner_query_obj["correlation_predicates_origin"]
    is_having_child = inner_query_obj["is_having_child"]
    inner_join_view_name = inner_query_obj["inner_join_view_name"]

    row_counts = data_manager.get_row_counts(current_view_name)
    if row_counts == 0:
        args.logger.error("This cannot be happend")
    assert row_counts > 0

    # (FIX #12): Make correlation predicate as the top level predicate
    correlation_predicate_origin = None
    prefix_inner = "N" + str(nesting_level) + "_" + str(unique_alias) + "_"

    inner_view_sql_additional_conditions = ""
    if sql_type_dict["group"]:
        if not sql_type_dict["having"]:
            args.logger.error("This cannot be happend")
        assert sql_type_dict["having"]
        group_col_view = [
            group_col.replace(".", "__").replace(prefix_inner, f"{inner_join_view_name}.")
            for group_col in group_columns
        ]
        group_col_view_string = ", ".join(group_col_view)
        inner_view_sql_additional_conditions += f""" GROUP BY {group_col_view_string} """

        having_view = preorder_traverse_to_replace_alias(
            having_predicates, [".", prefix_inner], ["__", f"{inner_join_view_name}."]
        )
        inner_view_sql_additional_conditions += f""" HAVING {having_view} """
    if sql_type_dict["order"]:
        order_col_view = ", ".join(
            [
                order_col.replace(".", "__").replace(prefix_inner, f"{inner_join_view_name}.")
                for order_col in order_columns
            ]
        )
        inner_view_sql_additional_conditions += f""" ORDER BY {order_col_view} """
    if sql_type_dict["limit"]:
        inner_view_sql_additional_conditions += f""" LIMIT {limit_num} """

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
            sql_type_dict["where"] = True

        if use_agg_sel:
            # [TODO] IF use aggregation, we need to convert full outer joined view to inner joined view
            select_col_view = (
                agg_cols[0][0] + "(" + inner_join_view_name + "." + agg_cols[0][1].replace(".", "__") + ")"
            )
        else:
            if agg_cols[0][1] == "*":
                select_col_view = inner_join_view_name + "." + correlation_column.replace(".", "__")
            else:
                select_col_view = inner_join_view_name + "." + agg_cols[0][1].replace(".", "__")

        correlation_col_view = correlation_column.replace(".", "__")
        inner_view_sql = f"""SELECT DISTINCT {select_col_view} FROM {inner_join_view_name} WHERE {inner_join_view_name}.{correlation_col_view} = {current_view_name}.{correlation_col_view} """
        inner_view_sql += inner_view_sql_additional_conditions

        inner_view_sql_origin = f"""SELECT DISTINCT {select_col_view} FROM {inner_join_view_name} WHERE {inner_join_view_name}.{correlation_col_view} = {args.fo_view_name}.{correlation_col_view} """
        inner_view_sql_origin += inner_view_sql_additional_conditions

        inner_query_result = []
        # FOR EACH
        meta_groups = data_manager.fetch_distinct_values(current_view_name, correlation_col_view)
        for group in meta_groups:
            correlation_predicate_view = view_predicate_generator(
                prefix_inner, correlation_column, "=", group, dtype_dict[correlation_column]
            )

            inner_view_sql_group = (
                f"""SELECT DISTINCT {select_col_view} FROM {inner_join_view_name} WHERE {correlation_predicate_view}"""
            )
            inner_view_sql_group += inner_view_sql_additional_conditions

            data_manager.execute(inner_view_sql_group)
            group_result = [datum[0] for datum in data_manager.fetchall()]
            inner_query_result.append([group, group_result])

    else:
        if use_agg_sel:
            select_col_view = (
                agg_cols[0][0] + "(" + inner_join_view_name + "." + agg_cols[0][1].replace(".", "__") + ")"
            )
            # [TODO] When we aggregate the data, we need to project full_outer_joined_view to inner_joined_view --> HOW TO DO THIS
        else:
            if agg_cols[0][1] == "*":
                args.logger.error("This cannot be happend")
                assert False
            select_col_view = inner_join_view_name + "." + agg_cols[0][1].replace(".", "__")
        inner_view_sql = f"""SELECT DISTINCT {select_col_view} FROM {inner_join_view_name}"""
        inner_view_sql += inner_view_sql_additional_conditions

        inner_view_sql_origin = f"""SELECT DISTINCT {select_col_view} FROM {inner_join_view_name}"""
        inner_view_sql_origin += inner_view_sql_additional_conditions

        data_manager.execute(inner_view_sql)
        inner_query_result = [datum[0] for datum in data_manager.fetchall()]

    line = sql_formation(
        args,
        sql_type_dict,
        necessary_tables,
        necessary_joins,
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

    return line, inner_query_result, correlation_predicate_origin, inner_view_sql, inner_view_sql_origin


def finite_query_generation(
    args,
    sql_type_dict,
    necessary_tables,
    necessary_joins,
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
    inner_join_view_name,
    childs,
    child_predicates_graphs=None,
    correlation_predicates_origin=[],
    is_having_child=False,
):
    # dddqqq
    line = sql_formation(
        args,
        sql_type_dict,
        necessary_tables,
        necessary_joins,
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
    args.logger.info(line)

    graph = tree_and_graph_formation(
        args,
        sql_type_dict,
        necessary_tables,
        necessary_joins,
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
        "childs": childs,
        "correlation_predicates_origin": correlation_predicates_origin,
        "is_having_child": is_having_child,
        "inner_join_view_name": inner_join_view_name,
    }
    return line, graph, obj


def add_new_query_for_having(
    args,
    rng,
    joins,
    tables,
    sql_type_dict,
    used_tables,
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
                    if ")" not in order_col_raw:
                        args.logger.error("This cannot be happend")
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
        "NULL",
        childs,
        child_predicates_graphs=child_predicates_graphs,
        correlation_predicates_origin=correlation_predicates_origin,
        is_having_child=True,
    )

    return line_having, graph_having, obj_having


def create_inner_joined_view(
    args,
    data_manager,
    original_view_name,
    inner_join_view_name,
    necessary_tables,
    necessary_joins,
    where_view_predicate_string,
):
    inner_join_query_selects = []
    for table in necessary_tables:
        columns = data_manager.fetch_column_names(table)
        col_refs = [f"{table}__{column}" for column in columns]
        inner_join_query_selects += col_refs
    inner_join_query_select_string = ", ".join(inner_join_query_selects)

    inner_join_query_string = f"""SELECT DISTINCT {inner_join_query_select_string} FROM {original_view_name} """
    inner_join_query_join_keys = set()
    for table in necessary_tables:
        keys = data_manager.get_primary_keys(table)
        inner_join_query_join_keys.update([f"{table}.{key}" for key in keys])

    for join in necessary_joins:
        t1, k1, t2, k2 = get_table_join_key_from_join_clause(join)
        inner_join_query_join_keys.add(f"{t1}.{k1}")
        inner_join_query_join_keys.add(f"{t2}.{k2}")

    inner_join_not_null_conditions = []
    for key in inner_join_query_join_keys:  # all join key should be not null
        key_ref = key.replace(".", "__")
        inner_join_not_null_conditions.append(f""" {key_ref} IS NOT NULL""")
    inner_join_query_predicate_strings = []
    if len(inner_join_not_null_conditions) > 0:
        inner_join_query_not_null_string = "( " + " AND ".join(inner_join_not_null_conditions) + " )"
        inner_join_query_predicate_strings.append(inner_join_query_not_null_string)
    if where_view_predicate_string is not None:
        inner_join_query_predicate_strings.append("( " + where_view_predicate_string + " )")

    inner_join_query_predicate_string = " AND ".join(inner_join_query_predicate_strings)
    if len(inner_join_query_predicate_strings) > 0:
        inner_join_query_string += f""" WHERE {inner_join_query_predicate_string} """

    data_manager.create_view(
        args.logger, inner_join_view_name, inner_join_query_string, type="materialized", drop_if_exists=True
    )


def non_nested_query_generator(
    args,
    data_manager,
    rng,
    all_table_set,
    join_key_list,
    join_clause_list,
    dtype_dict,
    global_unique_query_idx,
):
    sql_type_dict = non_nested_query_form_selector(args, rng)

    used_tables = set()
    tables, joins, table_columns_projection, table_columns = get_query_token(
        args,
        all_table_set,
        join_key_list,
        data_manager,
        join_clause_list,
        sql_type_dict,
        rng,
    )
    prefix = get_prefix(1, global_unique_query_idx)

    view_names = []
    current_view_name = args.fo_view_name
    if sql_type_dict["where"]:
        (
            where_predicates,
            _,
            used_tables,
            tree_predicates_origin,
            predicates_origin,
            _,
            where_view_name,
            where_view_predicate_string,
        ) = where_generator(
            args,
            rng,
            table_columns,
            table_columns_projection,
            dtype_dict,
            join_key_list,
            all_table_set,
            join_clause_list,
            data_manager,
            current_view_name,
            used_tables,
            prefix,
        )
        current_view_name = where_view_name
        view_names.append(where_view_name)
    else:
        where_predicates = []
        tree_predicates_origin = []
        predicates_origin = []
        where_view_predicate_string = None

    if args.constraints["used_as_inner_query"]:
        if "OR" not in where_predicates:
            if sql_type_dict["group"]:
                pass
            else:
                sql_type_dict["group"] = True
                sql_type_dict["having"] = True

    if sql_type_dict["group"]:
        group_columns_origin, group_columns = group_generator(
            args, rng, table_columns, used_tables, dtype_dict, data_manager, current_view_name, prefix
        )
    else:
        group_columns_origin = []
        group_columns = []
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
        sql_type_dict,
        prefix,
    )

    used_tables_temp = get_updated_used_tables(used_tables, group_columns_origin)
    necessary_tables_temp, necessary_joins_temp = find_join_path(joins, tables, used_tables_temp)

    inner_join_view_name = get_view_name("non_nested", [args.fo_view_name, prefix, "inner_view"])
    create_inner_joined_view(
        args,
        data_manager,
        args.fo_view_name,
        inner_join_view_name,
        necessary_tables_temp,
        necessary_joins_temp,
        where_view_predicate_string,
    )

    # NOTE ::::: WE DO NOT PERFORM GROUP BY
    current_view_name = inner_join_view_name

    # [TODO] DROP WHERE VIEW!!!!!
    for view_name in view_names:
        data_manager.drop_view(args.logger, view_name)

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
            data_manager,
            current_view_name,
            used_tables,
            grouping_query_elements,
            prefix,
        )
        if having_predicates is None:
            args.logger.warning("Failed to generate having; restart query generation")
            assert False
    else:
        having_predicates = []
        having_predicates_origin = []
        having_tree_predicates_origin = []

    if sql_type_dict["order"]:
        done, order_columns_origin, order_columns, aggregated_order = order_generator(
            args,
            rng,
            table_columns,
            dtype_dict,
            agg_cols,
            sql_type_dict["group"],
            group_columns_origin,
            prefix,
        )
        sql_type_dict["aggregated_order"] = aggregated_order
        if not done:
            args.logger.warning("Failed to generate order by clause; restart query generation")
            assert False
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
        current_view_name,
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
    data_manager,
    rng,
    all_table_set,
    join_key_list,
    join_clause_list,
    dtype_dict,
    global_unique_query_idx,
    inner_query_objs=None,
    inner_query_graphs=None,
):
    if inner_query_objs is None:
        args.logger.error("This cannot be happend")
        assert False, "Currently not implemented"

    min_nested_pred_num = args.hyperparams["num_nested_pred_min"]
    max_nested_pred_num = args.hyperparams["num_nested_pred_max"]

    candidate_idxs = get_possible_inner_query_idxs(args, inner_query_objs)
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

    sql_type_dict = non_nested_query_form_selector(args, rng)
    sql_type_dict["where"] = True

    tables, joins, table_columns_projection, table_columns = get_query_token(
        args,
        all_table_set,
        join_key_list,
        data_manager,
        join_clause_list,
        sql_type_dict,
        rng,
        inner_query_tables=inner_query_tables,
    )

    view_names = []
    current_view_name = args.fo_view_name
    used_tables = set()

    # Step 1. Outer query generation
    (
        where_predicates,
        nested_predicates_graphs,
        used_tables,
        tree_predicates_origin,
        predicates_origin,
        correlation_predicates_origin,
        where_view_name,
        where_view_predicate_string,
    ) = where_generator(
        args,
        rng,
        table_columns,
        table_columns_projection,
        dtype_dict,
        join_key_list,
        all_table_set,
        join_clause_list,
        data_manager,
        current_view_name,
        used_tables,
        prefix,
        chosen_inner_queries=chosen_inner_queries,
        num_nested_predicates=num_nested_predicates,
        inner_query_objs=inner_query_objs,
        inner_query_graphs=inner_query_graphs,
    )
    view_names.append(where_view_name)
    current_view_name = where_view_name

    if sql_type_dict["group"]:
        group_columns_origin, group_columns = group_generator(
            args,
            rng,
            table_columns,
            used_tables,
            dtype_dict,
            data_manager,
            current_view_name,
            prefix,
        )
    else:
        group_columns_origin = []
        group_columns = []

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
        sql_type_dict,
        prefix,
    )

    used_tables_temp = get_updated_used_tables(used_tables, group_columns_origin)
    necessary_tables_temp, necessary_joins_temp = find_join_path(joins, tables, used_tables_temp)

    inner_join_view_name = get_view_name("nested", [args.fo_view_name, prefix, "inner_view"])
    create_inner_joined_view(
        args,
        data_manager,
        args.fo_view_name,
        inner_join_view_name,
        necessary_tables_temp,
        necessary_joins_temp,
        where_view_predicate_string,
    )

    current_view_name = inner_join_view_name

    # [TODO] DROP WHERE VIEW!!!!!
    for view_name in view_names:
        data_manager.drop_view(args.logger, view_name)

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
            data_manager,
            current_view_name,
            used_tables,
            grouping_query_elements,
            prefix,
        )
        if having_predicates is None:
            args.logger.warning("Failed to generate having; restart query generation")
            assert False
    else:
        having_predicates = []
        having_predicates_origin = []
        having_tree_predicates_origin = []

    if sql_type_dict["order"]:
        done, order_columns_origin, order_columns, aggregated_order = order_generator(
            args,
            rng,
            table_columns,
            dtype_dict,
            agg_cols,
            sql_type_dict["group"],
            group_columns_origin,
            prefix,
        )
        sql_type_dict["aggregated_order"] = aggregated_order
        if not done:
            args.logger.warning("Failed to generate order by clause; restart query generation")
            assert False
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
        current_view_name,
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
    data_manager,
    rng,
    all_table_set,
    join_key_list,
    join_clause_list,
    dtype_dict,
    inner_query_objs,
    inner_query_graphs,
    global_unique_query_idx,
):
    only_nested = args.sql_info["type"] in ["nested"]
    only_nonnested = args.sql_info["type"] in ["non-nested"]

    if args.sql_info["type"] == "non-nested":
        query, graph, obj = non_nested_query_generator(
            args,
            data_manager,
            rng,
            all_table_set,
            join_key_list,
            join_clause_list,
            dtype_dict,
            global_unique_query_idx,
        )
    else:
        query, graph, obj = nested_query_generator(
            args,
            data_manager,
            rng,
            all_table_set,
            join_key_list,
            join_clause_list,
            dtype_dict,
            global_unique_query_idx,
            inner_query_objs,
            inner_query_graphs,
        )

    return query, graph, obj
