#import sql_genetion_utils
from sql_gen_utils.sql_genetion_utils import *

def nesting_type_selector (args, rng, only_nested=False, only_nonnested=False, inner_query_obj=None):
    assert not( only_nested and only_nonnested ), "Only nested and only nonnested options cannot be activated at the same time."

    nesting_type_origin = ['non-nested', 'type-n', 'type-a', 'type-j', 'type-ja']
    if args.set_nested_query_type:
        nesting_type_origin = ['non-nested']
        if args.has_type_n:
            nesting_type_origin.append('type-n')
        if args.has_type_a:
            nesting_type_origin.append('type-a')
        if args.has_type_j:
            nesting_type_origin.append('type-j')
        if args.has_type_ja:
            nesting_type_origin.append('type-ja')

    if inner_query_obj:
        if inner_query_obj['use_agg_sel']:
            if '*' in inner_query_obj['select'][0]:
                nesting_type_origin = ['non-nested', 'type-ja']
            else:
                nesting_type_origin = ['non-nested', 'type-a', 'type-ja']
        else:
            if inner_query_obj['select'][0] == '*':
                nesting_type_origin = ['non-nested', 'type-j']
            else:
                nesting_type_origin = ['non-nested', 'type-n', 'type-j']

    if only_nested:
        nesting_type = nesting_type_origin[rng.randint(1, len(nesting_type_origin))]
    elif only_nonnested:
        nesting_type = 'non-nested'
    else:
        nesting_type = nesting_type_origin[rng.randint(0, len(nesting_type_origin))]

    return nesting_type

def nesting_position_selector (args, rng, nesting_type, inner_query_obj=None):
    # Nesting Types:
    # - WHERE <column> <operator> <Inner query>
    # - WHERE <column> <IN/NOT IN> <Inner query>
    # - WHERE <EXISTS/NOT EXISTS> <Inner query>
    # - WHERE <Inner query> <operator> <value>

    if nesting_type == 'type-n':
        return rng.randint(0, 2)

    elif nesting_type == 'type-a':
        return 0

    elif nesting_type == 'type-j':
        if inner_query_obj:
            if inner_query_obj['select'][0] == '*':
                return 2
        return rng.randint(0, 4)

    elif nesting_type == 'type-ja':
        if inner_query_obj:
            if '*' in inner_query_obj['select'][0]:
                return 3
        return rng.choice([0, 3])

def non_nested_query_form_selector (args, rng):
    only_spj = args.query_type in ['spj-non-nested', 'spj-nested', 'spj-mix']
    if only_spj:
        sql_type = {
            'where': bool(rng.randint(0, 2)),
            'group': False,
            'having': False,
            'order': False,
            'limit': False
        }
    else:
        if args.set_clause_by_clause:
            sql_type = {
                'where': False,
                'group': False,
                'having': False,
                'order': False,
                'limit': False
            }
            if args.has_where:
                sql_type['where'] = True
            if args.has_group or args.has_having:
                sql_type['group'] = True
            if args.has_having:
                sql_type['having'] = True
            if args.has_order or args.has_limit:
                sql_type['order'] = True
            if args.has_limit:
                sql_type['limit'] = True
        else:
            sql_type = {
                'where': bool(rng.randint(0, 2)),
                'group': bool(rng.randint(0, 2)),
                'having': bool(rng.randint(0, 2)),
                'order': bool(rng.randint(0, 2)),
                'limit': bool(rng.randint(0, 2))
            }
                
    if not sql_type['group']:
        sql_type['having'] = False

    if not sql_type['order']:
        sql_type['limit'] = False

    return sql_type

def agg_selector (rng, use_agg, dtype_dict, join_key_list, col, outer_nesting_position=-1, outer_operator=None):
    if use_agg:
        if dtype_dict[col] == 'str':
            agg = rng.choice(TEXTUAL_AGGS)
        else:
            # (FIX #1, C6) Not use AVG/SUM/MIN/MAX for key columns
            if col in IDS: #join_key_list:
                agg = 'COUNT' # rng.choice(KEY_AGGS)
            else:
                # (FIX #7) Not use COUNT/SUM for <col> <op> <val> shaped outer query
                if outer_nesting_position == 0:
                    possible_aggs = POSSIBLE_AGGREGATIONS_PER_OPERATOR[outer_operator]
                    agg = rng.choice(possible_aggs)
                else:
                    agg = rng.choice(NUMERIC_AGGS)
    else:
        agg = 'NONE'
    
    return agg

def select_generator (args, rng, cols, dtype_dict, join_key_list, tables,
                        group=False, outer_inner=None,
                        nesting_type='non-nested', nesting_column=None,
                        outer_nesting_position=-1, outer_operator=None):
    if outer_nesting_position != -1:
        num_select = 1
    else:
        min_select, max_select = args.num_select_min, args.num_select_max
        num_select = rng.randint(min_select, max_select)

    columns = []
    agg_cols = []

    use_distinct = bool(rng.randint(0, 2))
    # (FIX #11) Use aggregation function for type-a, type-ja query and not use for type-n, type-j query
    if nesting_type in ['type-a', 'type-ja']:
        use_agg = True
    elif nesting_type in ['type-n', 'type-j']:
        use_agg = False
    else:
        tmp_prob = 0.2
        #use_agg = True if group else bool(rng.randint(0, 2))
        use_agg = True if group else bool(rng.choice([0, 1], p=[1-tmp_prob, tmp_prob]))

    if outer_inner == 'outer':
        prefix = 'O_'
    elif outer_inner == 'inner':
        prefix = 'I_'
    else:
        prefix = ''

    used_tables = set()

    if num_select == 0:
        if use_agg:
            #agg = rng.choice(NUMERIC_AGGS)
            agg = rng.choice(TEXTUAL_AGGS)
        else:
            agg = 'NONE'

        col_rep = agg + '(*)' if agg != 'NONE' else '*'
        columns.append(col_rep)
        agg_cols.append((agg, '*'))
    elif outer_nesting_position == 2:
        first_table = tables[0]
        agg = 'NONE'
        col = PRIMARY_KEYS[first_table]
        col_rep = prefix + col

        columns.append(col_rep)
        agg_cols.append((agg, col))
        used_tables.add(col.split('.')[0])
    else:
        if nesting_column is not None:
            col = nesting_column
            agg = agg_selector (rng, use_agg, dtype_dict, join_key_list, col, outer_nesting_position=outer_nesting_position, outer_operator=outer_operator)

            col_rep = agg + '(' + prefix + col + ')' if agg != 'NONE' else prefix + col

            columns.append(col_rep)
            agg_cols.append((agg, col))
            used_tables.add(col.split('.')[0])

        while len(columns) < num_select:
            if not use_agg and len(columns) == len(cols):
                break
            col = rng.choice(cols)
            agg = agg_selector (rng, use_agg, dtype_dict, join_key_list, col)

            distinct = ''
            if agg == 'COUNT' and col not in IDS: # Use distinct if COUNT + non_key_column
                distinct = 'DISTINCT '

            col_rep = agg + '(' + distinct + prefix + col + ')' if agg != 'NONE' else prefix + col

            if col_rep in columns:
                continue
            else:
                columns.append(col_rep)
                agg_cols.append((agg, col))
                used_tables.add(col.split('.')[0])

    return columns, agg_cols, (used_tables, use_agg)

