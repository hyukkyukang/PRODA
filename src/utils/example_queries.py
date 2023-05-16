import abc
import argparse
import json
from typing import List
from hkkang_utils import misc as misc_utils
from src.pylogos.query_graph.koutrika_query_graph import (
    Attribute,
    Function,
    FunctionType,
    OperatorType,
    Query_graph,
    Relation,
    Value,
)

import src.query_tree.operator as qt_operator
from src.query_tree.operator import Aggregation, Clause, Condition, Foreach, Projection, Selection
from src.query_tree.query_tree import Attach, BaseTable, QueryBlock, QueryTree, Refer, get_global_index
from src.table_excerpt.table_excerpt import TableExcerpt
from src.utils.example_table_excerpt import car_table, movie_table, director_table, direction_table, rating_table
from src.VQA.EVQA import Aggregator, Clause, EVQANode, EVQATree, Grouping, Header, Operator, Ordering, Selecting


def find_nth_occurrence_index(lst, item, n):
    """Find the nth occurrence of an item in a list"""
    index = -1
    for i in range(n):
        index = lst.index(item, index + 1)
    return index


class TestQuery(metaclass=abc.ABCMeta):
    def __init__(self):
        self._query_tree = None
        self._evqa = None
        self._sql = None

    @property
    def sql(self):
        return self._sql

    @property
    @abc.abstractmethod
    def evqa(self) -> EVQATree:
        pass

    @property
    @abc.abstractmethod
    def query_tree(self):
        pass


class ProjectionQuery(TestQuery):
    def __init__(self):
        super(ProjectionQuery, self).__init__()
        self._sql = "SELECT id FROM cars"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node
        node = EVQANode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(car_table.table_excerpt_headers.index("id")))
        # Construct tree
        return EVQATree(node)

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        baseTable = BaseTable(car_table.headers, car_table.rows)
        # Create node
        tables = [baseTable]
        node = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), tables)),
            operations=[Projection(get_global_index(tables, 0, "id"))],
            sql=self.sql,
        )
        # Construct tree
        return QueryTree(root=node, sql=self.sql)


class MinMaxQuery(TestQuery):
    def __init__(self):
        super(MinMaxQuery, self).__init__()
        self._sql = "SELECT max(horsepower), min(max_speed) FROM cars"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node
        node = EVQANode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("horsepower"), agg_type=Aggregator.max))
        node.add_projection(Header(node.headers.index("max_speed"), agg_type=Aggregator.min))
        # Construct tree
        return EVQATree(node)

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        base_tables = [BaseTable(car_table.headers, car_table.rows)]
        # Create node
        node = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            operations=[
                Projection(get_global_index(base_tables, 0, "horsepower")),
                Projection(get_global_index(base_tables, 0, "max_speed")),
                Aggregation(get_global_index(base_tables, 0, "horsepower"), "max"),
                Aggregation(get_global_index(base_tables, 0, "max_speed"), "min"),
            ],
            sql=self.sql,
        )
        return QueryTree(root=node, sql=self.sql)


class CountAvgSumQuery(TestQuery):
    def __init__(self):
        super(CountAvgSumQuery, self).__init__()
        self._sql = "SELECT count(id), avg(max_speed), sum(price) FROM cars"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node
        node = EVQANode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("id"), agg_type=Aggregator.count))
        node.add_projection(Header(node.headers.index("max_speed"), agg_type=Aggregator.avg))
        node.add_projection(Header(node.headers.index("price"), agg_type=Aggregator.sum))
        # Construct tree
        return EVQATree(node)

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        base_tables = [BaseTable(car_table.headers, car_table.rows)]
        # Create node
        node = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            operations=[
                Projection(get_global_index(base_tables, 0, "id")),
                Projection(get_global_index(base_tables, 0, "max_speed")),
                Projection(get_global_index(base_tables, 0, "price")),
                Aggregation(get_global_index(base_tables, 0, "id"), "count"),
                Aggregation(get_global_index(base_tables, 0, "max_speed"), "avg"),
                Aggregation(get_global_index(base_tables, 0, "price"), "sum"),
            ],
            sql=self.sql,
        )
        return QueryTree(root=node, sql=self.sql)


class SelectionQuery(TestQuery):
    def __init__(self):
        super(SelectionQuery, self).__init__()
        self._sql = "SELECT id FROM cars WHERE year = 2010"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node
        node = EVQANode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("id")))
        # Create conditions for the node
        clause = Clause([Selecting(node.headers.index("year"), Operator.equal, "2010")])
        node.add_predicate(clause)
        # Construct tree
        return EVQATree(node)

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        base_tables = [BaseTable(car_table.headers, car_table.rows)]
        # Create node
        node = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            operations=[
                Projection(get_global_index(base_tables, 0, "id")),
                Selection(
                    clauses=[
                        Clause(
                            conditions=[
                                Condition(
                                    l_operand=get_global_index(base_tables, 0, "year"),
                                    operator="=",
                                    r_operand="2010",
                                )
                            ]
                        )
                    ]
                ),
            ],
            sql=self.sql,
        )
        return QueryTree(root=node, sql=self.sql)


class AndOrQuery(TestQuery):
    def __init__(self):
        super(AndOrQuery, self).__init__()
        self._sql = "SELECT id, price FROM cars WHERE (model = 'tesla model x' and year = 2011) or (model = 'tesla model x' and year = 2012)"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node
        node = EVQANode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("id")))
        node.add_projection(Header(node.headers.index("price")))
        # Create conditions for the node
        # Condition1 (first clause of DNF)
        cond1_1 = Selecting(node.headers.index("model"), Operator.equal, "tesla model x")
        cond1_2 = Selecting(node.headers.index("year"), Operator.equal, "2011")
        clause1 = Clause([cond1_1, cond1_2])
        # Condition2 (second clause of DNF)
        cond2_1 = Selecting(node.headers.index("model"), Operator.equal, "tesla model x")
        cond2_2 = Selecting(node.headers.index("year"), Operator.equal, "2012")
        clause2 = Clause([cond2_1, cond2_2])
        # Add all conditions to the node
        node.add_predicate(clause1)
        node.add_predicate(clause2)
        # Construct tree
        return EVQATree(node)

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        base_tables = [BaseTable(car_table.headers, car_table.rows)]
        # Create node
        node = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            operations=[
                Projection(get_global_index(base_tables, 0, "id")),
                Projection(get_global_index(base_tables, 0, "price")),
                Selection(
                    clauses=[
                        Clause(
                            conditions=[
                                Condition(
                                    l_operand=get_global_index(base_tables, 0, "model"),
                                    operator="=",
                                    r_operand="tesla model x",
                                ),
                                Condition(
                                    l_operand=get_global_index(base_tables, 0, "year"),
                                    operator="=",
                                    r_operand="2011",
                                ),
                            ]
                        ),
                        Clause(
                            conditions=[
                                Condition(
                                    l_operand=get_global_index(base_tables, 0, "model"),
                                    operator="=",
                                    r_operand="tesla model x",
                                ),
                                Condition(
                                    l_operand=get_global_index(base_tables, 0, "year"),
                                    operator="=",
                                    r_operand="2012",
                                ),
                            ]
                        ),
                    ]
                ),
            ],
        )
        return QueryTree(root=node, sql=self.sql)


