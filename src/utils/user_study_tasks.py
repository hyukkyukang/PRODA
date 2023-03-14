import json
import os

from pylogos.translate import translate

from src.query_tree.query_tree import QueryTree
from src.task.task import Task
from src.utils.user_study_queries import MovieQuery1, MovieQuery2, MovieQuery3, MovieQuery5
from src.VQL.EVQL import EVQLTree
import hkkang_utils.file as file_utils
from src.utils.example_tasks import create_nl_and_mapping


def MovieTask1(query_object):
    config_file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../config.yml")
    config = file_utils.read_yaml_file(config_file_path)
    task_save_dir_path = config["taskSaveDirPath"]

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
        result_table=result,
        history_task_ids=[],
    )
    task1_id = Task.save(sub_task1, task_save_dir_path)
    print(task1_id)

    return sub_task1

def MovieTask2(query_object):
    config_file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../config.yml")
    config = file_utils.read_yaml_file(config_file_path)
    task_save_dir_path = config["taskSaveDirPath"]

    evql_object = query_object.evql
    query_graphs = query_object.query_graphs

    # Create natural language
    evql1 = evql_object.children[0].children[1]
    evql2 = evql_object.children[0].children[0]
    evql3 = evql_object.children[0]
    evql4 = evql_object

    result_tables = query_object.result_tables

    nl4, mapping4 = create_nl_and_mapping(query_graphs[0], evql4)
    nl3, mapping3 = create_nl_and_mapping(query_graphs[1], evql3)
    nl2, mapping2 = create_nl_and_mapping(query_graphs[2], evql2)
    nl1, mapping1 = create_nl_and_mapping(query_graphs[3], evql1)

    # Create and save task1
    sub_task1 = Task(
        nl=nl1,
        nl_mapping=mapping1,
        sql="SELECT Max(R2.stars) AS max_stars, M2.id as m_id FROM movie AS M2, rating AS R2 GROUP BY M2.id",
        evql=evql1,
        query_type="GroupbyQuery",
        task_type=1,
        db_name="IMDB",
        table_excerpt=evql1.node.table_excerpt,
        result_table=result_tables[0],
        history_task_ids=[],
    )
    task1_id = Task.save(sub_task1, task_save_dir_path)
    print(task1_id)

    # Create and save task2
    sub_task2 = Task(
        nl=nl2,
        nl_mapping=mapping2,
        sql="SELECT M3.id FROM movie AS M3, direction AS MD, director AS D WHERE D.first_Name = 'spielberg' ADN D.last_Name = 'steven'",
        evql=evql2,
        query_type="SelectionQuery",
        task_type=1,
        db_name="IMDB",
        table_excerpt=evql2.node.table_excerpt,
        result_table=result_tables[1],
        history_task_ids=[],
    )
    task2_id = Task.save(sub_task2, task_save_dir_path)
    print(task2_id)

    # Create and save task3
    sub_task3 = Task(
        nl=nl3,
        nl_mapping=mapping3,
        sql="SELECT M1.id as id, avg(R1.stars) as avg_stars FROM movie AS M1, rating AS R1, B1, B2 WHERE R1.stars < B1.max_stars AND M1.id IN B2 AND B1.m_id = M1.id GROUP BY M1.id",
        evql=evql3,
        query_type="CorrelatedNestedQuery",
        task_type=1,
        db_name="IMDB",
        table_excerpt=evql3.node.table_excerpt,
        result_table=result_tables[2],
        history_task_ids=[task2_id, task1_id],
    )
    task3_id = Task.save(sub_task3, task_save_dir_path)
    print(task3_id)

    # Create and save task4
    sub_task4 = Task(
        nl=nl4,
        nl_mapping=mapping4,
        sql="SELECT B3.id as id FROM B3 WHERE B3.avg_stars >= 3",
        evql=evql4,
        query_type="HavingQuery",
        task_type=1,
        db_name="IMDB",
        table_excerpt=evql4.node.table_excerpt,
        result_table=result_tables[3],
        history_task_ids=[task3_id, task2_id, task1_id],
    )
    task4_id = Task.save(sub_task4, task_save_dir_path)
    print(task4_id)

    return sub_task1

if __name__ == "__main__":
    #query_object = MovieQuery1()
    #MovieTask1(query_object)
    #query_object = MovieQuery2()
    #MovieTask1(query_object)
    #query_object = MovieQuery3()
    #MovieTask1(query_object)
    query_object = MovieQuery5()
    MovieTask2(query_object)
