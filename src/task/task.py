from enum import IntEnum
from typing import List

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
    block_id: str = attrs.field(default="1")

    def dump_json(self):
        return {
            "nl": self.nl,
            "sql": self.sql,
            "evql": self.evql.dump_json(),
            "queryType": self.query_type,
            "taskType": self.task_type,
            "dbName": self.db_name,
            "tableExcerpt": self.table_excerpt.dump_json() if self.table_excerpt else None,
            "resultTable": self.result_table.dump_json() if self.result_table else None,
            "blockId": self.block_id,
        }

    @staticmethod
    def load_json(json_obj):
        return Task(
            nl=json_obj["nl"],
            sql=json_obj["sql"],
            evql=EVQLTree.load_json(json_obj["evql"]),
            query_type=json_obj["queryType"],
            task_type=json_obj["taskType"],
            db_name=json_obj["dbName"],
            table_excerpt=TableExcerpt.load_json(json_obj["tableExcerpt"]) if json_obj["tableExcerpt"] else None,
            result_table=TableExcerpt.load_json(json_obj["resultTable"]) if json_obj["resultTable"] else None,
            block_id=json_obj["blockId"],
        )