class SelectionQueryWithOr(TestQuery):
    def __init__(self):
        super(SelectionQueryWithOr, self).__init__()
        self._sql = "SELECT id FROM cars WHERE (max_speed > 2000) OR (year = 2010)"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node
        node = EVQANode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("id")))
        # Create conditions for the node
        clause1 = Clause(
            [
                Selecting(
                    node.headers.index("max_speed"),
                    Operator.greaterThan,
                    "2000",
                )
            ]
        )
        clause2 = Clause([Selecting(node.headers.index("year"), Operator.equal, "2010")])
        node.add_predicate(clause1)
        node.add_predicate(clause2)
        # Construct tree
        return EVQATree(node)

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        base_tables = [BaseTable(car_table.headers, car_table.rows)]
        # Create node
        node = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            operations=[
                Projection(get_global_index(base_tables, 0, "id")),
                Selection(
                    clauses=[
                        Clause(
                            Conditions=[
                                Condition(
                                    l_operand=get_global_index(base_tables, 0, "max_speed"),
                                    operator=">",
                                    r_operand="2000",
                                )
                            ]
                        ),
                        Clause(
                            Conditions=[
                                Condition(
                                    l_operand=get_global_index(base_tables, 0, "year"), opeartor="=", r_operand="2010"
                                )
                            ]
                        ),
                    ]
                ),
            ],
        )
        return QueryTree(root=node, sql=self.sql)


class SelectionQueryWithAnd(TestQuery):
    def __init__(self):
        super(SelectionQueryWithAnd, self).__init__()
        self._sql = "SELECT id FROM cars WHERE max_speed > 2000 AND year = 2010"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node
        node = EVQANode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("id")))
        # Create conditions for the node
        cond1 = Selecting(node.headers.index("max_speed"), Operator.greaterThan, "2000")
        cond2 = Selecting(node.headers.index("year"), Operator.equal, "2010")
        clause = Clause([cond1, cond2])
        node.add_predicate(clause)
        return EVQATree(node)

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        # Create node
        base_tables = [BaseTable(car_table.headers, car_table.rows)]
        node = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            operations=[
                Projection(get_global_index(base_tables, 0, "id")),
                Selection(
                    clauses=[
                        Clause(
                            conditions=[
                                Condition(
                                    l_operand=get_global_index(base_tables, 0, "max_speed"),
                                    operator=">",
                                    r_operand="2000",
                                ),
                                Condition(
                                    l_operand=get_global_index(base_tables, 0, "year"), operator="=", r_operand="2010"
                                ),
                            ]
                        )
                    ]
                ),
            ],
        )
        return QueryTree(root=node, sql=self.sql)


class OrderByQuery(TestQuery):
    def __init__(self):
        super(OrderByQuery, self).__init__()
        self._sql = "SELECT id FROM cars WHERE year = 2010 ORDER BY horsepower DESC"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node
        node = EVQANode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("id")))
        # Create conditions for the node
        cond1 = Selecting(node.headers.index("year"), Operator.equal, "2010")
        cond2 = Ordering(node.headers.index("horsepower"), is_ascending=False)
        clause = Clause([cond1, cond2])
        node.add_predicate(clause)
        return EVQATree(node)

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        base_tables = [BaseTable(car_table.headers, car_table.rows)]
        # Create node
        node = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            operations=[
                Projection(get_global_index(base_tables, 0, "id")),
                Selection(
                    clauses=[Clause(conditions=[Condition(get_global_index(base_tables, 0, "year"), "=", "2010")])]
                ),
                qt_operator.Ordering(get_global_index(base_tables, 0, "horsepower"), ascending=False),
            ],
        )
        return QueryTree(root=node, sql=self.sql)


class GroupByQuery(TestQuery):
    def __init__(self):
        super(GroupByQuery, self).__init__()
        self._sql = "SELECT count(*), model FROM cars GROUP BY model"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node
        node = EVQANode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("cars"), agg_type=Aggregator.count))
        node.add_projection(Header(node.headers.index("model")))
        # Create conditions for the node
        cond = Grouping(node.headers.index("model"))
        clause = Clause([cond])
        node.add_predicate(clause)
        return EVQATree(node)

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        base_tables = [BaseTable(car_table.headers, car_table.rows)]
        # Create node
        node = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            operations=[
                Projection(get_global_index(base_tables, 0, "*")),
                Projection(get_global_index(base_tables, 0, "model")),
                Aggregation(get_global_index(base_tables, 0, "*"), "count"),
                qt_operator.Grouping(get_global_index(base_tables, 0, "model")),
            ],
        )
        return QueryTree(root=node, sql=self.sql)


class HavingQuery(TestQuery):
    def __init__(self):
        super(HavingQuery, self).__init__()
        self._sql = "SELECT model FROM cars GROUP BY model HAVING AVG(max_speed) > 400"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node 1
        node_1 = EVQANode(f"{car_table.name}_query", car_table)
        node_1.add_projection(Header(node_1.headers.index("model")))
        node_1.add_projection(Header(node_1.headers.index("max_speed"), agg_type=Aggregator.avg))
        # Create conditions for the node
        cond1_2 = Grouping(node_1.headers.index("model"))
        clause = Clause([cond1_2])
        node_1.add_predicate(clause)

        # Query Result
        result_headers = ["model", "max_speed"]
        result_col_types = ["string", "number"]
        result_rows = [
            ["ford", 230],
            ["cherlet", 330],
            ["toyota", 430],
            ["volkswage", 530],
            ["amc", 630],
            ["pontiac", 730],
            ["datsun", 830],
            ["hyundai", (930 + 940) / 2],
            ["kia", 1030],
            ["genesis", (1130 + 1140) / 2],
        ]
        result_table = TableExcerpt("cars2", result_headers, result_col_types, rows=result_rows)

        # Next Table Excerpt
        new_car_headers = result_headers
        new_col_types = result_col_types
        new_rows = result_rows
        new_table_excerpt = TableExcerpt("cars", new_car_headers, new_col_types, rows=new_rows)

        # Create tree node 2
        # TODO: Need to discuss about how to name variables from previous step
        node_2 = EVQANode(f"{new_table_excerpt.name}_query", new_table_excerpt)
        node_2.add_projection(Header(node_2.headers.index("model")))

        cond2 = Selecting(
            find_nth_occurrence_index(node_2.headers, "max_speed", 1),
            Operator.greaterThan,
            "400",
        )
        node_2.add_predicate(Clause([cond2]))
        return EVQATree(node_2, children=[EVQATree(node_1)])

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        base_tables = [BaseTable(car_table.headers, car_table.rows)]
        # Create node1
        node1 = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            operations=[
                Projection(get_global_index(base_tables, 0, "model")),
                Projection(get_global_index(base_tables, 0, "max_speed"), "max_speed"),
                Aggregation(get_global_index(base_tables, 0, "max_speed"), "avg"),
                qt_operator.Grouping(get_global_index(base_tables, 0, "model")),
            ],
        )
        # Create node2
        node2_tables = [node1]
        node2 = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), node2_tables)),
            operations=[
                Projection(get_global_index(node2_tables, 0, "model")),
                Selection(
                    clauses=[Clause(conditions=[Condition(get_global_index(node2_tables, 0, "max_speed"), ">", "400")])]
                ),
            ],
        )
        return QueryTree(root=node2, sql=self.sql)