def where_generator (args, rng, table_columns, dtype_dict, join_key_list,
                        all_table_set, join_clause_list, join_key_pred,
                        df, dvs, n, used_tables,
                        outer_inner=None,
                        nesting_position=-1, nesting_type='non-nested',
                        outer_correlation_column=None):
    min_pred_num = args.num_pred_min
    max_pred_num = args.num_pred_max

    num_predicate = rng.randint(min_pred_num, min(len(table_columns),max_pred_num)+1)
    num_nonnest_predicate = num_predicate - 1 if nesting_position != -1 else num_predicate
    # predicates_cols = list(rng.choice(table_columns, num_predicate, replace=True))

    # cols = predicates_cols
    # vals = list(df[predicates_cols].iloc[n])

    tree_predicates = build_predicate_tree_cnf(rng, [[x] for x in range(num_predicate)])
    tree_predicates_origin = copy.deepcopy(tree_predicates)
    if len(tree_predicates) == 1:
        tree_predicates.append(True)
    else:
        split_predicate_tree_with_condition(tree_predicates)
    flatten_tree = flatten_condition_predicate_tree(tree_predicates)
    sorted_conditions = sorted(flatten_tree, key=lambda x: x[0])

    predicates = list()
    predicates_origin = list()
    nesting_col = None
    cond_idx = 0

    result_guarantee_predicates = list()
    result_guarantee_tuples = df

    if outer_inner == 'outer':
        prefix = 'O_'
    elif outer_inner == 'inner':
        prefix = 'I_'
    else:
        prefix = ''

    continue_cnt = 0
    while cond_idx < num_nonnest_predicate:
        if continue_cnt > 100:
            raise Exception()
        tuple_idx = rng.randint(0, len(result_guarantee_tuples))
        column_idx = rng.randint(0, len(table_columns))

        col = table_columns[column_idx]
        vals = result_guarantee_tuples[[col]].iloc[tuple_idx]
        val = vals[0]
        result_condition = sorted_conditions[cond_idx][1]

        if col in IDS: # Not generate any condition using id/hash code/note columns
            continue_cnt += 1
            continue

        if dtype_dict[col] == 'str':
            v = str(val).strip()
            if val == 'nan' or pd.isnull(val) :
                # op = 'IS_NULL'
                # vals[0] = 'None'
                continue_cnt += 1
                continue
            else:
                # (FIX C3) NO =, !=, IN, NOT IN operators for hash codes and notes
                if col in HASH_CODES + NOTES:
                    op = rng.choice(TEXTUAL_OPERATORS[2:-2])
                    # v_tok = str(rng.choice(v.split(' ')))
                    # if len(v_tok) > 7:
                    #     v_tok = v_tok[:7]
                    # v = v_tok
                else:
                    op = rng.choice(TEXTUAL_OPERATORS)
                if op == 'NOT IN' and len(dvs[col]) < 2 :
                    # op = 'IS_NULL'
                    # vals[0] = 'None'
                    continue_cnt += 1
                    continue
                else:
                    v = get_str_op_values(op,v,dvs[col],rng,num_in_max=args.num_in_max)

                    if op in ['IN', 'NOT IN']:
                        v, num_val = v
                        if num_val <= 1:
                            op = '=' if op == 'IN' else '!='
                            v = v[1:-1]

                    if op == 'IS_NOT_NULL':
                        vals[0] = v
                    else:
                        vals[0] =  f'''\"{v}\"'''

        elif dtype_dict[col] == 'date' :
            if val == 'nan' or pd.isnull(val) :
                # op = 'IS_NULL'
                # vals[0] = 'None'
                continue_cnt += 1
                continue
            else :
                op = rng.choice(NUMERIC_OPERATORS)
                if op=='!=':
                    v = rng.choice(dvs[col])
                    while (len(dvs[col]) > 1) and (v == val): v = rng.choice(dvs[col])
                vals[0] = v

        else:
            if np.isnan(val):
                # op = 'IS_NULL'
                # vals[0] = 'None'
                continue_cnt += 1
                continue
            else:
                # (FIX #4) Not choose lte, lt, gte, gt for key column
                if col in join_key_list:
                    op = rng.choice(KEY_OPERATORS)
                else:
                    op = rng.choice(NUMERIC_OPERATORS)
                
                if op=='!=':
                    v = rng.choice(dvs[col])
                    while (len(dvs[col]) > 1) and (v == val): v = rng.choice(dvs[col])
                else:
                    v = val

                if dtype_dict[col] == 'int':
                    vals[0] = int(v)

        if result_condition:
            query_predicate = predicate_generator(col, op, str(vals[0]))

            # num_result = len(df.query(' AND '.join(result_guarantee_predicates)))
            new_result_guarantee_tuples = result_guarantee_tuples.query(query_predicate)
            num_result = len(new_result_guarantee_tuples)
            if num_result < 1:
                continue_cnt += 1
                continue
            result_guarantee_tuples = new_result_guarantee_tuples
            result_guarantee_predicates.append(query_predicate)

        used_tables.add(col.split('.')[0])
        if op in ['IS_NULL', 'IS_NOT_NULL']:
            predicate_str = prefix + col + ' ' + op
            predicate_tuple = ( prefix_col, op, None )
        else:
            predicate_str = prefix + col + ' ' + op + ' ' + str(vals[0])
            predicate_tuple = ( prefix+col, op, str(vals[0]) )
        predicates_origin.append( predicate_tuple )
        predicates.append(predicate_str)
        cond_idx += 1

    if nesting_position != -1: # If nested query needs to be generated
        result_condition = sorted_conditions[-1][1]
        done = False
        continue_count = 0
        while not done:
            if continue_count > 100000:
                raise Exception("Too many continue")
            continue_count += 1
            if nesting_type in ['type-j', 'type-ja']:
                correlation_column = rng.choice(table_columns)
            else:
                correlation_column = None
            if nesting_position == 0:
                column_idx = rng.randint(0, len(table_columns))
                col = table_columns[column_idx]
                if correlation_column and col == correlation_column:
                    continue

                # (FIX #5) Non-textual column for type-a, type-ja nested query
                # for <col> <op> <inner query> form
                if nesting_type in ['type-a', 'type-ja'] and dtype_dict[col] == 'str':
                    continue
                if nesting_type in ['type-a', 'type-ja'] and col in IDS:
                    continue
                if dtype_dict[col] == 'str' and nesting_type not in ['type-a', 'type-ja']:
                    op = rng.choice(TEXTUAL_OPERATORS[0:3])
                else:
                    op = rng.choice(NUMERIC_OPERATORS)

                inner_query, inner_query_result, inner_obj = inner_query_generator(args, df, n, rng,
                                                    all_table_set, join_key_list, join_clause_list, join_key_pred,
                                                    dtype_dict, dvs,
                                                    nesting_position=nesting_position, nesting_type=nesting_type,
                                                    outer_table_pool=None,
                                                    nesting_column=col, correlation_column=correlation_column,
                                                    outer_operator=op)
                # assert len(inner_query_result) == 1, "The number of result of inner query should be 1"

                if result_condition:
                    if nesting_type in ['type-j', 'type-ja']:
                        new_result_guarantee_tuples = pd.DataFrame([], columns=result_guarantee_tuples.columns)
                        for tid in range(len(result_guarantee_tuples)):
                            tpl = result_guarantee_tuples.iloc[[tid]]

                            cur_group = None
                            for key, item in inner_query_result:
                                if key == tpl[correlation_column].iloc[0]:
                                    cur_group = item
                                    break
                            if cur_group is None or (type(cur_group.iloc[0,1]) != str and np.isnan(cur_group.iloc[0,1])):
                                continue

                            result_val = cur_group.iloc[0, 1]
                            if dtype_dict[col] == 'str' and nesting_type != 'type-ja':
                                if op in ['=', '!=']:
                                    result_val = '"' + result_val + '"'
                                else:
                                    result_val = '"' + rng.choice(['%', '']) + result_val + rng.choice(['%', '']) + '"'
                            query_predicate = predicate_generator(col, op, str(result_val))
                            query_result = tpl.query(query_predicate)
                            if len(query_result) > 0:
                                new_result_guarantee_tuples = new_result_guarantee_tuples.append(tpl.iloc[0])
                    else:
                        result_val = inner_query_result.iloc[0, 0] # Get the value of the inner query
                        if type(result_val) != str and np.isnan(result_val):
                            continue

                        if dtype_dict[col] == 'str' and nesting_type != 'type-a':
                            if op in ['=', '!=']:
                                result_val = '"' + result_val + '"'
                            else:
                                result_val = '"' + rng.choice(['%', '']) + result_val + rng.choice(['%', '']) + '"'
                        query_predicate = predicate_generator(col, op, str(result_val))
                        new_result_guarantee_tuples = result_guarantee_tuples.query(query_predicate)

                    num_result = len(new_result_guarantee_tuples)
                    if num_result < 1:
                        continue
                    if num_result > 1:
                        if "=" in op or "LIKE" in op:
                            op += " ANY"
                        else:
                            op += rng.choice([" ANY", " ALL"])
                    result_guarantee_tuples = new_result_guarantee_tuples
                    # result_guarantee_predicates.append(query_predicate)

                used_tables.add(col.split('.')[0])
                predicate_str = prefix + col + ' ' + op + ' (' + inner_query + ')'
                predicate_tuple = ( prefix+col, op, '(' + inner_query + ')', inner_obj )
                nesting_col = col
                done = True
            
            elif nesting_position == 1:
                column_idx = rng.randint(0, len(table_columns))
                col = table_columns[column_idx]
                if correlation_column and col == correlation_column:
                    continue
                op = rng.choice(['IN', 'NOT IN'])

                inner_query, inner_query_result, inner_obj = inner_query_generator(args, df, n, rng,
                                                    all_table_set, join_key_list, join_clause_list, join_key_pred,
                                                    dtype_dict, dvs,
                                                    nesting_position=nesting_position, nesting_type=nesting_type,
                                                    outer_table_pool=None,
                                                    nesting_column=col, correlation_column=correlation_column)
                # assert len(inner_query_result) == 1, "The number of column of inner query should be 1"
                if result_condition:
                    new_result_guarantee_tuples = pd.DataFrame([], columns=result_guarantee_tuples.columns)
                    if nesting_type in ['type-j', 'type-ja']:
                        for tid in range(len(result_guarantee_tuples)):
                            tpl = result_guarantee_tuples.iloc[[tid]]

                            cur_group = None
                            for key, item in inner_query_result:
                                if key == tpl[correlation_column].iloc[0]:
                                    cur_group = item
                                    break
                            if cur_group is None:
                                continue
                            result_val = list(cur_group.iloc[:,1])

                            column_value = tpl[col].iloc[0]
                            if (column_value in result_val and op == 'IN') or (column_value not in result_val and op == 'NOT IN'):
                                new_result_guarantee_tuples = new_result_guarantee_tuples.append(tpl.iloc[0])

                    else:
                        result_val = list(inner_query_result.iloc[:, 0]) # Get the values of the inner query
                        for tid in range(len(result_guarantee_tuples)):
                            tpl = result_guarantee_tuples.iloc[[tid]]
                            column_value = tpl[col].iloc[0]
                            if column_value in result_val:
                                new_result_guarantee_tuples = new_result_guarantee_tuples.append(tpl)

                    num_result = len(new_result_guarantee_tuples)
                    if num_result < 1:
                        continue
                    result_guarantee_tuples = new_result_guarantee_tuples
                    # result_guarantee_predicates.append(query_predicate)


                used_tables.add(col.split('.')[0])
                predicate_str = prefix + col + ' ' + op + ' (' + inner_query + ')'
                predicate_tuple = ( prefix+col, op, '(' + inner_query + ')', inner_obj )
                nesting_col = col
                done = True
                break

            elif nesting_position == 2:
                op = rng.choice(['EXISTS', 'NOT EXISTS'])
                inner_query, inner_query_result, inner_obj = inner_query_generator(args, df, n, rng,
                                                    all_table_set, join_key_list, join_clause_list, join_key_pred,
                                                    dtype_dict, dvs,
                                                    nesting_position=nesting_position, nesting_type=nesting_type,
                                                    outer_table_pool=None,
                                                    correlation_column=correlation_column)

                if result_condition: # Always correlation condition
                    new_result_guarantee_tuples = pd.DataFrame([], columns=result_guarantee_tuples.columns)
                    for tid in range(len(result_guarantee_tuples)):
                        tpl = result_guarantee_tuples.iloc[[tid]]

                        cur_group = None
                        for key, item in inner_query_result:
                            if key == tpl[correlation_column].iloc[0]:
                                cur_group = item
                                break

                        num_result = len(cur_group) if cur_group is not None else 0
                        if (num_result > 0 and op == 'EXISTS') or (num_result < 1 and op == 'NOT EXISTS'):
                            new_result_guarantee_tuples = new_result_guarantee_tuples.append(tpl.iloc[0])

                    num_result = len(new_result_guarantee_tuples)
                    if num_result < 1:
                        continue

                predicate_str = op + ' (' + inner_query + ')'
                predicate_tuple = ( None, op, '(' + inner_query + ')', inner_obj )
                done = True
                break

            elif nesting_position == 3:
                column_idx = rng.randint(0, len(table_columns))
                col = table_columns[column_idx]
                if correlation_column and col == correlation_column:
                    continue

                if dtype_dict[col] == 'str' and nesting_type not in ['type-a', 'type-ja']:
                    op = rng.choice(TEXTUAL_OPERATORS[0:3])
                else:
                    op = rng.choice(NUMERIC_OPERATORS)

                # val = randomly_select_value_from_column()

                inner_query, inner_query_result, inner_obj = inner_query_generator(args, df, n, rng,
                                                    all_table_set, join_key_list, join_clause_list, join_key_pred,
                                                    dtype_dict, dvs,
                                                    nesting_position=nesting_position, nesting_type=nesting_type,
                                                    outer_table_pool=None,
                                                    nesting_column=col, correlation_column=correlation_column)
                # Always correlation condition
            
                if len(inner_query_result) == 0:
                    continue

                if op in ['=', '>=', '<=']:
                    cur_group = None
                    for key, item in inner_query_result:
                        if key == result_guarantee_tuples[correlation_column].iloc[0]:
                            cur_group = item
                            break
                    if cur_group is None:
                        continue
                    val = cur_group[col].iloc[0]
                    if type(val) != str and np.isnan(val):
                        continue
                else:
                    tid = rng.randint(0, len(inner_query_result))
                    val = inner_query_result[tid][1].iloc[0,1]
                    if type(val) != str and np.isnan(val):
                        continue

                if dtype_dict[col] == 'str' and nesting_type not in ['type-a', 'type-ja']:
                    if op in ['=', '!=']:
                        val = '"' + val + '"'
                    else:
                        val = '"' + rng.choice(['%', '']) + val + rng.choice(['%', '']) + '"'

                if result_condition: # (TODO) Add correlation checker
                    new_result_guarantee_tuples = pd.DataFrame([], columns=result_guarantee_tuples.columns)
                    for tid in range(len(result_guarantee_tuples)):
                        tpl = result_guarantee_tuples.iloc[[tid]]

                        cur_group = None
                        for key, item in inner_query_result:
                            if key == tpl[correlation_column].iloc[0]:
                                cur_group = item
                                break
                        if cur_group is None:
                            continue

                        query_predicate = predicate_generator(col, op, str(val))
                        predicate_result = cur_group.query(query_predicate)
                        num_result = len(predicate_result)
                        if num_result > 0:
                            new_result_guarantee_tuples = new_result_guarantee_tuples.append(tpl.iloc[0])

                    num_result = len(new_result_guarantee_tuples)
                    if num_result < 1:
                        continue
                    result_guarantee_tuples = new_result_guarantee_tuples
                    # result_guarantee_predicates.append(query_predicate)
                
                predicate_str = '(' + inner_query + ') ' + op + ' ' + str(val)
                predicate_tuple = ( '(' + inner_query + ')', op, str(val), inner_obj )
                done = True
                break

        if not done:
            raise Exception()
        print(inner_query)
        predicates.append(predicate_str)
        predicates_origin.append( predicate_tuple )

    tree_predicates = restore_predicate_tree(tree_predicates, predicates)

    # (FIX #12): Make correlation predicate as the top level predicate 
    if outer_correlation_column is not None: # (TODO) nned to identify whether it's generating outer query or inner query
        correlation_predicate = 'O_' + outer_correlation_column + ' = I_' + outer_correlation_column
        tree_predicates = [(correlation_predicate, 'AND', tree_predicates)]
        result_guarantee_tuples = result_guarantee_tuples.groupby(outer_correlation_column)
        used_tables.add(outer_correlation_column.split('.')[0])

    return tree_predicates, nesting_col, used_tables, result_guarantee_tuples, tree_predicates_origin, predicates_origin

