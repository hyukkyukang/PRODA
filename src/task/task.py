from enum import IntEnum
from typing import List

import json
import attrs

from src.table_excerpt.table_excerpt import TableExcerpt
from src.VQL.EVQL import EVQLTree


class TaskTypes(IntEnum):
    Simplification = 1
    Validation = 2


@attrs.define
class Task:
    nl: str
    sql: str
    evql: EVQLTree
    query_type: IntEnum
    task_type: IntEnum
    db_name: str
    table_excerpt: TableExcerpt
    result_table: TableExcerpt
    history: List["Task"] = attrs.Factory(list)

    def dump_json(self):
        return json.dumps(
            {
                "nl": self.nl,
                "sql": self.sql,
                "evql": self.evql.dump_json(),
                "table_excerpt": self.table_excerpt.dump_json() if self.table_excerpt else None,
                "result_table": self.result_table.dump_json() if self.result_table else None,
                "queryType": self.query_type,
                "dbName": self.db_name,
                "taskType": self.task_type,
                "subTasks": [
                    {**history.dump_json(), **{"db_name": self.db_name, "task_type": self.task_type}}
                    for history in self.history
                ],
            }
        )

    @staticmethod
    def load_json(json_obj):
        return Task(
            nl=json_obj["nl"],
            sql=json_obj["sql"],
            evql=EVQLTree.load_json(json_obj["evql"]),
            query_type=json_obj["queryType"],
            task_type=json_obj["taskType"],
            db_name=json_obj["dbName"],
            table_excerpt=TableExcerpt.load_json(json_obj["table_excerpt"]) if json_obj["table_excerpt"] else None,
            result_table=TableExcerpt.load_json(json_obj["result_table"]) if json_obj["result_table"] else None,
            history=[Task.load_json(sub_task) for sub_task in json_obj["subTasks"]],
        )
