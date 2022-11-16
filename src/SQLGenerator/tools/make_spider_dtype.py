import re
import json
import argparse
import os
import sqlite3
from datetime import datetime
from encodings.aliases import aliases

_encodings = set(aliases.values())

DBPATH_GLOBAL = "/mnt/sdb1/hjkim/NL2QGM/data/spider/database/"
DATE_PATTERN_ISO = r'^(-?(?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9]+)?(Z|[+-](?:2[0-3]|[01][0-9]):[0-5][0-9])?$'
match_iso8601 = re.compile(DATE_PATTERN_ISO).match

def load_schemas(schemas_path):
    schemas = json.load(open(schemas_path))
    return schemas

def is_date_type(values): # Currently not support date type
    for value in values:
        is_date = False
        if match_iso8601( value ) is None: # ISO 8061 format
            for fmt in ('%Y%m%d', '%Y-%m-%d %H:%M', '%Y-%m-%d %H:%M:%S', '%Y-%m-%d', '%d-%b-%Y', '%d/%m/%Y %H:%M', '%Y'):
                try:
                    datetime.strptime(value, fmt)
                except ValueError:
                    if value == '0000-00-00':
                        is_date = True
                else:
                    is_date = True
            if not is_date:
                return False
    return True

def is_int_type(values):
    for value in values:
        try:
            float(value)
        except ValueError:
            return False
        else:
            if not float(value).is_integer():
                return False
    return True

def is_float_type(values):
    for value in values:
        try:
            float(value)
        except ValueError:
            return False
        else:
            pass
    return True

def is_str_type(values):
    for value in values:
        if not isinstance(value, str):
            return False
    return True

def type_check_based_column_type(values, spider_column_type):
    column_type = ""

    assert spider_column_type in ("text", "number", "time", "others", "boolean"), values

    if spider_column_type == "time":
        if len(values) == 0:
            column_type = "date"
        else:
            if not isinstance(values[0], str):
                print("WARNING! type casting {} to str".format(type(values[0])))
                for i in range(len(values)):
                    values[i]=str(values[i])
            
            if is_date_type(values):
                column_type = "date"
            else:
                print(values)
                assert False
    elif spider_column_type in ("text"):
        if len(values) == 0:
            column_type = "str"
        else:
            if not isinstance(values[0], str):
                print("WARNING! type casting {} to str".format(type(values[0])))
                for i in range(len(values)):
                    values[i]=str(values[i])
            if is_date_type(values):
                column_type = "date"
            else:
                column_type = "str"
    elif spider_column_type in ("boolean", "others"):
        column_type = "str"
    elif spider_column_type == "number":
        if len(values) == 0:
            column_type = "int"
        else:
            if is_int_type(values):
                column_type = "int"
            elif is_float_type(values):
                column_type = "float"
            else:
                print("WARNING! spider data type errors (str -> number) for: {}".format(values))
                column_type = "str"
    else:
        assert False
    
    assert column_type in ("date", "str", "int", "float")
    return column_type


def type_check(values):
    column_type = ""
    assert len(values) > 0

    if is_date_type(values):
        column_type = "date"
    elif is_int_type(values):
        column_type = "int"
    elif is_float_type(values):
        column_type = "float"
    elif is_str_type(values):
        column_type = "str"
    else:
        assert False
    
    assert column_type in ("date", "str", "int", "float")
    return column_type


def try_encodings(byte_text: bytes):
    for encoding in _encodings:
        try:
            print(f'Encoding {encoding}: {byte_text.decode(encoding)}')
        except (UnicodeDecodeError, LookupError):
            pass

def get_values(cur, table, column):
    cur.execute("SELECT DISTINCT {} FROM {}".format(column, table))

    #values = cur.fetchall()
    #return [value[0] for value in values if value[0] is not None and value[0] != '']
    values = []
    while True:
        try:
            row = cur.fetchone()
        except sqlite3.OperationalError:
            continue
        if row is None:
            break
        if row[0] is None or row[0] == '':
            continue
        values.append(row[0])

    return values

