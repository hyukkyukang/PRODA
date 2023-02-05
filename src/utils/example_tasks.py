import json

from src.task.query_types import QueryTypes
from src.task.task import Task, TaskTypes
from src.utils.example_queries import HavingQuery
from src.table_excerpt.table_excerpt import TableExcerpt

# One
headers = ["id", "model", "horsepower", "max_speed", "year", "price"]
col_types = ["number", "string", "number", "number", "number", "number"]
rows = [
    [1, "A", 100, 200, 2012, 10000],
    [2, "B", 200, 300, 2011, 70000],
    [3, "C", 300, 400, 2009, 60000],
    [4, "D", 400, 500, 2010, 50000],
    [5, "E", 500, 600, 2010, 40000],
    [6, "A", 300, 300, 2010, 30000],
    [7, "A", 200, 200, 2010, 20000],
    [8, "B", 100, 200, 2010, 10000],
]

car_table1 = TableExcerpt("cars", headers, col_types, rows=rows)
# Two
headers = ["model", "avg"]
col_types = ["string", "number"]
rows = [["A", 250], ["B", 200], ["D", 500], ["E", 600]]
car_table2 = TableExcerpt("cars", headers, col_types, rows=rows)

# Three
headers = ["model", "avg"]
col_types = ["string", "number"]
rows = [["D", 500], ["E", 600]]
car_table3 = TableExcerpt("cars", headers, col_types, rows=rows)


def create_dummy_task():
    sub_task1 = Task(
        nl="Show average max speed of each model whose production year is 2010.",
        sql="SELECT model, avg(max_speed) FROM cars WHERE year = 2010 GROUP BY model",
        evql=HavingQuery().evql.children[0].node,
        table_excerpt=car_table1,
        result_table=car_table2,
        query_type="WHEREScalarComparison",
        task_type=1,
        db_name="cars",
    )
    sub_task2 = Task(
        nl="Show models whose average max speed is greater than 400.",
        sql="SELECT model FROM step1_cars WHERE step1_max_speed_avg > 400",
        evql=HavingQuery().evql.node,
        table_excerpt=car_table2,
        result_table=car_table3,
        query_type="WHEREScalarComparison",
        task_type=2,
        db_name="cars",
    )

    task = Task(
        nl="For cars whose production year is 2010, show models whose average max speed is greater than 2000.",
        sql="SELECT model FROM cars WHERE year = 2010 GROUP BY model HAVING AVG(max_speed) > 2000",
        evql=HavingQuery().evql,
        query_type="WHEREScalarComparison",
        task_type=1,
        db_name="cars",
        table_excerpt=None,
        result_table=None,
        history=[sub_task1, sub_task2],
    )

    return task


if __name__ == "__main__":
    dummy_task = create_dummy_task()
    print(json.dumps(dummy_task.dump_json(), indent=4))
    stop = 1
