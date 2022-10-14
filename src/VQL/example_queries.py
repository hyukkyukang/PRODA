import abc
import json
import argparse

from src.VQL.EVQL import EVQLTree , EVQLNode, Selecting, Ordering, Grouping, Operator, Aggregator, Header, Clause

from src.table.examples.car_table import car_table
from src.table.table import Table

class TestQuery(metaclass=abc.ABCMeta):
    def __init__(self):
        self._evql = None
        self._sql = None

    @property
    def sql(self):
        return self._sql

    @property
    @abc.abstractmethod
    def evql(self):
        pass

class ProjectionQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT id FROM cars"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node
            node = EVQLNode(car_table)
            node.add_projection(Header(car_table.table_excerpt_headers.index("id")))
            # Construct tree
            self._evql = EVQLTree(node)
        return self._evql

class MinMaxQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT max(horsepower), min(max_speed) FROM cars"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node
            node = EVQLNode(car_table)
            node.add_projection(Header(car_table.table_excerpt_headers.index("horsepower"), agg_type=Aggregator.max))
            node.add_projection(Header(car_table.table_excerpt_headers.index("max_speed"), agg_type=Aggregator.min))
            # Construct tree
            self._evql = EVQLTree(node)
        return self._evql



class CountAvgSumQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT count(id), avg(max_speed), sum(price) FROM cars"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node
            node = EVQLNode(car_table)
            node.add_projection(Header(car_table.table_excerpt_headers.index("id"), agg_type=Aggregator.count))
            node.add_projection(Header(car_table.table_excerpt_headers.index("max_speed"), agg_type=Aggregator.avg))
            node.add_projection(Header(car_table.table_excerpt_headers.index("price"), agg_type=Aggregator.sum))
            # Construct tree
            self._evql = EVQLTree(node)
        return self._evql


class SelectionQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT id FROM cars WHERE year = 2010"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node
            node = EVQLNode(car_table)
            node.add_projection(Header(car_table.table_excerpt_headers.index("id")))
            # Create conditions for the node
            clause = Clause([Selecting(car_table.table_excerpt_headers.index("year"),
                                             Operator.equal,
                                             "2010")])
            node.add_predicate(clause)
            # Construct tree
            self._evql = EVQLTree(node)
        return self._evql


class AndOrQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT id, price FROM cars WHERE (model = 'tesla model x' and year = 2011) or (model = 'tesla model x' and year = 2012)"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node
            node = EVQLNode(car_table)
            node.add_projection(Header(car_table.table_excerpt_headers.index("id")))
            node.add_projection(Header(car_table.table_excerpt_headers.index("price")))
            # Create conditions for the node
            # Condition1 (first clause of DNF)
            cond1_1 = Selecting(car_table.table_excerpt_headers.index("model"),
                                             Operator.equal,
                                             "tesla model x")
            cond1_2 = Selecting(car_table.table_excerpt_headers.index("year"),
                                             Operator.equal,
                                             "2011") 
            clause1 = Clause([cond1_1, cond1_2])
            # Condition2 (second clause of DNF)
            cond2_1 = Selecting(car_table.table_excerpt_headers.index("model"),
                                             Operator.equal,
                                             "tesla model x")
            cond2_2 = Selecting(car_table.table_excerpt_headers.index("year"),
                                             Operator.equal,
                                             "2012")
            clause2 = Clause([cond2_1, cond2_2])
            # Add all conditions to the node
            node.add_predicate(clause1)
            node.add_predicate(clause2)
            # Construct tree
            self._evql = EVQLTree(node)
        return self._evql
    
    
    
