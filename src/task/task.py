import abc
import dataclasses
import functools
import json
import os
from enum import IntEnum
from typing import Dict, List

import hkkang_utils.file as file_utils
import hkkang_utils.string as string_utils

from src.table_excerpt.table_excerpt import TableExcerpt
from src.utils.data_manager import save_json, save_task_in_db
from src.VQA.EVQA import EVQATree


class TaskTypes(IntEnum):
    Simplification = 1
    Validation = 2


@dataclasses.dataclass
class Task:
    nl: str
    nl_mapping: Dict[str, any]
    sql: str
    evqa: EVQATree
    query_type: IntEnum
    task_type: TaskTypes
    db_name: str
    table_excerpt: TableExcerpt
    result_table: TableExcerpt

    @staticmethod
    @abc.abstractclassmethod
    def load_json(json_obj: Dict) -> "Task":
        pass
    
    @abc.abstractclassmethod
    def save(self, dir_path: str) -> int:
        pass

    def dump_json(self) -> Dict:
        return {
            "nl": self.nl,
            "nl_mapping": self.nl_mapping,
            "sql": self.sql,
            "evqa": self.evqa.dump_json(),
            "queryType": self.query_type,
            "taskType": self.task_type,
            "dbName": self.db_name,
            "tableExcerpt": self.table_excerpt.dump_json() if self.table_excerpt else None,
            "resultTable": self.result_table.dump_json() if self.result_table else None,
        }


    #Helper methods to save the task data
    def _get_unique_file_name(self, dir_path: str) -> str:
        """Get unique file name for saving the task data.

        :param dir_path: directory path to save the task data
        :type dir_path: str
        :return: unique file name
        :rtype: str
        """
        # use evqa sub directory to check the uniqueness
        file_names = file_utils.get_files_in_directory(os.path.join(dir_path, "evqa"))
        while True:
            unique_str = f"{string_utils.generate_random_str(size=10)}.json"
            if unique_str not in file_names:
                return unique_str

    def _get_evqa_file_path(self, dir_path: str, file_name: str) -> str:
        return os.path.join(dir_path, "evqa", file_name)

    def _get_table_excerpt_file_path(self, dir_path: str, file_name: str) -> str:
        return os.path.join(dir_path, "table_excerpt",file_name)

    def _get_result_table_file_path(self, dir_path: str, file_name: str) -> str:
        return os.path.join(dir_path, "result_table", file_name)

    def _get_nl_mapping_file_path(self, dir_path: str, file_name: str) -> str:
        return os.path.join(dir_path, "nl_mapping", file_name)

    # Methods to help saving the task data
    def _save_attributes(self, dir_path: str, file_name: str) -> None:
        # Save as json file
        save_json(self.evqa.dump_json(), self._get_evqa_file_path(dir_path, file_name))
        save_json(
            self.table_excerpt.dump_json(),
            self._get_table_excerpt_file_path(dir_path, file_name),
        )
        save_json(
            self.result_table.dump_json(),
            self._get_result_table_file_path(dir_path, file_name),
        )
        save_json(
            json.dumps(self.nl_mapping),
            self._get_nl_mapping_file_path(dir_path, file_name),
        )


@dataclasses.dataclass
class TaskWithSubTasks(Task):
    sub_tasks: List["TaskWithSubTasks"] = dataclasses.field(default_factory=list)

    @staticmethod
    def load_json(json_obj: Dict) -> "TaskWithSubTasks":
        return TaskWithSubTasks(
            nl=json_obj["nl"],
            nl_mapping=json_obj["nl_mapping"],
            sql=json_obj["sql"],
            evqa=EVQATree.load_json(json_obj["evqa"]),
            query_type=json_obj["queryType"],
            task_type=json_obj["taskType"],
            db_name=json_obj["dbName"],
            table_excerpt=TableExcerpt.load_json(json_obj["tableExcerpt"])
            if json_obj["tableExcerpt"]
            else None,
            result_table=TableExcerpt.load_json(json_obj["resultTable"])
            if json_obj["resultTable"]
            else None,
            sub_tasks=[
                TaskWithSubTasks.load_json(sub_task_obj)
                for sub_task_obj in json_obj["subTasks"]
            ],
        )

    def dump_json(self) -> Dict:
        json_obj = super().dump_json()
        # Append history
        json_obj["subTasks"] = list(map(lambda t: t.dump_json(), self.sub_tasks))
        return json_obj

    def save(self, dir_path: str) -> int:
        # Save attributes
        unique_file_name = self._get_unique_file_name(dir_path)
        self._save_attributes(dir_path, unique_file_name)

        # Save recursively
        sub_task_ids = [sub_task.save() for sub_task in self.sub_tasks]

        return save_task_in_db(
            nl=self.nl,
            sql=self.sql,
            query_type=self.query_type,
            evqa_path=self._get_evqa_file_path(dir_path, unique_file_name),
            table_excerpt_path=self._get_table_excerpt_file_path(
                dir_path, unique_file_name
            ),
            result_table_path=self._get_result_table_file_path(
                dir_path, unique_file_name
            ),
            nl_mapping_path=self._get_nl_mapping_file_path(dir_path, unique_file_name),
            db_name=self.db_name,
            task_type=self.task_type,
            sub_task_ids=sub_task_ids,
        )


@dataclasses.dataclass
class TaskWithSubTaskIDs(Task):
    sub_task_ids: List[int] = dataclasses.field(default_factory=list)

    @staticmethod
    def load_json(json_obj: Dict) -> "TaskWithSubTaskIDs":
        return TaskWithSubTaskIDs(
            nl=json_obj["nl"],
            nl_mapping=json_obj["nl_mapping"],
            sql=json_obj["sql"],
            evqa=EVQATree.load_json(json_obj["evqa"]),
            query_type=json_obj["queryType"],
            task_type=json_obj["taskType"],
            db_name=json_obj["dbName"],
            table_excerpt=TableExcerpt.load_json(json_obj["tableExcerpt"])
            if json_obj["tableExcerpt"]
            else None,
            result_table=TableExcerpt.load_json(json_obj["resultTable"])
            if json_obj["resultTable"]
            else None,
            sub_task_ids=json_obj["historyTaskIDs"],
        )

    def dump_json(self) -> Dict:
        json_obj = super().dump_json()
        json_obj["subTaskIDs"] = self.sub_task_ids
        return json_obj

    def save(self, dir_path: str) -> int:
        # Save attributes
        unique_file_name = self._get_unique_file_name(dir_path)
        self._save_attributes(dir_path, unique_file_name)

        return save_task_in_db(
            nl=self.nl,
            sql=self.sql,
            query_type=self.query_type,
            evqa_path=self._get_evqa_file_path(dir_path, unique_file_name),
            table_excerpt_path=self._get_table_excerpt_file_path(
                dir_path, unique_file_name
            ),
            result_table_path=self._get_result_table_file_path(
                dir_path, unique_file_name
            ),
            nl_mapping_path=self._get_nl_mapping_file_path(dir_path, unique_file_name),
            db_name=self.db_name,
            task_type=self.task_type,
            sub_task_ids=self.sub_task_ids,
        )