class NestedQuery(TestQuery):
    def __init__(self):
        super(NestedQuery, self).__init__()
        self._sql = "SELECT id FROM cars WHERE max_speed > (SELECT AVG(max_speed) FROM cars WHERE year = 2010)"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node 1
        node_1 = EVQANode(f"{car_table.name}_query", car_table)
        node_1.add_projection(Header(node_1.headers.index("max_speed"), agg_type=Aggregator.avg))
        # Create conditions for the node
        cond1_1 = Selecting(node_1.headers.index("year"), Operator.equal, "2010")
        node_1.add_predicate(Clause([cond1_1]))

        # Query Result
        result_headers = ["avg_max_speed"]
        result_col_types = ["number"]
        result_rows = [[280]]
        result_table = TableExcerpt(node_1.name, result_headers, result_col_types, rows=result_rows)

        # New table excerpt
        new_table_excerpt = TableExcerpt.concatenate("cars3", car_table, result_table)

        # Create tree node 2
        node_2 = EVQANode(f"{new_table_excerpt.name}_query", new_table_excerpt)
        node_2.add_projection(Header(node_2.headers.index("id")))
        cond2 = Selecting(
            find_nth_occurrence_index(node_2.headers, "max_speed", 1),
            Operator.greaterThan,
            Operator.add_idx_prefix(node_2.headers.index("avg_max_speed")),
        )
        node_2.add_predicate(Clause([cond2]))
        return EVQATree(node_2, children=[EVQATree(node_1)])

    @misc_utils.property_with_cache
    def query_tree(self):
        # Create base table
        base_tables = [BaseTable(car_table.headers, car_table.rows)]

        # Create node
        node1 = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            operations=[
                Projection(get_global_index(base_tables, 0, "max_speed"), "avg_max_speed"),
                Aggregation(get_global_index(base_tables, 0, "max_speed"), "avg"),
                Selection(
                    clauses=[Clause(conditions=[Condition(get_global_index(base_tables, 0, "year"), "=", "2010")])]
                ),
            ],
        )

        # Get base table
        node2_tables = base_tables + [node1]
        node2 = QueryBlock(
            child_tables=list(map(lambda t: Attach(t), node2_tables)),
            operations=[
                Projection(get_global_index(node2_tables, 0, "id")),
                Selection(
                    clauses=[
                        Clause(
                            conditions=[
                                Condition(
                                    get_global_index(node2_tables, 0, "max_speed"),
                                    ">",
                                    get_global_index(node2_tables, 1, "avg_max_speed"),
                                )
                            ]
                        )
                    ]
                ),
            ],
        )

        return QueryTree(root=node2, sql=self.sql)


class CorrelatedNestedQuery(TestQuery):
    def __init__(self):
        super(CorrelatedNestedQuery, self).__init__()
        self._sql = "SELECT T2.id FROM cars AS T2 WHERE T2.max_speed > (SELECT avg(T1.max_speed) FROM cars AS T1 WHERE T1.model = T2.model)"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node 1
        mapping1 = [
            (0, car_table.headers.index("max_speed") + 1, "max_speed"),
            (1, car_table.headers.index("model") + 1, "model"),
        ]
        node_1 = EVQANode(
            f"{car_table.name}_query", car_table, "SELECT avg(max_speed) FROM cars GROUP BY model", mapping=mapping1
        )
        node_1.add_projection(Header(node_1.headers.index("max_speed"), agg_type=Aggregator.avg))
        cond1 = Grouping(node_1.headers.index("model"))
        node_1.add_predicate(Clause([cond1]))

        # Query Result w/o concatenation
        result_headers = ["model", "avg_max_speed"]
        result_col_types = [
            TableExcerpt._str_to_dtype("string"),
            TableExcerpt._str_to_dtype("number"),
        ]
        result_rows = [
            ["ford", 230],
            ["cherlet", 330],
            ["toyota", 430],
            ["volkswage", 530],
            ["amc", 630],
            ["pontiac", 730],
            ["datsun", 830],
            ["hyundai", 935],
            ["kia", 1030],
            ["genesis", 1135],
        ]
        result_table = TableExcerpt(
            node_1.name,
            result_headers,
            result_col_types,
            rows=result_rows,
        )

        # Query Result
        new_car_table = TableExcerpt.concatenate("cars2", car_table, result_table)

        # Create tree node 2
        mapping2 = [
            (0, new_car_table.headers.index("id") + 1, "id"),
            (1, new_car_table.headers.index("model") + 1, "model"),
            (1, new_car_table.headers.index("model") + 1, "model"),
            (1, new_car_table.headers.index("max_speed") + 1, "max_speed"),
            (1, new_car_table.headers.index("max_speed") + 1, "avg_max_speed"),
        ]
        node_2 = EVQANode(f"{new_car_table.name}_query", new_car_table, self.sql, mapping=mapping2)
        node_2.add_projection(Header(node_2.headers.index("id")))
        # Create conditions for the node
        cond2_1 = Selecting(
            node_2.headers.index("max_speed"),
            Operator.greaterThan,
            Operator.add_idx_prefix(node_2.headers.index("avg_max_speed")),
        )
        cond2_2 = Selecting(
            find_nth_occurrence_index(node_2.headers, "model", 1),
            Operator.equal,
            Operator.add_idx_prefix(find_nth_occurrence_index(node_2.headers, "model", 2)),
        )
        node_2.add_predicate(Clause([cond2_1, cond2_2]))

        return EVQATree(node_2, children=[EVQATree(node_1)])

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base table
        base_table1 = BaseTable(car_table.headers, car_table.rows)
        base_table2 = BaseTable(car_table.headers, car_table.rows)

        # Get node 1
        base_tables = [base_table1, base_table2]
        node1 = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            join_conditions=[
                Selection(
                    clauses=[
                        Clause(
                            conditions=[
                                Condition(
                                    get_global_index(base_tables, 0, "model"),
                                    "=",
                                    get_global_index(base_tables, 1, "model"),
                                )
                            ]
                        )
                    ]
                )
            ],
            operations=[
                Projection(get_global_index(base_tables, 0, "max_speed"), "avg_max_speed"),
                Aggregation(get_global_index(base_tables, 0, "max_speed"), "avg"),
                Foreach(get_global_index(base_tables, 0, "model")),
            ],
        )

        # Get node2
        node2_tables = [base_table1, node1]
        node2 = QueryBlock(
            child_tables=list(map(lambda t: Attach(t), node2_tables)),
            operations=[
                Projection(get_global_index(node2_tables, 0, "id")),
                Selection(
                    clauses=[
                        Clause(
                            conditions=[
                                Condition(
                                    get_global_index(node2_tables, 0, "max_speed"),
                                    ">",
                                    get_global_index(node2_tables, 1, "avg_max_speed"),
                                )
                            ]
                        )
                    ]
                ),
            ],
        )
        return QueryTree(root=node2, sql=self.sql)

    @misc_utils.property_with_cache
    def query_graphs(self) -> List[Query_graph]:
        def graph_1() -> Query_graph:
            ## Initialize nodes
            # Relation
            cars = Relation("cars", "cars")
            # Attribute
            max_speed = Attribute("max_speed", "max_speed")
            model = Attribute("model", "model")
            # Function
            avg = Function(FunctionType.Avg)
            ## Construct graph
            query_graph = Query_graph("CorrelatedNestedQuery_subgraph")
            query_graph.connect_membership(cars, max_speed)
            query_graph.connect_transformation(avg, max_speed)
            query_graph.connect_grouping(cars, model)
            return query_graph

        def graph_2() -> Query_graph:
            ## Initialize nodes
            # Relation
            cars_1 = Relation("cars", "cars")
            cars_2 = Relation("cars_t2", "cars", is_primary=True)
            # Attribute
            cars_id = Attribute("id", "id")
            cars_max_speed_t1 = Attribute("max_speed", "max_speed")
            cars_max_speed_t2 = Attribute("avg_max_speed", "max_speed")
            cars_model_t1 = Attribute("model", "model")
            cars_model_t2 = Attribute("g_model", "model")
            # Function
            avg = Function(FunctionType.Avg)

            ## Construct graph
            query_graph = Query_graph("CorrelatedNestedQuery")
            query_graph.connect_membership(cars_2, cars_id)
            # Nesting
            query_graph.connect_selection(cars_2, cars_max_speed_t2)
            query_graph.connect_predicate(cars_max_speed_t2, avg, OperatorType.GreaterThan)
            query_graph.connect_transformation(avg, cars_max_speed_t1)
            query_graph.connect_membership(cars_1, cars_max_speed_t1)
            # Correlation condition
            query_graph.connect_selection(cars_1, cars_model_t1)
            query_graph.connect_predicate(cars_model_t1, cars_model_t2, OperatorType.Equal)
            # Correlation back to the outer query
            query_graph.connect_selection(cars_model_t2, cars_2)
            return query_graph

        return [graph_2(), graph_1()]


