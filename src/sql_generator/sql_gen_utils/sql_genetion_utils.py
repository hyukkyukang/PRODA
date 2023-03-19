from sql_gen_utils.query_graph import Relation, Attribute, Value, Function, Query_graph
from sql_gen_utils.query_graph import OperatorType, AggregationType, operatorNameToType, aggregationNameToType
from hashlib import new
import numpy as np
from numpy.lib.shape_base import column_stack
import pandas as pd
import json
import copy
import networkx as nx

# if is_null_support:
# TEXTUAL_OPERATORS = ['=','!=','LIKE','NOT LIKE','IN','NOT IN','IS_NOT_NULL']
TEXTUAL_OPERATORS = ['=','!=','LIKE','NOT LIKE','IN','NOT IN']
NUMERIC_OPERATORS = ['<=','<','>=','>','=','!=']
KEY_OPERATORS = ['=','!=']

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
#KEY_AGGS = ['MIN', 'MAX', 'COUNT']
KEY_AGGS = ['COUNT']
LOGICAL_OPERATORS = ['AND', 'OR']

# [TODO]: remove
imdb_col_info = json.load(open('data/imdb_dtype_dict.json'))
HASH_CODES = imdb_col_info['hash_codes']
NOTES = imdb_col_info['notes']
IDS = imdb_col_info['ids']
PRIMARY_KEYS = imdb_col_info['primary_keys']


def get_possbie_inner_query_idxs(args, inner_query_objs):
    idxs=[]

    for idx in range(len(inner_query_objs)):
        select_columns = inner_query_objs[idx]['select']
        if len(select_columns) == 1:
            idxs.append(idx)
    
    return idxs


def get_col_info(dbname):
    col_info = json.load(open('data/{dbname}_dtype_dict.json'))
    IDS = col_info['ids']
    HASH_CODES = col_info['hash_codes']
    NOTES = col_info['notes']
    PRIMARY_KEYS = col_info['primary_keys']

    return IDS, HASH_CODES, NOTES, PRIMARY_KEYS

def alias_generator(args):
    # [TODO]: make alias generators when given a table namd and the current nested block index
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

def build_predicate_tree_cnf (rng, predicates): #[ [ [A OR B] AND [C OR D] ] AND [E OR F] ] [ [A AND B] ]
    while len(predicates) > 1:
        selected_idx = rng.choice(range(len(predicates)), 2, replace=False)
        selected_predicates = [predicates[i] for i in selected_idx]
        if len(selected_predicates[0]) > 1 and selected_predicates[0][1] == "AND":
            op = "AND"
        elif len(selected_predicates[1]) > 1 and selected_predicates[1][1] == "AND":
            op = "AND"
        else:
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

def preorder_traverse_to_get_graph (tree, cnf_idx):
    if not isinstance(tree, tuple) and not isinstance(tree, list):
        operations = [(tree, cnf_idx)]
        return operations, cnf_idx
    if len(tree) == 1:
        operations, new_cnf_idx = preorder_traverse_to_get_graph(tree[0], cnf_idx)
        return operations, new_cnf_idx
    
    elif len(tree) == 3:
        left, op, right = tree
    
    left_operations, after_left_cnf_idx = preorder_traverse_to_get_graph(left, cnf_idx)
    if op == "AND":
        after_left_cnf_idx += 1
    right_operations, after_right_cnf_idx = preorder_traverse_to_get_graph(right, after_left_cnf_idx)

    operations = left_operations + right_operations

    return operations, after_right_cnf_idx

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

def get_updated_used_tables(used_tables, columns):
    for col in columns:
        if col == '*':
            continue
        used_tables.add(col.split(".")[0])

    return used_tables


def find_existing_rel_node(rel_nodes, cur_rel_node):
    equi_idx=-1
    for idx, rel_node in enumerate(rel_nodes):
        if rel_node.is_equivalent(rel_node, cur_rel_node):
            assert equi_idx == -1
            equi_idx = idx
    return equi_idx

