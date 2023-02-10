import json
from os import F_ULOCK

dbs = json.load(open('data/tables.json'))
whole_schema = {}
dtype_dict = {}
c_type_map = {
    'text': 'str',
    'number': 'float',
    'time': 'date',
    'others': 'str',
    'boolean': 'str'
}

for db_ent in dbs:
    db_id = db_ent['db_id']
    column_names = db_ent['column_names_original']
    table_names = db_ent['table_names_original']
    column_types = db_ent['column_types']
    primary_keys = db_ent['primary_keys']
    foreign_keys = db_ent['foreign_keys']

    join_keys = {}
    for t in table_names:
        join_keys[t] = []

    for c in column_names:
        t_idx = c[0]
        c_name = c[1]
        
        if t_idx >= 0:
            t_name = table_names[t_idx]
            # join_keys[t_name].append(c_name)

    join_clauses = []
    for fk, pk in foreign_keys:
        fk_col_info = column_names[fk]
        fk_col = fk_col_info[1]
        fk_tab = table_names[fk_col_info[0]]

        pk_col_info = column_names[pk]
        pk_col = pk_col_info[1]
        pk_tab = table_names[pk_col_info[0]]

        clause = pk_tab + '.' + pk_col + '=' + fk_tab + '.' + fk_col

        join_clauses.append(clause)
        if pk_tab not in join_keys:
            join_keys[pk_tab] = []
        if fk_tab not in join_keys:
            join_keys[fk_tab] = []

        if pk_col not in join_keys[pk_tab]:
            join_keys[pk_tab].append(pk_col)
        if fk_col not in join_keys[fk_tab]:
            join_keys[fk_tab].append(fk_col)


    dtype_dict[db_id] = {}
    for t in table_names:
        dtype_dict[db_id][t] = {}
    for c_idx, c in enumerate(column_names):
        t_idx = c[0]
        c_name = c[1]
        c_type = column_types[c_idx]

        c_type_new = c_type_map[c_type]
        
        if t_idx >= 0:
            t_name = table_names[t_idx]
            dtype_dict[db_id][t_name + '.' + c_name] = c_type_new


    whole_schema[db_id] = {
        'join_tables': list(join_keys.keys()),
        'join_keys': join_keys,
        'join_clauses': join_clauses,
        'dataset': 'spider',
        'join_root': table_names[0],
        'join_how': 'outer',
        'use_cols': db_id,
        'data_dir': 'data/csv/' + db_id + '/'
    }

json.dump(whole_schema, open('data/spider_schema.json', 'w'), indent=2)
json.dump(dtype_dict, open('data/spider_dtype_dict.json', 'w'), indent=2)
