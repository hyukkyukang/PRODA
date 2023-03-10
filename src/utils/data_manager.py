import argparse
import json
import pickle
from typing import Any

from src.utils.pg_connector import PostgresConnector

# Must be given an absolute path
config = json.load(open("/home/proda/config.json"))["collection"]


# Save python object files as pickle files.
def save_data(data: Any, path: str) -> None:
    with open(path, "wb") as f:
        pickle.dump(data, f)


def save_task_in_db(
    nl: str,
    sql: str,
    evql_path: str,
    query_type: str,
    table_excerpt_path: str,
    result_table_path: str,
    db_name: str,
    task_type: int,
) -> None:
    pg = PostgresConnector(config["DBUserID"], config["DBUserPW"], config["DBIP"], config["DBPort"], config["DBName"])
    pg.execute(
        f"INSERT INTO {config['DBTaskTableName']} (nl, sql, evql_path, query_type, table_excerpt_path, result_table_path, db_name, task_type) VALUES ('{nl}', '{sql}', '{evql_path}', '{query_type}', '{table_excerpt_path}', '{result_table_path}', '{db_name}', '{task_type}')"
    )


# Load pickle files as python objects.
def load_data(path: str) -> None:
    with open(path, "rb") as f:
        return pickle.load(f)


# Load data and print it json string.
def load_and_print_data(path: str) -> None:
    data = load_data(path)
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
