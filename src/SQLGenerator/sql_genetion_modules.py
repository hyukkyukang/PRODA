from hashlib import new
import numpy as np
from numpy.lib.shape_base import column_stack
import pandas as pd
import json

# if is_null_support:
# TEXTUAL_OPERATORS = ['=','!=','LIKE','NOT LIKE','IN','NOT IN','IS_NOT_NULL']
TEXTUAL_OPERATORS = ['=','!=','LIKE','NOT LIKE','IN','NOT IN']
NUMERIC_OPERATORS = ['<=','<','>=','>','=','!=']
KEY_OPERATORS = ['=','!=']
# else:
# 	TEXTUAL_OPERATORS = ['=','!=','LIKE','NOT LIKE','IN','NOT IN']
POSSIBLE_AGGREGATIONS_PER_OPERATOR = {
    '=': ['MIN', 'MAX', 'AVG', 'SUM'],
    '!=': ['MIN', 'MAX', 'AVG', 'SUM'],
    '=_w': ['MIN', 'MAX', 'AVG', 'SUM'],
    '!=_w': ['MIN', 'MAX', 'AVG', 'SUM'],
    '<=': ['AVG', 'SUM'],
    '<': ['MAX', 'AVG', 'SUM'],
    '>=': ['AVG', 'SUM'],
    '>': ['MIN', 'AVG', 'SUM'],
    '<=_w': ['MAX', 'AVG', 'SUM'],
    '<_w': ['MAX', 'AVG', 'SUM'],
    '>=_w': ['MIN', 'AVG', 'SUM'],
    '>_w': ['MIN', 'AVG', 'SUM'],
}
# (CONSIDERATION) larger/smaller than sum without condition is wierd? what if negative values exist

NUMERIC_AGGS = ['MIN', 'MAX', 'AVG', 'SUM', 'COUNT']
TEXTUAL_AGGS = ['COUNT']
KEY_AGGS = ['MIN', 'MAX', 'COUNT']

LOGICAL_OPERATORS = ['AND', 'OR']

imdb_col_info = json.load(open('imdb_dtypedict.json'))
HASH_CODES = imdb_col_info['hash_codes']
NOTES = imdb_col_info['notes']
IDS = imdb_col_info['ids']
PRIMARY_KEYS = imdb_col_info['primary_keys']


def alias_generator(args):
    if args.db == 'imdb':
        ALIAS_TO_TABLE_NAME = None
        # ALIAS_TO_TABLE_NAME = {
        #         'n':'name',
        #         'mc':'movie_companies',
        #         'an':'aka_name',
        #         'mi':'movie_info',
        #         'mk':'movie_keyword',
        #         'pi':'person_info',
        #         'cct':'comp_cast_type',
        #         'cc':'complete_cast',
        #         'ch_n':'char_name', 
        #         'ml':'movie_link',
        #         'ct':'company_type',
        #         'ci':'cast_info',
        #         'it':'info_type',
        #         'cn':'company_name',
        #         'at':'aka_title',
        #         'kt':'kind_type',
        #         'rt':'role_type',
        #         'mi_idx':'movie_info_idx',
        #         'k':'keyword',
        #         'lt':'link_type',
        #         't':'title',
        #     }
    elif args.db == 'tpcds':
        ALIAS_TO_TABLE_NAME = {
                'ss': 'store_sales',
                'sr': 'store_returns',
                'cs': 'catalog_sales',
                'cr': 'catalog_returns',
                'ws': 'web_sales',
                'wr': 'web_returns',
                'inv': 'inventory',
                's': 'store',
                'cc': 'call_center',
                'cp': 'catalog_page',
                'web': 'web_site',
                'wp': 'web_page',
                'w': 'warehouse',
                'c': 'customer',
                'ca': 'customer_address',
                'cd': 'customer_demographics',
                'd': 'date_dim',
                'hd': 'household_demographics',
                'i': 'item',
                'ib': 'income_band',
                'p': 'promotion',
                'r': 'reason',
                'sm': 'ship_mode',
                't': 'time_dim',
            }	
    else:
        ALIAS_TO_TABLE_NAME = None

    if ALIAS_TO_TABLE_NAME:
        TABLE_NAME_TO_ALIAS = dict()
        for k,v in ALIAS_TO_TABLE_NAME.items():
            TABLE_NAME_TO_ALIAS[v] = k
    else:
        TABLE_NAME_TO_ALIAS = None

    return ALIAS_TO_TABLE_NAME, TABLE_NAME_TO_ALIAS


