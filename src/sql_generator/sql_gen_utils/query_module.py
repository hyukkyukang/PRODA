import random

NUMERIC_AGGS = ['NONE', 'MIN', 'MAX', 'AVG', 'SUM', 'COUNT']
TEXTUAL_AGGS = ['NONE', 'COUNT']

def select_generator (args, cols, dtype_dict):
    min_select, max_select = args.min_select_clause, args.max_select_clause
    num_select = random.randint(min_select, max_select)

    columns = []

    if num_select == 0:
        columns.append('*') 
    else:
        while len(columns) < num_select:
            col = random.sample(cols, 1)
            if dtype_dict[col] == 'str':
                agg = random.sample(TEXTUAL_AGGS, 1)
            elif dtype_dict[col] == 'date':
                raise NotImplementedError("Date is not considered in Spider dataset")
            else:
                agg = random.sample(NUMERIC_AGGS, 1)

            if (agg, col) in columns:
                continue
            else:
                columns.append((agg, col))

    return columns

def group_generator (args, cols, dtype_dict):
    min_group, max_group = args.min_group_clause, args.max_group_clause
    num_gruop = random.randint(min_group, max_group)

    assert num_gruop > 0

    columns = random.sample(cols, num_gruop)

    return columns

def order_generator (args, cols, dtype_dict, is_group):
    min_order, max_order = args.min_order_clause, args.max_order_clause
    num_order = random.randint(min_order, max_order)

    assert num_order > 0

    columns = []

    while len(columns) < num_order:
        col = random.sample(cols, 1)
        if is_group:
            agg = 'NONE'
        else:
            if dtype_dict[col] == 'str':
                agg = random.sample(TEXTUAL_AGGS, 1)
            elif dtype_dict[col] == 'date':
                raise NotImplementedError("Date is not considered in Spider dataset")
            else:
                agg = random.sample(NUMERIC_AGGS, 1)

        if (agg, col) in columns:
            continue
        else:
            columns.append((agg, col))

    return columns
