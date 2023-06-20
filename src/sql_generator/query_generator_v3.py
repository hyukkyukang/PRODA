import numpy as np
import pandas as pd
import os
import sys
import argparse
import datetime
import time
import json
import hkkang_utils.file as file_utils
import logging
from tqdm import tqdm
from requests.structures import CaseInsensitiveDict

import src.sql_generator.sql_gen_utils.utils as utils
import src.sql_generator.sql_gen_utils.sql_genetion_utils as sql_genetion_utils
from src.sql_generator.sql_gen_utils.sql_genetion_modules import query_generator
from src.pylogos.translate import translate as logos_translate
from src.sql_generator.tools.storage.db import PostgreSQLDatabase


def check_sql_result(data_manager, sql):
    data_manager.execute(sql)

    try:
        data_manager.execute(sql)
        result = data_manager.fetchall()
        if len(result) >= 1:
            return True
    except:
        return False

    return False


def create_full_outer_view(args, ip, port, user_id, user_pw, schema, SEED=1234):
    args.logger.info("... start generating full outer joined view...")
    data_manager = PostgreSQLDatabase(user_id, user_pw, ip, port, schema["dataset"])
    # <table name>___<column name>

    view_name = sql_genetion_utils.get_view_name("main", [schema["dataset"], schema["use_cols"]])

    select_columns = []
    # tables = data_manager.fetch_table_names() ### DO NOT USE ALL TABLES IN DB
    tables = schema["join_tables"]
    table_info = {}
    for table in tables:
        columns = data_manager.fetch_column_names(table)
        table_info[table] = columns
        for column in columns:
            select_columns.append(f"{table}.{column} AS {table}__{column}")
    select_clause = ", ".join(select_columns)

    from_clause = f"""{schema["join_root"]}"""
    visited_join_clauses = []
    visited_tables = [schema["join_root"]]
    join_clauses = schema["join_clauses"]
    while len(visited_join_clauses) < len(join_clauses):
        is_updated = False
        for table in visited_tables:
            for join_clause in join_clauses:
                if join_clause in visited_join_clauses:
                    continue
                key1 = join_clause.split("=")[0]
                key2 = join_clause.split("=")[1]
                tab1 = key1.split(".")[0]
                tab2 = key2.split(".")[0]

                if tab1 == table:
                    if tab2 in visited_tables:
                        args.logger.warning("cyclic join")
                        from_clause += f" AND {join_clause}"
                    else:
                        from_clause += f" FULL OUTER JOIN {tab2} ON {join_clause}"
                        visited_tables.append(tab2)
                    is_updated = True
                    visited_join_clauses.append(join_clause)

                if tab2 == table:
                    if tab1 in visited_tables:
                        args.logger.warning("cyclic join")
                        from_clause += f" AND {join_clause}"
                    else:
                        from_clause += f" FULL OUTER JOIN {tab1} ON {join_clause}"
                        visited_tables.append(tab1)
                    is_updated = True
                    visited_join_clauses.append(join_clause)
        if not is_updated:
            # Not connected join
            args.logger.error("Not supported error: Cartesian Product on FROM clause")
            assert False

    full_outer_join_sql = f"""
            SELECT DISTINCT {select_clause}
            FROM {from_clause};
        """

    args.logger.info(f"View SQL: {full_outer_join_sql}")

    data_manager.create_view(args.logger, view_name, full_outer_join_sql, type="materialized", drop_if_exists=False)
    args.logger.info("... finished: generating full outer joined view...")

    return data_manager, view_name, table_info