def get_str_op_values(op,val,distinct_values,rng,num_in_max):
    if op == '=':
        return val
    elif op == '!=':
        v = rng.choice(distinct_values)
        while (len(distinct_values) > 1) and (v is val): v = rng.choice(distinct_values) # not test yet
        return str(v).strip()
    elif op == 'LIKE':
        val = str(rng.choice(val.split(' ')))
        candidate_op_idx = rng.choice([0,1,2])
        if len(val) > 7:
            if candidate_op_idx == 0:
                val = val[:7]
            elif candidate_op_idx == 1:
                val = val[-7:]
            elif candidate_op_idx == 2:
                start_idx = rng.randint(0,len(val)-7)
                val = val[start_idx:start_idx+7]

        candidate_vals = [f"{val}%",f"%{val}",f"%{val}%"]

        # val = val.replace('"', '\\\"')
        # return rng.choice([f"{val}%",f"%{val}",f"%{val}%"])

        return candidate_vals[candidate_op_idx].replace('"', '\\\"')
    elif op == 'NOT LIKE':
        for i in range(10): #param
            if len(distinct_values) == 1:
                return rng.choice([f"{val}%",f"%{val}",f"%{val}%"])
            distinct_values = distinct_values
            candidate_val = str(rng.choice(distinct_values)).strip()

            candidate_val = str(rng.choice(candidate_val.split(' ')))
            if len(candidate_val) > 7:
                start_idx = rng.randint(0,len(candidate_val)-7)
                candidate_val = candidate_val[start_idx:start_idx+7]

            candidate_op_idx = rng.choice([0,1,2])
            candidate_vals = [f"{candidate_val}%",f"%{candidate_val}",f"%{candidate_val}%"]

            if candidate_op_idx == 0:
                if val.startswith(candidate_val):
                    continue
            elif candidate_op_idx == 1 :
                if val.endswith(candidate_val):
                    continue
            elif candidate_op_idx == 2 :
                if candidate_val in val:
                    continue
                
            return candidate_vals[candidate_op_idx].replace('"', '\\\"')

        return candidate_vals[candidate_op_idx].replace('"', '\\\"')
    elif op == 'IN':
        num_in_values = rng.randint(1, num_in_max+1) #param
        index = np.argwhere(distinct_values==val)
        distinct_values = np.delete(distinct_values, index)
        candidate_val = rng.choice(distinct_values,size=min(len(distinct_values),num_in_values-1),replace=False)
        in_values = np.insert(candidate_val,0,val)
        num_in_values = len(in_values)
        
        if type(in_values[0]) == str:
            in_value_txt = ','.join(["'%s'"%(v.strip().replace("'", "\\\'").replace('"', '\\\"')) for v in in_values])
        else :
            in_values = list(map(lambda i: "'%s'"%(str(i).strip().replace("'", "\\\'").replace('"', '\\\"')), in_values))
            in_value_txt = ','.join(in_values)
        in_value_txt = f"({in_value_txt})"
        return in_value_txt, num_in_values

    elif op == 'NOT IN':
        num_in_values = rng.randint(1, num_in_max+1) #param
        index = np.argwhere(distinct_values==val)
        distinct_values = np.delete(distinct_values, index)
        in_values = rng.choice(distinct_values,size=min(len(distinct_values),num_in_values),replace=False)
        num_in_values = len(in_values)
        
        if type(in_values[0]) == str:
            in_value_txt = ','.join(["'%s'"%(v.strip().replace("'", "\\\'").replace('"', '\\\"')) for v in in_values])
        else :
            in_values = list(map(lambda i: "'%s'"%(str(i).strip().replace("'", "\\\'").replace('"', '\\\"')), in_values))
            in_value_txt = ','.join(in_values)
        in_value_txt = f"({in_value_txt})"
        return in_value_txt, num_in_values
    elif op == 'IS_NULL':
        return 'None'
    elif op == 'IS_NOT_NULL':
        return 'None'


def split_predicate_tree_with_condition (predicates):
    if not isinstance(predicates, list) or len(predicates) < 2:
        return
    if predicates[1] not in ['AND', 'OR']:
        return
    
    parent_cond = True
    if len(predicates) == 4:
        parent_cond = predicates[3]
    
    if predicates[1] == 'AND':
        predicates[0].append(parent_cond)
        predicates[2].append(parent_cond)
    else:
        predicates[0].append(parent_cond)
        predicates[2].append(False)

    split_predicate_tree_with_condition (predicates[0])
    split_predicate_tree_with_condition (predicates[2])