class CorrelatedNestedQuery2(TestQuery):
    def __init__(self):
        super(CorrelatedNestedQuery2, self).__init__()
        self._sql = "SELECT T2.id FROM cars AS T2 WHERE T2.max_speed > (SELECT avg(T1.max_speed) FROM cars AS T1 WHERE T1.model = T2.model) GROUP BY T2.model HAVING AVG(T2.max_speed) > 300"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node 1
        node_1 = EVQANode(f"{car_table.name}_query", car_table)
        node_1.add_projection(Header(node_1.headers.index("max_speed"), agg_type=Aggregator.avg))
        # Create conditions for the node
        cond1_1 = Grouping(node_1.headers.index("model"))
        node_1.add_predicate(Clause([cond1_1]))

        # Query Result
        result_headers = ["model"] + ["max_speed"]
        result_col_types = [
            TableExcerpt._str_to_dtype("string"),
            TableExcerpt._str_to_dtype("float"),
        ]
        result_rows = [
            ["ford", 230],
            ["cherlet", 330],
            ["toyota", 430],
            ["volkswage", 530],
            ["amc", 630],
            ["pontiac", 730],
            ["datsun", 830],
            ["hyundai", 935],
            ["kia", 1030],
            ["genesis", 1135],
        ]
        result_table = TableExcerpt(node_1.name, result_headers, result_col_types, rows=result_rows)

        # Create tree node 2
        new_table_excerpt = TableExcerpt.concatenate("cars2", car_table, result_table)
        node_2 = EVQANode(f"{new_table_excerpt.name}_query", new_table_excerpt)
        node_2.add_projection(Header(node_2.headers.index("id")))
        node_2.add_projection(Header(node_2.headers.index("max_speed"), agg_type=Aggregator.avg))
        # Create conditions for the node
        cond2_1 = Selecting(
            node_2.headers.index("max_speed"),
            Operator.greaterThan,
            Operator.add_idx_prefix(find_nth_occurrence_index(node_2.headers, "max_speed", 2)),
        )
        cond2_2 = Selecting(
            node_2.headers.index("model"),
            Operator.equal,
            Operator.add_idx_prefix(find_nth_occurrence_index(node_2.headers, "model", 2)),
        )
        cond2_3 = Grouping(node_1.headers.index("model"))
        node_2.add_predicate(Clause([cond2_1, cond2_2, cond2_3]))

        # Query Result
        result_headers_2 = ["id", "max_speed"]
        result_col_types_2 = [
            TableExcerpt._str_to_dtype("int"),
            TableExcerpt._str_to_dtype("float"),
        ]
        result_rows_2 = [[1, 350]]
        result_table_2 = TableExcerpt(node_2.name, result_headers_2, result_col_types_2, rows=result_rows_2)

        # Create tree node 3
        node_3 = EVQANode(f"{result_table_2.name}_query", result_table_2)
        node_3.add_projection(Header(node_3.headers.index("id")))
        # Create conditions for the node
        cond3 = Selecting(node_3.headers.index("max_speed"), Operator.greaterThan, "300")
        node_3.add_predicate(Clause([cond3]))
        return EVQATree(node_3, children=[EVQATree(node_2, children=[EVQATree(node_1)])])

    @misc_utils.property_with_cache
    def query_tree(self):
        pass


