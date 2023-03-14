import json
import os

from pylogos.translate import translate

from src.query_tree.query_tree import QueryTree
from src.task.task import Task
from src.utils.user_study_queries import MovieQuery1
from src.VQL.EVQL import EVQLTree
import hkkang_utils.file as file_utils
from src.utils.example_tasks import create_nl_and_mapping


def MovieTask1():
    config_file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../config.yml")
    config = file_utils.read_yaml_file(config_file_path)
    task_save_dir_path = config["taskSaveDirPath"]

    query_object = MovieQuery1()
    evql_object = query_object.evql
    query_graphs = query_object.query_graphs
    sql = query_object.sql

    # Create natural language
    evql1 = evql_object
    nl1, mapping1 = create_nl_and_mapping(query_graphs[0], evql1)
    result = query_object.result_tables[0]

    # Create and save task1
    sub_task1 = Task(
        nl=nl1,
        nl_mapping=mapping1,
        sql=sql,
        evql=evql1,
        query_type="SelectionQuery",
        task_type=1,
        db_name="Movie",
        table_excerpt=evql1.node.table_excerpt,
        result_table=evql1.node.table_excerpt,
        history_task_ids=[],
    )
    task1_id = Task.save(sub_task1, task_save_dir_path)
    print(task1_id)

    return sub_task1


if __name__ == "__main__":
    MovieTask1()
