import json
import random
from typing import List

from hkkang_utils.misc import property_with_cache
from pylogos.query_graph.koutrika_query_graph import Query_graph
from pylogos.translate import translate

from src.query_tree.query_tree import Node, QueryBlock
from src.task import Task
from src.utils.example_queries import CorrelatedNestedQuery
from src.utils.pg_connector import PostgresConnector
from src.VQA.EVQA import EVQATree

# TASK_TYPES = [1, 2]
TASK_TYPES = [1]

dummy_query = CorrelatedNestedQuery()


class Task_Generator:
    def __init__(self, admin_db_config, data_db_config):
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

    @property_with_cache
    def task_type(self):
        """Randomly select a task type to generate"""
        selected_type = random.choice(TASK_TYPES)
        return selected_type

    @property_with_cache
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

    def _query_to_task(
        self, evqa: EVQATree, query_tree: Node, query_graphs: List[Query_graph], is_recursive_call=False
    ):
        # Select a query type to generate
        query_type = self.query_type
        task_type = self.task_type

        # Generate SQL
        sql = evqa.node.sql
        table_excerpt = evqa.node.table_excerpt

        # Generate NL
        generated_nl, mapping_info = translate(query_graphs[0])

        # Add Alignment annotation
        nl_mapping = []
        for x, y, value in evqa.node.mapping:
            key_str = f"{x},{y}"
            for item in filter(lambda k: value in [k["table"], k["column"]], mapping_info):
                nl_mapping.append((key_str, item["start"], item["end"]))
        nl_mapping = sorted(nl_mapping, key=lambda x: x[1])

        # Create history
        child_query_blocks = [edge.child for edge in query_tree.child_tables if type(edge.child) == QueryBlock]
        assert len(child_query_blocks) == len(evqa.children), f"{len(child_query_blocks)} != {len(evqa.children)}"
        history = (
            []
            if is_recursive_call
            else [
                self._query_to_task(child_node, child_block, query_graphs[1:])
                for child_node, child_block in zip(evqa.children, child_query_blocks)
            ]
        )

        # For each evqa node

        # Wrap with Task class
        # TODO: handle table_excerpt, result table, and history
        return Task(
            nl=generated_nl,
            nl_mapping=nl_mapping,
            sql=sql,
            evqa=evqa,
            query_type=query_type,
            task_type=task_type,
            db_name="db_name",
            table_excerpt=table_excerpt,
            result_table=None,
            history=history,
        )

    def __call__(self) -> List[Task]:
        # Generate SQL
        evqa = dummy_query.evqa
        query_tree_root_node = dummy_query.query_tree.root
        query_graphs = dummy_query.query_graphs

        # For each evqa node

        # Wrap with Task class
        # TODO: handle table_excerpt, result table, and history
        return [self._query_to_task(evqa, query_tree_root_node, query_graphs)]

    def convert_tasks_into_json_string(self, tasks: List[Task]) -> str:
        return json.dumps([task.dump_json() for task in tasks][0])


if __name__ == "__main__":
    admin_db_config = {
        "host": "localhost",
        "userid": "config_user",
        "passwd": "config_user_pw",
        "port": "5432",
        "db_name": "proda_config",
        "table_name": "query_goal",
    }

    data_db_config = {
        "host": "localhost",
        "userid": "collection_user",
        "passwd": "collection_user_pw",
        "port": "5432",
        "db_name": "proda_collection",
        "table_name": "collection",
    }

    task_generator = Task_Generator(admin_db_config, data_db_config)
    new_tasks = task_generator()
    print(task_generator.convert_tasks_into_json_string(new_tasks))