class MultipleSublinksQuery(TestQuery):
    def __init__(self):
        super(MultipleSublinksQuery, self).__init__()
        self._sql = "SELECT id FROM cars WHERE max_speed > (SELECT avg(max_speed) FROM cars WHERE model = 'hyundai') AND horsepower > (SELECT avg(horsepower) FROM cars WHERE model = 'genesis')"

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node 1
        node_1 = EVQANode(f"{car_table}_query1", car_table)
        node_1.add_projection(Header(node_1.headers.index("max_speed"), agg_type=Aggregator.avg))
        # Create conditions for the node
        cond1 = Selecting(node_1.headers.index("model"), Operator.equal, "hyundai")
        node_1.add_predicate(Clause([cond1]))

        # Query result 1
        result_headers = ["max_speed"]
        result_col_types = [TableExcerpt._str_to_dtype("float")]
        result_rows = [[935]]
        result_table1 = TableExcerpt(node_1.name, result_headers, result_col_types, rows=result_rows)

        # Create tree node 2
        node_2 = EVQANode(f"{car_table}_query2", car_table)
        node_2.add_projection(Header(node_2.headers.index("horsepower"), agg_type=Aggregator.avg))
        # Create conditions for the node
        cond2 = Selecting(node_2.headers.index("model"), Operator.equal, "genesis")
        node_2.add_predicate(Clause([cond2]))

        # Query Result 2
        result_headers = ["horsepower"]
        result_col_types = [TableExcerpt._str_to_dtype("float")]
        result_rows = [[10.5]]
        result_table2 = TableExcerpt(node_2.name, result_headers, result_col_types, rows=result_rows)

        new_car_table1 = TableExcerpt.concatenate("cars2", car_table, result_table1)
        new_car_table2 = TableExcerpt.concatenate("cars3", new_car_table1, result_table2)

        # Create tree node 3
        node_3 = EVQANode(f"{new_car_table2.name}_query", new_car_table2)
        node_3.add_projection(Header(node_3.headers.index("id")))
        # Create conditions for the node
        cond3_1 = Selecting(
            node_3.headers.index("max_speed"),
            Operator.greaterThan,
            Operator.add_idx_prefix(find_nth_occurrence_index(node_3.headers, "max_speed", 2)),
        )
        cond3_2 = Selecting(
            node_3.headers.index("horsepower"),
            Operator.greaterThan,
            Operator.add_idx_prefix(find_nth_occurrence_index(node_3.headers, "horsepower", 2)),
        )
        node_3.add_predicate(Clause([cond3_1, cond3_2]))
        return EVQATree(node_3, children=[EVQATree(node_2), EVQATree(node_1)])

    @misc_utils.property_with_cache
    def query_tree(self):
        pass


