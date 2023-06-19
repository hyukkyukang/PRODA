import abc
from typing import Any, List, Optional

import hkkang_utils.list as list_utils

from src.query_tree.operator import Clause, Operation, Projection, Foreach


class Node(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def get_headers(self) -> List[str]:
        pass

    @abc.abstractmethod
    def get_headers_with_table_name(self) -> List[str]:
        pass

    @abc.abstractmethod
    def get_name(self) -> str:
        pass

    @abc.abstractmethod
    def get_rows(self) -> List[List[Any]]:
        pass

    @property
    @abc.abstractmethod
    def height(self) -> List[List[Any]]:
        pass

    @property
    @abc.abstractmethod
    def num_nodes(self) -> List[List[Any]]:
        pass


# class Edge(metaclass=abc.ABCMeta):
#     def __init__(self, child: Node):
#         self.child: Node = child


# class Refer(Edge):
#     def __init__(self, *args, **kwargs):
#         super(Refer, self).__init__(*args, **kwargs)


# class Attach(Edge):
#     def __init__(self, *args, **kwargs):
#         super(Attach, self).__init__(*args, **kwargs)


class BaseTable(Node):
    def __init__(self, header: List[str], data: List[List[Any]], name: Optional[str] = None):
        self.header: List[str] = header
        self.data: List[List[Any]] = data
        self.name: str = name

    def __len__(self):
        return len(self.header)

    @property
    def height(self):
        return 0

    @property
    def num_nodes(self):
        return 0

    def get_name(self) -> str:
        return self.name

    def get_headers(self) -> List[str]:
        return self.header

    def get_headers_with_table_name(self) -> List[str]:
        headers = self.get_headers()
        if self.name:
            headers = [self.name + "_" + colname for colname in headers]
        return headers

    def get_rows(self) -> List[List[Any]]:
        return self.data


class QueryBlock(Node):
    def __init__(
        self,
        child_tables: List[Node],
        operations: List[Operation],
        join_conditions: Optional[List[Clause]] = None,
        sql: Optional[str] = None,
        name: Optional[str] = None,
    ):
        """Multiple Selection in the operations list are treated as conjunctions"""
        self.child_tables: List[Node] = child_tables
        self.join_conditions: List[Clause] = join_conditions if join_conditions else []
        self.operations: List[Operation] = operations
        self.sql: str = sql
        self.name: str = name
        self.result_guarantee_tuples: List[List[Any]] = [[]]
        self.result_tuples: List[List[Any]] = [[]]

    def __len__(self):
        return sum(len(op) for op in self.operations if type(op) in [Projection, Foreach])

    @property
    def height(self):
        return 1 + max(node.height for node in self.child_tables)

    @property
    def num_nodes(self) -> List[List[Any]]:
        return 1 + sum(node.num_nodes for node in self.child_tables)

    def get_name(self) -> str:
        return self.name

    def add_join_conditions(self, join_conditions: List[Clause]):
        self.join_conditions += join_conditions

    def add_operations(self, operations: List[Operation]):
        self.operations += operations

    def update_child_table(self, idx, new_child_table):
        self.child_tables[idx] = new_child_table

    def get_child_tables(self) -> List[Node]:
        return self.child_tables

    def get_child_table(self, name) -> Node:
        for child_table in self.get_child_tables():
            if child_table.get_name() == name:
                return child_table

    def get_headers(self) -> List[str]:
        # Get header names
        new_headers = []
        projections = [op for op in self.operations if isinstance(op, Projection)]
        for proj in projections:
            if proj.alias:
                new_headers.append(proj.alias)
            else:
                accumulated_len = 0
                for child_table in self.child_tables:
                    child_headers = child_table.get_headers()
                    if accumulated_len + len(child_headers) > proj.column_id:
                        new_headers.append(child_headers[proj.column_id - accumulated_len])
                        break
                    accumulated_len += len(child_headers)
        return new_headers

    def get_headers_with_table_name(self) -> List[str]:
        # Get header names
        new_headers = []
        projections = [op for op in self.operations if isinstance(op, Projection)]
        for proj in projections:
            if proj.alias:
                new_headers.append(proj.alias)
            else:
                accumulated_len = 0
                for child_table in self.child_tables:
                    child_headers = child_table.get_headers_with_table_name()
                    if accumulated_len + len(child_headers) > proj.column_id:
                        new_headers.append(child_headers[proj.column_id - accumulated_len])
                        break
                    accumulated_len += len(child_headers)
        return new_headers

    def get_rows(self) -> List[List[Any]]:
        return self.result_guarantee_tuples

    def get_result_rows(self) -> List[List[Any]]:
        return self.result_tuples


class QueryTree:
    def __init__(self, root: Node, sql: str):
        self.root: Node = root
        self.sql: str = sql

    @property
    def height(self):
        return self.root.height

    @property
    def num_nodes(self):
        return self.root.num_nodes


# Helper functions
def get_global_index(tables: List[Node], table_id: int, column_name: str) -> int:
    if column_name == "*":
        return -1
    return sum(len(t) for t in tables[:table_id]) + tables[table_id].get_headers().index(column_name)
