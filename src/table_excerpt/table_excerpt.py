from typing import List, Any, Optional, Union

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
    def __init__(self, value: Any):
        self.value = value
        self.dtype = Cell.to_dtype(value)

    @staticmethod
    def to_dtype(value: Any) -> DType:
        """Convert value into DType"""
        if type(value) in [int, float]:
            return DNumber()
        elif type(value) == str:
            return DString()
        elif type(value) == bool:
            return DBoolean()
        elif type(value) == list:
            return DList(Cell.to_dtype(value[0]))
        raise ValueError(f"Cannot convert {type(value)} to dtype")
    
    @staticmethod
    def load_json(json_obj: dict):
        return Cell(json_obj["value"])
    
    @property
    def is_null(self):
        return self.value == None
    
    def dump_json(self):
        return {"value": self.value}

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
    def __init__(self, headers, col_types, table_name=None, rows=None, allow_null=True):
        self.name = table_name
        self.headers: List[str] = headers
        self.col_types: List[DType] = list(map(TableExcerpt._str_to_dtype, col_types))
        self.allow_null = allow_null
        self.rows: Optional[Union[Row, List[str]]] = []
        self.add_rows(rows)

    @staticmethod
    def _str_to_dtype(data_type: Union[str, DType]) -> DType:
        """convert type_name into DType"""
        if isinstance(data_type, DType):
            return data_type
        assert type(data_type) == str, f"Data type must be str or DType, got {type(data_type)}"
        type_names = data_type.lower().split(".")
        type_name = type_names[0]
        if type_name in ["int", "float", "number"]:
            return DNumber()
        elif type_name in ["str", "string"]:
            return DString()
        elif type_name in ["bool", "boolean"]:
            return DBoolean()
        elif type_name in ["list"]:
            return DList(TableExcerpt._str_to_dtype(".".join(type_names[1:])))
        raise ValueError(f"Cannot convert {type_name} to dtype")

    @property
    def header_names_for_grouping(self):
        # TODO: Need to find better way to distinguish headers for grouping
        return [header for header in self.headers if "group" in header.lower()]

    @property
    def table_excerpt_headers(self):
        return [self.name] + self.headers

    def _check_row_corresponse_with_header(self, row: Row):
        # Check column number
        assert len(row) == len(self.headers), f"Row length must be equal to header length, got {len(row)} and {len(self.headers)}"
        # Check data types
        for i, (cell, col_type) in enumerate(zip(row, self.col_types)):
            if self.allow_null and cell.is_null:
                continue
            assert type(cell.dtype) == type(col_type) and cell.dtype.__class__.__name__ == col_type.__class__.__name__, f"Column {i} must be {col_type}, got {cell.dtype}"

    def is_nested_col(self, col_index: int):
        return type(self.col_types[col_index]) == DList

    def add_row(self, row):
        if not isinstance(row, Row):
            row = Row([Cell(value) for value in row])
        self._check_row_corresponse_with_header(row)
        self.rows.append(row)
        return self.rows
    
    def add_rows(self, rows):
        return [self.add_row(row) for row in rows]

    def dump_json(self):
        return {"name": self.name, "headers": self.headers, "col_types": [col_type.dump_json() for col_type in self.col_types], "rows": [row.dump_json() for row in self.rows], "allow_null": self.allow_null}
    
    @staticmethod
    def load_json(json_obj):
        return TableExcerpt(json_obj["headers"], [DType.load_json(col_type) for col_type in json_obj["col_types"]], table_name=json_obj["name"], rows=[Row.load_json(row) for row in json_obj["rows"]], allow_null=json_obj["allow_null"])
    
    
if __name__ == "__main__":
    from src.table_excerpt.examples.car_table import car_table
    stop = 1