class MultipleSublinksQuery2(TestQuery):
    def __init__(self):
        super(MultipleSublinksQuery2, self).__init__()
        self._sql = """SELECT M1.id
                        FROM movie AS M1
                            JOIN rating AS R1
                            ON M1.id = R1.mov_id
                        WHERE R1.stars < (SELECT Max(R2.stars)
                                          FROM movie AS M2
                                                JOIN rating AS R2
                                                ON M2.id = R2.mov_id
                                          WHERE M2.id = M1.id)
                        AND M1.id IN (SELECT M3.id
                                      FROM movie AS M3
                                            JOIN direction AS MD
                                            ON M3.id = MD.mov_id
                                            JOIN director AS D
                                            ON MD.dir_id = D.id
                                      WHERE D.first_name = 'Spielberg'
                                        AND D.last_name = 'Steven')
                        GROUP BY M1.id
                        HAVING Avg(R1.stars) >= 3
                    """

    @misc_utils.property_with_cache
    def evqa(self) -> EVQATree:
        # Create tree node 1
        init_table1 = TableExcerpt.fake_join("movie_rating", [movie_table, rating_table])

        mapping1 = [
            (0, init_table1.headers.index("id"), "id"),
            (0, init_table1.headers.index("stars"), "stars"),
            (1, init_table1.headers.index("id"), "id"),
        ]

        node_1 = EVQANode(f"query1", init_table1, mapping=mapping1)
        node_1.add_projection(Header(node_1.headers.index("id"), alias="m_id"))
        node_1.add_projection(Header(node_1.headers.index("stars"), agg_type=Aggregator.max, alias="max_stars"))
        node_1.add_predicate(Clause([Grouping(node_1.headers.index("id"))]))
        # Query result
        node_1_result_headers = ["m_id", "max_stars"]
        node_1_result_col_types = ["number", "number"]
        node_1_result_rows = [[1, 1.1], [2, 2.2]]
        node_1_result = TableExcerpt(
            f"{node_1.name}_result", node_1_result_headers, node_1_result_col_types, rows=node_1_result_rows
        )

        # Create tree node 2
        init_table2 = TableExcerpt.fake_join("block2", [movie_table, direction_table, director_table])

        mapping2 = [
            (0, init_table2.headers.index("id"), "id"),
            (1, init_table2.headers.index("first_name"), "first_name"),
            (2, init_table2.headers.index("last_name"), "last_name"),
        ]

        node_2 = EVQANode(f"query2", init_table2, mapping=mapping2)
        node_2.add_projection(Header(node_2.headers.index("id"), alias="b2_m_id"))
        node_2.add_predicate(
            Clause(
                [
                    Selecting(node_2.headers.index("first_name"), Operator.equal, "Spielberg"),
                    Selecting(node_2.headers.index("last_name"), Operator.equal, "Steven"),
                ]
            )
        )
        node_2_result_headers = ["b2_m_id"]
        node_2_result_col_types = ["number"]
        node_2_result_rows = [[1], [2]]
        node_2_result = TableExcerpt(
            f"{node_2.name}_result", node_2_result_headers, node_2_result_col_types, rows=node_2_result_rows
        )

        # Create tree node 3
        init_table3 = TableExcerpt.fake_join("tmp", [movie_table, rating_table, node_2_result])
        init_table3 = TableExcerpt.concatenate("block3_table_excerpt", init_table3, node_1_result)

        mapping3 = [
            (0, init_table3.headers.index("id"), "id"),
            (0, init_table3.headers.index("stars"), "stars"),
            (1, init_table3.headers.index("id"), "id"),
            (1, init_table3.headers.index("stars"), "stars"),
        ]

        node_3 = EVQANode(f"query3", init_table3, mapping=mapping3)
        node_3.add_projection(Header(node_3.headers.index("id"), alias="id"))
        node_3.add_projection(Header(node_3.headers.index("stars"), agg_type=Aggregator.avg, alias="avg_stars"))
        node_3.add_predicate(
            Clause(
                [
                    Selecting(
                        node_3.headers.index("id"),
                        Operator.In,
                        Operator.add_idx_prefix(node_3.headers.index("b2_m_id")),
                    ),
                    Selecting(
                        node_3.headers.index("id"),
                        Operator.equal,
                        Operator.add_idx_prefix(node_3.headers.index("m_id")),
                    ),
                    Selecting(
                        node_3.headers.index("stars"),
                        Operator.lessThan,
                        Operator.add_idx_prefix(node_3.headers.index("max_stars")),
                    ),
                ]
            )
        )
        node_3_result_headers = ["id", "avg_stars"]
        node_3_result_col_types = ["number", "number"]
        node_3_result_rows = [[1, 1.1]]
        node_3_result = TableExcerpt(
            f"{node_3.name}_result", node_3_result_headers, node_3_result_col_types, rows=node_3_result_rows
        )

        # Create tree node 4
        mapping4 = [
            (0, node_3_result.headers.index("id"), "id"),
            (1, node_3_result.headers.index("avg_stars"), "avg_stars"),
        ]

        node_4 = EVQANode(f"query4", node_3_result, mapping=mapping4)
        node_4.add_projection(Header(node_4.headers.index("id"), alias="id"))
        node_4.add_predicate(Clause([Selecting(node_4.headers.index("avg_stars"), Operator.greaterThanOrEqual, 3)]))

        return EVQATree(node_4, children=[EVQATree(node_3, children=[EVQATree(node_2), EVQATree(node_1)])])

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        table_movie = BaseTable(["id"], [[]])
        table_rating = BaseTable(["mov_id", "stars"], [[]])
        table_direction = BaseTable(["mov_id", "dir_id"], [[]])
        table_director = BaseTable(["id", "first_name", "last_name"], [[]])

        # Create B1
        node_b1_tables = [table_movie, table_rating]
        node_b1 = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), node_b1_tables)),
            join_conditions=[
                Selection(
                    l_operand=get_global_index(node_b1_tables, 0, "id"),
                    operator="=",
                    r_operand=len(table_movie) + table_rating.index("mov_id"),
                )
            ],
            operations=[
                Projection(
                    column_id=get_global_index(node_b1_tables, 1, "stars"),
                    alias="max_stars",
                ),
                Projection(
                    column_id=get_global_index(node_b1_tables, 0, "id"),
                    alias="m_id",
                ),
                Aggregation(
                    column_id=get_global_index(node_b1_tables, 1, "stars"),
                    func_type="max",
                ),
                Foreach(column_id=get_global_index(node_b1_tables, 0, "id")),
            ],
            sql="""ForEACH M2.id as m_id 
                    (SELECT Max(R2.stars) as max_stars
                    FROM movie AS M2 JOIN rating AS R2 ON M2.id = R2.mov_id
                """,
        )
        # Create B2
        node_b2_tables = [table_movie, table_direction, table_director]
        node_b2 = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), node_b2_tables)),
            join_conditions=[
                Selection(
                    l_operand=get_global_index(node_b2_tables, 0, "id"),
                    operator="=",
                    r_operand=get_global_index(node_b2_tables, 1, "mov_id"),
                ),
                Selection(
                    l_operand=get_global_index(node_b2_tables, 1, "dir_id"),
                    operator="=",
                    r_operand=get_global_index(node_b2_tables, 2, "id"),
                ),
            ],
            operations=[
                Projection(column_id=get_global_index(node_b2_tables, 0, "id")),
                Selection(
                    l_operand=get_global_index(node_b2_tables, 2, "first_name"),
                    operator="=",
                    r_operand="Spielberg",
                ),
                Selection(
                    l_operand=get_global_index(node_b2_tables, 2, "last_name"),
                    operator="=",
                    r_operand="Steven",
                ),
            ],
            sql="""SELECT M3.id 
                    FROM movie AS M3 JOIN direction AS MD ON M3.id = MD.mov_id
                        JOIN director AS D ON MD.dir_id = D.id
                    WHERE D.first_name = 'Spielberg' AND D.last_name = 'Steven'
                """,
        )

        # Create B3
        node_b3_tables = [table_movie, table_rating, node_b1, node_b2]
        node_b3 = QueryBlock(
            child_tables=list(map(lambda t: Attach(t), node_b3_tables)),
            join_conditions=[
                Selection(
                    l_operand=get_global_index(node_b3_tables, 0, "id"),
                    operator="=",
                    r_operand=get_global_index(node_b3_tables, 1, "mov_id"),
                ),
                Selection(
                    l_operand=get_global_index(node_b3_tables, 0, "id"),
                    operator="=",
                    r_operand=get_global_index(node_b3_tables, 2, "m_id"),
                ),
            ],
            operations=[
                Projection(
                    column_id=get_global_index(node_b3_tables, 0, "id"),
                    alias="id",
                ),
                Projection(
                    column_id=get_global_index(node_b3_tables, 1, "stars"),
                    alias="avg_stars",
                ),
                Aggregation(
                    column_id=get_global_index(node_b3_tables, 1, "stars"),
                    func_type="avg",
                ),
                Selection(
                    l_operand=get_global_index(node_b3_tables, 0, "stars"),
                    operator="<",
                    r_operand=get_global_index(node_b3_tables, 2, "max_stars"),
                ),
                Selection(
                    l_operand=get_global_index(node_b3_tables, 0, "id"),
                    operator="IN",
                    r_operand=node_b2,
                ),
            ],
            sql="""SELECT M1.id as id, 
                        Avg(R1.stars) as avg_stars
                    FROM movie AS M1 
                        JOIN rating AS R1 on M1.id = R1.mov_id 
                        JOIN B1 ON B1.m_id = M1.id 
                        ATTACH B2 
                    WHERE R1.stars < B1.max_stars AND M1.id IN B2
                    GROUP BY M1.id
                """,
        )
        # Create B4
        node_b4_tables = [node_b3]
        node_b4 = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), node_b4_tables)),
            operations=[
                Selection(
                    l_operand=get_global_index(node_b4_tables, 0, "avg_stars"),
                    operator=">=",
                    r_operand=3,
                )
            ],
            sql="SELECT B3.id as id FROM B3 WHERE B3.avg_stars >= 3",
        )

        return QueryTree(node_b4, self.sql)

    @misc_utils.property_with_cache
    def query_graphs(self) -> List[Query_graph]:
        def graph_1() -> Query_graph:
            # Relation
            movie_2 = Relation("movie_t2", "movie", is_primary=True)
            rating_2 = Relation("rating_t2", "rating")

            # Attribute
            movie_2_id_1 = Attribute("m2_id_1", "id")
            movie_2_id_2 = Attribute("m2_id_2", "id")
            rating_2_stars = Attribute("r2_stars", "stars")

            # Function
            rating_max = Function(FunctionType.Max)

            ## Construct graph
            query_graph = Query_graph("CorrelatedNestedQuery1")
            query_graph.connect_membership(movie_2, movie_2_id_1)
            query_graph.connect_membership(rating_2, rating_2_stars)
            query_graph.connect_transformation(rating_2_stars, rating_max)
            query_graph.connect_simplified_join(rating_2, movie_2, "belongs to", "")

            # Prepare Correlation
            query_graph.connect_grouping(movie_2, movie_2_id_2)

            return query_graph

        def graph_2() -> Query_graph:
            # Relation
            movie_3 = Relation("movie_t3", "movie", is_primary=True)
            direction = Relation("direction", "direction")
            director = Relation("director", "director")

            # Attribute
            movie_3_id = Attribute("m3_id", "id")
            director_last_name = Attribute("last_name", "last_name")
            director_first_name = Attribute("first_name", "first_name")

            # Values
            v_first_name = Value("spielbverg", "spielbverg")
            v_last_name = Value("steven", "steven")

            ## Construct graph
            query_graph = Query_graph("CorrelatedNestedQuery3")
            # Second Nesting
            query_graph.connect_membership(movie_3, movie_3_id)
            query_graph.connect_simplified_join(movie_3, direction)
            query_graph.connect_simplified_join(direction, director)
            query_graph.connect_selection(director, director_last_name)
            query_graph.connect_predicate(director_last_name, v_last_name)
            query_graph.connect_selection(director, director_first_name)
            query_graph.connect_predicate(director_first_name, v_first_name)

            return query_graph

        def graph_3() -> Query_graph:
            # Relation
            movie_1 = Relation("movie", "movie", is_primary=True)
            movie_2 = Relation("movie_t2", "movie")
            movie_3 = Relation("movie_t3", "movie")
            rating_1 = Relation("rating", "rating")
            rating_2 = Relation("rating_t2", "rating")
            direction = Relation("direction", "direction")
            director = Relation("director", "director")

            # Attribute
            movie_1_id1 = Attribute("m1_id1", "id")
            movie_1_id2 = Attribute("m1_id2", "id")
            movie_1_id3 = Attribute("m1_id3", "id")
            movie_1_id4 = Attribute("m1_id4", "id")

            movie_2_id = Attribute("m2_id", "id")
            movie_3_id = Attribute("m3_id", "id")

            rating_1_stars1 = Attribute("r1_stars1", "stars")
            rating_2_stars = Attribute("r2_stars", "stars")

            director_last_name = Attribute("last_name", "last_name")
            director_first_name = Attribute("first_name", "first_name")

            # Function
            rating_max = Function(FunctionType.Max)

            # Values
            v_first_name = Value("spielbverg", "spielbverg")
            v_last_name = Value("steven", "steven")

            ## Construct graph
            query_graph = Query_graph("CorrelatedNestedQuery3")
            query_graph.connect_membership(movie_1, movie_1_id1)
            query_graph.connect_simplified_join(movie_1, rating_1, "", "belongs to")

            # Nesting
            query_graph.connect_selection(rating_1, rating_1_stars1)
            query_graph.connect_predicate(rating_1_stars1, rating_max, OperatorType.LessThan)

            query_graph.connect_transformation(rating_max, rating_2_stars)
            query_graph.connect_membership(rating_2, rating_2_stars)
            query_graph.connect_simplified_join(rating_2, movie_2, "belongs to", "")

            # Correlation
            query_graph.connect_selection(movie_2, movie_2_id)
            query_graph.connect_predicate(movie_2_id, movie_1_id2)
            query_graph.connect_selection(movie_1_id2, movie_1)

            # Second Nesting
            query_graph.connect_selection(movie_1, movie_1_id3)
            query_graph.connect_predicate(movie_1_id3, movie_3_id, OperatorType.In)

            query_graph.connect_membership(movie_3, movie_3_id)
            query_graph.connect_simplified_join(movie_3, direction)
            query_graph.connect_simplified_join(direction, director)
            query_graph.connect_selection(director, director_last_name)
            query_graph.connect_predicate(director_last_name, v_last_name)
            query_graph.connect_selection(director, director_first_name)
            query_graph.connect_predicate(director_first_name, v_first_name)

            # For grouping and having
            query_graph.connect_grouping(movie_1, movie_1_id4)
            return query_graph

        def graph_4() -> Query_graph:
            ## Initialize nodes
            # Relation
            movie_1 = Relation("movie", "movie", is_primary=True)
            movie_2 = Relation("movie_t2", "movie")
            movie_3 = Relation("movie_t3", "movie")
            rating_1 = Relation("rating", "rating")
            rating_2 = Relation("rating_t2", "rating")
            direction = Relation("direction", " ")
            director = Relation("director", "director")

            # Attribute
            movie_1_id1 = Attribute("m1_id1", "id")
            movie_1_id2 = Attribute("m1_id2", "id")
            movie_1_id3 = Attribute("m1_id3", "id")
            movie_1_id4 = Attribute("m1_id4", "id")

            movie_2_id = Attribute("m2_id", "id")
            movie_3_id = Attribute("m3_id", "id")

            rating_1_stars1 = Attribute("r1_stars1", "stars")
            rating_1_stars2 = Attribute("r1_stars2", "stars")
            rating_2_stars = Attribute("r2_stars", "stars")

            director_last_name = Attribute("last_name", "last_name")
            director_first_name = Attribute("first_name", "first_name")

            # Function
            rating_avg = Function(FunctionType.Avg)
            rating_max = Function(FunctionType.Max)

            # Values
            v_first_name = Value("spielbverg", "spielbverg")
            v_last_name = Value("steven", "steven")
            v_3 = Value("3", "3")

            ## Construct graph
            query_graph = Query_graph("CorrelatedNestedQuery4")
            query_graph.connect_membership(movie_1, movie_1_id1)
            query_graph.connect_simplified_join(movie_1, rating_1, "", "belongs to")

            # Nesting
            query_graph.connect_selection(rating_1, rating_1_stars1)
            query_graph.connect_predicate(rating_1_stars1, rating_max, OperatorType.LessThan)

            query_graph.connect_transformation(rating_max, rating_2_stars)
            query_graph.connect_membership(rating_2, rating_2_stars)
            query_graph.connect_simplified_join(rating_2, movie_2, "belongs to", "")

            # Correlation
            query_graph.connect_selection(movie_2, movie_2_id)
            query_graph.connect_predicate(movie_2_id, movie_1_id2)
            query_graph.connect_selection(movie_1_id2, movie_1)

            # Second Nesting
            query_graph.connect_selection(movie_1, movie_1_id3)
            query_graph.connect_predicate(movie_1_id3, movie_3_id, OperatorType.In)

            query_graph.connect_membership(movie_3, movie_3_id)
            query_graph.connect_simplified_join(movie_3, direction)
            query_graph.connect_simplified_join(direction, director)
            query_graph.connect_selection(director, director_first_name)
            query_graph.connect_predicate(director_first_name, v_first_name)
            query_graph.connect_selection(director, director_last_name)
            query_graph.connect_predicate(director_last_name, v_last_name)

            # For grouping and having
            query_graph.connect_grouping(movie_1, movie_1_id4)
            query_graph.connect_having(rating_1, rating_1_stars2)
            query_graph.connect_transformation(rating_1_stars2, rating_avg)
            query_graph.connect_predicate(rating_avg, v_3, OperatorType.GEq)
            return query_graph

        return [graph_4(), graph_3(), graph_2(), graph_1()]