def nested_predicate_generator (args, rng, table_columns, dtype_dict, join_key_list,
                        all_table_set, join_clause_list, join_key_pred,
                        df, dvs, n, used_tables,
                        outer_inner=None,
                        nesting_position=-1, nesting_type='non-nested',
                        outer_correlation_column=None, inner_query_obj=None):
    
    num_predicate = 1

    tree_predicates = build_predicate_tree_cnf(rng, [[x] for x in range(num_predicate)])
    if len(tree_predicates) == 1:
        tree_predicates.append(True)
    else:
        split_predicate_tree_with_condition(tree_predicates)
    flatten_tree = flatten_condition_predicate_tree(tree_predicates)
    sorted_conditions = sorted(flatten_tree, key=lambda x: x[0])

    predicates = list()
    nesting_col = None
    cond_idx = 0

    result_guarantee_predicates = list()
    result_guarantee_tuples = df

    if outer_inner == 'outer':
        prefix = 'O_'
    elif outer_inner == 'inner':
        prefix = 'I_'
    else:
        prefix = ''

    continue_cnt = 0
    
    result_condition = sorted_conditions[-1][1]
    done = False
    while not done:
        if nesting_type in ['type-j', 'type-ja']:
            if inner_query_obj:
                inner_query_tables = inner_query_obj['tables']
                inner_query_columns = [table_column for table_column in table_columns if table_column.split('.')[0] in inner_query_tables]
                correlation_column = rng.choice(inner_query_columns)
            else:
                correlation_column = rng.choice(table_columns)
        else:
            correlation_column = None
        if nesting_position == 0:
            if inner_query_obj:
                assert len(inner_query_obj['agg_cols']) == 1
                col = inner_query_obj['agg_cols'][0][1] #col
            else:
                column_idx = rng.randint(0, len(table_columns))
                col = table_columns[column_idx]
            if correlation_column and col == correlation_column:
                continue

            # (FIX #5) Non-textual column for type-a, type-ja nested query
            # for <col> <op> <inner query> form

            if nesting_type in ['type-a', 'type-ja'] and dtype_dict[col] == 'str':
                continue
            if nesting_type in ['type-a', 'type-ja'] and col in IDS:
                continue
            if dtype_dict[col] == 'str' and nesting_type not in ['type-a', 'type-ja']:
                op = rng.choice(TEXTUAL_OPERATORS[0:3])
            else:
                op = rng.choice(NUMERIC_OPERATORS)
            
            if inner_query_obj is None:
                inner_query, inner_query_result, _ = inner_query_generator(args, df, n, rng,
                                                all_table_set, join_key_list, join_clause_list, join_key_pred,
                                                dtype_dict, dvs,
                                                nesting_position=nesting_position, nesting_type=nesting_type,
                                                outer_table_pool=None,
                                                nesting_column=col, correlation_column=correlation_column,
                                                outer_operator=op)
            else:
                inner_query, inner_query_result = inner_query_obj_to_inner_query(args, df, n, rng, inner_query_obj, dtype_dict, dvs, nesting_column=col, correlation_column=correlation_column)
            # assert len(inner_query_result) == 1, "The number of result of inner query should be 1"

            if result_condition:
                if nesting_type in ['type-j', 'type-ja']:
                    new_result_guarantee_tuples = pd.DataFrame([], columns=result_guarantee_tuples.columns)
                    for tid in range(len(result_guarantee_tuples)):
                        tpl = result_guarantee_tuples.iloc[[tid]]

                        cur_group = None
                        for key, item in inner_query_result:
                            if key == tpl[correlation_column].iloc[0]:
                                cur_group = item
                                break
                        if cur_group is None or (type(cur_group.iloc[0,1]) != str and np.isnan(cur_group.iloc[0,1])):
                            continue

                        result_val = cur_group.iloc[0, 1]
                        if dtype_dict[col] == 'str' and nesting_type != 'type-ja':
                            if op in ['=', '!=']:
                                result_val = '"' + result_val + '"'
                            else:
                                result_val = '"' + rng.choice(['%', '']) + result_val + rng.choice(['%', '']) + '"'
                        query_predicate = predicate_generator(col, op, str(result_val))
                        query_result = tpl.query(query_predicate)
                        if len(query_result) > 0:
                            new_result_guarantee_tuples = new_result_guarantee_tuples.append(tpl.iloc[0])
                else:
                    result_val = inner_query_result.iloc[0, 0] # Get the value of the inner query
                    if type(result_val) != str and np.isnan(result_val):
                        continue

                    if dtype_dict[col] == 'str' and nesting_type != 'type-a':
                        if op in ['=', '!=']:
                            result_val = '"' + result_val + '"'
                        else:
                            result_val = '"' + rng.choice(['%', '']) + result_val + rng.choice(['%', '']) + '"'
                    query_predicate = predicate_generator(col, op, str(result_val))
                    new_result_guarantee_tuples = result_guarantee_tuples.query(query_predicate)

                num_result = len(new_result_guarantee_tuples)
                if num_result < 1:
                    continue
                result_guarantee_tuples = new_result_guarantee_tuples
                # result_guarantee_predicates.append(query_predicate)

            used_tables.add(col.split('.')[0])
            predicate_str = prefix + col + ' ' + op + ' (' + inner_query + ')'
            nesting_col = col
            done = True
        
        elif nesting_position == 1:
            if inner_query_obj:
                assert len(inner_query_obj['agg_cols']) == 1
                col = inner_query_obj['agg_cols'][0][1] #col
            else:
                column_idx = rng.randint(0, len(table_columns))
                col = table_columns[column_idx]

            if correlation_column and col == correlation_column:
                continue
            op = rng.choice(['IN', 'NOT IN'])

            if inner_query_obj is None:
                inner_query, inner_query_result, _ = inner_query_generator(args, df, n, rng,
                                                all_table_set, join_key_list, join_clause_list, join_key_pred,
                                                dtype_dict, dvs,
                                                nesting_position=nesting_position, nesting_type=nesting_type,
                                                outer_table_pool=None,
                                                nesting_column=col, correlation_column=correlation_column)
            else:
                inner_query, inner_query_result = inner_query_obj_to_inner_query(args, df, n, rng, inner_query_obj, dtype_dict, dvs, nesting_column=col, correlation_column=correlation_column)
            # assert len(inner_query_result) == 1, "The number of column of inner query should be 1"
            if result_condition:
                new_result_guarantee_tuples = pd.DataFrame([], columns=result_guarantee_tuples.columns)
                if nesting_type in ['type-j', 'type-ja']:
                    for tid in range(len(result_guarantee_tuples)):
                        tpl = result_guarantee_tuples.iloc[[tid]]

                        cur_group = None
                        for key, item in inner_query_result:
                            if key == tpl[correlation_column].iloc[0]:
                                cur_group = item
                                break
                        if cur_group is None:
                            continue
                        result_val = list(cur_group.iloc[:,1])

                        column_value = tpl[col].iloc[0]
                        if (column_value in result_val and op == 'IN') or (column_value not in result_val and op == 'NOT IN'):
                            new_result_guarantee_tuples = new_result_guarantee_tuples.append(tpl.iloc[0])

                else:
                    result_val = list(inner_query_result.iloc[:, 0]) # Get the values of the inner query
                    for tid in range(len(result_guarantee_tuples)):
                        tpl = result_guarantee_tuples.iloc[[tid]]
                        column_value = tpl[col].iloc[0]
                        if column_value in result_val:
                            new_result_guarantee_tuples = new_result_guarantee_tuples.append(tpl)

                num_result = len(new_result_guarantee_tuples)
                if num_result < 1:
                    continue
                result_guarantee_tuples = new_result_guarantee_tuples
                # result_guarantee_predicates.append(query_predicate)


            used_tables.add(col.split('.')[0])
            predicate_str = prefix + col + ' ' + op + ' (' + inner_query + ')'
            nesting_col = col
            done = True
            break

        elif nesting_position == 2:
            op = rng.choice(['EXISTS', 'NOT EXISTS'])
            if inner_query_obj is None:
                inner_query, inner_query_result, _ = inner_query_generator(args, df, n, rng,
                                                all_table_set, join_key_list, join_clause_list, join_key_pred,
                                                dtype_dict, dvs,
                                                nesting_position=nesting_position, nesting_type=nesting_type,
                                                outer_table_pool=None,
                                                correlation_column=correlation_column)
            else:
                inner_query, inner_query_result = inner_query_obj_to_inner_query(args, df, n, rng, inner_query_obj, dtype_dict, dvs, correlation_column=correlation_column)

            if result_condition: # Always correlation condition
                new_result_guarantee_tuples = pd.DataFrame([], columns=result_guarantee_tuples.columns)
                for tid in range(len(result_guarantee_tuples)):
                    tpl = result_guarantee_tuples.iloc[[tid]]

                    cur_group = None
                    for key, item in inner_query_result:
                        if key == tpl[correlation_column].iloc[0]:
                            cur_group = item
                            break

                    num_result = len(cur_group) if cur_group is not None else 0
                    if (num_result > 0 and op == 'EXISTS') or (num_result < 1 and op == 'NOT EXISTS'):
                        new_result_guarantee_tuples = new_result_guarantee_tuples.append(tpl.iloc[0])

                num_result = len(new_result_guarantee_tuples)
                if num_result < 1:
                    continue

            predicate_str = op + ' (' + inner_query + ')'
            done = True
            break

        elif nesting_position == 3:
            if inner_query_obj:
                assert len(inner_query_obj['agg_cols']) == 1
                col = inner_query_obj['agg_cols'][0][1] #col
            else:
                column_idx = rng.randint(0, len(table_columns))
                col = table_columns[column_idx]
            if correlation_column and col == correlation_column:
                continue

            if '*' not in col and dtype_dict[col] == 'str' and nesting_type not in ['type-a', 'type-ja']:
                op = rng.choice(TEXTUAL_OPERATORS[0:3])
            else:
                op = rng.choice(NUMERIC_OPERATORS)

            # val = randomly_select_value_from_column()

            if inner_query_obj is None:
                inner_query, inner_query_result, _ = inner_query_generator(args, df, n, rng,
                                                all_table_set, join_key_list, join_clause_list, join_key_pred,
                                                dtype_dict, dvs,
                                                nesting_position=nesting_position, nesting_type=nesting_type,
                                                outer_table_pool=None,
                                                nesting_column=col, correlation_column=correlation_column)
            else:
                inner_query, inner_query_result = inner_query_obj_to_inner_query(args, df, n, rng, inner_query_obj, dtype_dict, dvs, nesting_column=col, correlation_column=correlation_column)
            # Always correlation condition
        
            if len(inner_query_result) == 0:
                continue

            if op in ['=', '>=', '<=']:
                cur_group = None
                for key, item in inner_query_result:
                    if key == result_guarantee_tuples[correlation_column].iloc[0]:
                        cur_group = item
                        break
                if cur_group is None:
                    continue
                val = cur_group[col].iloc[0]
                if type(val) != str and np.isnan(val):
                    continue
            else:
                tid = rng.randint(0, len(inner_query_result))
                val = inner_query_result[tid][1].iloc[0,1]
                if type(val) != str and np.isnan(val):
                    continue

            if '*' not in col and dtype_dict[col] == 'str' and nesting_type not in ['type-a', 'type-ja']:
                if op in ['=', '!=']:
                    val = '"' + val + '"'
                else:
                    val = '"' + rng.choice(['%', '']) + val + rng.choice(['%', '']) + '"'

            if result_condition: # (TODO) Add correlation checker
                new_result_guarantee_tuples = pd.DataFrame([], columns=result_guarantee_tuples.columns)
                for tid in range(len(result_guarantee_tuples)):
                    tpl = result_guarantee_tuples.iloc[[tid]]

                    cur_group = None
                    for key, item in inner_query_result:
                        if key == tpl[correlation_column].iloc[0]:
                            cur_group = item
                            break
                    if cur_group is None:
                        continue

                    query_predicate = predicate_generator(col, op, str(val))
                    predicate_result = cur_group.query(query_predicate)
                    num_result = len(predicate_result)
                    if num_result > 0:
                        new_result_guarantee_tuples = new_result_guarantee_tuples.append(tpl.iloc[0])

                num_result = len(new_result_guarantee_tuples)
                if num_result < 1:
                    continue
                result_guarantee_tuples = new_result_guarantee_tuples
                # result_guarantee_predicates.append(query_predicate)
            
            predicate_str = '(' + inner_query + ') ' + op + ' ' + str(val)
            done = True
            break
        
    if not done:
        raise Exception()
    predicates.append(predicate_str)

    tree_predicates = restore_predicate_tree(tree_predicates, predicates)
    

    query_graph = None

    return tree_predicates, nesting_col, used_tables, result_guarantee_tuples, query_graph

