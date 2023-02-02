import abc
import argparse
import json

from hkkang_utils import misc as misc_utils

from src.query_tree.operator import Aggregation, Foreach, Grouping, Ordering, Projection, Selection
from src.query_tree.query_tree import Attach, BaseTable, QueryBlock, QueryTree, Refer, get_global_index
from src.table_excerpt.examples.car_table import car_table
from src.table_excerpt.table_excerpt import TableExcerpt
from src.VQL.EVQL import Aggregator, Clause, EVQLNode, EVQLTree, Grouping, Header, Operator, Ordering, Selecting


def find_nth_occurrence_index(lst, item, n):
    """Find the nth occurrence of an item in a list"""
    index = -1
    for i in range(n):
        index = lst.index(item, index + 1)
    return index


class TestQuery(metaclass=abc.ABCMeta):
    def __init__(self):
        self._query_tree = None
        self._evql = None
        self._sql = None

    @property
    def sql(self):
        return self._sql

    @property
    @abc.abstractmethod
    def evql(self):
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
    def evql(self):
        # Create tree node
        node = EVQLNode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(car_table.table_excerpt_headers.index("id")))
        # Construct tree
        return EVQLTree(node)

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
    def evql(self):
        # Create tree node
        node = EVQLNode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("horsepower"), agg_type=Aggregator.max))
        node.add_projection(Header(node.headers.index("max_speed"), agg_type=Aggregator.min))
        # Construct tree
        return EVQLTree(node)

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
    def evql(self):
        # Create tree node
        node = EVQLNode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("id"), agg_type=Aggregator.count))
        node.add_projection(Header(node.headers.index("max_speed"), agg_type=Aggregator.avg))
        node.add_projection(Header(node.headers.index("price"), agg_type=Aggregator.sum))
        # Construct tree
        return EVQLTree(node)

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
    def evql(self):
        # Create tree node
        node = EVQLNode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("id")))
        # Create conditions for the node
        clause = Clause([Selecting(node.headers.index("year"), Operator.equal, "2010")])
        node.add_predicate(clause)
        # Construct tree
        return EVQLTree(node)

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
                    l_operand=get_global_index(base_tables, 0, "year"),
                    operator="=",
                    r_operand="2010",
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
    def evql(self):
        # Create tree node
        node = EVQLNode(f"{car_table.name}_query", car_table)
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
        return EVQLTree(node)

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
                    r_operand=Selection(
                        l_operand=Selection(
                            get_global_index(base_tables, 0, "model"),
                            "=",
                            "tesla model x",
                        ),
                        operator="=",
                        r_operand=Selection(
                            get_global_index(base_tables, 0, "year"),
                            "=",
                            "2011",
                        ),
                    ),
                    operator="or",
                    l_operand=Selection(
                        l_operand=Selection(
                            get_global_index(base_tables, 0, "model"),
                            "=",
                            "tesla model x",
                        ),
                        operator="=",
                        r_operand=Selection(
                            get_global_index(base_tables, 0, "year"),
                            "=",
                            "2012",
                        ),
                    ),
                ),
            ],
        )
        return QueryTree(root=node, sql=self.sql)


class SelectionQueryWithOr(TestQuery):
    def __init__(self):
        super(SelectionQueryWithOr, self).__init__()
        self._sql = "SELECT id FROM cars WHERE (max_speed > 2000) OR (year = 2010)"

    @misc_utils.property_with_cache
    def evql(self):
        # Create tree node
        node = EVQLNode(f"{car_table.name}_query", car_table)
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
        return EVQLTree(node)

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
                    l_operand=Selection(
                        get_global_index(base_tables, 0, "max_speed"),
                        ">",
                        "2000",
                    ),
                    operator="or",
                    r_operand=Selection(get_global_index(base_tables, 0, "year"), "=", "2010"),
                ),
            ],
        )
        return QueryTree(root=node, sql=self.sql)


