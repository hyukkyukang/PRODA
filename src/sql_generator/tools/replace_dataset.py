import json
import pandas as pd

from tqdm import tqdm

schemas = json.load(open('data/spider_schema.json'))
cell_replacement = {}
skip_for_test = ['baseball_1']

for db_id in tqdm(list(sorted(schemas.keys())), total=len(schemas.keys())):
    if db_id in skip_for_test:
        continue
    schema = schemas[db_id]
    if 'join_unique_values' not in schema.keys():
        schema['join_unique_values'] = {}
        join_groups = []
        for join_cond in schema['join_clauses']:
            c1, c2 = join_cond.split('=')

            make_new_group = True
            for join_group in join_groups:
                if c1 in join_group or c2 in join_group:
                    make_new_group = False
                    if c1 not in join_group:
                        join_group.append(c1)
                    if c2 not in join_group:
                        join_group.append(c2)
            
            if make_new_group:
                join_groups.append([c1, c2])

        for join_group in join_groups:		
            schema['join_unique_values'][tuple(join_group)] = {}

    for table in tqdm(schema['join_tables'], total=len(schema['join_tables'])):
        df = pd.read_csv(schema['data_dir'] + table + '.csv')
        cols = schema['join_keys'][table]

        for col in cols:
            if pd.api.types.is_numeric_dtype(df[col]):
                continue
            tabcol = table + '.' + col
            for join_group in schema['join_unique_values'].keys():
                if tabcol in join_group:
                    for cell in df[col]:
                        if cell not in schema['join_unique_values'][join_group].keys():
                            schema['join_unique_values'][join_group][cell] = len(schema['join_unique_values'][join_group].keys())
                    
                    for key, value in schema['join_unique_values'][join_group].items():
                        df[col] = df[col].replace(key, value)

        df.to_csv(schema['data_dir'].replace('/csv/', '/csv_replaced/') + table + '.csv',
            index=False)

    cell_replacement[db_id] = {
        'join_groups': {},
        'replacement': {}
    }
    for join_group in schema['join_unique_values'].keys():
        cur_join_group_key = len(cell_replacement[db_id]['join_groups'].keys())
        cell_replacement[db_id]['join_groups'][cur_join_group_key] = join_group
        cell_replacement[db_id]['replacement'][cur_join_group_key] = {v: k for k, v in schema['join_unique_values'][join_group].items()}

json.dump(cell_replacement, open('data/spider_replacement.json', 'w'), indent=2)