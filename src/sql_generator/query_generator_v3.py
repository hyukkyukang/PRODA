import numpy as np
import pandas as pd
import os
import sys
import argparse
import datetime
import time
import json
import logging
from tqdm import tqdm
from requests.structures import CaseInsensitiveDict

import src.sql_generator.sql_gen_utils.utils as utils
import src.sql_generator.sql_gen_utils.sql_genetion_utils as sql_genetion_utils
from src.sql_generator.sql_gen_utils.sql_genetion_modules import query_generator
from src.pylogos.translate import translate as logos_translate
from src.sql_generator.tools.storage.db import PostgreSQLDatabase
from src.config import config


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


def create_full_outer_view(
    args, rng, data_manager, schema, hist=None, column_info=None, SEED=1234
):
    args.logger.info("... start generating full outer joined view...")

    if args.use_one_predicate:
        # Choose predicate; categorical column
        # If it is not used for inner query - no matter
        # Outer query - Use the same fo view with inner query
        # (Advanced, TODO) Group by, Aggregation, NOT EXISTS: Inner query should contain the predicate
        if args.predicate_id:
            view_name = sql_genetion_utils.get_view_name(
                "main_given_predicate",
                [schema["dataset"], schema["use_cols"], args.predicate_id],
            )
            ###### This fo view should already exists
        else:
            global_column_idx = 0
            candidate_columns = []
            for table in args.table_info.keys():
                if table not in hist.keys():
                    global_column_idx += len(args.table_info[table])
                    continue
                for column in args.table_info[table]:
                    hist[table][column] = [
                        val for val in hist[table][column] if val[0] is not None
                    ]
                    if column in hist[table].keys() and len(hist[table][column]) > 0:
                        candidate_columns.append((table, column, global_column_idx))
                    global_column_idx += 1
            if len(candidate_columns) == 0:
                args.logger.warning(
                    "[WARNING] There is no candidate predicates which can be used for generating a full outer join view; start generating for all rows"
                )
                args.use_one_predicate = False
                view_name = sql_genetion_utils.get_view_name(
                    "main", [schema["dataset"], schema["use_cols"]]
                )
            else:
                chosen_col = candidate_columns[rng.choice(len(candidate_columns))]
                chosen_val_idx = rng.randint(0, len(hist[chosen_col[0]][chosen_col[1]]))
                chosen_val = hist[chosen_col[0]][chosen_col[1]][chosen_val_idx]

                rand_id = f"c{chosen_col[2]}_v{chosen_val_idx}"
                view_name = sql_genetion_utils.get_view_name(
                    "main_given_predicate",
                    [schema["dataset"], schema["use_cols"], rand_id],
                )
    else:
        view_name = sql_genetion_utils.get_view_name(
            "main", [schema["dataset"], schema["use_cols"]]
        )

    select_columns = []
    # <table name>___<column name>
    # tables = data_manager.fetch_table_names() ### DO NOT USE ALL TABLES IN DB
    for table in args.table_info.keys():
        for column in args.table_info[table]:
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
            FROM {from_clause}
        """
    if args.use_one_predicate and not args.predicate_id:
        pred_col_name = chosen_col[0] + "." + chosen_col[1]
        predicate = ""
        if len(chosen_val) == 2:  # point
            pred_val = chosen_val[0]
            if column_info["dtype_dict"][pred_col_name] in ("str"):
                predicate = f"""{pred_col_name} = '{pred_val}' """
            else:
                predicate = f"{pred_col_name} = {pred_val}"
        elif len(chosen_val) == 3:  # range
            if column_info["dtype_dict"][pred_col_name] == "int":
                pred_val_st = int(chosen_val[0])
                pred_val_ta = int(chosen_val[0] + chosen_val[2])
            else:
                pred_val_st = chosen_val[0]
                pred_val_ta = chosen_val[0] + chosen_val[2]
            predicate = (
                f"{pred_col_name} >= {pred_val_st} AND {pred_col_name} < {pred_val_ta}"
            )

        full_outer_join_sql += f""" WHERE {predicate}; """
    else:
        full_outer_join_sql += ";"

    args.logger.info(f"View SQL: {full_outer_join_sql}")

    data_manager.create_view(
        args.logger,
        view_name,
        full_outer_join_sql,
        type="materialized",
        drop_if_exists=False,
    )
    args.logger.info("... finished: generating full outer joined view...")

    return view_name


def run_generator(
    data_manager,
    schema,
    column_info,
    args,
    rng,
    check_execution_result=False,
    log_step=1,
):
    all_table_set = set(schema["join_tables"])
    join_clause_list = schema["join_clauses"]
    join_keys = schema["join_keys"]

    join_key_list = list()
    for table, cols in join_keys.items():
        for col in cols:
            join_key_list.append(f"{table}.{col}")

    t1 = time.time()
    t2 = time.time()

    lines = list()
    graphs = list()
    objs = list()

    dtype_dict = CaseInsensitiveDict(column_info["dtype_dict"])
    (
        args.IDS,
        args.HASH_CODES,
        args.NOTES,
        args.CATEGORIES,
        args.FOREIGN_KEYS,
    ) = sql_genetion_utils.set_col_info(column_info)

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
            inner_query_graphs += utils.load_graphs(
                inner_query_path + ".graph", q_count
            )
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


if __name__ == "__main__":
    filename = "src/sql_generator/configs/test_experiments.json"
    filename = "src/sql_generator/configs/test_experiments_nested.json"
    filename = "src/sql_generator/configs/test_experiments_nested_2.json"
    filename = "src/sql_generator/configs/mubi_svod_platform_experiments.json"
    # argument
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--infile",
        type=str,
        default="data/database/nba/non_nested_query_hyperparameter_guide_1.json",
    )
    args = parser.parse_args()
    if args.infile:
        with open(args.infile, "rt") as f:
            t_args = argparse.Namespace()
            t_args.__dict__.update(json.load(f))
            args = parser.parse_args(namespace=t_args)

    formatter = logging.Formatter(
        "[[ %(levelname)s ]]::%(asctime)s::%(funcName)s::%(lineno)d - %(message)s"
    )

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

    SCHEMA = json.load(open(f"{args.data_dir}/{args.db}/schema_new.json"))
    schema = CaseInsensitiveDict(utils.lower_case_schema_data(SCHEMA[args.schema_name]))

    rng = np.random.RandomState(args.seed)

    IP = config["DB"]["IP"]
    port = config["DB"]["Port"]
    DBUserID = config["DB"]["data"]["UserID"]
    DBUserPW = config["DB"]["data"]["UserPW"]

    data_manager, table_info = utils.connect_data_manager(
        IP, port, DBUserID, DBUserPW, schema
    )
    args.table_info = CaseInsensitiveDict(table_info)

    COL_INFO = json.load(open(f"{args.data_dir}/{args.db}/dtype_dict.json"))
    column_info = COL_INFO[schema["dataset"]]

    if not args.use_one_predicate:
        fo_view_name = create_full_outer_view(args, rng, data_manager, schema)
        args.fo_view_name = fo_view_name
    else:
        hist = json.load(open(f"{args.data_dir}/{args.db}/selective_histogram.json"))
        args.fo_view_name = create_full_outer_view(
            args, rng, data_manager, schema, hist=hist, column_info=column_info
        )

    run_generator(data_manager, schema, column_info, args, rng)