def group_generator (args, rng, cols, dtype_dict, group=False, outer_inner = 'non-nested'):
    min_group, max_group = args.num_group_min, args.num_group_max
    num_group = rng.randint(min_group, max_group)

    if outer_inner == 'outer':
        prefix = 'O_'
    elif outer_inner == 'inner':
        prefix = 'I_'
    else:
        prefix = ''

    columns = rng.choice(cols, num_group, replace=False)

    columns_with_prefix = [prefix + col for col in columns]

    return columns, columns_with_prefix

def hainvg_generator (args, rng, table_columns, group_columns, dtype_dict, df, dvs, n, used_tables, outer_inner = 'non-nested'):
    min_pred_num = args.num_having_min
    max_pred_num = args.num_having_max

    having_candidate_columns = [table_column for table_column in table_columns if table_column not in list(group_columns)] + ["*"]
    num_predicate = rng.randint(min_pred_num, min(len(having_candidate_columns),max_pred_num)+1)
    predicates_cols = list(rng.choice(having_candidate_columns, num_predicate, replace=True))

    if outer_inner == 'outer':
        prefix = 'O_'
    elif outer_inner == 'inner':
        prefix = 'I_'
    else:
        prefix = ''

    # [TODO] 
    cols = predicates_cols
    # vals for *
    # vals for specific columns
    vals = list()
    for predicates_col in  predicates_cols:
        if predicates_col == "*":
             vals.append(n)
        else:
             vals.append( df[predicates_col].iloc[n])
    ops = list()

    predicates = list()

    for i,val in enumerate(vals):
        col = cols[i]
        v = val
        if col != '*':
            used_tables.add(col.split('.')[0])

        if col not in list(group_columns):
            if col == "*" or dtype_dict[col] == 'str':
                agg = rng.choice(TEXTUAL_AGGS)
            else:
                agg = rng.choice(NUMERIC_AGGS)
        else:
            agg = 'NONE'
            assert False

        new_dtype = None
        if agg in ['NONE', 'MAX', 'MIN', 'AVG', 'SUM']:
            new_dtype = dtype_dict[col]
        else:
            new_dtype = 'int'

        # col_dtype = column_dtype_dict[col]
        if new_dtype == 'str':
            v = str(val).strip()
            if val == 'nan' or pd.isnull(val) :
                # op = 'IS_NULL'
                # vals[i] = 'None'
                continue
            else:
                op = rng.choice(TEXTUAL_OPERATORS)
                if op == 'NOT IN' and len(dvs[col]) < 2 :
                    # op = 'IS_NULL'
                    # vals[i] = 'None'
                    continue
                else:
                    v = get_str_op_values(op,v,dvs[col],rng,num_in_max=args.num_in_max)
                    if op == 'IS_NOT_NULL':
                        vals[i] = v
                    else:
                        vals[i] =  f'''\"{v}\"'''

        elif new_dtype == 'date' :
            if val == 'nan' or pd.isnull(val) :
                # op = 'IS_NULL'
                # vals[i] = 'None'
                continue
            else :
                op = rng.choice(NUMERIC_OPERATORS)
                if op=='!=':
                    v = rng.choice(dvs[col])
                    while (len(dvs[col]) > 1) and (v == val): v = rng.choice(dvs[col])
                vals[i] = v

        else:
            if type(val) != str and np.isnan(val):
                # op = 'IS_NULL'
                # vals[i] = 'None'
                continue
            else:
                op = rng.choice(NUMERIC_OPERATORS)
                if agg == 'COUNT':
                    vals[i] = rng.randint(1,5)
                else:
                    if op=='!=':
                        v = rng.choice(dvs[col])
                        while (len(dvs[col]) > 1) and (v == val): v = rng.choice(dvs[col])

                    if dtype_dict[col] == 'int':
                        vals[i] = int(v)

        ops.append(op)
        if col == "*":
            predicates.append(agg + '(' + col + ') ' + op + ' ' + str(vals[i]) if agg != 'NONE' else col + ' ' + op + ' ' + str(vals[i]))
        else:
            predicates.append(agg + '(' + prefix + col + ') ' + op + ' ' + str(vals[i]) if agg != 'NONE' else prefix + col + ' ' + op + ' ' + str(vals[i]))

    tree_predicates = build_predicate_tree_cnf(rng, predicates)

    return tree_predicates, (cols, vals, ops), used_tables

