import abc
from typing import Any, List, Optional

import hkkang_utils.list as list_utils

from src.query_tree.operator import Clause, Operation, Projection, Foreach


class Node(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def get_headers(self) -> List[str]:
        pass

    @abc.abstractmethod
    def get_rows(self) -> List[List[Any]]:
        pass


class Edge(metaclass=abc.ABCMeta):
    def __init__(self, child: Node):
        self.child: Node = child


class Refer(Edge):
    def __init__(self, *args, **kwargs):
        super(Refer, self).__init__(*args, **kwargs)


class Attach(Edge):
    def __init__(self, *args, **kwargs):
        super(Attach, self).__init__(*args, **kwargs)


class BaseTable(Node):
    def __init__(self, header: List[str], data: List[List[Any]]):
        self.header: List[str] = header
        self.data: List[List[Any]] = data

    def __len__(self):
        return len(self.header)

    def get_headers(self) -> List[str]:
        return self.header

    def get_rows(self) -> List[List[Any]]:
        return self.data


class QueryBlock(Node):
    def __init__(
        self,
        child_tables: List[Edge],
        operations: List[Operation],
        join_conditions: Optional[List[Clause]] = None,
        sql: Optional[str] = None,
    ):
        """Multiple Selection in the operations list are treated as conjunctions"""
        self.child_tables: List[Edge] = child_tables
        self.join_conditions: List[Clause] = join_conditions if join_conditions else []
        self.operations: List[Operation] = operations
        self.sql: str = sql

    def __len__(self):
        return sum(len(op) for op in self.operations if type(op) in [Projection, Foreach])

    def get_headers(self) -> List[str]:
        # Get header names
        new_headers = []
        projections = [op for op in self.operations if isinstance(op, Projection)]
        for proj in projections:
            if proj.alias:
                new_headers.append(proj.alias)
            else:
                accumulated_len = 0
                for child_edge in self.child_tables:
                    child_table = child_edge.child
                    child_headers = child_table.get_headers()
                    if accumulated_len + len(child_headers) > proj.column_id:
                        new_headers.append(child_headers[proj.column_id - accumulated_len])
                        break
                    accumulated_len += len(child_headers)
        return new_headers

    def get_rows(self) -> List[List[Any]]:
        # new_rows = []
        # projections = [op for op in self.operations if isinstance(op, Projection)]
        # for proj in projections:
        #     accumulated_len = 0
        #     for child_edge in self.child_tables:
        #         child_table = child_edge.child
        #         child_headers = child_table.get_headers()
        #         child_rows = child_table.get_rows()
        #         if accumulated_len + len(child_headers) > proj.column_id:
        #             for child_row in child_rows
        #             new_rows.append(child_row[proj.column_id - accumulated_len] for child_row in child_rows)
        #             break
        #         accumulated_len += len(child_rows)
        # if self.join_conditions:
        #     # TODO
        #     raise NotImplementedError
        # return list_utils.do_flatten_list([t.child.get_rows() for t in self.child_tables])
        return []


class QueryTree:
    def __init__(self, root: Node, sql: str):
        self.root: Node = root
        self.sql: str = sql


# Helper functions
def get_global_index(tables: List[Node], table_id: int, column_name: str) -> int:
    if column_name == "*":
        return -1
    return sum(len(t) for t in tables[:table_id]) + tables[table_id].get_headers().index(column_name)
