import json

from VQL.example_queries import HavingQuery

class Task:
    def __init__(self, nl, sql, evql, query_type, db_name, task_type, sub_tasks=None):
        self.nl = nl
        self.sql = sql
        self.evql = evql
        self.query_type = query_type
        self.db_name = db_name
        self.task_type = task_type
        self.sub_tasks = sub_tasks if sub_tasks else []

    def add_sub_task(self, sub_task):
        self.sub_tasks.append(sub_task)

    def dump_json(self):
        return {
            "nl": self.nl,
            "sql": self.sql,
            "evql": self.evql.dump_json(),
            "queryType": self.query_type,
            "dbName": self.db_name,
            "taskType": self.task_type,
            "subTasks": [{**sub_task.dump_json(), **{"db_name": self.db_name, "task_type": self.task_type}} for sub_task in self.sub_tasks],
        }

class SubTask:
    def __init__(self, nl, sql, evql, table_excerpt, result_table):
        self.nl = nl
        self.sql = sql
        self.evql = evql
        self.table_excerpt = table_excerpt
        self.result_table = result_table
        
    def dump_json(self):
        return {
            "nl": self.nl,
            "sql": self.sql,
            "evql": self.evql.dump_json(),
            "tableExcerpt": self.table_excerpt,
            "resultTable": self.result_table,
        }

def create_dummy_task():
    sub_task1 = SubTask(
        nl="Show average max speed of each model whose production year is 2010.",
        sql="SELECT model, avg(max_speed) FROM cars WHERE year = 2010 GROUP BY model",
        evql=HavingQuery().evql.child.node,
        table_excerpt= [
        { "id": 1, "model": "A", "horsepower": 100, "max_speed": 200, "year": 2012, "price": 10000 },
        { "id": 2, "model": "B", "horsepower": 200, "max_speed": 300, "year": 2011, "price": 70000 },
        { "id": 3, "model": "C", "horsepower": 300, "max_speed": 400, "year": 2009, "price": 60000 },
        { "id": 4, "model": "D", "horsepower": 400, "max_speed": 500, "year": 2010, "price": 50000 },
        { "id": 5, "model": "E", "horsepower": 500, "max_speed": 600, "year": 2010, "price": 40000 },
        { "id": 6, "model": "A", "horsepower": 300, "max_speed": 300, "year": 2010, "price": 30000 },
        { "id": 7, "model": "A", "horsepower": 200, "max_speed": 200, "year": 2010, "price": 20000 },
        { "id": 8, "model": "B", "horsepower": 100, "max_speed": 200, "year": 2010, "price": 10000 },
    ],
        result_table = [
        { "model": "A", "max_speed_avg": 250 },
        { "model": "B", "max_speed_avg": 200 },
        { "model": "D", "max_speed_avg": 500 },
        { "model": "E", "max_speed_avg": 600 },
    ],
    )
    sub_task2 = SubTask(
        nl="Show models whose average max speed is greater than 400.",
        sql="SELECT model FROM step1_cars WHERE step1_max_speed_avg > 400",
        evql=HavingQuery().evql.node,
        table_excerpt= [
        { "model": "A", "max_speed_avg": 250 },
        { "model": "B", "max_speed_avg": 200 },
        { "model": "D", "max_speed_avg": 500 },
        { "model": "E", "max_speed_avg": 600 },
    ],
        result_table = [
        { "model": "D", "max_speed_avg": 500 },
        { "model": "E", "max_speed_avg": 600 },
    ]
    )
    task = Task(
        nl="For cars whose production year is 2010, show models whose average max speed is greater than 2000.",
        sql="SELECT model FROM cars WHERE year = 2010 GROUP BY model HAVING AVG(max_speed) > 2000",
        evql=HavingQuery().evql,
        query_type = "WHERE: scalar comparison",
        db_name = "cars",
        task_type= 1,
        sub_tasks=[sub_task1, sub_task2]
    )
    
    return task

if __name__ == "__main__":
    dummy_task = create_dummy_task()
    print(json.dumps(dummy_task.dump_json(), indent=4))