def order_generator (args, rng, cols, dtype_dict, group=False, group_columns=False, outer_inner='non-nested'):
    min_order, max_order = args.num_order_min, args.num_order_max
    num_order = rng.randint(min_order, max_order)

    columns = []
    if outer_inner == 'outer':
        prefix = 'O_'
    elif outer_inner == 'inner':
        prefix = 'I_'
    else:
        prefix = ''
    
    columns_with_prefix = []

    while len(columns) < num_order:
        col = rng.choice(cols)
        # use_agg = bool(rng.randint(0, 2))
        use_agg = False
        if not group or col in group_columns:
            use_agg = False

        if use_agg:
            if dtype_dict[col] == 'str':
                agg = rng.choice(TEXTUAL_AGGS)
            else:
                agg = rng.choice(NUMERIC_AGGS)
        else:
            agg = 'NONE'

        col_rep = agg + '(' + col + ')' if agg != 'NONE' else col
        col_rep_with_prefix = agg + '(' + prefix + col + ')' if agg != 'NONE' else prefix + col
        if col_rep in columns:
            continue
        else:
            columns.append(col_rep)
            columns_with_prefix.append(col_rep_with_prefix)

    return columns, columns_with_prefix

def limit_generator (args, rng):
    min_limit, max_limit = args.num_limit_min, args.num_limit_max
    num_limit = rng.randint(min_limit, max_limit)

    return num_limit