def flatten_condition_predicate_tree (predicates):
    if not isinstance(predicates, list) or len(predicates) <= 2:
        return [predicates]
    if predicates[1] not in ['AND', 'OR']:
        return [predicates]

    p1 = flatten_condition_predicate_tree(predicates[0])
    p2 = flatten_condition_predicate_tree(predicates[2])

    return p1 + p2


def build_predicate_tree (rng, predicates):
    while len(predicates) > 1:
        selected_idx = rng.choice(range(len(predicates)), 2, replace=False)
        selected_predicates = [predicates[i] for i in selected_idx]
        op = rng.choice(LOGICAL_OPERATORS)

        connected_predicates = [selected_predicates[0], op, selected_predicates[1]]

        new_predicates = [p for idx, p in enumerate(predicates) if idx not in selected_idx] + [connected_predicates]
        predicates = new_predicates

    return predicates[0]


def restore_predicate_tree (tree, predicates):
    if len(tree) <= 2:
        idx = tree[0]
        return predicates[idx]

    left = restore_predicate_tree (tree[0], predicates)
    right = restore_predicate_tree (tree[2], predicates)

    return [left, tree[1], right]


def preorder_traverse (tree):
    if not isinstance(tree, tuple) and not isinstance(tree, list):
        return tree

    assert len(tree) == 3 or len(tree) == 1

    if len(tree) == 1:
        assert len(tree[0]) == 3
        left, op, right = tree[0]
    elif len(tree) == 3:
        left, op, right = tree

    return '(' + preorder_traverse(left) + ' ' + op + ' ' + preorder_traverse(right) + ')'


def nesting_type_selector (args, rng, only_nested=False, only_nonnested=False):
    assert not( only_nested and only_nonnested ), "Only nested and only nonnested options cannot be activated at the same time."

    nesting_type_origin = ['non-nested', 'type-n', 'type-a', 'type-j', 'type-ja']
    if args.set_nested_query_type:
        nesting_type_origin = ['non_nested']
        if args.has_type_n:
            nesting_type_origin.append('type-n')
        if args.has_type_a:
            nesting_type_origin.append('type-a')
        if args.has_type_j:
            nesting_type_origin.append('type-j')
        if args.has_type_ja:
            nesting_type_origin.append('type-ja')
    if only_nested:
        nesting_type = nesting_type_origin[rng.randint(1, len(nesting_type_origin))]
    elif only_nonnested:
        nesting_type = 'non-nested'
    else:
        nesting_type = nesting_type_origin[rng.randint(0, len(nesting_type_origin))]

    return nesting_type


