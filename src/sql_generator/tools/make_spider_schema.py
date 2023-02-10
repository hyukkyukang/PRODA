import json
import argparse
import os

DATASET_PATH = "datasets/spider_csv_export/"

def load_schemas(schemas_path):
    schemas = json.load(open(schemas_path))
    return schemas

def transform_schemas(schemas):
    schemas_transformed = {}
    for schema in schemas:
        db_id, schema_transformed = trasnform_schema_per_db(schema)
        schemas_transformed[db_id] = schema_transformed
    return schemas_transformed

def trasnform_schema_per_db(schema):
    schema_transformed = {}

    db_id = schema["db_id"]
    tables = schema["table_names_original"]
    columns = schema["column_names_original"]
    schema_transformed['join_tables'] = tables

    foreign_keys = schema["foreign_keys"]
    primary_keys = schema["primary_keys"]
    join_clauses = []
    key_dict = {}
    for table in tables: # Initialize
        key_dict[table] = []
    for fk_pk_pair in foreign_keys: # Find all keys in db
        assert ( len(fk_pk_pair) == 2 )
        fk, pk = columns[ fk_pk_pair[0] ], columns[ fk_pk_pair[1] ]
        assert ( len(fk) == 2 )
        assert ( len(pk) == 2 )
        fk_table_id, pk_table_id = fk[0], pk[0]
        assert ( fk_table_id >= 0 and fk_table_id < len(tables) )
        assert ( pk_table_id >= 0 and pk_table_id < len(tables) )
        fk_table = tables[fk_table_id]
        pk_table = tables[pk_table_id]
        assert ( fk_table in key_dict and pk_table in key_dict )
        key_dict[fk_table].append( fk[1] )
        key_dict[pk_table].append( pk[1] )

        join_clause=pk_table+"."+pk[1]+"="+fk_table+"."+fk[1]
        join_clauses.append(join_clause)
    
    for pk_id in primary_keys: # if not exists in dict
        pk = columns[pk_id]
        assert ( len(pk) == 2 )
        pk_table_id = pk[0]
        assert ( pk_table_id >= 0 and pk_table_id < len(tables) )
        pk_table = tables[pk_table_id]
        assert ( pk_table in key_dict )
        if pk[1] not in key_dict[table]:
            key_dict[pk_table].append( pk[1] )

    
    schema_transformed['join_keys']=key_dict

    schema_transformed['join_clauses']=join_clauses

    schema_transformed['dataset'] = "spider"
    schema_transformed['join_root'] = None
    schema_transformed['join_how'] = "outer"
    schema_transformed['use_cols'] = db_id
    schema_transformed['data_dir'] = os.path.join(DATASET_PATH, db_id)

    return db_id, schema_transformed
    
    

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--schemas_path',type=str, default='./data/spider/tables.json')
    parser.add_argument('--output_path',type=str,default='./data/spider_schema.json')
    args = parser.parse_args()

    schemas_path = args.schemas_path
    schemas = load_schemas(schemas_path)
    print (schemas_path)
    schemas_formatted=transform_schemas(schemas)

    with open(args.output_path, 'w') as wf:
        json.dump(schemas_formatted, wf, indent=3)

    

    
    
    