def inner_query_obj_to_inner_query(args, df, n, rng, inner_query_obj, dtype_dict, dvs, nesting_column=None, correlation_column=None):

    # obj to sql
    sql_type_dict = inner_query_obj['type']
    agg_cols = inner_query_obj['agg_cols']
    use_agg_sel = inner_query_obj['use_agg_sel']
    select_columns = inner_query_obj['select']
    where_predicates = inner_query_obj['where']
    group_columns = inner_query_obj['group']
    having_predicates = inner_query_obj['having']
    order_columns = inner_query_obj['order']
    limit_num = inner_query_obj['limit']
    necessary_tables = inner_query_obj['tables']
    necessary_joins = inner_query_obj['joins']

    # [TODO] Add correlated columns

    line, _ = sql_formation(args, sql_type_dict, necessary_tables, necessary_joins, 'inner', select_columns, where_predicates, group_columns, having_predicates, order_columns, limit_num)

    return line, None

def inner_query_generator (args, df, n, rng,
                            all_table_set, join_key_list, join_clause_list, join_key_pred,
                            dtype_dict, dvs,
                            nesting_position=-1, nesting_type='non-nested',
                            outer_table_pool=None,
                            nesting_column=None, correlation_column=None,
                            outer_operator=None):
    assert not (nesting_column is None and correlation_column is None), "Inner query must have one of nesting column or correlationg column"

    remain_n = list(range(len(df.notna())))[1:]
    while True:
        if len(remain_n) == 0:
            raise Exception()
        n = rng.choice(remain_n)
        df_columns_not_null = df.columns[df.notna().iloc[n]]
        tables,joins, _, table_columns = get_query_token(all_table_set,join_key_list,df.columns,df_columns_not_null,join_clause_list,rng,join_key_pred=join_key_pred)
        
        if correlation_column is not None and correlation_column not in table_columns:
            remain_n.remove(n)
            continue
        if nesting_column is not None and nesting_column not in table_columns:
            remain_n.remove(n)
            continue
        else:
            break

    sql_type_dict = non_nested_query_form_selector(args, rng)
    # (FIX #10) Always generate where clause for correlated inner query
    if nesting_type in ['type-j', 'type-ja']:
        sql_type_dict['where'] = True
    # (FIX #9) Always generate where clause for inner query of <col> <IN/NOT IN> <inner query> 
    # when table pool of the inner query and the outer query are the same
    if outer_table_pool and set(tables) == set(outer_table_pool) and nesting_position == 1:
        sql_type_dict['where'] = True
    
    if nesting_position == 3:
        sql_type_dict['group'] = False
        sql_type_dict['having'] = False
    
    if sql_type_dict['order']:
        sql_type_dict['limit'] = True
    
    # (FIX C8) One of where/group/order/agg must be in nested query
    while True:
        one_cond = sql_type_dict['where'] or sql_type_dict['group'] or sql_type_dict['order'] or nesting_type in ['type-a', 'type-ja']
        if one_cond:
            break

        sql_type_dict = non_nested_query_form_selector(args, rng)
        if nesting_position == 3:
            sql_type_dict['group'] = False
            sql_type_dict['having'] = False

        if sql_type_dict['order']:
            sql_type_dict['limit'] = True
    

    # (FIX C9) Fix possible operator - aggregation pair
    if outer_operator is not None and sql_type_dict['where']:
        outer_operator = outer_operator + '_w'
        
    select_columns, agg_cols, (used_tables, use_agg_sel) = select_generator(args, rng, table_columns, dtype_dict, join_key_list, tables,
                                                                group=sql_type_dict['group'], outer_inner='inner', 
                                                                nesting_type=nesting_type, nesting_column=nesting_column, 
                                                                outer_nesting_position=nesting_position, outer_operator=outer_operator)
    if sql_type_dict['where']:
        where_predicates, nesting_column, used_tables, result_tuples, tree_predicates_origin, predicates_origin = where_generator(args, rng, table_columns, dtype_dict, join_key_list, all_table_set, join_clause_list, join_key_pred, df, dvs, n, used_tables, outer_inner='inner', outer_correlation_column=correlation_column)
    else:
        where_predicates = []
        tree_predicates_origin = []
        predicates_origin = []
        result_tuples = df
    group_columns_origin, group_columns = group_generator(args, rng,  table_columns, dtype_dict, group=sql_type_dict['group'], outer_inner='inner')
    if sql_type_dict['having']:
        having_predicates, _, used_tables = hainvg_generator(args, rng, table_columns, group_columns_origin, dtype_dict, df, dvs, n, used_tables, outer_inner='inner')
    else:
        having_predicates = []
    order_columns_origin, order_columns = order_generator(args, rng, table_columns, dtype_dict, group=sql_type_dict['group'], group_columns=group_columns_origin, outer_inner='inner')
    limit_num = limit_generator(args, rng)

    used_tables = get_updated_used_tables(used_tables, group_columns_origin)
    used_tables = get_updated_used_tables(used_tables, order_columns_origin)

    # (FIX C4) Remove unncessary tables & joins
    necessary_tables, necessary_joins = find_join_path(joins, tables, used_tables)

    #if sql_type_dict['group']:
    #    select_columns = list(group_columns) + select_columns
    #    agg_cols = [ ('NONE', group_col) for group_col in group_columns_origin ] + agg_cols

    line, _ = sql_formation(args, sql_type_dict, necessary_tables, necessary_joins, 'inner', select_columns, where_predicates, group_columns, having_predicates, order_columns, limit_num)

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
        "correlation_column": correlation_column
    }


    if correlation_column is not None:
        if not use_agg_sel:
            select_columns = [correlation_column] + [col for agg, col in agg_cols]
            new_result_tuples = []
            for key, item in result_tuples:
                new_result_tuples.append((key, item[select_columns]))
            result_tuples = new_result_tuples
        else:
            new_result_tuples = []
            for key, item in result_tuples:
                new_item = item[[correlation_column]].iloc[[0]]
                for i in range(len(agg_cols)):
                    agg, col = agg_cols[i]
                    func = convert_agg_to_func(agg)
                    # col_rep = select_columns[i]
                    new_item[col] = [item[col].aggregate(func=func)]
                new_result_tuples.append((key, new_item))
            result_tuples = new_result_tuples
    else:
        if not use_agg_sel:
            result_tuples = result_tuples[[col for agg, col in agg_cols]]
        else:
            new_result_tuples = pd.DataFrame([])
            for i in range(len(agg_cols)):
                agg, col = agg_cols[i]
                func = convert_agg_to_func(agg)
                new_result_tuples[col] = [result_tuples[col].aggregate(func=func)]

            result_tuples = new_result_tuples


    return line, result_tuples, obj
  
