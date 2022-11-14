from enum import IntEnum

class TaskTypes(IntEnum):
    Simplification = 1
    Validation = 2

class Task:
    def __init__(self, nl, sql, evql, table_excerpt, result_table, query_type, db_name, task_type, history=None):
        self.nl = nl
        self.sql = sql
        self.evql = evql
        self.query_type = query_type
        self.task_type = task_type
        self.db_name = db_name
        self.table_excerpt = table_excerpt
        self.result_table = result_table
        self.history = history if history else []

    def dump_json(self):
        return {
            "nl": self.nl,
            "sql": self.sql,
            "evql": self.evql.dump_json(),
            "table_excerpt": self.table_excerpt.dump_json() if self.table_excerpt else None,
            "result_table": self.result_table.dump_json() if self.result_table else None,
            "queryType": self.query_type,
            "dbName": self.db_name,
            "taskType": self.task_type,
            "subTasks": [{**history.dump_json(), **{"db_name": self.db_name, "task_type": self.task_type}} for history in self.history],
        }