class SelectionQueryWithAnd(TestQuery):
    def __init__(self):
        super(SelectionQueryWithAnd, self).__init__()
        self._sql = "SELECT id FROM cars WHERE max_speed > 2000 AND year = 2010"

    @misc_utils.property_with_cache
    def evql(self):
        # Create tree node
        node = EVQLNode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("id")))
        # Create conditions for the node
        cond1 = Selecting(node.headers.index("max_speed"), Operator.greaterThan, "2000")
        cond2 = Selecting(node.headers.index("year"), Operator.equal, "2010")
        clause = Clause([cond1, cond2])
        node.add_predicate(clause)
        return EVQLTree(node)

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
                    l_operand=get_global_index(base_tables, 0, "max_speed"),
                    operator=">",
                    r_operand="2000",
                ),
                Selection(
                    l_operand=get_global_index(base_tables, 0, "year"),
                    operator="=",
                    r_operand="2010",
                ),
            ],
        )
        return QueryTree(root=node, sql=self.sql)


class OrderByQuery(TestQuery):
    def __init__(self):
        super(OrderByQuery, self).__init__()
        self._sql = "SELECT id FROM cars WHERE year = 2010 ORDER BY horsepower DESC"

    @misc_utils.property_with_cache
    def evql(self):
        # Create tree node
        node = EVQLNode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("id")))
        # Create conditions for the node
        cond1 = Selecting(node.headers.index("year"), Operator.equal, "2010")
        cond2 = Ordering(node.headers.index("horsepower"), is_ascending=False)
        clause = Clause([cond1, cond2])
        node.add_predicate(clause)
        return EVQLTree(node)

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        base_tables = [BaseTable(car_table.headers, car_table.rows)]
        # Create node
        node = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            operations=[
                Projection(get_global_index(base_tables, 0, "id")),
                Selection(get_global_index(base_tables, 0, "year"), "=", "2010"),
                Ordering(get_global_index(base_tables, 0, "horsepower"), is_ascending=False),
            ],
        )
        return QueryTree(root=node, sql=self.sql)


class GroupByQuery(TestQuery):
    def __init__(self):
        super(GroupByQuery, self).__init__()
        self._sql = "SELECT count(*), model FROM cars GROUP BY model"

    @misc_utils.property_with_cache
    def evql(self):
        # Create tree node
        node = EVQLNode(f"{car_table.name}_query", car_table)
        node.add_projection(Header(node.headers.index("cars"), agg_type=Aggregator.count))
        # Create conditions for the node
        cond = Grouping(node.headers.index("model"))
        clause = Clause([cond])
        node.add_predicate(clause)
        return EVQLTree(node)

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
                Grouping(get_global_index(base_tables, 0, "model")),
            ],
        )
        return QueryTree(root=node, sql=self.sql)


class HavingQuery(TestQuery):
    def __init__(self):
        super(HavingQuery, self).__init__()
        self._sql = "SELECT model FROM cars GROUP BY model HAVING AVG(max_speed) > 400"

    @misc_utils.property_with_cache
    def evql(self):
        # Create tree node 1
        node_1 = EVQLNode(f"{car_table.name}_query", car_table)
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
        result_table = TableExcerpt("cars2", result_headers, result_col_types, result_rows)

        # Next Table Excerpt
        new_car_headers = result_headers
        new_col_types = result_col_types
        new_rows = result_rows
        new_table_excerpt = TableExcerpt("cars", new_car_headers, new_col_types, new_rows)

        # Create tree node 2
        # TODO: Need to discuss about how to name variables from previous step
        node_2 = EVQLNode(f"{new_table_excerpt.name}_query", new_table_excerpt)
        node_2.add_projection(Header(node_2.headers.index("model")))

        cond2 = Selecting(
            find_nth_occurrence_index(node_2.headers, "max_speed", 1),
            Operator.greaterThan,
            "400",
        )
        node_2.add_predicate(Clause([cond2]))
        return EVQLTree(node_2, children=[EVQLTree(node_1)])

    @misc_utils.property_with_cache
    def query_tree(self):
        # Get base tables
        base_tables = [BaseTable(car_table.headers, car_table.rows)]
        # Create node1
        node1 = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), base_tables)),
            operations=[
                Projection(get_global_index(base_tables, 0, "model")),
                Projection(get_global_index(base_tables, 0, "max_speed"), "avg_max_speed"),
                Aggregation(get_global_index(base_tables, 0, "max_speed"), "avg"),
                Grouping(get_global_index(base_tables, 0, "model")),
            ],
        )
        # Create node2
        node2_tables = [node1]
        node2 = QueryBlock(
            child_tables=list(map(lambda t: Refer(t), node2_tables)),
            operations=[
                Projection(get_global_index(node2_tables, 0, "model")),
                Selection(get_global_index(node2_tables, 0, "avg_max_speed"), ">", "400"),
            ],
        )
        return QueryTree(root=node2, sql=self.sql)