def non_nested_query_generator (args, df, n, rng,
                                all_table_set, join_key_list, join_clause_list, join_key_pred,
                                dtype_dict, dvs):

    df_columns_not_null = df.columns[df.notna().iloc[n]]
    tables,joins,table_columns_projection, table_columns = get_query_token(all_table_set,join_key_list,df.columns,df_columns_not_null,join_clause_list,rng,join_key_pred=join_key_pred)

    sql_type_dict = non_nested_query_form_selector(args, rng)
    
    select_columns, agg_cols, (used_tables, use_agg_sel) = select_generator(args, rng, table_columns_projection, dtype_dict, join_key_list, tables, group=sql_type_dict['group'])
    where_predicates, _, used_tables, _, tree_predicates_origin, predicates_origin= where_generator(args, rng, table_columns, dtype_dict, join_key_list, 
                        all_table_set, join_clause_list, join_key_pred, df, dvs, n, used_tables)
    group_columns_origin, group_columns = group_generator(args, rng,  table_columns, dtype_dict, group=sql_type_dict['group'])
    having_predicates, _, used_tables = hainvg_generator(args, rng, table_columns, group_columns_origin, dtype_dict, df, dvs, n, used_tables)
    order_columns_origin, order_columns = order_generator(args, rng, table_columns, dtype_dict, group=sql_type_dict['group'], group_columns=group_columns_origin)
    limit_num = limit_generator(args, rng)

    used_tables = get_updated_used_tables(used_tables, group_columns_origin)
    used_tables = get_updated_used_tables(used_tables, order_columns_origin)
  
    necessary_tables, necessary_joins = find_join_path(joins, tables, used_tables)

    if sql_type_dict['group']:
        select_columns = list(group_columns) + select_columns
        agg_cols = [ ('NONE', group_col) for group_col in group_columns ] + agg_cols

    line, graph = sql_formation(args, sql_type_dict, necessary_tables, necessary_joins, 'non-nested', select_columns, where_predicates, group_columns, having_predicates, order_columns, limit_num, make_graph=True, select_agg_cols=agg_cols, tree_predicates_origin = tree_predicates_origin, predicates_origin=predicates_origin)
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
        "predicates_origin": predicates_origin
    }

    return line, graph, obj

