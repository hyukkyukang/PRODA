from typing import Any, List, Optional, Union
from hkkang_utils import string as string_utils
from decimal import Decimal
import datetime


def perform_join(table1, table2, key1_idx, key2_idx, join_type, empty_row1, empty_row2):
    df = []
    joined_row1 = set()
    joined_row2 = set()
    for idx1, row1 in enumerate(table1):
        for idx2, row2 in enumerate(table2):
            if row1[key1_idx].value == row2[key2_idx].value:
                df.append(Row(row1.cells + row2.cells))
                joined_row1.add(idx1)
                joined_row2.add(idx2)
    if join_type in ("left_outer", "full_outer"):
        for idx, row1 in enumerate(table1):
            if idx not in joined_row1:
                df.append(Row(row1.cells + empty_row2.cells))
    if join_type in ("right_outer", "full_outer"):
        for idx, row2 in enumerate(table2):
            if idx not in joined_row2:
                df.append(Row(empty_row1.cells + row2.cells))
    return df


class DType:
    def __str__(self):
        return self.__class__.__name__

    def __repr__(self) -> str:
        return self.__class__.__name__

    def dump_json(self):
        if type(self) == DList:
            return f"{self.__class__.__name__}.{self.inner_type.dump_json()}"
        return self.__class__.__name__

    @staticmethod
    def load_json(type_name: str):
        module = getattr(__import__("src.table_excerpt.table_excerpt"), "table_excerpt").table_excerpt
        sub_type_names = type_name.split(".")
        if len(sub_type_names) > 1:
            return getattr(module, sub_type_names[0])(inner_type=DType.load_json(".".join(sub_type_names[1:])))
        return getattr(module, type_name)()


class DNumber(DType):
    pass


class DString(DType):
    pass


class DBoolean(DType):
    pass


class DList(DType):
    def __init__(self, inner_type: DType):
        self.inner_type = inner_type

    def __str__(self):
        return self.__class__.__name__ + f"[{self.inner_type}]"

    def __repr__(self):
        return self.__class__.__name__ + f"[{self.inner_type}]"


class Cell:
    def __init__(self, value: Any, dtype=None):
        self.value = value
        if (dtype is not None and dtype == "date") or type(value) == datetime.date or type(value) == datetime.datetime:
            self.value = str(value)
        if dtype is not None:
            if dtype in ("int", "float", "number"):
                self.dtype = DNumber()
            else:
                self.dtype = DString()
        else:
            self.dtype = Cell.to_dtype(value)

    @staticmethod
    def to_dtype(value: Any) -> DType:
        if value is None or value == "":
            return None
        """Convert value into DType"""
        if type(value) in [int, float, Decimal]:
            return DNumber()
        elif type(value) in [str, datetime.date, datetime.datetime]:
            return DString()
        elif type(value) == bool:
            return DBoolean()
        elif type(value) == list:
            return DList(Cell.to_dtype(value[0]))

    @staticmethod
    def load_json(json_obj: dict):
        return Cell(json_obj["value"])

    @property
    def is_null(self):
        return self.value == None or self.value == ""

    def dump_json(self):
        value = float(self.value) if type(self.value) == Decimal else self.value
        return {"value": value}


class Row:
    def __init__(self, cells: List[Cell]):
        self.cells = cells

    def __getitem__(self, index: int) -> Cell:
        return self.cells[index]

    def __len__(self) -> int:
        return len(self.cells)

    def dump_json(self):
        return {"cells": [cell.dump_json() for cell in self.cells]}

    @staticmethod
    def load_json(json_obj: dict):
        return Row([Cell.load_json(cell) for cell in json_obj["cells"]])


