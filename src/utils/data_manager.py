import argparse
import json
import os
import pickle
import sys
from typing import Any, Dict, List, Union

import hkkang_utils.file as file_utils

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))))
from src.config import config
from src.utils.pg_connector import PostgresConnector

IP = config["DB"]["IP"]
port = config["DB"]["Port"]
DBName = config["DB"]["collection"]["DBName"]
DBUserID = config["DB"]["collection"]["UserID"]
DBUserPW = config["DB"]["collection"]["UserPW"]
DBTaskTableName = config["DB"]["collection"]["TaskTableName"]
DBTaskSetTableName = config["DB"]["collection"]["TaskSetTableName"]


# Save python object files as pickle files.
def save_data(data: Any, path: str) -> None:
    # Create directory if not exists
    dir_path, _ = file_utils.split_path_into_dir_and_file_name(path)
    os.makedirs(dir_path, exist_ok=True)
    with open(path, "wb") as f:
        pickle.dump(data, f)


def save_json(data: Union[Dict, str], path: str) -> None:
    def save_json_string() -> None:
        # Check if data is JSON
        try:
            json.loads(data)
        except:
            raise ValueError("Data is not JSON")
        with open(path, "wb") as f:
            f.write(data.encode("utf-8"))

    def save_json_object() -> None:
        # check if valid json object
        try:
            json_str = json.dumps(data)
        except:
            raise ValueError("Data is not JSON")
        with open(path, "w", encoding="utf8") as f:
            json.dump(data, f)

    # Create directory if not exists
    dir_path, _ = file_utils.split_path_into_dir_and_file_name(path)
    os.makedirs(dir_path, exist_ok=True)
    if type(data) == str:
        save_json_string()
    else:
        save_json_object()


def save_task_set_in_db(
    task_ids: List[int],
):
    pg = PostgresConnector(DBUserID, DBUserPW, IP, port, DBName)
    task_ids_str = "{" + ",".join(map(lambda k: f'"{str(k)}"', task_ids)) + "}"
    pg.execute(f"INSERT INTO {DBTaskSetTableName} (task_ids) VALUES ('{task_ids_str}') RETURNING id")
    return pg.fetchone()[0]


def save_task_set_in_db(
    task_ids: List[int],
):
    pg = PostgresConnector(DBUserID, DBUserPW, IP, port, DBName)
    task_ids_str = "{" + ",".join(map(lambda k: f'"{str(k)}"', task_ids)) + "}"
    pg.execute(f"INSERT INTO {DBTaskSetTableName} (task_ids) VALUES ('{task_ids_str}') RETURNING id")
    return pg.fetchone()[0]


def save_task_in_db(
    nl: str,
    sql: str,
    query_type: str,
    evqa_path: str,
    table_excerpt_path: str,
    result_table_path: str,
    nl_mapping_path: str,
    db_name: str,
    task_type: int,
    sub_task_ids: List[int],
) -> int:
    pg = PostgresConnector(DBUserID, DBUserPW, IP, port, DBName)
    sub_task_ids_str = "{" + ",".join(map(lambda k: f'"{str(k)}"', sub_task_ids)) + "}"
    nl = nl.replace("'", "\\'")
    sql = sql.replace("'", "\\'")
    pg.execute(
        f"INSERT INTO {DBTaskTableName} (nl, sql, query_type, evqa_path, table_excerpt_path, result_table_path, nl_mapping_path, db_name, task_type, sub_task_ids) VALUES (E'{nl}', E'{sql}', '{query_type}', '{evqa_path}', '{table_excerpt_path}', '{result_table_path}', '{nl_mapping_path}', '{db_name}', {task_type}, '{sub_task_ids_str}') RETURNING id"
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