def nested_query_generator_from_scratch (args, df, n, rng,
                                all_table_set, join_key_list, join_clause_list, join_key_pred,
                                dtype_dict, dvs, nesting_type):
    nesting_position = nesting_position_selector(args, rng, nesting_type)

    sql_type_dict = non_nested_query_form_selector(args, rng)
    # Always generate where clause for nested query
    sql_type_dict['where'] = True
    
    # Step 1. Outer query generation
    df_columns_not_null = df.columns[df.notna().iloc[n]]
    tables,joins, table_columns_projection, table_columns = get_query_token(all_table_set,join_key_list,df.columns,df_columns_not_null,join_clause_list,rng,join_key_pred=join_key_pred)

    select_columns, agg_cols, (used_tables, use_agg_sel) = select_generator(args, rng, table_columns_projection, dtype_dict, join_key_list, tables, group=sql_type_dict['group'], outer_inner='outer')
    if sql_type_dict['where']:
        where_predicates, nesting_column, used_tables, _, tree_predicates_origin, predicates_origin= where_generator(args, rng, table_columns, dtype_dict, join_key_list, 
                        all_table_set, join_clause_list, join_key_pred, df, dvs, n, used_tables, outer_inner='outer', nesting_position=nesting_position, nesting_type=nesting_type)
    else:
        where_predicates = []
        result_tuples = df
    group_columns_origin, group_columns = group_generator(args, rng,  table_columns, dtype_dict, group=sql_type_dict['group'], outer_inner='outer')
    if sql_type_dict['having']:
        having_predicates, _, used_tables = hainvg_generator(args, rng, table_columns, group_columns_origin, dtype_dict, df, dvs, n, used_tables, outer_inner='outer')
    else:
        having_predicates = []
    order_columns_origin, order_columns = order_generator(args, rng, table_columns, dtype_dict, group=sql_type_dict['group'], group_columns=group_columns_origin, outer_inner='outer')
    limit_num = limit_generator(args, rng)
    
    used_tables = get_updated_used_tables(used_tables, group_columns_origin)
    used_tables = get_updated_used_tables(used_tables, order_columns_origin)

    # (FIX C4) Remove unncessary tables & joins
    necessary_tables, necessary_joins = find_join_path(joins, tables, used_tables)

    if sql_type_dict['group']:
        select_columns = list(group_columns) + select_columns
        agg_cols = [ ('NONE', group_col) for group_col in group_columns_origin ] + agg_cols

    line, graph = sql_formation(args, sql_type_dict, necessary_tables, necessary_joins, 'outer', select_columns, where_predicates, group_columns, having_predicates, order_columns, limit_num, make_graph = True, select_agg_cols = agg_cols, tree_predicates_origin = tree_predicates_origin, predicates_origin = predicates_origin)
    #graph = []
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
        "predicates_origin": predicates_origin
    }

    return line, graph, obj

def nested_query_generator (args, df, n, rng,
                                all_table_set, join_key_list, join_clause_list, join_key_pred,
                                dtype_dict, dvs, nesting_type, inner_query_objs = None, inner_query_graphs = None):
    
    if inner_query_objs is None:
        line, graph, obj = nested_query_generator_from_scratch(args, df, n, rng,
                                all_table_set, join_key_list, join_clause_list, join_key_pred,
                                dtype_dict, dvs, nesting_type)
        return line, graph, obj

    df_columns_not_null = df.columns[df.notna().iloc[n]]
    tables,joins, table_columns_projection, table_columns = get_query_token(all_table_set,join_key_list,df.columns,df_columns_not_null,join_clause_list,rng, join_key_pred=join_key_pred)

    # Random select the number of inner queries
    min_nested_pred_num = args.num_nestd_pred_min
    max_nested_pred_num = args.num_nested_pred_max

    candidate_idxs = get_possbie_inner_query_idxs(args, inner_query_objs) # [TODO] If it projects multiple columns, modify the SELECT clause
    num_nested_predicate = rng.randint(min_nested_pred_num, min(len(candidate_idxs),max_nested_pred_num)+1)
    chosen_inner_queries = rng.choice(candidate_idxs, num_nested_predicate, replace=False)

    nested_predicates = []
    nested_predicate_graphs = []

    for i in range(num_nesetd_predicates):
        inner_query_idx = chosen_inner_queries[i]
        nesting_type = nesting_type_selector(args, rng, only_nested=only_nested, only_nonnested=only_nonnested, inner_query_obj=inner_query_objs[inner_query_idx])
        nesting_position = nesting_position_selector(args, rng, nesting_type, inner_query_obj=inner_query_objs[inner_query_idx])
        nested_predicate, nesting_column, used_tables, _, nested_predicate_graph = nested_predicate_generator(args, rng, table_columns, dtype_dict, join_key_list, 
                all_table_set, join_clause_list, join_key_pred, df, dvs, n, used_tables, 
                outer_inner='outer', nesting_position=nesting_position, nesting_type=nesting_type, inner_query_obj = inner_query_objs[inner_query_idx], inner_query_graph = inner_query_graphs[inner_query_idx])
        if i != 0:
            nested_predicates.append('AND')
        nested_predicates.append(nested_predicate)
        nested_predicate_graphs.append(nested_predicate_graph)

    sql_type_dict = non_nested_query_form_selector(args, rng)
    
    # Step 1. Outer query generation
    select_columns, agg_cols, (used_tables, use_agg_sel) = select_generator(args, rng, table_columns_projection, dtype_dict, join_key_list, tables, group=sql_type_dict['group'], outer_inner='outer')
    if sql_type_dict['where']:
        where_predicates, _, used_tables, _, tree_predicates_origin, predicates_origin= where_generator(args, rng, table_columns, dtype_dict, join_key_list, join_clause_list, join_key_pred, df, dvs, n, used_tables)
    else:
        where_predicates = []
        result_tuples = df
    
    # Always generate where clause for nested query
    sql_type_dict['where'] = True
    if len(where_predicates) > 0:
        where_predicates += ['AND']
    where_predicates += nested_predicates

    group_columns_origin, group_columns = group_generator(args, rng,  table_columns, dtype_dict, group=sql_type_dict['group'])
    if sql_type_dict['having']:
        having_predicates, _, used_tables = hainvg_generator(args, rng, table_columns, group_columns_origin, dtype_dict, df, dvs, n, used_tables)
    else:
        having_predicates = []
    order_columns_origin, order_columns = order_generator(args, rng, table_columns, dtype_dict, group=sql_type_dict['group'], group_columns=group_columns_origin)
    limit_num = limit_generator(args, rng)

    used_tables = get_updated_used_tables(used_tables, group_columns_origin)
    used_tables = get_updated_used_tables(used_tables, order_columns_origin)

    # (FIX C4) Remove unncessary tables & joins
    necessary_tables, necessary_joins = find_join_path(joins, tables, used_tables)

    line, _ = sql_formation(args, sql_type_dict, necessary_tables, necessary_joins, 'outer', select_columns, where_predicates, group_columns, having_predicates, order_columns, limit_num, select_agg_cols=agg_cols)
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
        "predicates_origin": predicates_origin
    }



    return line, graph, obj

  
def query_generator (args, df, n, rng,
                        all_table_set, join_key_list, join_clause_list, join_key_pred,
                        dtype_dict, dvs, inner_query_objs=None, inner_query_graphs=None):
    only_nested = args.query_type in ['spj-nested', 'nested']
    only_nonnested = args.query_type in ['spj-non-nested', 'non-nested']
    nesting_type = nesting_type_selector(args, rng, only_nested=only_nested, only_nonnested=only_nonnested)

    if nesting_type == 'non-nested':
        query, graph, obj = non_nested_query_generator(args, df, n, rng,
                                                all_table_set, join_key_list, join_clause_list, join_key_pred,
                                                dtype_dict, dvs)
    else:
        query, graph, obj = nested_query_generator(args, df, n, rng,
                                        all_table_set, join_key_list, join_clause_list, join_key_pred,
                                        dtype_dict, dvs, nesting_type, inner_query_objs, inner_query_graphs)
        graph = []

    return query, graph, obj
