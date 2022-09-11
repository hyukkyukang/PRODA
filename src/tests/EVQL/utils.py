import abc

from VQL.EVQL import EVQLTree , EVQLNode, Selecting, Ordering, Grouping, Operator, Aggregator, Header, Clause

CARS_TABLE_HEADERS = ["cars", "id", "model", "horsepower", "max_speed", "year", "price"]

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
            node = EVQLNode(CARS_TABLE_HEADERS)
            node.add_projection(Header(CARS_TABLE_HEADERS.index("id")))
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
            node = EVQLNode(CARS_TABLE_HEADERS)
            node.add_projection(Header(CARS_TABLE_HEADERS.index("horsepower"), agg_type=Aggregator.max))
            node.add_projection(Header(CARS_TABLE_HEADERS.index("max_speed"), agg_type=Aggregator.min))
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
            node = EVQLNode(CARS_TABLE_HEADERS)
            node.add_projection(Header(CARS_TABLE_HEADERS.index("id"), agg_type=Aggregator.count))
            node.add_projection(Header(CARS_TABLE_HEADERS.index("max_speed"), agg_type=Aggregator.avg))
            node.add_projection(Header(CARS_TABLE_HEADERS.index("price"), agg_type=Aggregator.sum))
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
            node = EVQLNode(CARS_TABLE_HEADERS)
            node.add_projection(Header(CARS_TABLE_HEADERS.index("id")))
            # Create conditions for the node
            clause = Clause([Selecting(CARS_TABLE_HEADERS.index("year"),
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
            node = EVQLNode(CARS_TABLE_HEADERS)
            node.add_projection(Header(CARS_TABLE_HEADERS.index("id")))
            node.add_projection(Header(CARS_TABLE_HEADERS.index("price")))
            # Create conditions for the node
            # Condition1 (first clause of DNF)
            cond1_1 = Selecting(CARS_TABLE_HEADERS.index("model"),
                                             Operator.equal,
                                             "tesla model x")
            cond1_2 = Selecting(CARS_TABLE_HEADERS.index("year"),
                                             Operator.equal,
                                             "2011") 
            clause1 = Clause([cond1_1, cond1_2])
            # Condition2 (second clause of DNF)
            cond2_1 = Selecting(CARS_TABLE_HEADERS.index("model"),
                                             Operator.equal,
                                             "tesla model x")
            cond2_2 = Selecting(CARS_TABLE_HEADERS.index("year"),
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
            node = EVQLNode(CARS_TABLE_HEADERS)
            node.add_projection(Header(CARS_TABLE_HEADERS.index("id")))
            # Create conditions for the node
            clause1 = Clause([Selecting(CARS_TABLE_HEADERS.index("max_speed"), 
                                             Operator.greaterThan,
                                             "2000")])
            clause2 = Clause([Selecting(CARS_TABLE_HEADERS.index("year"),
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
            node = EVQLNode(CARS_TABLE_HEADERS)
            node.add_projection(Header(CARS_TABLE_HEADERS.index("id")))
            # Create conditions for the node
            cond1 = Selecting(CARS_TABLE_HEADERS.index("max_speed"), Operator.greaterThan, "2000")
            cond2 = Selecting(CARS_TABLE_HEADERS.index("year"), Operator.equal, "2010")
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
            node = EVQLNode(CARS_TABLE_HEADERS)
            node.add_projection(Header(CARS_TABLE_HEADERS.index("id")))
            # Create conditions for the node
            cond1 = Selecting(CARS_TABLE_HEADERS.index("year"), Operator.equal, "2010")
            cond2 = Ordering(CARS_TABLE_HEADERS.index("horsepower"), is_ascending=False)
            clause = Clause([cond1, cond2])
            node.add_predicate(clause)
            self._evql = EVQLTree(node)
        return self._evql


class GroupByQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT model FROM cars WHERE year = 2010 GROUP BY model"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node
            node = EVQLNode(CARS_TABLE_HEADERS)
            node.add_projection(Header(CARS_TABLE_HEADERS.index("model")))
            # Create conditions for the node
            cond1 = Selecting(CARS_TABLE_HEADERS.index("year"), Operator.equal, "2010")
            cond2 = Grouping(CARS_TABLE_HEADERS.index("model"))
            clause = Clause([cond1, cond2])
            node.add_predicate(clause)
            self._evql = EVQLTree(node)
        return self._evql


class HavingQuery(TestQuery):
    def __init__(self):
        self._evql = None
        self._sql = "SELECT model FROM cars WHERE year = 2010 GROUP BY model HAVING AVG(max_speed) > 2000"

    @property
    def evql(self):
        if not self._evql:
            # Create tree node 1
            node_1 = EVQLNode(CARS_TABLE_HEADERS)
            node_1.add_projection(Header(CARS_TABLE_HEADERS.index("model")))
            node_1.add_projection(Header(CARS_TABLE_HEADERS.index("max_speed"), agg_type=Aggregator.avg))
            # Create conditions for the node
            cond1_1 = Selecting(CARS_TABLE_HEADERS.index("year"), Operator.equal, "2010")
            cond1_2 = Grouping(CARS_TABLE_HEADERS.index("model"))
            clause = Clause([cond1_1, cond1_2])
            node_1.add_predicate(clause)

            # Create tree node 2
            next_headers = [CARS_TABLE_HEADERS[0], "step1_model","step1_max_speed_avg"]
            # TODO: Need to discuss about how to name variables from previous step
            node_2 = EVQLNode(next_headers)
            node_2.add_projection(Header(next_headers.index("step1_model")))
            
            cond2 = Selecting(next_headers.index("step1_max_speed_avg"),
                              Operator.greaterThan, "2000")
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
            node_1 = EVQLNode(CARS_TABLE_HEADERS)
            node_1.add_projection(Header(CARS_TABLE_HEADERS.index("max_speed"), agg_type=Aggregator.avg))
            # Create conditions for the node
            cond1_1 = Selecting(CARS_TABLE_HEADERS.index("year"), Operator.equal, "2010")
            node_1.add_predicate(Clause([cond1_1]))

            # Create tree node 2
            next_headers = CARS_TABLE_HEADERS+["step1_max_speed_avg"]
            node_2 = EVQLNode(next_headers)
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
            node_1 = EVQLNode(CARS_TABLE_HEADERS)
            node_1.add_projection(Header(CARS_TABLE_HEADERS.index("model")))
            node_1.add_projection(Header(CARS_TABLE_HEADERS.index("cars"), agg_type=Aggregator.count))
            # Create conditions for the node
            cond1_1 = Grouping(CARS_TABLE_HEADERS.index("model"))
            node_1.add_predicate(Clause([cond1_1]))

            # Create tree node 2
            next_headers = CARS_TABLE_HEADERS+["step1_cars_count"]
            node_2 = EVQLNode(next_headers,foreach_col_id=next_headers.index("model"))
            node_2.add_projection(Header(next_headers.index("model")))
            # Create conditions for the node
            cond2 = Selecting(next_headers.index("step1_cars_count"), Operator.greaterThan, "2")
            node_2.add_predicate(Clause([cond2]))

            # Create tree node 3
            next_headers = CARS_TABLE_HEADERS+["step2_model"]
            node_3 = EVQLNode(next_headers)
            node_3.add_projection(Header(next_headers.index("id")))
            # Create conditions for the node
            cond3 = Selecting(next_headers.index("step2_model"), Operator.exists, None)
            node_3.add_predicate(Clause([cond3]))
            self._evql = EVQLTree(node_3, [EVQLTree(node_2, [EVQLTree(node_1, enforce_t_alias=True)])])
        return self._evql