class NestedQuery(TestQuery):
    def __init__(self):
        super(NestedQuery, self).__init__()
        self._sql = "SELECT id FROM cars WHERE max_speed > (SELECT AVG(max_speed) FROM cars WHERE year = 2010)"

    @misc_utils.property_with_cache
    def evql(self):
        # Create tree node 1
        node_1 = EVQLNode(f"{car_table.name}_query", car_table)
        node_1.add_projection(Header(node_1.headers.index("max_speed"), agg_type=Aggregator.avg))
        # Create conditions for the node
        cond1_1 = Selecting(node_1.headers.index("year"), Operator.equal, "2010")
        node_1.add_predicate(Clause([cond1_1]))

        # Query Result
        result_headers = ["avg_max_speed"]
        result_col_types = ["number"]
        result_rows = [[280]]
        result_table = TableExcerpt(node_1.name, result_headers, result_col_types, result_rows)

        # New table excerpt
        new_table_excerpt = TableExcerpt.concatenate("cars3", car_table, result_table)

        # Create tree node 2
        node_2 = EVQLNode(f"{new_table_excerpt.name}_query", new_table_excerpt)
        node_2.add_projection(Header(node_2.headers.index("id")))
        cond2 = Selecting(
            find_nth_occurrence_index(node_2.headers, "max_speed", 1),
            Operator.greaterThan,
            Operator.add_idx_prefix(node_2.headers.index("avg_max_speed")),
        )
        node_2.add_predicate(Clause([cond2]))
        return EVQLTree(node_2, children=[EVQLTree(node_1)])

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
                Selection(get_global_index(base_tables, 0, "year"), "=", "2010"),
            ],
        )

        # Get base table
        node2_tables = base_tables + [node1]
        node2 = QueryBlock(
            child_tables=list(map(lambda t: Attach(t), node2_tables)),
            operations=[
                Projection(get_global_index(node2_tables, 0, "id")),
                Selection(
                    get_global_index(node2_tables, 0, "max_speed"),
                    ">",
                    get_global_index(node2_tables, 1, "avg_max_speed"),
                ),
            ],
        )

        return QueryTree(root=node2, sql=self.sql)


class CorrelatedNestedQuery(TestQuery):
    def __init__(self):
        super(CorrelatedNestedQuery, self).__init__()
        self._sql = "SELECT T2.id FROM cars AS T2 WHERE T2.max_speed > (SELECT avg(T1.max_speed) FROM cars AS T1 WHERE T1.model = T2.model)"

    @misc_utils.property_with_cache
    def evql(self):
        # Create tree node 1
        node_1 = EVQLNode(f"{car_table.name}_query", car_table)
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
        result_table = TableExcerpt(node_1.name, result_headers, result_col_types, result_rows)

        # Query Result
        new_car_table = TableExcerpt.concatenate("cars2", car_table, result_table)

        # Create tree node 2
        node_2 = EVQLNode(f"{new_car_table.name}_query", new_car_table)
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

        return EVQLTree(node_2, children=[EVQLTree(node_1)])

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
                Selection(get_global_index(base_tables, 0, "model"), "=", get_global_index(base_tables, 1, "model"))
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
                    get_global_index(node2_tables, 0, "max_speed"),
                    ">",
                    get_global_index(node2_tables, 1, "avg_max_speed"),
                ),
            ],
        )
        return QueryTree(root=node2, sql=self.sql)