import re


def compare_string_without_newline(str1, str2):
    str1 = re.sub(" +", " ", str1)
    str2 = re.sub(" +", " ", str2)
    return str1.replace("\n", "") == str2.replace("\n", "")


def query_graph_to_generic_templates(query_graph):
    """
    input:
        - query_graph
    output:
        - list of generic template graphs
    Assumption:
        - a relation must exists in a generic template
    """

    def get_all_paths(cur_relation, visited_edges):
        return get_all_outgoing_paths_to_adj_relations(
            cur_relation, visited_edges
        ) + get_all_incoming_paths_from_adj_relations(cur_relation, visited_edges)

    def get_all_outgoing_paths_to_adj_relations(cur_relation, visited_edges):
        all_paths = []
        for src, dst in query_graph.out_edges(cur_relation):
            if (src, dst) not in visited_edges:
                visited_edges.append((src, dst))
                if isinstance(dst, Relation):
                    all_paths.append([(src, dst)])
                else:
                    rec_paths = get_all_paths(dst, visited_edges)
                    rec_paths = [[(src, dst)] + p for p in rec_paths] if rec_paths else [[(src, dst)]]
                    all_paths += rec_paths
        return all_paths

    def get_all_incoming_paths_from_adj_relations(cur_relation, visited_edges):
        all_paths = []
        for src, dst in query_graph.in_edges(cur_relation):
            if (src, dst) not in visited_edges:
                visited_edges.append((src, dst))
                if isinstance(dst, Relation):
                    all_paths.append([(src, dst)])
                else:
                    rec_paths = get_all_paths(dst, visited_edges)
                    rec_paths = [p + [(src, dst)] for p in rec_paths] if rec_paths else [[(src, dst)]]
                    all_paths += rec_paths
        return all_paths

    visited_edges = []
    generic_templates = []
    paths_for_generic_templates = []
    # Get all paths for generic templates
    for relation in query_graph.relations:
        paths_for_generic_templates += get_all_paths(relation, visited_edges)
    for path in paths_for_generic_templates:
        graph = Query_graph()
        for src, dst in path:
            edge = query_graph.edges[src, dst]["data"]
            graph.unidirectional_connect(src, edge, dst)
        generic_template = Generic_template(graph, query_graph)
        print(generic_template.nl_description)
        generic_templates.append(generic_template)
    return generic_templates


