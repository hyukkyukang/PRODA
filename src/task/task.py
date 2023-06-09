import os
import json
from enum import IntEnum
from typing import Any, Dict, List

import attrs
import hkkang_utils.string as string_utils

from src.table_excerpt.table_excerpt import TableExcerpt
from src.utils.data_manager import save_task_in_db, save_json
from src.VQL.EVQL import EVQLTree


class TaskTypes(IntEnum):
    Simplification = 1
    Validation = 2


@attrs.define
class Task:
    nl: str
    nl_mapping: Dict[str, Any]
    sql: str
    evql: EVQLTree
    query_type: IntEnum
    task_type: IntEnum
    db_name: str
    table_excerpt: TableExcerpt
    result_table: TableExcerpt
    history_task_ids: List[int] = attrs.field(default=attrs.Factory(List))
    block_id: str = attrs.field(default="1")

    @staticmethod
    def save(cls, dir_path):
        # Generate file paths
        rand_id = string_utils.generate_random_str(size=10)
        evql_file_path = os.path.join(dir_path, f"evql/{rand_id}.json")
        table_excerpt_path = os.path.join(dir_path, f"table_excerpt/{rand_id}.json")
        result_table_path = os.path.join(dir_path, f"result_table/{rand_id}.json")
        nl_mapping_path = os.path.join(dir_path, f"nl_mapping/{rand_id}.json")

        print(evql_file_path)

        # Save as json file
        save_json(cls.evql.dump_json(), evql_file_path)
        save_json(cls.table_excerpt.dump_json(), table_excerpt_path)
        save_json(cls.result_table.dump_json(), result_table_path)
        save_json(json.dumps(cls.nl_mapping), nl_mapping_path)

        # Save in DB
        return save_task_in_db(
            nl=cls.nl,
            sql=cls.sql,
            query_type=cls.query_type,
            evql_path=evql_file_path,
            table_excerpt_path=table_excerpt_path,
            result_table_path=result_table_path,
            nl_mapping_path=nl_mapping_path,
            db_name=cls.db_name,
            task_type=cls.task_type,
            history_task_ids=cls.history_task_ids,
        )

    def dump_json(self):
        return {
            "nl": self.nl,
            "nl_mapping": self.nl_mapping,
            "sql": self.sql,
            "evql": self.evql.dump_json(),
            "queryType": self.query_type,
            "taskType": self.task_type,
            "dbName": self.db_name,
            "tableExcerpt": self.table_excerpt.dump_json() if self.table_excerpt else None,
            "resultTable": self.result_table.dump_json() if self.result_table else None,
            "history_task_ids": self.history_task_ids,
            "blockId": self.block_id,
        }

    @staticmethod
    def load_json(json_obj):
        return Task(
            nl=json_obj["nl"],
            nl_mapping=json_obj["nl_mapping"],
            sql=json_obj["sql"],
            evql=EVQLTree.load_json(json_obj["evql"]),
            query_type=json_obj["queryType"],
            task_type=json_obj["taskType"],
            db_name=json_obj["dbName"],
            table_excerpt=TableExcerpt.load_json(json_obj["tableExcerpt"]) if json_obj["tableExcerpt"] else None,
            result_table=TableExcerpt.load_json(json_obj["resultTable"]) if json_obj["resultTable"] else None,
            block_id=json_obj["blockId"],
            history_task_ids=[json_obj["history_task_ids"]],
        )