def make_dtype(schema):
    columns=schema["column_names_original"]
    tables=schema["table_names_original"]
    spider_column_types=schema["column_types"]
    db_id=schema["db_id"]

    db_path=os.path.join(DBPATH_GLOBAL, db_id, db_id+".sqlite")
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    dtype_dict={}
    for column_id, (table_id, column_name) in enumerate(columns):
        if table_id == -1:
            continue
        table_name = tables[table_id]
        col_ref_name = table_name + "." + column_name

        spider_column_type = spider_column_types[column_id]
        values = get_values(cur, table_name, '`'+column_name+'`')
        column_type = type_check_based_column_type(values, spider_column_type)
        assert ( column_type in ("int", "float", "str", "date") )
        dtype_dict[col_ref_name] = column_type
    
    conn.close()

    return dtype_dict

def make_ids(schema, include_fk=True):
    columns=schema["column_names_original"]
    tables=schema["table_names_original"]
    
    primary_keys=schema["primary_keys"] # [ pk_id, .., ]
    
    ids=[]
    for pk_id in primary_keys:
        pk_table_id = columns[ pk_id ][0]
        pk_name = columns[ pk_id ][1]
        pk_table_name = tables[ pk_table_id ]
        pk_ref_name = pk_table_name + "." + pk_name
        ids.append(pk_ref_name)

    if include_fk:
        foreign_keys=schema["foreign_keys"]
        for fk_id, pk_id in foreign_keys:
            pk_table_id = columns[ pk_id ][0]
            fk_table_id = columns[ fk_id ][0]
            pk_name = columns[ pk_id ][1]
            fk_name = columns[ fk_id ][1]
            pk_table_name = tables[ pk_table_id ]
            fk_table_name = tables[ fk_table_id ]
            pk_ref_name = pk_table_name + "." + pk_name
            fk_ref_name = fk_table_name + "." + fk_name
            #assert ( pk_ref_name in ids )
            if pk_ref_name not in ids:
                ids.append(pk_ref_name)
            if fk_ref_name not in ids:
                ids.append(fk_ref_name)

    return ids

def make_notes(schema):
    return []

def make_hash_codes(schema):
    return []

def make_primary_keys(schema):
    primary_keys=schema["primary_keys"] # [ pk_id, .., ]
    columns=schema["column_names_original"]
    tables=schema["table_names_original"]

    primary_keys_transformed={}
    for pk_id in primary_keys:
        pk_table_id = columns[ pk_id ][0]
        pk_name = columns[ pk_id ][1]
        pk_table_name = tables[ pk_table_id ]
        pk_ref_name = pk_table_name + "." + pk_name
        primary_keys_transformed[pk_table_name] = pk_ref_name

    return primary_keys_transformed

def make_dtype_dict_per_schema(schema):
    db_id=schema["db_id"]
    dtype_dict={}

    dtype_dict["dtype_dict"]=make_dtype(schema)
    dtype_dict["ids"]=make_ids(schema)
    dtype_dict["hash_codes"]=make_hash_codes(schema)
    dtype_dict["notes"]=make_notes(schema)
    dtype_dict["primary_keys"]=make_primary_keys(schema)

    return db_id, dtype_dict

def make_dtype_dict_collection(schemas):
    dtype_dict_collection = {}
    for schema in schemas:
        db_id, dtype_dict = make_dtype_dict_per_schema(schema)
        dtype_dict_collection[db_id] = dtype_dict

    return dtype_dict_collection

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--schemas_path',type=str, default='./data/spider/tables.json')
    parser.add_argument('--output_path',type=str,default='./data/spider_dtype_dict.json')
    args = parser.parse_args()

    schemas_path = args.schemas_path
    schemas = load_schemas(schemas_path)
    
    dtype_dict_collection = make_dtype_dict_collection(schemas)

    with open(args.output_path, 'w') as wf:
        json.dump(dtype_dict_collection, wf, indent=3)

    

    
    
    
