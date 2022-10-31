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
    def __init__(self, name, headers, col_types, rows=None, base_table_names=None):
        self.name = name
        self.headers: List[str] = headers
        self.col_types: List[DType] = list(map(TableExcerpt._to_dtype, col_types))
        self.rows: Optional[Union[Row, List[str]]] = []
        self.base_table_names: List[str] = base_table_names if base_table_names else \
                                            [name for _ in range(len(headers))]
        self.add_rows(rows)

    @staticmethod
    def concatenate(new_table_name, base_table, new_table):
        def retrieve_col_items(rows, col_id, list_num):
            tmp = [row[col_id].value for row in rows]
            if list_num == 1:
                return tmp
            return [tmp for _ in range(list_num)]
            
        """ Cartesian product of two tables """
        new_headers = base_table.headers + new_table.headers
        new_col_types = base_table.col_types + [DList(col_type) for col_type in new_table.col_types]
        base_table_names = base_table.base_table_names + new_table.base_table_names

        # Find column with most grouping layer
        max_recursive_list_num = max([str(col_type).count("DList") for col_type in new_col_types])

        # Create lists of column items
        columns_to_concatenate = [Cell(retrieve_col_items(new_table.rows, col_id, max_recursive_list_num)) for col_id in range(len(new_table.headers))]
        new_rows =  [Row(row.cells + columns_to_concatenate) for row in base_table.rows]
        return TableExcerpt(new_table_name, new_headers, new_col_types, rows=new_rows, base_table_names=base_table_names)
            

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
        elif type_name in ["str", "string"]:
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
        assert len(row) == len(self.headers), f"Row length must be equal to header length, got {len(row)} and {len(self.headers)}"
        # Check data types
        for i, (cell, col_type) in enumerate(zip(row, self.col_types)):
            if cell.is_null:
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
        return {"name": self.name, "headers": self.headers, "col_types": [col_type.dump_json() for col_type in self.col_types], "rows": [row.dump_json() for row in self.rows], "base_table_names": self.base_table_names}
    
    @staticmethod
    def load_json(json_obj):
        return TableExcerpt(json_obj["name"], json_obj["headers"], [DType.load_json(col_type) for col_type in json_obj["col_types"]], rows=[Row.load_json(row) for row in json_obj["rows"]], base_table_names=json_obj["base_table_names"])
    
    
if __name__ == "__main__":
    from src.table_excerpt.examples.car_table import car_table
    stop = 1