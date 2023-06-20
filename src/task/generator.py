import argparse
import functools
import json
import os
import random
from typing import Dict, List

import tqdm
from requests.structures import CaseInsensitiveDict

from src.config import config
from src.pylogos.query_graph.koutrika_query_graph import Query_graph
from src.pylogos.translate_progressive import translate_progressive
from src.query_tree.query_tree import Node, QueryBlock, QueryTree
from src.sql_generator.sql_gen_utils.sql_genetion_utils import get_prefix
from src.sql_generator.sql_gen_utils.utils import load_graphs, load_objs
from src.sql_generator.tools.storage.db import PostgreSQLDatabase
from src.table_excerpt.table_excerpt_generator import update_query_tree_with_table_excerpt
from src.task import Task, TaskTypes, TaskWithSubTasks
from src.utils.pg_connector import PostgresConnector
from src.utils.rewrite_sentence_gpt import *
from src.VQA.EVQA import EVQATree
from src.VQA.query_tree_to_EVQA import convert_queryTree_to_EVQATree

project_path = config.ProjectPath


class Task_Generator:
    def __init__(self, admin_db_config, data_db_config, db_name):
        self.admin_db_config = admin_db_config
        self.data_db_config = data_db_config
        self.admin_db_connector = PostgresConnector(
            admin_db_config["userid"],
            admin_db_config["passwd"],
            admin_db_config["host"],
            admin_db_config["port"],
            admin_db_config["db_name"],
        )
        self.data_db_connector = PostgresConnector(
            data_db_config["userid"],
            data_db_config["passwd"],
            data_db_config["host"],
            data_db_config["port"],
            data_db_config["db_name"],
        )
        self.db_name = db_name

    def __call__(
        self,
        evqa: EVQATree,
        query_tree: QueryTree,
        query_graphs: Query_graph,
        query_objs: Dict[str, Dict],
        query_id: str,
    ) -> Task:
        # TODO: handle table_excerpt, result table, and history
        return self.query_to_task(evqa, query_tree.root, query_graphs, query_objs, query_id)

    @property
    def query_goal_dic(self):
        # Read in query goals from database
        results = self.admin_db_connector.execute(f"SELECT * FROM {self.admin_db_config['table_name']}")
        return {item[0]: item[1] for item in results}

    @property
    def collected_data(self):
        cnt_dic = {key: 0 for key in self.query_goal_dic.keys()}
        # Read in collected data from database
        results = self.data_db_connector.execute(f"SELECT * FROM {self.data_db_config['table_name']}")
        for result in results:
            query_type = result[4]
            if query_type in cnt_dic:
                cnt_dic[query_type] += 1
            else:
                cnt_dic[query_type] = 0
        return cnt_dic

    @functools.cached_property
    def task_type(self):
        """Randomly select a task type to generate"""
        return TaskTypes.Validation

    @functools.cached_property
    def query_type(self):
        """Randomly select a query type to generate"""
        # Read goal number of queries for each query type
        query_goal_dic = self.query_goal_dic

        # Get Stat. for collected data
        collected_data = self.collected_data

        # Figure out remaining target query type
        for key, value in collected_data.items():
            if key in query_goal_dic.keys():
                query_goal_dic[key] -= value

        remaining_types = [key for key, value in query_goal_dic.items() if value > 0]

        # Randomly select one from the remaining query types
        selected_type = random.choice(remaining_types)

        return selected_type

    def get_query_type(self, query_objs, query_id):
        ### [nesting_type]__[#tables]__[where]__[groupby]__[having]__[orderby]__[limit]
        query_type = ""
        obj = query_objs[query_id]
        if query_id.startswith("N1"):
            query_type += "non-nested"
        else:
            assert len(obj["childs"]) > 0
            nesting_types = []
            for child in obj["childs"]:
                is_correlated = False
                for correlation_predicate in correlation_predicates_origin:
                    prefix_inner = correlation_predicate[0]
                    if prefix_inner == child:
                        is_correlated = True
                        break

                child_obj = query_objs[child]
                is_aggregated = child_obj["use_agg_sel"]

                if not is_correlated and not is_aggregated:
                    nesting_types.append("type-n")
                elif not is_correlated and is_aggregated:
                    nesting_types.append("type-a")
                elif is_correlated and not is_aggregated:
                    nesting_types.append("type-j")
                elif is_correlated and is_aggregated:
                    nesting_types.append("type-ja")
                else:
                    assert False
            query_type += ",".join(nesting_types)
        query_type += "__" + str(len(obj["tables"]))
        query_type += "__" + str(obj["type"]["where"])
        query_type += "__" + str(obj["type"]["group"])
        query_type += "__" + str(obj["type"]["having"])
        query_type += "__" + str(obj["type"]["order"])
        query_type += "__" + str(obj["type"]["limit"])

        return query_type

    def get_task_type(self, query_objs, query_id):
        return 0

    def query_to_task(
        self,
        evqa: EVQATree,
        query_tree: Node,
        query_graphs: Dict[str, Query_graph],
        query_objs: Dict[str, Dict],
        query_id,
        is_recursive_call=False,
    ) -> TaskWithSubTasks:
        # Select a query type to generate
        # TODO: Fix self.get_query_type (correlation_predicates_origin is not defined within this function)
        # query_type = self.get_query_type(query_objs, query_id)
        query_type = TaskTypes.Validation
        task_type = self.get_task_type(query_objs, query_id)

        # Generate SQL
        sql = evqa.node.sql
        table_excerpt = evqa.node.table_excerpt
        result_table = evqa.node.result_table

        # Generate NL
        # TODO: Need to generate NL with use_gpt=True
        full_nl, generated_nl = translate_progressive(query_tree, query_id, query_objs, query_graphs, use_gpt=False)

        # Add Alignment annotation
        nl_mapping = []
        # for x, y, value in evqa.node.mapping:
        #    key_str = f"{x},{y}"
        #    for item in filter(lambda k: value in [k["table"], k["column"]], mapping_info):
        #        nl_mapping.append((key_str, item["start"], item["end"]))
        # nl_mapping = sorted(nl_mapping, key=lambda x: x[1])

        # Create history
        child_query_blocks = [node for node in query_tree.child_tables if type(node) == QueryBlock]
        child_query_ids = [get_prefix(*child_info)[:-1] for child_info in query_objs[query_id]["childs"]]
        assert len(child_query_blocks) == len(evqa.children), f"{len(child_query_blocks)} != {len(evqa.children)}"
        sub_tasks = (
            []
            if is_recursive_call
            else [
                self.query_to_task(child_node, child_block, query_graphs, query_objs, child_id)
                for child_node, child_block, child_id in zip(evqa.children, child_query_blocks, child_query_ids)
            ]
        )

        # Wrap with Task class
        return TaskWithSubTasks(
            nl=generated_nl,
            nl_mapping=nl_mapping,
            sql=sql,
            evqa=evqa,
            query_type=query_type,
            task_type=task_type,
            db_name="db_name",
            table_excerpt=table_excerpt,
            result_table=result_table,
            sub_tasks=sub_tasks,
        )

    def convert_tasks_into_json_string(self, task: Task) -> str:
        return json.dumps(task.dump_json())


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--infile", type=str, default="src/sql_generator/configs/test_experiments_nested.json")
    parser.add_argument(
        "--query_paths",
        nargs="+",
        default=[
            os.path.join(project_path, "non-nested/result.out"),
            os.path.join(project_path, "non-nested/result2.out"),
            os.path.join(project_path, "non-nested/result3.out"),
        ],
    )
    parser.add_argument("--dbname", default="car_1")
    parser.add_argument("--use_cols", default="car_1")
    parser.add_argument("--output_path", type=str, default=os.path.join(project_path, "result_with_te.out"))
    args = parser.parse_args()
    if args.infile:
        with open(args.infile, "rt") as f:
            t_args = argparse.Namespace()
            t_args.__dict__.update(json.load(f))
            args = parser.parse_args(namespace=t_args)

    admin_db_config = {
        "host": config.DB.IP,
        "userid": config.DB.config.UserID,
        "passwd": config.DB.config.UserPW,
        "port": config.DB.Port,
        "db_name": config.DB.config.DBName,
        "table_name": config.DB.config.QueryGoalNumsTableName,
    }

    data_db_config = {
        "host": config.DB.IP,
        "userid": config.DB.collection.UserID,
        "passwd": config.DB.collection.UserPW,
        "port": config.DB.Port,
        "db_name": config.DB.collection.DBName,
        "table_name": config.DB.collection.CollectionTableName,
    }

    database_db_config = {
        "host": config.DB.IP,
        "userid": config.DB.data.UserID,
        "passwd": config.DB.data.UserPW,
        "port": config.DB.Port,
        "db_name": args.dbname,
    }

    COL_INFO = json.load(open(f"database/{args.db}/dtype_dict.json"))
    column_info = COL_INFO[args.db]
    dtype_dict = CaseInsensitiveDict(column_info["dtype_dict"])

    args.query_paths = args.sql_info["inner_query_paths"] + [args.output]

    query_objs = {}
    query_graphs = {}
    query_trees = []
    query_objs: Dict[str, Dict] = {}
    query_graphs: Dict[str, Query_graph] = {}
    query_trees: List[QueryTree] = []
    keys = []
    for query_path in args.query_paths:
        with open(query_path, "r") as fp:
            q_count = len(fp.readlines())
        loaded_objs = load_objs(query_path + ".obj", q_count)
        loaded_graphs = load_graphs(query_path + ".graph", q_count)
        for loaded_obj, loaded_graph in zip(loaded_objs, loaded_graphs):
            block_name = get_prefix(loaded_obj["nesting_level"], loaded_obj["unique_alias"])[:-1]
            query_objs[block_name] = loaded_obj
            query_graphs[block_name] = loaded_graph[1]
            query_trees.append((block_name, loaded_graph[0]))

    task_generator = Task_Generator(
        admin_db_config,
        data_db_config,
        args.db,
    )
    data_manager = PostgreSQLDatabase(
        database_db_config["userid"],
        database_db_config["passwd"],
        database_db_config["host"],
        database_db_config["port"],
        database_db_config["db_name"],
    )
    skip_cnt = 0
    bad_cnt = 0
    cnt = 0
    for key, query_tree in tqdm.tqdm(query_trees):
        # TODO: Need to ask why this condition is needed
        if not query_objs[key]["is_having_child"]:  ### N1 - non-nest, N2 - nesting leve 2, N3 - nesting level 3
            try:
                query_tree_with_te = update_query_tree_with_table_excerpt(
                    args.db, args.schema_name, data_manager, dtype_dict, query_graphs, query_objs, query_tree, key
                )
                evqa = convert_queryTree_to_EVQATree(query_tree_with_te)
                new_task = task_generator(evqa, query_tree_with_te, query_graphs, query_objs, key)
                new_task.save("./data")
                tmp = task_generator.convert_tasks_into_json_string(new_task)
                # print(task_generator.convert_tasks_into_json_string(new_tasks))
                cnt += 1
            except:
                bad_cnt += 1
                continue
        else:
            skip_cnt += 1

    print("Done!")