# class Query(metaclass=abc.ABCMeta):
#     # To cache graph
#     _graph = None

#     @property
#     def generic_templates(self):
#         if not hasattr(self, "_generic_templates"):
#             self._generic_templates = query_graph_to_generic_templates(self.graph)
#         return self._generic_templates

#     @property
#     @abc.abstractmethod
#     def sql(self) -> str:
#         pass

#     @property
#     @abc.abstractmethod
#     def graph(self) -> Query_graph:
#         pass

#     @property
#     @abc.abstractmethod
#     def nl(self) -> str:
#         pass

#     @property
#     @abc.abstractmethod
#     def BST_nl(self) -> str:
#         pass

#     @property
#     @abc.abstractmethod
#     def MRP_nl(self) -> str:
#         pass

#     @property
#     @abc.abstractmethod
#     def TMT_nl(self) -> str:
#         pass


# class GroupBy_query(Query):
#     @property
#     def sql(self):
#         return """  SELECT year, term, max(grade)
#                     FROM studentHistory
#                     GROUP BY year, term
#                     HAVING avg(grade) > 3
#                """

#     @property
#     def graph(self):
#         if not GroupBy_query._graph:
#             # Relation
#             studentHistory = Relation("StudentHistory", "student history")

#             # Attribute
#             year_prj = Attribute("year")
#             year_grp = Attribute("year")
#             term_prj = Attribute("term")
#             term_grp = Attribute("term")
#             grade1 = Attribute("grade")
#             grade2 = Attribute("grade")
#             avg = Function(FunctionType.Avg)
#             max = Function(FunctionType.Max)
#             v_3 = Value("3")

#             query_graph = Query_graph("group-by query")
#             query_graph.connect_membership(studentHistory, grade1)
#             query_graph.connect_transformation(max, grade1)
#             query_graph.connect_grouping(studentHistory, year_grp)
#             query_graph.connect_grouping(year_grp, term_grp)
#             query_graph.connect_membership(studentHistory, year_prj)
#             query_graph.connect_membership(studentHistory, term_prj)
#             query_graph.connect_having(studentHistory, grade2)
#             query_graph.connect_transformation(grade2, avg)
#             query_graph.connect_predicate(avg, v_3)
#             GroupBy_query._graph = query_graph
#         return GroupBy_query._graph

#     @property
#     def simplified_graph(self):
#         if not GroupBy_query._graph:
#             # Relation
#             studentHistory = Relation("StudentHistory", "student history")

#             # Attribute
#             year_prj = Attribute("year_p", "year")
#             year_grp = Attribute("year_g", "year")
#             term_prj = Attribute("term_p", "term")
#             term_grp = Attribute("term_g", "term")
#             grade1 = Attribute("grade_p", "grade")
#             grade2 = Attribute("grade_h", "grade")
#             avg = Function(FunctionType.Avg)
#             max = Function(FunctionType.Max)
#             v_3 = Value("3")

#             query_graph = Query_graph("group-by query")
#             query_graph.connect_membership(studentHistory, grade1)
#             query_graph.connect_transformation(max, grade1)
#             query_graph.connect_grouping(studentHistory, year_grp)
#             query_graph.connect_grouping(year_grp, term_grp)
#             query_graph.connect_membership(studentHistory, year_prj)
#             query_graph.connect_membership(studentHistory, term_prj)
#             query_graph.connect_having(studentHistory, grade2)
#             query_graph.connect_transformation(grade2, avg)
#             query_graph.connect_predicate(avg, v_3, OperatorType.GreaterThan)
#             GroupBy_query._graph = query_graph
#         return GroupBy_query._graph

#     @property
#     def nl(self):
#         return " "

#     @property
#     def BST_nl(self) -> str:
#         return """ """

#     @property
#     def MRP_nl(self) -> str:
#         return "find maximum grade, year, and term of student history for each year and term of student history, considering only those groups whose average grade of student history is greater than 3."

#     @property
#     def TMT_nl(self) -> str:
#         return """ """


def parse_args():
    parser = argparse.ArgumentParser(description="Translate EVQA to SQL")
    parser.add_argument("--query_type", type=str, help="Tell the type of example query")
    return parser.parse_args()


if __name__ == "__main__":
    tmp = ProjectionQuery()
    QUERY_TYPE_TO_CLASS_MAPPING = {
        "projection": ProjectionQuery,
        "minMax": MinMaxQuery,
        "countAvgSum": CountAvgSumQuery,
        "selection": SelectionQuery,
        "andOr": AndOrQuery,
        "selectionWithOr": SelectionQueryWithOr,
        "selectionWithAnd": SelectionQueryWithAnd,
        "orderBy": OrderByQuery,
        "groupBy": GroupByQuery,
        "having": HavingQuery,
        "nested": NestedQuery,
        "correlatedNested": CorrelatedNestedQuery,
        "correlatedNested2": CorrelatedNestedQuery2,
        "multipleSublinks": MultipleSublinksQuery,
    }

    args = parse_args()
    query_type = args.query_type

    if query_type in QUERY_TYPE_TO_CLASS_MAPPING.keys():
        query = QUERY_TYPE_TO_CLASS_MAPPING[query_type]()
    else:
        raise RuntimeError("Should not be here")
    dumped_query = query.evqa.dump_json()
    print(json.dumps(dumped_query, indent=4))
