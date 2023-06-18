import json
import os

from src.config import config
from src.pylogos.query_graph.koutrika_query_graph import Query_graph
from src.pylogos.translate import translate
from src.query_tree.query_tree import QueryTree
from src.task.task import Task
from src.utils.example_queries import MultipleSublinksQuery2
from src.VQA.EVQA import EVQATree


def create_nl_and_mapping(query_graph: Query_graph, evqa: EVQATree):
    nl, mapping_info = translate(query_graph)
    nl_mapping = []
    for x, y, value in evqa.node.mapping:
        key_str = f"{x+1},{y}"
        for item in filter(lambda k: value in [k["table"], k["column"]], mapping_info):
            nl_mapping.append((key_str, item["start"], item["end"]))
    nl_mapping = sorted(nl_mapping, key=lambda x: x[1])
    return nl, nl_mapping


def example_task_in_the_paper():
    config_file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../config.yml")
    task_save_dir_path = os.path.join(config["ProjectPath"], config["TaskSaveDirPath"])

    query_object = MultipleSublinksQuery2()
    evqa_object = query_object.evqa
    query_graphs = query_object.query_graphs

    # Create natural language
    evqa1 = evqa_object.children[0].children[1]
    evqa2 = evqa_object.children[0].children[0]
    evqa3 = evqa_object.children[0]
    evqa4 = evqa_object

    nl4, mapping4 = create_nl_and_mapping(query_graphs[0], evqa4)
    nl3, mapping3 = create_nl_and_mapping(query_graphs[1], evqa3)
    nl2, mapping2 = create_nl_and_mapping(query_graphs[2], evqa2)
    nl1, mapping1 = create_nl_and_mapping(query_graphs[3], evqa1)

    # Create and save task1
    sub_task1 = Task(
        nl=nl1,
        nl_mapping=mapping1,
        sql="SELECT Max(R2.stars) AS max_stars, M2.id as m_id FROM movie AS M2, rating AS R2 GROUP BY M2.id",
        evqa=evqa1,
        query_type="GroupbyQuery",
        task_type=1,
        db_name="IMDB",
        table_excerpt=evqa1.node.table_excerpt,
        result_table=evqa1.node.table_excerpt,
        history_task_ids=[],
    )
    task1_id = Task.save(sub_task1, task_save_dir_path)

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
        result_table=evqa2.node.table_excerpt,
        history_task_ids=[],
    )
    task2_id = Task.save(sub_task2, task_save_dir_path)

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
        result_table=evqa3.node.table_excerpt,
        history_task_ids=[task2_id, task1_id],
    )
    task3_id = Task.save(sub_task3, task_save_dir_path)

    # Create and save task4
    sub_task4 = Task(
        nl=nl4,
        nl_mapping=mapping4,
        sql="SELECT B3.id as id FROM B3 WHERE B3.avg_stars >= 3",
        evqa=evqa4,
        query_type="HavingQuery",
        task_type=1,
        db_name="IMDB",
        table_excerpt=evqa4.node.table_excerpt,
        result_table=evqa4.node.table_excerpt,
        history_task_ids=[task3_id, task2_id, task1_id],
    )
    task4_id = Task.save(sub_task4, task_save_dir_path)

    return sub_task4


if __name__ == "__main__":
    example_task_in_the_paper()
