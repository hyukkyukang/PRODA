import os

from rewrite_sentence_gpt import *

from src.config import config
from src.pylogos.query_graph.koutrika_query_graph import Query_graph
from src.pylogos.translate import translate
from src.query_tree.query_tree import QueryTree
from src.task.task import Task
from src.utils.data_manager import save_task_set_in_db
from src.utils.example_queries import CorrelatedNestedQuery
from src.utils.example_tasks import create_nl_and_mapping
from src.utils.user_study_queries import (MovieQuery1, MovieQuery2,
                                          MovieQuery3, MovieQuery5,
                                          MovieQuery6)
from src.VQA.EVQA import EVQATree


def templatize(history, current):
    text = ""
    refer_text = []
    for i, sentence in enumerate(history):
        text += " Q" + str(i + 1) + " is to " + sentence
        refer_text.append("Q" + str(i + 1))

    cur_idx = len(history) + 1
    text += " Q" + str(cur_idx) + " is to " + current

    text += " Write out Q" + str(cur_idx) + " in a sentence by referring to " + ", ".join(refer_text) + "."
    # print(text)

    return text


def MovieTask1(query_object):
    task_save_dir_path = os.path.join(config["ProjectPath"], config["TaskSaveDirPath"])

    evqa_object = query_object.evqa
    query_graphs = query_object.query_graphs
    sql = query_object.sql

    # Create natural language
    evqa1 = evqa_object
    nl1, mapping1 = create_nl_and_mapping(query_graphs[0], evqa1)
    result = query_object.result_tables[0]

    # Create and save task1
    sub_task1 = Task(
        nl="Find first_name and last_name of actor in ascending order of first_name",
        nl_mapping=mapping1,
        sql=sql,
        evqa=evqa1,
        query_type="SelectionQuery",
        task_type=1,
        db_name="Movie",
        table_excerpt=evqa1.node.table_excerpt,
        result_table=result,
        history_task_ids=[],
    )
    task1_id = Task.save(sub_task1, task_save_dir_path)
    print(task1_id)

    return sub_task1


def MovieTask2(query_object):
    task_save_dir_path = os.path.join(config["ProjectPath"], config["TaskSaveDirPath"])

    evqa_object = query_object.evqa
    query_graphs = query_object.query_graphs

    # Create natural language
    evqa1 = evqa_object.children[0].children[1]
    evqa2 = evqa_object.children[0].children[0]
    evqa3 = evqa_object.children[0]
    evqa4 = evqa_object

    result_tables = query_object.result_tables

    nl4_origin, mapping4 = create_nl_and_mapping(query_graphs[0], evqa4)
    nl3_origin, mapping3 = create_nl_and_mapping(query_graphs[1], evqa3)
    nl2, mapping2 = create_nl_and_mapping(query_graphs[2], evqa2)
    nl1, mapping1 = create_nl_and_mapping(query_graphs[3], evqa1)

    nl3_concat = templatize([nl1, nl2], nl3_origin)
    nl3 = rewrite_sentence(nl3_concat)
    # nl3 = nl3_origin

    nl4_concat = templatize([nl1, nl2, nl3], nl4_origin)
    nl4 = rewrite_sentence(nl4_concat)
    # nl4 = nl4_origin
    print(nl4_origin)
    print(nl3_origin)
    print(nl2)
    print(nl1)

    # Create and save task1
    sub_task1 = Task(
        nl="Find id of movie for each id of movie, maximum stars of rating in which rating belongs to movie.",
        nl_mapping=mapping1,
        sql="SELECT Max(R2.stars) AS max_stars, M2.id as m_id FROM movie AS M2, rating AS R2 GROUP BY M2.id",
        evqa=evqa1,
        query_type="GroupbyQuery",
        task_type=1,
        db_name="IMDB",
        table_excerpt=evqa1.node.table_excerpt,
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
        evqa=evqa2,
        query_type="SelectionQuery",
        task_type=1,
        db_name="IMDB",
        table_excerpt=evqa2.node.table_excerpt,
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
        evqa=evqa3,
        query_type="CorrelatedNestedQuery",
        task_type=1,
        db_name="IMDB",
        table_excerpt=evqa3.node.table_excerpt,
        result_table=result_tables[2],
        history_task_ids=[task2_id, task1_id],
    )
    task3_id = Task.save(sub_task3, task_save_dir_path)
    print(task3_id)

    # Create and save task4
    sub_task4 = Task(
        # nl="Find id of movie for each id of movie, considering only those groups whose average stars of rating is greater than 5.5, where id of movie is in id of movie where first_name of director is James and last_name of director is Cameron and stars of rating is less than maximum stars of rating in which rating belongs to movie of the same id.",
        nl=nl4,
        nl_mapping=mapping4,
        sql="SELECT B3.id as id FROM B3 WHERE B3.avg_stars >= 3",
        evqa=evqa4,
        query_type="HavingQuery",
        task_type=1,
        db_name="IMDB",
        table_excerpt=evqa4.node.table_excerpt,
        result_table=result_tables[3],
        history_task_ids=[task3_id, task2_id, task1_id],
    )
    task4_id = Task.save(sub_task4, task_save_dir_path)
    print(task4_id)

    return [task1_id, task2_id, task3_id, task4_id]


def MovieTask3(query_object):
    task_save_dir_path = os.path.join(config["ProjectPath"], config["TaskSaveDirPath"])

    evqa_object = query_object.evqa
    query_graphs = query_object.query_graphs

    # Create natural language
    evqa1 = evqa_object.children[0]
    evqa2 = evqa_object

    # result_tables = query_object.result_tables
    result_tables = [0, 1]

    nl2, mapping2 = create_nl_and_mapping(query_graphs[0], evqa2)
    nl1, mapping1 = create_nl_and_mapping(query_graphs[1], evqa1)

    # Create and save task1
    sub_task1 = Task(
        nl=nl1,
        nl_mapping=mapping1,
        sql="Sub1",
        evqa=evqa1,
        query_type="GroupbyQuery",
        task_type=1,
        db_name="IMDB",
        table_excerpt=evqa1.node.table_excerpt,
        result_table=result_tables[0],
        history_task_ids=[],
    )
    task1_id = Task.save(sub_task1, task_save_dir_path)
    print(task1_id)

    # Create and save task2
    sub_task2 = Task(
        nl=nl2,
        nl_mapping=mapping2,
        sql="Full",
        evqa=evqa2,
        query_type="HavingQuery",
        task_type=1,
        db_name="IMDB",
        table_excerpt=evqa2.node.table_excerpt,
        result_table=result_tables[1],
        history_task_ids=[task1_id],
    )
    task2_id = Task.save(sub_task2, task_save_dir_path)
    print(task2_id)

    return [task1_id, task2_id]


def save_task_set(task_ids):
    task_set_id = save_task_set_in_db(task_ids)
    print(f"TaskSetID: {task_set_id}")


if __name__ == "__main__":
    # query_object = MovieQuery1()
    # MovieTask1(query_objct)
    # query_object = MovieQuery2()
    # MovieTask1(query_object)
    # query_object = MovieQuery3()
    # MovieTask1(query_object)
    # query_object = MovieQuery5()
    # MovieTask2(query_object)
    # query_object = MovieQuery6()
    # MovieTask3(query_object)
    set_openai()
    query_object1 = MovieQuery5()
    task_ids = MovieTask2(query_object1)
    save_task_set(task_ids)