class CorrelatedNestedQuery2(TestQuery):
    def __init__(self):
        super(CorrelatedNestedQuery2, self).__init__()
        self._sql = "SELECT T2.id FROM cars AS T2 WHERE T2.max_speed > (SELECT avg(T1.max_speed) FROM cars AS T1 WHERE T1.model = T2.model) GROUP BY T2.model HAVING AVG(T2.max_speed) > 300"

    @misc_utils.property_with_cache
    def evql(self):
        # Create tree node 1
        node_1 = EVQLNode(f"{car_table.name}_query", car_table)
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
        result_table = TableExcerpt(node_1.name, result_headers, result_col_types, result_rows)

        # Create tree node 2
        new_table_excerpt = TableExcerpt.concatenate("cars2", car_table, result_table)
        node_2 = EVQLNode(f"{new_table_excerpt.name}_query", new_table_excerpt)
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
        result_table_2 = TableExcerpt(node_2.name, result_headers_2, result_col_types_2, result_rows_2)

        # Create tree node 3
        node_3 = EVQLNode(f"{result_table_2.name}_query", result_table_2)
        node_3.add_projection(Header(node_3.headers.index("id")))
        # Create conditions for the node
        cond3 = Selecting(node_3.headers.index("max_speed"), Operator.greaterThan, "300")
        node_3.add_predicate(Clause([cond3]))
        return EVQLTree(node_3, children=[EVQLTree(node_2, children=[EVQLTree(node_1)])])


class MultipleSublinksQuery(TestQuery):
    def __init__(self):
        super(MultipleSublinksQuery, self).__init__()
        self._sql = "SELECT id FROM cars WHERE max_speed > (SELECT avg(max_speed) FROM cars WHERE model = 'hyundai') AND horsepower > (SELECT avg(horsepower) FROM cars WHERE model = 'genesis')"

    @misc_utils.property_with_cache
    def evql(self):
        # Create tree node 1
        node_1 = EVQLNode(f"{car_table}_query1", car_table)
        node_1.add_projection(Header(node_1.headers.index("max_speed"), agg_type=Aggregator.avg))
        # Create conditions for the node
        cond1 = Selecting(node_1.headers.index("model"), Operator.equal, "hyundai")
        node_1.add_predicate(Clause([cond1]))

        # Query result 1
        result_headers = ["max_speed"]
        result_col_types = [TableExcerpt._str_to_dtype("float")]
        result_rows = [[935]]
        result_table1 = TableExcerpt(node_1.name, result_headers, result_col_types, result_rows)

        # Create tree node 2
        node_2 = EVQLNode(f"{car_table}_query2", car_table)
        node_2.add_projection(Header(node_2.headers.index("horsepower"), agg_type=Aggregator.avg))
        # Create conditions for the node
        cond2 = Selecting(node_2.headers.index("model"), Operator.equal, "genesis")
        node_2.add_predicate(Clause([cond2]))

        # Query Result 2
        result_headers = ["horsepower"]
        result_col_types = [TableExcerpt._str_to_dtype("float")]
        result_rows = [[10.5]]
        result_table2 = TableExcerpt(node_2.name, result_headers, result_col_types, result_rows)

        new_car_table1 = TableExcerpt.concatenate("cars2", car_table, result_table1)
        new_car_table2 = TableExcerpt.concatenate("cars3", new_car_table1, result_table2)

        # Create tree node 3
        node_3 = EVQLNode(f"{new_car_table2.name}_query", new_car_table2)
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
        return EVQLTree(node_3, children=[EVQLTree(node_2), EVQLTree(node_1)])


class MultipleSublinksQuery(TestQuery):
    def __init__(self):
        super(MultipleSublinksQuery, self).__init__()
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
    def evql(self):
        raise NotImplementedError

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


def parse_args():
    parser = argparse.ArgumentParser(description="Translate EVQL to SQL")
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
    dumped_query = query.evql.dump_json()
    print(json.dumps(dumped_query, indent=4))
