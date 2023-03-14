import argparse
import json
import os
import pickle
from typing import Any, List

import hkkang_utils.file as file_utils

from src.utils.pg_connector import PostgresConnector

# Must be given an absolute path
config_file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../config.yml")
config = file_utils.read_yaml_file(config_file_path)

IP = config["DB"]["IP"]
port = config["DB"]["Port"]
DBName = config["DB"]["collection"]["DBName"]
DBUserID = config["DB"]["collection"]["UserID"]
DBUserPW = config["DB"]["collection"]["UserPW"]
DBTableName = config["DB"]["collection"]["TaskTableName"]


# Save python object files as pickle files.
def save_data(data: Any, path: str) -> None:
    # Create directory if not exists
    dir_path, _ = file_utils.split_path_into_dir_and_file_name(path)
    os.makedirs(dir_path, exist_ok=True)
    with open(path, "wb") as f:
        pickle.dump(data, f)


def save_task_in_db(
    nl: str,
    sql: str,
    query_type: str,
    evql_path: str,
    table_excerpt_path: str,
    result_table_path: str,
    nl_mapping_path: str,
    db_name: str,
    task_type: int,
    history_task_ids: List[int],
) -> None:
    pg = PostgresConnector(DBUserID, DBUserPW, IP, port, DBName)
    history_task_ids_str = "{" + ",".join(map(lambda k: f'"{str(k)}"', history_task_ids)) + "}"
    sql = sql.replace("'", "\\'")
    pg.execute(
        f"INSERT INTO {DBTableName} (nl, sql, query_type, evql_path, table_excerpt_path, result_table_path, nl_mapping_path, db_name, task_type, history_task_ids) VALUES (E'{nl}', E'{sql}', '{query_type}', '{evql_path}', '{table_excerpt_path}', '{result_table_path}', '{nl_mapping_path}', '{db_name}', {task_type}, '{history_task_ids_str}') RETURNING id"
    )
    return pg.fetchone()[0]


# Load pickle files as python objects.
def load_data(path: str) -> None:
    assert os.path.exists(path), f"{path} does not exist!"
    with open(path, "rb") as f:
        return pickle.load(f)


# Load data and print it json string.
def load_and_print_data(path: str) -> None:
    data = load_data(path)
    try:
        print(json.dumps(data), end="")
    except Exception as e:
        assert hasattr(data, "dump_json"), f"{data.__class__.__name__} does not have dump_json method!"
        print(json.dumps(data.dump_json()), end="")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--file_path", type=str, required=True)
    args = parser.parse_args()
    return args


if __name__ == "__main__":
    args = parse_args()
    load_and_print_data(args.file_path)
