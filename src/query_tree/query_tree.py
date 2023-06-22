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
    def __init__(self, header: List[str], dtype: List[List[Any]], data: List[List[Any]], name: Optional[str] = None):
        self.header: List[str] = header
        self.dtype: List[str] = dtype
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
        """Get result headers

        :return: List of headers
        :rtype: List[str]
        """
        return self.header

    def get_headers_with_table_name(self) -> List[str]:
        """Get result headers with table name

        :return: List of headers with table name
        :rtype: List[str]
        """
        headers = self.get_headers()
        if self.name:
            headers = [self.name + "_" + colname for colname in headers]
        return headers

    def get_dtypes(self) -> List[str]:
        return self.dtype

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
        self.result_guarantee_tuples: List[List[Any]] = []
        self.result_tuples: List[List[Any]] = []

    def __len__(self):
        return len(self.get_headers())
        ##### return sum(len(op) for op in self.operations if type(op) in [Projection, Foreach])
        ##### Foreach operator always comes with projection operator
        ##### return sum(len(op) for op in self.operations if type(op) in [Projection])

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
    
    def global_idx_to_column(self, global_idx):
        if global_idx == -1:
            return "*"
        
        col = None
        accumulated_len = 0
        for child_table in self.child_tables:
            child_headers = child_table.get_headers_with_table_name()
            if accumulated_len + len(child_headers) > global_idx:
                col = child_headers[global_idx - accumulated_len]
                break
            accumulated_len += len(child_headers)
        assert col is not None
        return col
    
    def get_join_keys(self):
        join_keys = []
        for join_condition in self.join_conditions:
            l_idx = join_condition.clauses[0].conditions[0].l_operand
            r_idx = join_condition.clauses[0].conditions[0].r_operand
            l_col = self.global_idx_to_column(l_idx)
            r_col = self.global_idx_to_column(r_idx)
            join_keys.append(l_col)
            join_keys.append(r_col)
        return join_keys
    
    def add_operations_fronted(self, operations: List[Operation]):
        self.operations = operations + self.operations
        
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
        """Get result headers

        :return: List of headers
        :rtype: List[str]
        """
        new_headers = []
        projections = [op for op in self.operations if isinstance(op, Projection) or isinstance(op, Foreach)]
        # If star projection and add all headers
        if any([proj.alias == "*" for proj in projections]):
            return list_utils.do_flatten_list([child_table.get_headers() for child_table in self.child_tables if type(child_table) == BaseTable ])
        # Get projecting headers
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
        """Get result headers with table name

        :return: List of headers with table name
        :rtype: List[str]
        """
        new_headers = []
        projections = [op for op in self.operations if isinstance(op, Projection) or isinstance(op, Foreach)]
        # If star projection and add all headers
        if any([proj.alias == "*" for proj in projections]):
            return list_utils.do_flatten_list([
                child_table.get_headers_with_table_name() for child_table in self.child_tables if type(child_table) == BaseTable ])
        # Get projecting headers
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

    def get_dtypes(self) -> List[str]:
        # Get dtypes for headers
        new_dtypes = []
        projections = [op for op in self.operations if isinstance(op, Projection) or isinstance(op, Foreach)]
        if any([proj.alias == "*" for proj in projections]):
            return list_utils.do_flatten_list([
                child_table.get_dtypes() for child_table in self.child_tables if type(child_table) == BaseTable])
        for proj in projections:
            if proj.dtype:
                new_dtypes.append(proj.dtype)
            else:
                accumulated_len = 0
                for child_table in self.child_tables:
                    child_dtypes = child_table.get_dtypes()
                    if accumulated_len + len(child_dtypes) > proj.column_id:
                        new_dtypes.append(child_dtypes[proj.column_id - accumulated_len])
                        break
                    accumulated_len += len(child_dtypes)
        return new_dtypes

    def get_rows(self) -> List[List[Any]]:
        return self.result_guarantee_tuples

    def get_result_rows(self) -> List[List[Any]]:
        return self.result_tuples

    def add_row(self, row):
        self.result_guarantee_tuples.append(row)

    def add_rows(self, rows):
        [self.add_row(row) for row in rows]

    def add_result_row(self, row):
        self.result_tuples.append(row)

    def add_result_rows(self, rows):
        [self.add_result_row(row) for row in rows]


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


# Helper functions
def get_global_index_header_with_table_name(tables: List[Node], table_id: int, column_name: str) -> int:
    if column_name == "*":
        return -1
    return sum(len(t) for t in tables[:table_id]) + tables[table_id].get_headers_with_table_name().index(column_name)