class SelectionQueryWithOr(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT id FROM cars WHERE (max_speed > 2000) OR (year = 2010)"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node
            node = EVQLNode(car_table)
            node.add_projection(Header(car_table.table_excerpt_headers.index("id")))
            # Create conditions for the node
            clause1 = Clause([Selecting(car_table.table_excerpt_headers.index("max_speed"), 
                                             Operator.greaterThan,
                                             "2000")])
            clause2 = Clause([Selecting(car_table.table_excerpt_headers.index("year"),
                                             Operator.equal,
                                             "2010")])
            node.add_predicate(clause1)
            node.add_predicate(clause2)
            # Construct tree
            self._evql = EVQLTree(node)
        return self._evql


class SelectionQueryWithAnd(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT id FROM cars WHERE max_speed > 2000 AND year = 2010"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node
            node = EVQLNode(car_table)
            node.add_projection(Header(car_table.table_excerpt_headers.index("id")))
            # Create conditions for the node
            cond1 = Selecting(car_table.table_excerpt_headers.index("max_speed"), Operator.greaterThan, "2000")
            cond2 = Selecting(car_table.table_excerpt_headers.index("year"), Operator.equal, "2010")
            clause = Clause([cond1, cond2])
            node.add_predicate(clause)
            self._evql = EVQLTree(node)
        return self._evql


class OrderByQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT id FROM cars WHERE year = 2010 ORDER BY horsepower DESC"
        
    @property
    def evql(self):
        if not self._evql:
            # Create tree node
            node = EVQLNode(car_table)
            node.add_projection(Header(car_table.table_excerpt_headers.index("id")))
            # Create conditions for the node
            cond1 = Selecting(car_table.table_excerpt_headers.index("year"), Operator.equal, "2010")
            cond2 = Ordering(car_table.table_excerpt_headers.index("horsepower"), is_ascending=False)
            clause = Clause([cond1, cond2])
            node.add_predicate(clause)
            self._evql = EVQLTree(node)
        return self._evql


class GroupByQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT count(*), model FROM cars GROUP BY model"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node
            node = EVQLNode(car_table)
            node.add_projection(Header(car_table.table_excerpt_headers.index("cars"), agg_type=Aggregator.count))
            node.add_projection(Header(car_table.table_excerpt_headers.index("model")))
            # Create conditions for the node
            cond = Grouping(car_table.table_excerpt_headers.index("model"))
            clause = Clause([cond])
            node.add_predicate(clause)
            self._evql = EVQLTree(node)
        return self._evql


class HavingQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT model FROM cars WHERE year = 2010 GROUP BY model HAVING AVG(max_speed) > 400"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node 1
            node_1 = EVQLNode(car_table)
            node_1.add_projection(Header(car_table.table_excerpt_headers.index("model")))
            node_1.add_projection(Header(car_table.table_excerpt_headers.index("max_speed"), agg_type=Aggregator.avg))
            # Create conditions for the node
            cond1_1 = Selecting(car_table.table_excerpt_headers.index("year"), Operator.equal, "2010")
            cond1_2 = Grouping(car_table.table_excerpt_headers.index("model"))
            clause = Clause([cond1_1, cond1_2])
            node_1.add_predicate(clause)

            # Query Result
            new_car_headers = car_table.headers + ["model", "step1_max_speed_avg"]
            new_col_types = car_table.col_types + [Table._str_to_dtype("float"), Table._str_to_dtype("float")]
            new_rows = [[1, "ford", 10, 200, 2019, 20000, 400, 300]]
            new_car_table = Table(new_car_headers, new_col_types, "cars", new_rows)

            # Create tree node 2
            next_headers = new_car_table.table_excerpt_headers
            # TODO: Need to discuss about how to name variables from previous step
            node_2 = EVQLNode(new_car_table)
            node_2.add_projection(Header(next_headers.index("model")))
            
            cond2 = Selecting(next_headers.index("step1_max_speed_avg"),
                              Operator.greaterThan, "400")
            node_2.add_predicate(Clause([cond2]))
            self._evql = EVQLTree(node_2, [EVQLTree(node_1)])
        return self._evql


class NestedQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT id FROM cars WHERE max_speed > (SELECT AVG(max_speed) FROM cars WHERE year = 2010)"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node 1
            node_1 = EVQLNode(car_table)
            node_1.add_projection(Header(car_table.table_excerpt_headers.index("max_speed"), agg_type=Aggregator.avg))
            # Create conditions for the node
            cond1_1 = Selecting(car_table.table_excerpt_headers.index("year"), Operator.equal, "2010")
            node_1.add_predicate(Clause([cond1_1]))

            # Query Result
            new_car_headers = car_table.headers + ["step1_max_speed_avg"]
            new_col_types = car_table.col_types + [Table._str_to_dtype("float")]
            new_rows = [[1, "ford", 10, 200, 2019, 20000, 400]]
            new_car_table = Table(new_car_headers, new_col_types, "cars", new_rows)

            # Create tree node 2
            next_headers = new_car_table.table_excerpt_headers
            node_2 = EVQLNode(new_car_table)
            node_2.add_projection(Header(next_headers.index("id")))
            cond2 = Selecting(next_headers.index("max_speed"), Operator.greaterThan, "$step1_max_speed_avg")
            node_2.add_predicate(Clause([cond2]))
            self._evql = EVQLTree(node_2, [EVQLTree(node_1)])
        return self._evql


class CorrelatedNestedQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT T2.id FROM cars AS T2 WHERE EXISTS (SELECT T1.model FROM cars AS T1 WHERE T1.model = T2.model GROUP BY T1.model HAVING COUNT(*) > 2)"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node 1
            node_1 = EVQLNode(car_table)
            node_1.add_projection(Header(car_table.table_excerpt_headers.index("model")))
            node_1.add_projection(Header(car_table.table_excerpt_headers.index("cars"), agg_type=Aggregator.count))
            # Create conditions for the node
            cond1_1 = Grouping(car_table.table_excerpt_headers.index("model"))
            node_1.add_predicate(Clause([cond1_1]))

            # Query Result
            new_car_headers = car_table.headers + ["step1_cars_count"]
            new_col_types = car_table.col_types + [Table._str_to_dtype("float")]
            new_rows = [[1, "ford", 10, 200, 2019, 20000, 400]]
            new_car_table = Table(new_car_headers, new_col_types, "cars", new_rows)

            # Create tree node 2
            next_headers = new_car_table.table_excerpt_headers
            node_2 = EVQLNode(new_car_table,foreach_col_id=next_headers.index("model"))
            node_2.add_projection(Header(next_headers.index("model")))
            # Create conditions for the node
            cond2 = Selecting(next_headers.index("step1_cars_count"), Operator.greaterThan, "2")
            node_2.add_predicate(Clause([cond2]))

            # Query Result
            new_car_headers = new_car_table.headers + ["step2_model"]
            new_col_types = new_car_table.col_types + [Table._str_to_dtype("float")]
            new_rows = [[1, "ford", 10, 200, 2019, 20000, 400, 2]]
            new_car_table = Table(new_car_headers, new_col_types, "cars", new_rows)

            # Create tree node 3
            next_headers = new_car_table.table_excerpt_headers
            node_3 = EVQLNode(new_car_table)
            node_3.add_projection(Header(next_headers.index("id")))
            # Create conditions for the node
            cond3 = Selecting(next_headers.index("step2_model"), Operator.exists, None)
            node_3.add_predicate(Clause([cond3]))
            self._evql = EVQLTree(node_3, [EVQLTree(node_2, [EVQLTree(node_1, enforce_t_alias=True)])])
        return self._evql


def parse_args():
    parser = argparse.ArgumentParser(description="Translate EVQL to SQL")
    parser.add_argument(
        "--query_type",
        type=str,
        help="Tell the type of example query")
    return parser.parse_args()


if __name__ == "__main__":
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
        "correlatedNested": CorrelatedNestedQuery
    }
    
    args = parse_args()
    query_type = args.query_type
    
    if query_type in QUERY_TYPE_TO_CLASS_MAPPING.keys():
        query = QUERY_TYPE_TO_CLASS_MAPPING[query_type]()
    else:
        raise RuntimeError("Should not be here")
    dumped_query = query.evql.dump_json()
    print(json.dumps(dumped_query, indent=4))
    