class TableExcerpt:
    def __init__(self, name, headers, col_types, rows=None, base_table_names=None):
        self.name = name
        self.headers: List[str] = headers
        self.col_types: List[DType] = list(map(TableExcerpt._to_dtype, col_types))
        self.rows: Optional[Union[Row, List[str]]] = []
        self.base_table_names: List[str] = base_table_names if base_table_names else [name for _ in range(len(headers))]
        if rows:
            self.add_rows(rows)

    @staticmethod
    def fake_join(new_table_name: str, tables: List[Any], prefixes=None, join_atts=None):
        if prefixes is not None:
            assert len(prefixes) == len(tables)
            headers = []
            for table, prefix in zip(tables, prefixes):
                for header in table.headers:
                    headers.append(prefix + header)
        else:
            headers = [header for item in tables for header in item.headers]
        col_types = [col_type for item in tables for col_type in item.col_types]

        if join_atts is None:
            # Fake join
            # Find the smallest number of rows
            min_row_num = min([len(item.rows) for item in tables])

            new_rows = []
            for row_idx in range(min_row_num):
                row = []
                for table in tables:
                    row.extend(table.rows[row_idx])
                new_rows.append(Row(row))
        else:
            # Real join - left deep join
            joined_tables = []
            df = []
            for join_att in join_atts:
                t1_idx = join_att[0]
                t2_idx = join_att[1]
                c1_idx = tables[t1_idx].headers.index(join_att[2])
                c2_idx = tables[t2_idx].headers.index(join_att[3])
                join_type = join_att[4]

                cells_df = []
                for table in joined_tables:
                    for col_type in tables[table].col_types:
                        cells_df.append(Cell(None, dtype=col_type))
                empty_row_df = Row(cells_df)

                cells_t1 = []
                for col_type in tables[t1_idx].col_types:
                    cells_t1.append(Cell(None, dtype=col_type))
                empty_row_t1 = Row(cells_t1)

                cells_t2 = []
                for col_type in tables[t2_idx].col_types:
                    cells_t2.append(Cell(None, dtype=col_type))
                empty_row_t2 = Row(cells_t2)

                if t1_idx in joined_tables and t2_idx not in joined_tables:
                    offset = 0
                    for i in range(joined_tables.index(t1_idx)):
                        offset += len(tables[joined_tables[i]].headers)
                    df = perform_join(
                        df, tables[t2_idx].rows, offset + c1_idx, c2_idx, join_type, empty_row_df, empty_row_t2
                    )
                    joined_tables.append(t2_idx)
                elif t2_idx in joined_tables and t1_idx not in joined_tables:
                    offset = 0
                    for i in range(joined_tables.index(t2_idx)):
                        offset += len(tables[joined_tables[i]].headers)
                    if join_type == "left_outer":
                        join_type = "right_outer"
                    elif join_type == "right_outer":
                        join_type = "left_outer"
                    df = perform_join(
                        df, tables[t1_idx].rows, offset + c2_idx, c1_idx, join_type, empty_row_df, empty_row_t1
                    )
                    joined_tables.append(t1_idx)
                elif len(joined_tables) == 0:
                    df = perform_join(
                        tables[t1_idx].rows, tables[t2_idx].rows, c1_idx, c2_idx, join_type, empty_row_t1, empty_row_t2
                    )
                    joined_tables.append(t1_idx)
                    joined_tables.append(t2_idx)
                else:
                    assert False
            new_rows = df
            headers = []
            col_types = []
            for tid in joined_tables:
                for col_type in tables[tid].col_types:
                    col_types.append(col_type)
                for header in tables[tid].headers:
                    if prefix is not None:
                        headers.append(prefixes[tid] + header)
                    else:
                        headers.append(header)

        return TableExcerpt(new_table_name, headers, col_types, new_rows)

    @staticmethod
    def concatenate(new_table_name, base_table, new_table, prefixes=None):
        def retrieve_col_items(rows, col_id, list_num):
            tmp = [row[col_id].value for row in rows]
            if list_num == 1:
                return tmp
            return [tmp for _ in range(list_num)]

        """ Cartesian product of two tables """
        if prefixes is not None:
            assert len(prefixes) == 2
            new_headers = [prefixes[0] + header for header in base_table.headers]
            new_headers += [prefixes[1] + header for header in new_table.headers]
        else:
            new_headers = base_table.headers + new_table.headers
        new_col_types = base_table.col_types + [DList(col_type) for col_type in new_table.col_types]
        base_table_names = base_table.base_table_names + new_table.base_table_names

        # Find column with most grouping layer
        max_recursive_list_num = max([str(col_type).count("DList") for col_type in new_col_types])

        # Create lists of column items
        columns_to_concatenate = [
            Cell(retrieve_col_items(new_table.rows, col_id, max_recursive_list_num))
            for col_id in range(len(new_table.headers))
        ]
        new_rows = [Row(row.cells + columns_to_concatenate) for row in base_table.rows]
        return TableExcerpt(
            new_table_name,
            new_headers,
            new_col_types,
            rows=new_rows,
            base_table_names=base_table_names,
        )

    @staticmethod
    def _to_dtype(data_type: Union[str, DType]) -> DType:
        if isinstance(data_type, DType):
            return data_type
        return TableExcerpt._str_to_dtype(data_type)

    @staticmethod
    def _str_to_dtype(data_type: str) -> DType:
        """convert type_name into DType"""
        assert type(data_type) == str, f"Data type must be str or DType, got {type(data_type)}"
        type_names = data_type.lower().split(".")
        type_name = type_names[0]
        if type_name in ["int", "float", "number"]:
            return DNumber()
        elif type_name in ["str", "string", "date"]:
            return DString()
        elif type_name in ["bool", "boolean"]:
            return DBoolean()
        elif type_name in ["list"]:
            return DList(TableExcerpt._str_to_dtype(".".join(type_names[1:])))
        raise ValueError(f"Cannot convert {type_name} to dtype")

    @property
    def table_excerpt_headers(self):
        return [self.name] + self.headers

    def _check_row_corresponse_with_header(self, row: Row):
        # Check column number
        assert len(row) == len(
            self.headers
        ), f"Row length must be equal to header length, got {len(row)} and {len(self.headers)}"
        # Check data types
        for i, (cell, col_type) in enumerate(zip(row, self.col_types)):
            if cell.is_null:
                continue
            assert (
                type(cell.dtype) == type(col_type) and cell.dtype.__class__.__name__ == col_type.__class__.__name__
            ), f"Column value {cell.value}(idx:{i}) must be {col_type}, got {cell.dtype}"

    def is_nested_col(self, col_index: int):
        return type(self.col_types[col_index]) == DList

    def add_row(self, row):
        if not isinstance(row, Row):
            row = Row([Cell(value) for value in row])
        self._check_row_corresponse_with_header(row)
        self.rows.append(row)
        return self.rows

    def add_rows(self, rows: List[List[Any]]):
        return [self.add_row(row) for row in rows if row]

    def dump_json(self):
        return {
            "name": self.name,
            "headers": self.headers,
            "col_types": [col_type.dump_json() for col_type in self.col_types],
            "rows": [row.dump_json() for row in self.rows],
            "base_table_names": self.base_table_names,
        }

    @staticmethod
    def load_json(json_obj):
        return TableExcerpt(
            json_obj["name"],
            json_obj["headers"],
            [DType.load_json(col_type) for col_type in json_obj["col_types"]],
            rows=[Row.load_json(row) for row in json_obj["rows"]],
            base_table_names=json_obj["base_table_names"],
        )


# Helper functions
def type_detection(value: Any) -> str:
    if string_utils.is_number(value):
        return "int"
    elif type(value) == str:
        return "string"
    elif type(value) == list:
        return "list"
    elif type(value) == str and value.lower() in ["true", "false", "t", "f"]:
        return "boolean"
    else:
        raise ValueError(f"Cannot detect type of {value}")


if __name__ == "__main__":
    pass