def nesting_position_selector (args, rng, nesting_type):
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
        return rng.randint(0, 4)

    elif nesting_type == 'type-ja':
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

    tree_predicates = build_predicate_tree(rng, [[x] for x in range(num_predicate)])
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
                        vals[0] =  f"""\"{v}\""""

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
        else:
            predicate_str = prefix + col + ' ' + op + ' ' + str(vals[0])
        predicates.append(predicate_str)
        cond_idx += 1

    if nesting_position != -1: # If nested query needs to be generated
        result_condition = sorted_conditions[-1][1]
        done = False
        while not done:
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

                inner_query, inner_query_result = inner_query_generator(args, df, n, rng,
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
                    result_guarantee_tuples = new_result_guarantee_tuples
                    # result_guarantee_predicates.append(query_predicate)

                used_tables.add(col.split('.')[0])
                predicate_str = prefix + col + ' ' + op + ' (' + inner_query + ')'
                nesting_col = col
                done = True
            
            elif nesting_position == 1:
                column_idx = rng.randint(0, len(table_columns))
                col = table_columns[column_idx]
                if correlation_column and col == correlation_column:
                    continue
                op = rng.choice(['IN', 'NOT IN'])

                inner_query, inner_query_result = inner_query_generator(args, df, n, rng,
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
                nesting_col = col
                done = True
                break

            elif nesting_position == 2:
                op = rng.choice(['EXIST', 'NOT EXIST'])
                inner_query, inner_query_result = inner_query_generator(args, df, n, rng,
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
                        if (num_result > 0 and op == 'EXIST') or (num_result < 1 and op == 'NOT EXIST'):
                            new_result_guarantee_tuples = new_result_guarantee_tuples.append(tpl.iloc[0])

                    num_result = len(new_result_guarantee_tuples)
                    if num_result < 1:
                        continue

                predicate_str = op + ' (' + inner_query + ')'
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

                inner_query, inner_query_result = inner_query_generator(args, df, n, rng,
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
                done = True
                break

        # for i, val in enumerate(vals):
        #     if nesting_position == 1:
        #         op = rng.choice(['IN', 'NOT IN'])
        #         used_tables.add(col.split('.')[0])
        #         predicate_str = col + ' ' + op + ' ' + '|INNER_QUERY|'
        #         nesting_col = col
        #         done = True
        #         break

        #     elif nesting_position == 0:
        #         # (FIX #5) Non-textual column for type-a, type-ja nested query
        #         # for <col> <op> <inner query> form
        #         if nesting_type in ['type-a', 'type-ja'] and dtype_dict[col] == 'str':
        #             continue
        #         if dtype_dict[col] == 'str':
        #             op = rng.choice(TEXTUAL_OPERATORS[0:3])
        #         else:
        #             op = rng.choice(NUMERIC_OPERATORS)

        #         used_tables.add(col.split('.')[0])
        #         predicate_str = col + ' ' + op + ' ' + '|INNER_QUERY|'
        #         nesting_col = col
        #         done = True
        #         break

        #     elif nesting_position == 2:
        #         op = rng.choice(['EXIST', 'NOT EXIST'])
        #         predicate_str = op + ' ' + '|INNER_QUERY|'
        #         done = True
        #         break

        #     else:
        #         predicate_str = '|INNER_QUERY| |OP| |VAL|'
        #         done = True
        #         break
        
        if not done:
            raise Exception()
        predicates.append(predicate_str)

    tree_predicates = restore_predicate_tree(tree_predicates, predicates)

    # (FIX #12): Make correlation predicate as the top level predicate 
    if outer_correlation_column is not None: # (TODO) nned to identify whether it's generating outer query or inner query
        correlation_predicate = 'O_' + outer_correlation_column + ' = I_' + outer_correlation_column
        tree_predicates = [(correlation_predicate, 'AND', tree_predicates)]
        result_guarantee_tuples = result_guarantee_tuples.groupby(outer_correlation_column)

    return tree_predicates, nesting_col, used_tables, result_guarantee_tuples


def group_generator (args, rng, cols, dtype_dict, group=False):
    min_group, max_group = args.num_group_min, args.num_group_max
    num_group = rng.randint(min_group, max_group)

    columns = rng.choice(cols, num_group, replace=False)

    return columns


def hainvg_generator (args, rng, table_columns, group_columns, dtype_dict, df, dvs, n):
    min_pred_num = args.num_having_min
    max_pred_num = args.num_having_max

    num_predicate = rng.randint(min_pred_num, min(len(table_columns),max_pred_num)+1)
    predicates_cols = list(rng.choice(table_columns, num_predicate, replace=True))

    
    cols = predicates_cols
    vals = list(df[predicates_cols].iloc[n])
    ops = list()

    predicates = list()

    for i,val in enumerate(vals):
        col = cols[i]
        v = val

        if col not in list(group_columns):
            if dtype_dict[col] == 'str':
                agg = rng.choice(TEXTUAL_AGGS)
            else:
                agg = rng.choice(NUMERIC_AGGS)
        else:
            agg = 'NONE'

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
                        vals[i] =  f"""\"{v}\""""

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
        predicates.append(agg + '(' + col + ') ' + op + ' ' + str(vals[i]) if agg != 'NONE' else col + ' ' + op + ' ' + str(vals[i]))

    tree_predicates = build_predicate_tree(rng, predicates)

    return tree_predicates, (cols, vals, ops)


def order_generator (args, rng, cols, dtype_dict, group=False, group_columns=False):
    min_order, max_order = args.num_order_min, args.num_order_max
    num_order = rng.randint(min_order, max_order)

    columns = []

    while len(columns) < num_order:
        col = rng.choice(cols)
        use_agg = bool(rng.randint(0, 2))
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
        if col_rep in columns:
            continue
        else:
            columns.append(col_rep)

    return columns


def limit_generator (args, rng):
    min_limit, max_limit = args.num_limit_min, args.num_limit_max
    num_limit = rng.randint(min_limit, max_limit)

    return num_limit


def non_nested_query_generator (args, df, n, rng,
                                all_table_set, join_key_list, join_clause_list, join_key_pred,
                                dtype_dict, dvs):

    df_columns_not_null = df.columns[df.notna().iloc[n]]
    tables,joins,table_columns_projection, table_columns = get_query_token(all_table_set,join_key_list,df.columns,df_columns_not_null,join_clause_list,rng,join_key_pred=join_key_pred)

    sql_type_dict = non_nested_query_form_selector(args, rng)
    
    select_columns, _, (used_tables, use_agg_sel) = select_generator(args, rng, table_columns_projection, dtype_dict, join_key_list, tables, group=sql_type_dict['group'])
    where_predicates, _, used_tables, _= where_generator(args, rng, table_columns, dtype_dict, join_key_list, 
                        all_table_set, join_clause_list, join_key_pred, df, dvs, n, used_tables)
    group_columns = group_generator(args, rng,  table_columns, dtype_dict, group=sql_type_dict['group'])
    having_predicates, _ = hainvg_generator(args, rng, table_columns, group_columns, dtype_dict, df, dvs, n)
    order_columns = order_generator(args, rng, table_columns, dtype_dict, group=sql_type_dict['group'], group_columns=group_columns)
    limit_num = limit_generator(args, rng)

    # d1_tables = determine_degree_1_table(tables, joins)

    # if not is_inner_query:
    #     for d1t in d1_tables:
    #         if d1t not in used_tables:
    #             cols_in_d1t = [col for col in table_columns if col.split('.')[0] == d1t]
    #             col = rng.choice(cols_in_d1t)
    #             if use_agg_sel:
    #                 if dtype_dict[col] == 'str':
    #                     agg = rng.choice(TEXTUAL_AGGS)
    #                 else:
    #                     agg = rng.choice(NUMERIC_AGGS)
    #             else:
    #                 agg = 'NONE'

    #             col_rep = agg + '(' + col + ')' if agg != 'NONE' else col

    #             if col_rep in select_columns:
    #                 continue
    #             else:
    #                 select_columns.append(col_rep)

    necessary_tables, necessary_joins = find_join_path(joins, tables, used_tables)

    line = sql_formation(args, sql_type_dict, necessary_tables, necessary_joins, 'non-nested', select_columns, where_predicates, group_columns, having_predicates, order_columns, limit_num)

    return line


def nested_query_generator (args, df, n, rng,
                                all_table_set, join_key_list, join_clause_list, join_key_pred,
                                dtype_dict, dvs, nesting_type):
    nesting_position = nesting_position_selector(args, rng, nesting_type)

    sql_type_dict = non_nested_query_form_selector(args, rng)
    # Always generate where clause for nested query
    sql_type_dict['where'] = True
    
    # Step 1. Outer query generation
    df_columns_not_null = df.columns[df.notna().iloc[n]]
    tables,joins, table_columns_projection, table_columns = get_query_token(all_table_set,join_key_list,df.columns,df_columns_not_null,join_clause_list,rng,join_key_pred=join_key_pred)

    select_columns, _, (used_tables, use_agg_sel) = select_generator(args, rng, table_columns_projection, dtype_dict, join_key_list, tables, group=sql_type_dict['group'], outer_inner='outer')
    if sql_type_dict['where']:
        where_predicates, nesting_column, used_tables, _= where_generator(args, rng, table_columns, dtype_dict, join_key_list, 
                        all_table_set, join_clause_list, join_key_pred, df, dvs, n, used_tables, outer_inner='outer', nesting_position=nesting_position, nesting_type=nesting_type)
    else:
        where_predicates = []
        result_tuples = df
    group_columns = group_generator(args, rng,  table_columns, dtype_dict, group=sql_type_dict['group'])
    if sql_type_dict['having']:
        having_predicates, _ = hainvg_generator(args, rng, table_columns, group_columns, dtype_dict, df, dvs, n)
    else:
        having_predicates = []
    order_columns = order_generator(args, rng, table_columns, dtype_dict, group=sql_type_dict['group'], group_columns=group_columns)
    limit_num = limit_generator(args, rng)

    # d1_tables = determine_degree_1_table(tables, joins)

    # for d1t in d1_tables:
    #     if d1t not in used_tables:
    #         cols_in_d1t = [col for col in table_columns if col.split('.')[0] == d1t]
    #         col = rng.choice(cols_in_d1t)
    #         if use_agg_sel:
    #             if dtype_dict[col] == 'str':
    #                 agg = rng.choice(TEXTUAL_AGGS)
    #             else:
    #                 agg = rng.choice(NUMERIC_AGGS)
    #         else:
    #             agg = 'NONE'

    #         col_rep = agg + '(' + col + ')' if agg != 'NONE' else col

    #         if col_rep in select_columns:
    #             continue
    #         else:
    #             select_columns.append(col_rep)


    # (FIX C4) Remove unncessary tables & joins
    necessary_tables, necessary_joins = find_join_path(joins, tables, used_tables)

    line = sql_formation(args, sql_type_dict, necessary_tables, necessary_joins, 'outer', select_columns, where_predicates, group_columns, having_predicates, order_columns, limit_num)

    return line


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
    
    # (FIX C8) One of where/group/order/agg must be in nested query
    while True:
        one_cond = sql_type_dict['where'] or sql_type_dict['group'] or sql_type_dict['order'] or nesting_type in ['type-a', 'type-ja']
        if one_cond:
            break

        sql_type_dict = non_nested_query_form_selector(args, rng)

    # (FIX C9) Fix possible operator - aggregation pair
    if outer_operator is not None and sql_type_dict['where']:
        outer_operator = outer_operator + '_w'
        
    select_columns, agg_cols, (used_tables, use_agg_sel) = select_generator(args, rng, table_columns, dtype_dict, join_key_list, tables,
                                                                group=sql_type_dict['group'], outer_inner='inner', 
                                                                nesting_type=nesting_type, nesting_column=nesting_column, 
                                                                outer_nesting_position=nesting_position, outer_operator=outer_operator)
    if sql_type_dict['where']:
        where_predicates, nesting_column, used_tables, result_tuples = where_generator(args, rng, table_columns, dtype_dict, join_key_list, 
                            all_table_set, join_clause_list, join_key_pred, df, dvs, n, used_tables, outer_inner='inner', outer_correlation_column=correlation_column)
    else:
        where_predicates = []
        result_tuples = df
    group_columns = group_generator(args, rng,  table_columns, dtype_dict, group=sql_type_dict['group'])
    if sql_type_dict['having']:
        having_predicates, _ = hainvg_generator(args, rng, table_columns, group_columns, dtype_dict, df, dvs, n)
    else:
        having_predicates = []
    order_columns = order_generator(args, rng, table_columns, dtype_dict, group=sql_type_dict['group'], group_columns=group_columns)
    limit_num = limit_generator(args, rng)

    # (FIX C4) Remove unncessary tables & joins
    necessary_tables, necessary_joins = find_join_path(joins, tables, used_tables)

    line = sql_formation(args, sql_type_dict, necessary_tables, necessary_joins, 'inner', select_columns, where_predicates, group_columns, having_predicates, order_columns, limit_num)

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


    return line, result_tuples
    


def query_generator (args, df, n, rng,
                        all_table_set, join_key_list, join_clause_list, join_key_pred,
                        dtype_dict, dvs):
    only_nested = args.query_type in ['spj-nested', 'nested']
    only_nonnested = args.query_type in ['spj-non-nested', 'non-nested']
    nesting_type = nesting_type_selector(args, rng, only_nested=only_nested, only_nonnested=only_nonnested)

    if nesting_type == 'non-nested':
        query = non_nested_query_generator(args, df, n, rng,
                                                all_table_set, join_key_list, join_clause_list, join_key_pred,
                                                dtype_dict, dvs)

    else:
        query = nested_query_generator(args, df, n, rng,
                                        all_table_set, join_key_list, join_clause_list, join_key_pred,
                                        dtype_dict, dvs, nesting_type)

    # else:
    #     nesting_position = nesting_position_selector(args, rng, nesting_type)
    #     outer_query, correlation_column, nesting_column, outer_table_pool = non_nested_query_generator(args, df, n, rng,
    #                                                 all_table_set, join_key_list, join_clause_list, join_key_pred,
    #                                                 dtype_dict, dvs,
    #                                                 nesting_position=nesting_position, nesting_type=nesting_type)

    #     inner_query, _, _, _ = non_nested_query_generator(args, df, n, rng,
    #                                                 all_table_set, join_key_list, join_clause_list, join_key_pred,
    #                                                 dtype_dict, dvs,
    #                                                 is_inner_query=True,
    #                                                 outer_nesting_position=nesting_position, outer_nesting_type=nesting_type,
    #                                                 outer_table_pool=outer_table_pool,
    #                                                 nesting_column=nesting_column,
    #                                                 correlation_column=correlation_column)

    #     query = outer_query.replace('|INNER_QUERY|', '(' + inner_query + ')')

    return query


def sql_formation (args, sql_type_dict, tables, joins, outer_inner, select, where=None, group=None, having=None, order=None, limit=None):
    ALIAS_TO_TABLE_NAME, TABLE_NAME_TO_ALIAS = alias_generator(args)

	# SELECT clause generation
    if sql_type_dict['group']:
        select = list(group) + select
    select_clause = 'SELECT ' + ', '.join(select)

    if outer_inner == 'outer':
        prefix = 'O_'
    elif outer_inner == 'inner':
        prefix = 'I_'
    else:
        prefix = ''

    # FROM clause generation
    if TABLE_NAME_TO_ALIAS:
        table_token = sorted([f'{table} {prefix}{TABLE_NAME_TO_ALIAS[table]}' for table in tables])
    else:
        if prefix:
            table_token = sorted([f'{table} {prefix}{table}' for table in tables])
        else:
            table_token = sorted([f'{table}' for table in tables])

    table_string = ' JOIN '.join(table_token)

    join_token = sorted([alias_join_clause(join_c, TABLE_NAME_TO_ALIAS, prefix) for join_c in joins ])
    join_string = ' AND '.join(join_token)

    from_clause = ' FROM ' + table_string
    if len(join_token) >= 1:
        from_clause += ' ON ' + join_string

    # WHERE clause generation
    if sql_type_dict['where']:
        where_clause = ' WHERE ' + preorder_traverse(where)
    else:
        where_clause = ''

    # GROUP BY clause generation
    if sql_type_dict['group']:
        group_clause = ' GROUP BY ' + ', '.join(group)
    else:
        group_clause = ''

    # HAVING clause generation
    if sql_type_dict['having']:
        having_clause = ' HAVING ' + preorder_traverse(having)
    else:
        having_clause = ''

    # ORDER BY clause generation
    if sql_type_dict['order']:
        order_clause = ' ORDER BY ' + ', '.join(order)
    else:
        order_clause = ''

    # LIMIT clause generation
    if sql_type_dict['limit']:
        limit_clause = ' LIMIT ' + str(limit)
    else:
        limit_clause = ''

    line = select_clause + \
            from_clause + \
            where_clause + \
            group_clause + \
            having_clause + \
            order_clause + \
            limit_clause
    
    return line


def get_table_from_clause(join_clause):
	A,B = join_clause.split('=')
	return A.split('.')[0],B.split('.')[0]


def get_possible_join(selected_joins,avaliable_joins):
	result = list()
	for join_clause in avaliable_joins:
		A,B = join_clause.split('=')
		t1,t2 = A.split('.')[0],B.split('.')[0]
		for selected_clause in selected_joins:
			A,B = selected_clause.split('=')
			t3,t4 = A.split('.')[0],B.split('.')[0]
			if t1 == t3 or t1==t4 or t2 == t3 or t2==t4:
				result.append(join_clause)
	return result


def get_query_token(all_table_set, join_key_list,df_columns,df_columns_not_null,join_clause_list, rng,join_key_pred =True):
    avaliable_join_keys = list()
    avaliable_pred_cols = list(df_columns)
    for col in df_columns_not_null:
        if col in join_key_list:
            avaliable_join_keys.append(col)


    avaliable_join_list = list()
    avaliable_table_set = set()
    for join_clause in join_clause_list:
        A,B = join_clause.split('=')
        if A in avaliable_join_keys and B in avaliable_join_keys:
            avaliable_table_set.add(A.split('.')[0])
            avaliable_table_set.add(B.split('.')[0])
            avaliable_join_list.append(join_clause)


    if len(avaliable_table_set) == 0:
        for col in df_columns_not_null:
            table = col.split('.')[0]
            avaliable_table_set.add(table)

    avaliable_tables = list(avaliable_table_set)    
    num_join_clause = rng.randint(0,len(avaliable_join_list)+1)

    table_set = set()
    tables = list()
    joins = list()
    candiate_cols = list()
    predicates_cols = list()
    candidate_cols_projection = list()
    prob = 0.5

    table = rng.choice(avaliable_tables)
    table_set.add(table)
    cont = rng.choice([0, 1], p=[1-prob, prob])

    if cont == 1:
        available_init_join = []
        for join_clause in avaliable_join_list:
            t1, t2 = get_table_from_clause(join_clause)
            if t1 == table or t2 == table:
                available_init_join.append(join_clause)

        init_join = rng.choice(available_init_join)
        avaliable_join_list.remove(init_join)
        joins.append(init_join)

        t1,t2 = get_table_from_clause(init_join)
        table_set.add(t1)
        table_set.add(t2)
  
        cont = rng.choice([0, 1], p=[1-prob, prob])
        while cont == 1:
            candidate_joins = get_possible_join(joins,avaliable_join_list)
            if len(candidate_joins) == 0:
                break
            next_join = rng.choice(candidate_joins)
            avaliable_join_list.remove(next_join)
            joins.append(next_join)

            t1,t2 = get_table_from_clause(next_join)
            table_set.add(t1)
            table_set.add(t2)

            cont = rng.choice([0, 1], p=[1-prob, prob])

    for col in avaliable_pred_cols:
        if col.split('.')[0] in table_set:
            candidate_cols_projection.append(col)
            if (not join_key_pred) and col in join_key_list:
                continue
            candiate_cols.append(col)
    
    tables = list(table_set)




    # if num_join_clause == 0 : # single table
    #     table = rng.choice(avaliable_tables)
    #     tables.append(table)

    #     for col in avaliable_pred_cols:
    #         if col.split('.')[0] == table:
    #             if (not join_key_pred) and col in join_key_list:
    #                 continue
    #             candiate_cols.append(col)
    #     # num_predicate = rng.randint(min_pred_num, min(len(candiate_cols),max_pred_num)+1)
    #     # predicates_cols = list(rng.choice(candiate_cols,num_predicate))

    # else:
    #     init_join = rng.choice(avaliable_join_list)
    #     avaliable_join_list.remove(init_join)
    #     joins.append(init_join)

    #     t1,t2 = get_table_from_clause(init_join)
    #     table_set.add(t1)
    #     table_set.add(t2)

    #     for i in range(num_join_clause-1):
    #     	candidate_joins = get_possible_join(joins,avaliable_join_list)
    #     	if len(candidate_joins) == 0:
    #     		break
    #     	next_join = rng.choice(candidate_joins)
    #     	avaliable_join_list.remove(next_join)
    #     	joins.append(next_join)

    #     	t1,t2 = get_table_from_clause(next_join)
    #     	table_set.add(t1)
    #     	table_set.add(t2)

    #     for col in avaliable_pred_cols:
    #         if col.split('.')[0] in table_set:
    #             if (not join_key_pred) and col in join_key_list:
    #                 continue
    #             candiate_cols.append(col)
    #     # num_predicate = rng.randint(min_pred_num, min(len(candiate_cols),max_pred_num)+1)
    #     # predicates_cols = list(rng.choice(candiate_cols,num_predicate))
    #     tables = list(table_set)

    return tables,joins,candidate_cols_projection, candiate_cols
    #return tables,joins,candiate_cols, candiate_cols


def determine_degree_1_table (tables, joins):
	degrees = {k: 0 for k in tables}
	for join_c in joins:
		tc1, tc2 = join_c.split('=')
		t1, c1 = tc1.split('.')
		t2, c2 = tc2.split('.')

		degrees[t1] += 1
		degrees[t2] += 1


	d1_table = [k for k in degrees.keys() if degrees[k] == 1]

	return d1_table


def alias_join_clause(txt, TABLE_NAME_TO_ALIAS, prefix):
	token = txt.split('=')
	assert len(token)==2
	t1,k1 = token[0].split('.')
	t2,k2 = token[1].split('.')
	if TABLE_NAME_TO_ALIAS:
		t1 = TABLE_NAME_TO_ALIAS[t1]
		t2 = TABLE_NAME_TO_ALIAS[t2]
	return f"{prefix}{t1}.{k1}={prefix}{t2}.{k2}"


def bfs (edges, parents, observed, targets):
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
    path, joins = bfs(edges, candidates, observed, targets)
    src_parent, src_join = cp_condition[path[-1]]
    path.append(src_parent)
    joins.append(src_join)
    return path, joins


def find_join_path (joins, tables, used_tables):
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
    if agg == 'AVG':
        return 'mean'
    else:
        return agg.lower()


def is_numeric(val):
    try:
        float(val)
    except ValueError:
        return False
    else:
        return True


def predicate_generator(col, op, val):
    if op == 'IS_NULL':
        query_predicate = '`' + col + '`.isnull()'
    elif op == 'IS_NOT_NULL':
        query_predicate = 'not `' + col + '`.isnull()'
    elif op == 'LIKE' or op == 'NOT LIKE':
        if val[1] == '%' and val[-2] == '%':
            query_predicate = '`' + col + '`.str.contains("' + eval('"' + val[2:-2] + '"') + '", na=False)'
        elif val[1] == '%':
            query_predicate = '`' + col + '`.str.endswith("' + eval('"' + val[2:]) + '", na=False)'
        elif val[-2] == '%':
            query_predicate = '`' + col + '`.str.startswith("' + eval(val[:-2] + '"') + '", na=False)'
        else:
            query_predicate = '`' + col + '` == ' + val
        if op == 'NOT LIKE':
            query_predicate = 'not ' + query_predicate
    elif op == '=':
        if not is_numeric(val) and not (val[0] == '"' and val[-1] == '"'):
            query_predicate = '`' + col + '` == "' + val + '"'
        else:
            query_predicate = '`' + col + '` == ' + val
    elif op == 'IN':
        query_predicate = '`' + col + '` == ' + str(list(eval(val[1:-1])))
    elif op == 'NOT IN':
        query_predicate = '`' + col + '` != ' + str(list(eval(val[1:-1])))
    else:
        query_predicate = '`' + col + '` ' + op + ' ' + val

    return query_predicate
