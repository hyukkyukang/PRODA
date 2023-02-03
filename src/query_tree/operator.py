import abc
from typing import Any, List


class Operation(metaclass=abc.ABCMeta):
    def __init__(self, column_id: int):
        self.column_id: int = column_id


class Projection(Operation):
    def __init__(self, column_id: int, alias: str = None):
        super(Projection, self).__init__(column_id)
        self.alias: str = alias


class Aggregation(Operation):
    def __init__(self, column_id: int, func_type: str):
        super(Aggregation, self).__init__(column_id)
        self.func_type: str = func_type


class Condition:
    def __init__(self, l_operand: Any, operator: str, r_operand: Any):
        """
        We distinguish different kinds of expressions using the types of two operands.
        Possible types for l_operand can be one of the following:
            - int: to express column id
        Possible types for r_operand can be one of the following:
            - int: to express column id
            - str: to express values (including number. e.g. "1")
        """
        self.l_operand: Any = l_operand
        self.operator: str = operator
        self.r_operand: Any = r_operand


class Clause:
    def __init__(self, conditions: List[Condition]):
        self.conditions = conditions


class Selection(Operation):
    def __init__(self, clauses: List[Clause]):
        """We assume that the predicate follows Disjunctive Normal Form."""
        super(Selection, self).__init__(-1)
        self.clauses: List[Clause] = clauses


class Grouping(Operation):
    def __init__(self, *args, **kwargs):
        super(Grouping, self).__init__(*args, **kwargs)


class Ordering(Operation):
    def __init__(self, column_id: int, ascending: bool = True):
        super(Ordering, self).__init__(column_id)
        self.ascending: bool = ascending


class Foreach(Operation):
    def __init__(self, *args, **kwargs):
        super(Foreach, self).__init__(*args, **kwargs)


class Limit(Operation):
    def __init__(self, number: int):
        super(Limit, self).__init__(-1)
        self.number: int = number
