import abc
import json
import argparse

from src.VQL.EVQL import EVQLTree , EVQLNode, Selecting, Ordering, Grouping, Operator, Aggregator, Header, Clause

from src.table_excerpt.examples.car_table import car_table
from src.table_excerpt.table_excerpt import TableExcerpt

def find_nth_occurrence_index(lst, item, n):
    """Find the nth occurrence of an item in a list"""
    index = -1
    for i in range(n):
        index = lst.index(item, index + 1)
    return index

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
            node = EVQLNode(f"{car_table.name}_query", car_table)
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
            node = EVQLNode(f"{car_table.name}_query", car_table)
            node.add_projection(Header(node.headers.index("horsepower"), agg_type=Aggregator.max))
            node.add_projection(Header(node.headers.index("max_speed"), agg_type=Aggregator.min))
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
            node = EVQLNode(f"{car_table.name}_query", car_table)
            node.add_projection(Header(node.headers.index("id"), agg_type=Aggregator.count))
            node.add_projection(Header(node.headers.index("max_speed"), agg_type=Aggregator.avg))
            node.add_projection(Header(node.headers.index("price"), agg_type=Aggregator.sum))
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
            node = EVQLNode(f"{car_table.name}_query", car_table)
            node.add_projection(Header(node.headers.index("id")))
            # Create conditions for the node
            clause = Clause([Selecting(node.headers.index("year"),
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
            node = EVQLNode(f"{car_table.name}_query", car_table)
            node.add_projection(Header(node.headers.index("id")))
            node.add_projection(Header(node.headers.index("price")))
            # Create conditions for the node
            # Condition1 (first clause of DNF)
            cond1_1 = Selecting(node.headers.index("model"),
                                             Operator.equal,
                                             "tesla model x")
            cond1_2 = Selecting(node.headers.index("year"),
                                             Operator.equal,
                                             "2011") 
            clause1 = Clause([cond1_1, cond1_2])
            # Condition2 (second clause of DNF)
            cond2_1 = Selecting(node.headers.index("model"),
                                             Operator.equal,
                                             "tesla model x")
            cond2_2 = Selecting(node.headers.index("year"),
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
            node = EVQLNode(f"{car_table.name}_query", car_table)
            node.add_projection(Header(node.headers.index("id")))
            # Create conditions for the node
            clause1 = Clause([Selecting(node.headers.index("max_speed"), 
                                             Operator.greaterThan,
                                             "2000")])
            clause2 = Clause([Selecting(node.headers.index("year"),
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
            node = EVQLNode(f"{car_table.name}_query", car_table)
            node.add_projection(Header(node.headers.index("id")))
            # Create conditions for the node
            cond1 = Selecting(node.headers.index("max_speed"), Operator.greaterThan, "2000")
            cond2 = Selecting(node.headers.index("year"), Operator.equal, "2010")
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
            node = EVQLNode(f"{car_table.name}_query", car_table)
            node.add_projection(Header(node.headers.index("id")))
            # Create conditions for the node
            cond1 = Selecting(node.headers.index("year"), Operator.equal, "2010")
            cond2 = Ordering(node.headers.index("horsepower"), is_ascending=False)
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
            node = EVQLNode(f"{car_table.name}_query", car_table)
            node.add_projection(Header(node.headers.index("cars"), agg_type=Aggregator.count))
            node.add_projection(Header(node.headers.index("model")))
            # Create conditions for the node
            cond = Grouping(node.headers.index("model"))
            clause = Clause([cond])
            node.add_predicate(clause)
            self._evql = EVQLTree(node)
        return self._evql


class HavingQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT model FROM cars GROUP BY model HAVING AVG(max_speed) > 400"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node 1
            node_1 = EVQLNode(f"{car_table.name}_query", car_table)
            node_1.add_projection(Header(node_1.headers.index("model")))
            node_1.add_projection(Header(node_1.headers.index("max_speed"), agg_type=Aggregator.avg))
            # Create conditions for the node
            cond1_2 = Grouping(node_1.headers.index("model"))
            clause = Clause([cond1_2])
            node_1.add_predicate(clause)

            # Query Result
            result_headers = ["model", "max_speed"]
            result_col_types = ["string", "number"]
            result_rows = [["ford", 230],
                            ["cherlet", 330],
                            ["toyota", 430],
                            ["volkswage", 530],
                            ["amc", 630],
                            ["pontiac", 730],
                            ["datsun", 830],
                            ["hyundai", (930+940)/2],
                            ["kia", 1030],
                            ["genesis", (1130+1140)/2]]
            result_table = TableExcerpt("cars2", result_headers, result_col_types, result_rows)
            
            # Next Table Excerpt
            new_car_headers = result_headers
            new_col_types = result_col_types
            # new_rows = [
            #     [1, "ford", 10, 230, 2019, 20000, "ford", 230],
            #     [2, "cherlet", 10, 330, 2018, 15000, "cherlet", 330],
            #     [3, "toyota", 10, 430, 2017, 10000, "toyota", 430],
            #     [4, "volkswage", 10, 530, 2016, 8000, "volkswage", 530],
            #     [5, "amc", 10, 630, 2018, 15000, "amc", 630],
            #     [6, "pontiac", 10, 730, 2012, 71000, "pontiac", 730],
            #     [7, "datsun", 10, 830, 2013, 81000, "datsun", 830],
            #     [8, "hyundai", 10, 930, 2013, 91000, "hyundai", (930+940)/2],
            #     [9, "hyundai", 11, 940, 2014, 92000, "hyundai", (930+940)/2],
            #     [10, "kia", 10, 1030, 2014, 101000, "kia", 1030],
            #     [11, "genesis", 10, 1130, 2014, 111000, "genesis", (1130+1140)/2],
            #     [12, "genesis", 11, 1140, 2015, 112000, "genesis", (1130+1140)/2]
            # ]
            new_rows = result_rows
            new_table_excerpt = TableExcerpt("cars3", new_car_headers, new_col_types, new_rows)

            # Create tree node 2
            # TODO: Need to discuss about how to name variables from previous step
            node_2 = EVQLNode(f"{new_table_excerpt.name}_query", new_table_excerpt)
            node_2.add_projection(Header(node_2.headers.index("model")))
            
            cond2 = Selecting(find_nth_occurrence_index(node_2.headers, "max_speed", 1), Operator.greaterThan, "400")
            node_2.add_predicate(Clause([cond2]))
            self._evql = EVQLTree(node_2, children=[EVQLTree(node_1)])
        return self._evql


class NestedQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT id FROM cars WHERE max_speed > (SELECT AVG(max_speed) FROM cars WHERE year = 2010)"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node 1
            node_1 = EVQLNode(f"{car_table.name}_query", car_table, is_concatenate=True)
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
            cond2 = Selecting(find_nth_occurrence_index(node_2.headers, "max_speed", 1), Operator.greaterThan, node_2.headers.index("avg_max_speed"))
            node_2.add_predicate(Clause([cond2]))
            self._evql = EVQLTree(node_2, children=[EVQLTree(node_1)])
        return self._evql


class CorrelatedNestedQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT T2.id FROM cars AS T2 WHERE max_speed > (SELECT avg(max_speed) FROM cars AS T1 WHERE T1.model = T2.model)"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node 1
            node_1 = EVQLNode(f"{car_table.name}_query", car_table, is_concatenate=True)
            node_1.add_projection(Header(node_1.headers.index("max_speed"), agg_type=Aggregator.avg))
            cond1 = Grouping(node_1.headers.index("model"))
            node_1.add_predicate(Clause([cond1]))

            # Query Result w/o concatenation
            result_headers = ["avg_max_speed", "model"]
            result_col_types = [TableExcerpt._str_to_dtype("list.float"), TableExcerpt._str_to_dtype("list.string")]
            result_rows = [["ford", 230],
                            ["cherlet", 330],
                            ["toyota", 430],
                            ["volkswage", 530],
                            ["amc", 630],
                            ["pontiac", 730],
                            ["datsun", 830],
                            ["hyundai", 935],
                            ["kia", 1030],
                            ["genesis", 1135]]

            # Query Result
            new_car_headers = car_table.headers + result_headers
            new_col_types = car_table.col_types + result_col_types
            new_rows = [[1, "ford", 10, 230, 2019, 20000, [item[0] for item in result_rows], [item[1] for item in result_rows]],
                        [2, "cherlet", 10, 330, 2018, 15000, [item[0] for item in result_rows], [item[1] for item in result_rows]],
                        [3, "toyota", 10, 430, 2017, 10000, [item[0] for item in result_rows], [item[1] for item in result_rows]],
                        [4, "volkswage", 10, 530, 2016, 8000, [item[0] for item in result_rows], [item[1] for item in result_rows]],
                        [5, "amc", 10, 630, 2018, 15000, [item[0] for item in result_rows], [item[1] for item in result_rows]],
                        [6, "pontiac", 10, 730, 2012, 71000, [item[0] for item in result_rows], [item[1] for item in result_rows]],
                        [7, "datsun", 10, 830, 2013, 81000, [item[0] for item in result_rows], [item[1] for item in result_rows]],
                        [8, "hyundai", 10, 930, 2013, 91000, [item[0] for item in result_rows], [item[1] for item in result_rows]],
                        [9, "hyundai", 11, 940, 2014, 92000, [item[0] for item in result_rows], [item[1] for item in result_rows]],
                        [10, "kia", 10, 1030, 2014, 101000, [item[0] for item in result_rows], [item[1] for item in result_rows]],
                        [11, "genesis", 10, 1130, 2014, 111000, [item[0] for item in result_rows], [item[1] for item in result_rows]],
                        [12, "genesis", 11, 1140, 2015, 112000, [item[0] for item in result_rows], [item[1] for item in result_rows]]]
            new_car_table = TableExcerpt(node_1.name, new_car_headers, new_col_types, new_rows)

            # Create tree node 2
            node_2 = EVQLNode(f"{new_car_table.name}_query", new_car_table, is_concatenate=True)
            node_2.add_projection(Header(node_2.headers.index("id")))
            # Create conditions for the node
            cond2_1 = Selecting(node_2.headers.index("max_speed"), Operator.greaterThan, node_2.headers.index("avg_max_speed"))
            cond2_2 = Selecting(find_nth_occurrence_index(node_2.headers, "model", 1), Operator.equal, find_nth_occurrence_index(node_2.headers, "model", 2))
            node_2.add_predicate(Clause([cond2_1, cond2_2]))
            
            self._evql = EVQLTree(node_2, children=[EVQLTree(node_1, enforce_t_alias=True)])
        return self._evql


class CorrelatedNestedQuery2(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT T2.id FROM cars AS T2 WHERE max_speed > (SELECT avg(max_speed) FROM cars AS T1 WHERE T1.model = T2.model) GROUP BY T1.model HAVING AVG(max_speed) > 300)"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node 1
            node_1 = EVQLNode(f"{car_table.name}_query", car_table)
            node_1.add_projection(Header(node_1.headers.index("max_speed"), agg_type=Aggregator.avg))
            # Create conditions for the node
            cond1_1 = Grouping(node_1.headers.index("model"))
            node_1.add_predicate(Clause([cond1_1]))

            # Query Result
            result_headers = ["model"] + ["max_speed"]
            result_col_types = [TableExcerpt._str_to_dtype("list.string"), TableExcerpt._str_to_dtype("list.float")]
            result_rows = [["ford", 230],
                            ["cherlet", 330],
                            ["toyota", 430],
                            ["volkswage", 530],
                            ["amc", 630],
                            ["pontiac", 730],
                            ["datsun", 830],
                            ["hyundai", 935],
                            ["kia", 1030],
                            ["genesis", 1135]]
            result_table = TableExcerpt(node_1.name, result_headers, result_col_types, result_rows)

            # Create tree node 2
            new_table_excerpt = TableExcerpt.concatenate([car_table, result_table])
            node_2 = EVQLNode(f"{new_table_excerpt.name}_query", new_table_excerpt)
            node_2.add_projection(Header(node_2.headers.index("id")))
            node_2.add_projection(Header(node_2.headers.index("max_speed"), agg_type=Aggregator.avg))
            # Create conditions for the node
            cond2_1 = Selecting(node_2.headers.index("max_speed"), Operator.greaterThan, find_nth_occurrence_index(node_2.headers, "max_speed", 2))
            cond2_2 = Selecting(node_2.headers.index("model"), Operator.equal, find_nth_occurrence_index(node_2.headers, "model", 2))
            node_2.add_predicate(Clause([cond2_1, cond2_2]))

            # Query Result
            result_headers_2 = ["id", "max_speed"]
            result_col_types_2 = [TableExcerpt._str_to_dtype("list.int"), TableExcerpt._str_to_dtype("list.float")]
            result_rows_2 = [[1, 350]]
            result_table_2 = TableExcerpt(node_2.name, result_headers_2, result_col_types_2, result_rows_2)

            # Create tree node 3
            node_3 = EVQLNode(f"{result_table_2.name}_query", result_table_2)
            node_3.add_projection(Header(node_3.headers.index("id")))
            # Create conditions for the node
            cond3 = Selecting(node_3.headers.index("max_speed"), Operator.greaterThan, "300")
            node_3.add_predicate(Clause([cond3]))
            self._evql = EVQLTree(node_3, children=[EVQLTree(node_2, children=[EVQLTree(node_1, enforce_t_alias=True)])])
        return self._evql


class MultipleSublinksQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT id FROM cars WHERE max_speed > (SELECT avg(max_speed) FROM cars WHERE model = 'hyundai') AND horsepower > (SELECT avg(horsepower) FROM cars WHERE model = 'genesis')"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node 1
            node_1 = EVQLNode(f"{car_table}_query1", car_table)
            node_1.add_projection(Header(node_1.headers.index("max_speed"), agg_type=Aggregator.avg))
            # Create conditions for the node
            cond1 = Selecting(node_1.headers.index("model"), Operator.equal, "hyundai")
            node_1.add_predicate(Clause([cond1]))

            # Create tree node 2
            node_2 = EVQLNode(f"{car_table}_query2", car_table)
            node_2.add_projection(Header(node_2.headers.index("horsepower"), agg_type=Aggregator.avg))
            # Create conditions for the node
            cond2 = Selecting(node_2.headers.index("model"), Operator.equal, "genesis")
            node_2.add_predicate(Clause([cond2]))

            # Query Result
            new_car_headers = car_table.headers + ["max_speed"] + ["horsepower"]
            new_col_types = new_car_table.col_types + [TableExcerpt._str_to_dtype("list.float") + TableExcerpt._str_to_dtype("list.float")]
            node_1_result = [[935]]
            node_2_result = [[10.5]]
            new_rows = [row + node_1_result + node_2_result for row in car_table.rows]
            new_car_table = TableExcerpt(node_2.name, new_car_headers, new_col_types, new_rows)

            # Create tree node 3
            node_3 = EVQLNode(f"{new_car_table.name}_query", new_car_table)
            node_3.add_projection(Header(node_3.headers.index("id")))
            # Create conditions for the node
            cond3_1 = Selecting(node_3.headers.index("max_speed"), Operator.greaterThan, find_nth_occurrence_index(node_3.headers, "max_speed", 2))
            cond3_2 = Selecting(node_3.headers.index("horsepower"), Operator.greaterThan, find_nth_occurrence_index(node_3.headers, "horsepower", 2))
            node_3.add_predicate(Clause([cond3_1, cond3_2]))
            self._evql = EVQLTree(node_3, children=[EVQLTree(node_2), EVQLTree(node_1)])
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
        "correlatedNested": CorrelatedNestedQuery,
        "correlatedNested2": CorrelatedNestedQuery2,
        "multipleSublinks": MultipleSublinksQuery
    }
    
    args = parse_args()
    query_type = args.query_type
    
    if query_type in QUERY_TYPE_TO_CLASS_MAPPING.keys():
        query = QUERY_TYPE_TO_CLASS_MAPPING[query_type]()
    else:
        raise RuntimeError("Should not be here")
    dumped_query = query.evql.dump_json()
    print(json.dumps(dumped_query, indent=4))