def run_generator(data_manager, schema, column_info, args, check_execution_result=True, log_step=1):
    all_table_set = set(schema["join_tables"])
    join_clause_list = schema["join_clauses"]
    join_keys = schema["join_keys"]

    join_key_list = list()
    for table, cols in join_keys.items():
        for col in cols:
            join_key_list.append(f"{table}.{col}")

    rng = np.random.RandomState(args.seed)

    t1 = time.time()
    t2 = time.time()

    lines = list()
    graphs = list()
    objs = list()

    dtype_dict = CaseInsensitiveDict(column_info["dtype_dict"])
    args.IDS, args.HASH_CODES, args.NOTES, args.CATEGORIES, args.FOREIGN_KEYS = sql_genetion_utils.set_col_info(
        column_info
    )

    # for n in range(1,num_queries+1):
    pbar = tqdm(total=args.num_queries)
    num_success = 0
    num_iter = 0
    # Loading non-nested or nested query from files in the given paths
    if args.sql_info["inner_query_paths"]:
        inner_query_objs = list()
        inner_query_graphs = list()
        for inner_query_path in args.sql_info["inner_query_paths"]:
            with open(inner_query_path, "r") as fp:
                q_count = len(fp.readlines())
            inner_query_objs += utils.load_objs(inner_query_path + ".obj", q_count)
            inner_query_graphs += utils.load_graphs(inner_query_path + ".graph", q_count)
        # .obj type files
    else:
        inner_query_objs = None
        inner_query_graphs = None

    global_unique_query_idx = args.global_idx
    output_path = args.output

    while num_success < args.num_queries:
        num_iter += 1
        if num_success == 0 and num_iter > 10000:
            args.logger.warning("This type might be cannot be generated..")
            break

        if sql_genetion_utils.DEBUG_ERROR:
            line, graph, obj = query_generator(
                args,
                data_manager,
                rng,
                all_table_set,
                join_key_list,
                join_clause_list,
                dtype_dict,
                inner_query_objs,
                inner_query_graphs,
                global_unique_query_idx,
            )
            for i in range(len(line)):
                args.logger.info(f"SQL ({i}): ")
                args.logger.info(line[0].strip())
                args.logger.info(f"Translation  ({i}): ")
                text, _ = logos_translate(graph[i][1])
                args.logger.info(text + "\n")
        else:
            try:
                line, graph, obj = query_generator(
                    args,
                    data_manager,
                    rng,
                    all_table_set,
                    join_key_list,
                    join_clause_list,
                    dtype_dict,
                    inner_query_objs,
                    inner_query_graphs,
                    global_unique_query_idx,
                )
            except Exception as e:
                args.logger.error(e)
                continue

            for i in range(len(line)):
                args.logger.info(f"SQL ({i}): ")
                args.logger.info(line[i].strip())
                args.logger.info(f"Translation  ({i}): ")
                text, _ = logos_translate(graph[i][1])
                args.logger.info(text + "\n")
        global_unique_query_idx += len(line)

        if check_execution_result:
            # double checking by executing the generated query; it might takes long
            for sql in line:
                if not check_sql_result(data_manager, sql):
                    args.logger.error(f"An unexecutable SQL query is generated: {line}")
                    args.logger.error(f"{obj}")
                    raise Exception("Unexecutable query is generated")

        lines = lines + line
        graphs = graphs + graph
        objs = objs + obj
        pbar.update(len(line))
        num_success += len(line)

        if (num_success + 1) % log_step == 0:
            with open(output_path, "at") as writer:
                writer.writelines(lines)
                lines = list()
            with open(output_path + ".graph", "ab") as writer:
                utils.write_graphs(writer, graphs)
                graphs = list()
            with open(output_path + ".obj", "ab") as writer:
                utils.write_objs(writer, objs)
                objs = list()

            cur_time = time.time()
            txt = f"{num_success} queries are done. takes {cur_time-t1:.2f}s\t{cur_time-t2:.2f}s per {log_step}\n"
            args.logger.info(txt)
            t2 = time.time()

    pbar.close()

    with open(output_path, "at") as writer:
        writer.writelines(lines)
    with open(output_path + ".graph", "ab") as writer:
        utils.write_graphs(writer, graphs)
        graphs = list()
    with open(output_path + ".obj", "ab") as writer:
        utils.write_objs(writer, objs)
        objs = list()
    cur_time = time.time()
    txt = f"Done. takes {cur_time-t1:.2f}s\t{cur_time-t2:.2f}s\n"
    args.logger.info(txt)


def lower_case_schema_data(schema):
    new_schema = {"dataset": schema["dataset"], "use_cols": schema["use_cols"]}

    new_schema["join_tables"] = [table.lower() for table in schema["join_tables"]]

    new_schema["join_keys"] = {}
    for table in schema["join_keys"].keys():
        new_schema["join_keys"][table.lower()] = [column.lower() for column in schema["join_keys"][table]]

    new_schema["join_clauses"] = [clause.lower() for clause in schema["join_clauses"]]

    new_schema["join_root"] = schema["join_root"].lower()

    return new_schema


if __name__ == "__main__":
    filename = "src/sql_generator/configs/test_experiments.json"
    filename = "src/sql_generator/configs/test_experiments_nested.json"
    filename = "src/sql_generator/configs/test_experiments_nested_2.json"
    filename = "src/sql_generator/configs/mubi_svod_platform_experiments.json"
    # argument
    parser = argparse.ArgumentParser()
    parser.add_argument("--infile", type=str, default="src/sql_generator/configs/test_experiments_not_inner.json")
    args = parser.parse_args()
    if args.infile:
        with open(args.infile, "rt") as f:
            t_args = argparse.Namespace()
            t_args.__dict__.update(json.load(f))
            args = parser.parse_args(namespace=t_args)

    formatter = logging.Formatter("[[ %(levelname)s ]]::%(asctime)s::%(funcName)s::%(lineno)d - %(message)s")

    consol_handler = logging.StreamHandler(sys.stdout)
    consol_handler.setLevel(logging.DEBUG)
    consol_handler.setFormatter(formatter)

    file_handler = logging.FileHandler(args.log_path)
    file_handler.setLevel(logging.DEBUG)
    file_handler.setFormatter(formatter)

    args.logger = logging.getLogger()
    args.logger.setLevel(logging.DEBUG)
    args.logger.addHandler(consol_handler)
    args.logger.addHandler(file_handler)

    SCHEMA = json.load(open(f"{args.data_dir}/{args.db}_schema.json"))
    schema = CaseInsensitiveDict(lower_case_schema_data(SCHEMA[args.schema_name]))

    config_file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../config.yml")
    config = file_utils.read_yaml_file(config_file_path)

    IP = config["DB"]["IP"]
    port = config["DB"]["Port"]
    DBUserID = config["DB"]["data"]["UserID"]
    DBUserPW = config["DB"]["data"]["UserPW"]
    data_manager, fo_view_name, table_info = create_full_outer_view(args, IP, port, DBUserID, DBUserPW, schema)
    args.table_info = CaseInsensitiveDict(table_info)
    args.fo_view_name = fo_view_name

    COL_INFO = json.load(open(f"{args.data_dir}/{args.db}_dtype_dict.json"))
    column_info = COL_INFO[schema["dataset"]]

    run_generator(data_manager, schema, column_info, args)