def sql_formation (args, sql_type_dict, tables, joins, outer_inner, select, where=None, group=None, having=None, order=None, limit=None, make_graph=False, select_agg_cols=None, tree_predicates_origin=None, predicates_origin=None, nesting_level=None, nesting_block_idx=None, inner_select_nodes=None):
    ALIAS_TO_TABLE_NAME, TABLE_NAME_TO_ALIAS = alias_generator(args)
    graph = Query_graph()
    rel_nodes = []
    select_clause = 'SELECT ' + ', '.join(select)
    if make_graph: # add projection edges
        for col_info in select_agg_cols:
            agg = col_info[0]
            col = col_info[1]
            if col == "*":
                rel_name = tables[0]
                col = rel_name + ".*"
            else:
                rel_name = col.split(".")[0]
            
            if outer_inner == 'non-nested':
                cur_rel_node = Relation(rel_name) #Nesting level is always 0
                idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                if idx == -1:
                    rel_nodes.append(cur_rel_node)
                else:
                    cur_rel_node = rel_nodes[idx]
                cur_col_node = Attribute(col)
                if agg != "NONE":
                    cur_agg_node = Function(aggregationNameToType[agg.capitalize()])
                else:
                    cur_agg_node = None
            elif outer_inner == 'outer':
                cur_rel_node = Relation(rel_name) #Nesting level is always 0
                idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                if idx == -1:
                    rel_nodes.append(cur_rel_node)
                else:
                    cur_rel_node = rel_nodes[idx]
                cur_col_node = Attribute(col)
                if agg != "NONE":
                    cur_agg_node = Function(aggregationNameToType[agg.capitalize()])
                else:
                   cur_agg_node = None
            elif outer_inner == 'inner':
                cur_rel_node = Relation(rel_name, query_block_idx=nesting_block_idx, nesting_level=nesting_level) #Nesting level should be given
                idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                if idx == -1:
                    rel_nodes.append(cur_rel_node)
                else:
                    cur_rel_node = rel_nodes[idx]
                cur_col_node = Attribute(col, query_block_idx=nesting_block_idx, nesting_level=nesting_level)
                if agg != "NONE":
                    cur_agg_node = Function(aggregationNameToType[agg.capitalize()], query_block_idx=nesting_block_idx, nesting_level=nesting_level)
                else:
                   cur_agg_node = None
                inner_select_nodes.append((cur_rel_node, cur_col_node, cur_agg_node))
            else:
                assert False, "Currently not supported function: build graph for {outer_inner} query"
            
            graph.connect_projection(cur_rel_node, cur_col_node)
            if cur_agg_node is not None:
                graph.connect_aggregation(cur_col_node, cur_agg_node)

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
    
    if make_graph: # add join edges
        for join_c in joins:
            col_A, col_B = join_c.split('=')
            rel_name_A = col_A.split('.')[0]
            rel_name_B = col_B.split('.')[0]
            if outer_inner == 'non-nested':
                cur_rel_node_A = Relation(rel_name_A) #Nesting level is always 0
                idx = find_existing_rel_node(rel_nodes, cur_rel_node_A)
                if idx == -1:
                    rel_nodes.append(cur_rel_node_A)
                else:
                    cur_rel_node_A = rel_nodes[idx]
                
                cur_rel_node_B = Relation(rel_name_B)
                idx = find_existing_rel_node(rel_nodes, cur_rel_node_B)
                if idx == -1:
                    rel_nodes.append(cur_rel_node_B)
                else:
                    cur_rel_node_B = rel_nodes[idx]
                
                cur_col_node_A = Attribute(col_A)
                cur_col_node_B = Attribute(col_B)
            elif outer_inner == 'outer':
                cur_rel_node_A = Relation(rel_name_A) #Nesting level is always 0
                idx = find_existing_rel_node(rel_nodes, cur_rel_node_A)
                if idx == -1:
                    rel_nodes.append(cur_rel_node_A)
                else:
                    cur_rel_node_A = rel_nodes[idx]
                
                cur_rel_node_B = Relation(rel_name_B)
                idx = find_existing_rel_node(rel_nodes, cur_rel_node_B)
                if idx == -1:
                    rel_nodes.append(cur_rel_node_B)
                else:
                    cur_rel_node_B = rel_nodes[idx]
                
                cur_col_node_A = Attribute(col_A)
                cur_col_node_B = Attribute(col_B)
            elif outer_inner == 'inner':
                cur_rel_node_A = Relation(rel_name_A, query_block_idx=nesting_block_idx, nesting_level=nesting_level) #Nesting level should be given
                idx = find_existing_rel_node(rel_nodes, cur_rel_node_A)
                if idx == -1:
                    rel_nodes.append(cur_rel_node_A)
                else:
                    cur_rel_node_A = rel_nodes[idx]
                
                cur_rel_node_B = Relation(rel_name_B, query_block_idx=nesting_block_idx, nesting_level=nesting_level)
                idx = find_existing_rel_node(rel_nodes, cur_rel_node_B)
                if idx == -1:
                    rel_nodes.append(cur_rel_node_B)
                else:
                    cur_rel_node_B = rel_nodes[idx]
                
                cur_col_node_A = Attribute(col_A, query_block_idx=nesting_block_idx, nesting_level=nesting_level)
                cur_col_node_B = Attribute(col_B, query_block_idx=nesting_block_idx, nesting_level=nesting_level)
            else:
                assert False, "Currently not supported function: build graph for {outer_inner} query"
            
            graph.connect_join(cur_rel_node_A, cur_col_node_A, cur_col_node_B, cur_rel_node_B)
        
    # WHERE clause generation
    if sql_type_dict['where']:
        where_clause = ' WHERE ' + preorder_traverse(where)
        if make_graph: # add selection edges
            assert tree_predicates_origin
            operations, _ = preorder_traverse_to_get_graph(tree_predicates_origin, 0)
            for operation_idx, cnf_idx in operations:
                if outer_inner == 'non-nested':
                    operation = predicates_origin[operation_idx]
                    col = operation[0]
                    op = operation[1]
                    val = operation[2]
                    rel_name = col.split(".")[0]
                    
                    cur_rel_node = Relation(rel_name) #Nesting level is always 0
                    idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                    if idx == -1:
                        rel_nodes.append(cur_rel_node)
                    else:
                        cur_rel_node = rel_nodes[idx]
                    cur_col_node = Attribute(col)
                    cur_op_type = operatorNameToType[op]
                    cur_val_node = Value(val)
                    
                    graph.connect_selection(cur_rel_node, cur_col_node)
                    graph.connect_operation(cur_col_node, cur_op_type, cur_val_node)
                elif outer_inner == 'outer':
                    # [TODO] Make graph for inner query block
                    operation = predicates_origin[operation_idx]
                    left = operation[0]
                    op = operation[1]
                    right = operation[2]
                    if len(operation) == 4: # nested predicate
                        inner_obj = operation[3]
                        inner_select_nodes = []
                        
                        _, inner_graph = sql_formation(args, inner_obj['type'], inner_obj['tables'], inner_obj['joins'], 'inner', inner_obj['select'], inner_obj['where'], inner_obj['group'], inner_obj['having'], inner_obj['order'], inner_obj['limit'], make_graph=True, select_agg_cols=inner_obj['agg_cols'], tree_predicates_origin=inner_obj['tree_predicates_origin'], predicates_origin=inner_obj['predicates_origin'], nesting_block_idx=0, nesting_level=1, inner_select_nodes=inner_select_nodes)
                        assert len(inner_select_nodes) > 0
                        graph = nx.compose(graph, inner_graph)
                        correlation_column = inner_obj['correlation_column']
                        # correlation_predicate = 'O_' + outer_correlation_column + ' = I_' + outer_correlation_column
                        if correlation_column is not None:
                            # get correlated node 
                            rel_name_correlation = correlation_column.split('.')[0]
                            cur_rel_node_correlation = Relation(rel_name_correlation) #Nesting level is always 0
                            idx = find_existing_rel_node(rel_nodes, cur_rel_node_correlation)
                            if idx == -1:
                                rel_nodes.append(cur_rel_node_correlation)
                            else:
                                cur_rel_node_correlation = rel_nodes[idx]

                            cur_col_node_correlation = Attribute(correlation_column)
                            cur_op_type_correlation = operatorNameToType["="]
                            
                            cur_col_node_correlation_inner = Attribute(correlation_column, 0, 1)
                            cur_rel_node_correlation_inner = inner_graph.get_equivalent_node(Relation(rel_name_correlation, 0, 1))
                            assert cur_rel_node_correlation_inner is not None
                            
                            graph.connect_selection(cur_rel_node_correlation, cur_col_node_correlation)
                            graph.connect_operation(cur_col_node_correlation, cur_op_type_correlation, cur_col_node_correlation_inner)
                            graph.connect_projection(cur_col_node_correlation_inner, cur_rel_node_correlation_inner)                            
                            
                        if left is None: # EXISTS
                            assert correlation_column is not None
                            #dummy node
                            rel_name = correlation_column.split('.')[0]
                            cur_rel_node = Relation(rel_name) #Nesting level is always 0
                            idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                            if idx == -1:
                                rel_nodes.append(cur_rel_node)
                            else:
                                cur_rel_node = rel_nodes[idx]

                            cur_col_node = Attribute('*')
                            cur_op_type = operatorNameToType[op]
                            
                            cur_col_node_inner = inner_select_nodes[0][1]
                            #cur_rel_node_inner = inner_select_nodes[0][0]
                            if inner_select_nodes[0][2] is not None:
                                cur_col_node_inner = inner_select_nodes[0][2]

                            assert cur_col_node_inner is not None
                            
                            graph.connect_selection(cur_rel_node, cur_col_node)
                            graph.connect_operation(cur_col_node, cur_op_type, cur_col_node_inner)
                    

                        elif left.startswith('(') and left.endswith(')'): # ( inner query ) op val
                            assert correlation_column is not None
                            val = right

                            cur_col_node_inner = inner_select_nodes[0][1]
                            cur_rel_node_inner = inner_select_nodes[0][0]
                            cur_op_type = operatorNameToType[op]
                            cur_val_node = Value(val)

                            assert cur_col_node_inner is not None
                            
                            graph.connect_selection(cur_rel_node_inner, cur_col_node_inner)
                            if inner_select_nodes[0][2] is not None:
                                cur_agg_node_inner = inner_select_nodes[0][2]
                                graph.connect_aggregation(cur_col_node_inner, cur_agg_node_inner)
                                graph.connect_operation(cur_agg_node_inner, cur_op_type, cur_val_node)
                            else:
                                graph.connect_operation(cur_col_node_inner, cur_op_type, cur_val_node)
                            #get mu node 
                        else:
                            col = left
                            assert col.startswith('O_')
                            col = col[2:]
                            rel_name = col.split('.')[0]
                            cur_rel_node = Relation(rel_name) #Nesting level is always 0
                            idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                            if idx == -1:
                                rel_nodes.append(cur_rel_node)
                            else:
                                cur_rel_node = rel_nodes[idx]
                                
                            quantifier=''
                            if "ALL" in op or "ANY" in op:
                                quantifier = op[-3:]
                                op = op[:-4]
                            
                            cur_col_node = Attribute(col)
                            cur_op_type = operatorNameToType[op]

                            #get mu node 
                            cur_col_node_inner = inner_select_nodes[0][1]
                            #cur_rel_node_inner = inner_select_nodes[0][0]
                            if inner_select_nodes[0][2] is not None:
                                cur_col_node_inner = inner_select_nodes[0][2]

                            assert cur_col_node_inner is not None
                            graph.connect_selection(cur_rel_node, cur_col_node)
                            graph.connect_operation(cur_col_node, cur_op_type, cur_col_node_inner, quantifier=quantifier)
                    else:
                        col = left
                        assert col.startswith('O_')
                        col = col[2:]
                        val = right
                        rel_name = col.split(".")[0]
                        cur_rel_node = Relation(rel_name) #Nesting level is always 0
                        idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                        if idx == -1:
                            rel_nodes.append(cur_rel_node)
                        else:
                            cur_rel_node = rel_nodes[idx]
                        cur_col_node = Attribute(col)
                        cur_op_type = operatorNameToType[op]
                        cur_val_node = Value(val)
                        
                        graph.connect_selection(cur_rel_node, cur_col_node)
                        graph.connect_operation(cur_col_node, cur_op_type, cur_val_node)
                elif outer_inner == 'inner':
                    operation = predicates_origin[operation_idx]
                    col = operation[0]
                    assert col.startswith('I_')
                    col = col[2:]
                    op = operation[1]
                    val = operation[2]
                    rel_name = col.split(".")[0]
                    
                    cur_rel_node = Relation(rel_name, query_block_idx=nesting_block_idx, nesting_level=nesting_level) #Nesting level is always 0
                    idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                    if idx == -1:
                        rel_nodes.append(cur_rel_node)
                    else:
                        cur_rel_node = rel_nodes[idx]
                    cur_col_node = Attribute(col, query_block_idx=nesting_block_idx, nesting_level=nesting_level)
                    cur_op_type = operatorNameToType[op]
                    cur_val_node = Value(val, query_block_idx=nesting_block_idx, nesting_level=nesting_level)
                    
                    graph.connect_selection(cur_rel_node, cur_col_node)
                    graph.connect_operation(cur_col_node, cur_op_type, cur_val_node)
                else:
                    assert False, "Currently not supported function: build graph for {outer_inner} query"
    else:
        where_clause = ''

    # GROUP BY clause generation
    if sql_type_dict['group']:
        group_clause = ' GROUP BY ' + ', '.join(group)
        if make_graph: # add group by edges
            for group_col in group:
                rel_name = group_col.split(".")[0]
                if outer_inner == 'non-nested':
                    cur_rel_node = Relation(rel_name) #Nesting level is always 0
                    idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                    if idx == -1:
                        rel_nodes.append(cur_rel_node)
                    else:
                        cur_rel_node = rel_nodes[idx]
                    cur_col_node = Attribute(group_col)
                elif outer_inner == 'outer':
                    assert rel_name.startswith('O_')
                    rel_name = rel_name[2:]
                    cur_rel_node = Relation(rel_name) #Nesting level is always 0
                    idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                    if idx == -1:
                        rel_nodes.append(cur_rel_node)
                    else:
                        cur_rel_node = rel_nodes[idx]
                    assert group_col.startswith('O_')
                    group_col_origin = group_col[2:]
                    cur_col_node = Attribute(group_col_origin)
                elif outer_inner == 'inner':
                    assert rel_name.startswith('I_')
                    rel_name = rel_name[2:]
                    cur_rel_node = Relation(rel_name, query_block_idx=nesting_block_idx, nesting_level=nesting_level) #Nesting level is always 0
                    idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                    if idx == -1:
                        rel_nodes.append(cur_rel_node)
                    else:
                        cur_rel_node = rel_nodes[idx]
                    assert group_col.startswith('I_')
                    group_col_origin = group_col[2:]
                    cur_col_node = Attribute(group_col_origin, query_block_idx=nesting_block_idx, nesting_level=nesting_level)
                else:
                    assert False, "Currently not supported function: build graph for {outer_inner} query"
                graph.connect_group(cur_rel_node, cur_col_node)
    else:
        group_clause = ''

    # HAVING clause generation
    if sql_type_dict['having']:
        having_clause = ' HAVING ' + preorder_traverse(having)
        if make_graph: # add having edges
            operations, _ = preorder_traverse_to_get_graph(having, 0)
            for operation_string, cnf_idx in operations:
                if outer_inner == 'non-nested':
                    agg_col = operation_string.split(" ")[0]
                    assert "(" in agg_col and ")" in agg_col
                    agg = agg_col.split("(")[0]
                    col = agg_col.split("(")[1].split(")")[0]
                    op = operation_string.split(" ")[1]
                    val = " ".join(operation_string.split(" ")[2:])
                    if op == "NOT":
                        op += " "+operation_string.split(" ")[2]
                        val = " ".join(operation_string.split(" ")[3:])
                    
                    if col == "*":
                        rel_name = tables[0]
                        col = rel_name + ".*"
                    else:
                        rel_name = col.split(".")[0]
                    
                    cur_rel_node = Relation(rel_name) #Nesting level is always 0
                    idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                    if idx == -1:
                        rel_nodes.append(cur_rel_node)
                    else:
                        cur_rel_node = rel_nodes[idx]
                    cur_agg_node = Function(aggregationNameToType[agg.capitalize()])
                    cur_col_node = Attribute(col)
                    cur_op_type = operatorNameToType[op]
                    cur_val_node = Value(val)
                    
                    graph.connect_having(cur_rel_node, cur_col_node)
                    graph.connect_aggregation(cur_col_node, cur_agg_node)
                    graph.connect_operation(cur_agg_node, cur_op_type, cur_val_node)
                elif outer_inner == 'outer':
                    agg_col = operation_string.split(" ")[0]
                    assert "(" in agg_col and ")" in agg_col
                    agg = agg_col.split("(")[0]
                    col = agg_col.split("(")[1].split(")")[0]
                    assert col == "*" or col.startswith('O_')
                    if col.startswith('O_'):
                        col = col[2:]
                    op = operation_string.split(" ")[1]
                    val = " ".join(operation_string.split(" ")[2:])
                    if op == "NOT":
                        op += " "+operation_string.split(" ")[2]
                        val = " ".join(operation_string.split(" ")[3:])
                    
                    if col == "*":
                        rel_name = tables[0]
                        col = rel_name + ".*"
                    else:
                        rel_name = col.split(".")[0]
                    
                    cur_rel_node = Relation(rel_name) #Nesting level is always 0
                    idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                    if idx == -1:
                        rel_nodes.append(cur_rel_node)
                    else:
                        cur_rel_node = rel_nodes[idx]
                    cur_agg_node = Function(aggregationNameToType[agg.capitalize()])
                    cur_col_node = Attribute(col)
                    cur_op_type = operatorNameToType[op]
                    cur_val_node = Value(val)
                    
                    graph.connect_having(cur_rel_node, cur_col_node)
                    graph.connect_aggregation(cur_col_node, cur_agg_node)
                    graph.connect_operation(cur_agg_node, cur_op_type, cur_val_node)
                elif outer_inner == 'inner':
                    agg_col = operation_string.split(" ")[0]
                    assert "(" in agg_col and ")" in agg_col
                    agg = agg_col.split("(")[0]
                    col = agg_col.split("(")[1].split(")")[0]
                    assert col == "*" or col.startswith('I_')
                    if col.startswith('I_'):
                        col = col[2:]
                    op = operation_string.split(" ")[1]
                    val = " ".join(operation_string.split(" ")[2:])
                    if op == "NOT":
                        op += " "+operation_string.split(" ")[2]
                        val = " ".join(operation_string.split(" ")[3:])
                    
                    if col == "*":
                        rel_name = tables[0]
                        col = rel_name + ".*"
                    else:
                        rel_name = col.split(".")[0]
                    
                    cur_rel_node = Relation(rel_name, query_block_idx=nesting_block_idx, nesting_level=nesting_level) #Nesting level should be given
                    idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                    if idx == -1:
                        rel_nodes.append(cur_rel_node)
                    else:
                        cur_rel_node = rel_nodes[idx]
                    cur_agg_node = Function(aggregationNameToType[agg.capitalize()], query_block_idx=nesting_block_idx, nesting_level=nesting_level)
                    cur_col_node = Attribute(col, query_block_idx=nesting_block_idx, nesting_level=nesting_level)
                    cur_op_type = operatorNameToType[op]
                    cur_val_node = Value(val, query_block_idx=nesting_block_idx, nesting_level=nesting_level)
                    
                    graph.connect_having(cur_rel_node, cur_col_node)
                    graph.connect_aggregation(cur_col_node, cur_agg_node)
                    graph.connect_operation(cur_agg_node, cur_op_type, cur_val_node)
                else:
                    assert False, "Currently not supported function: build graph for {outer_inner} query"
    else:
        having_clause = ''

    # ORDER BY clause generation
    if sql_type_dict['order']:
        order_clause = ' ORDER BY ' + ', '.join(order)
        if make_graph: # add order by edges
            for order_col in order:
                assert '(' not in order_col, "Currently not support aggregation in order by"
                rel_name = order_col.split(".")[0]
                if outer_inner == 'non-nested':
                    cur_rel_node = Relation(rel_name) #Nesting level is always 0
                    idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                    if idx == -1:
                        rel_nodes.append(cur_rel_node)
                    else:
                        cur_rel_node = rel_nodes[idx]
                    cur_col_node = Attribute(order_col)
                elif outer_inner == 'outer':
                    assert rel_name.startswith('O_')
                    assert order_col.startswith('O_')
                    rel_name = rel_name[2:]
                    cur_rel_node = Relation(rel_name) #Nesting level is always 0
                    idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                    if idx == -1:
                        rel_nodes.append(cur_rel_node)
                    else:
                        cur_rel_node = rel_nodes[idx]
                    order_col_origin = order_col[2:]
                    cur_col_node = Attribute(order_col_origin)
                elif outer_inner == 'inner':
                    assert rel_name.startswith('I_')
                    assert order_col.startswith('I_')
                    rel_name = rel_name[2:]
                    cur_rel_node = Relation(rel_name, query_block_idx=nesting_block_idx, nesting_level=nesting_level) #Nesting level should be given
                    idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                    if idx == -1:
                        rel_nodes.append(cur_rel_node)
                    else:
                        cur_rel_node = rel_nodes[idx]
                    order_col_origin = order_col[2:]
                    cur_col_node = Attribute(order_col_origin, query_block_idx=nesting_block_idx, nesting_level=nesting_level)
                else:
                    assert False, "Currently not supported function: build graph for {outer_inner} query"
                graph.connect_order(cur_rel_node, cur_col_node, is_asc=True) # [TODO]: add order by desc
    else:
        order_clause = ''

    # LIMIT clause generation
    if sql_type_dict['limit']:
        limit_clause = ' LIMIT ' + str(limit)
        if make_graph: # add limit edges
            rel_name = tables[0]
            if outer_inner == 'non-nested':
                cur_rel_node = Relation(rel_name) #Nesting level is always 0
                idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                if idx == -1:
                    rel_nodes.append(cur_rel_node)
                else:
                    cur_rel_node = rel_nodes[idx]
                cur_val_node = Value(limit)
            elif outer_inner == 'outer':
                cur_rel_node = Relation(rel_name) #Nesting level is always 0
                idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                if idx == -1:
                    rel_nodes.append(cur_rel_node)
                else:
                    cur_rel_node = rel_nodes[idx]
                cur_val_node = Value(limit)
            elif outer_inner == 'inner':
                cur_rel_node = Relation(rel_name, query_block_idx=nesting_block_idx, nesting_level=nesting_level)
                idx = find_existing_rel_node(rel_nodes, cur_rel_node)
                if idx == -1:
                    rel_nodes.append(cur_rel_node)
                else:
                    cur_rel_node = rel_nodes[idx]
                cur_val_node = Value(limit)
            else:
                assert False, "Currently not supported function: build graph for {outer_inner} query"
            graph.connect_limit(cur_rel_node, cur_val_node)
    else:
        limit_clause = ''

    line = select_clause + \
            from_clause + \
            where_clause + \
            group_clause + \
            having_clause + \
            order_clause + \
            limit_clause
    
    if make_graph and outer_inner != 'inner':
        graph.set_join_directions()

    return line, graph

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
            #if (not join_key_pred) and (col in join_key_list): # or "id" in col.split('.')[1].lower()): # [TODO] Correction: id
            if (not join_key_pred) and (col in join_key_list or "id" in col.split('.')[1].lower()): # [TODO] Correction: id
                continue
            candiate_cols.append(col)
    
    tables = list(table_set)

    return tables,joins,candidate_cols_projection, candiate_cols


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
