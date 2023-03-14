import abc
import argparse
import json
from typing import List

from hkkang_utils import misc as misc_utils
from pylogos.query_graph.koutrika_query_graph import (
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
from src.utils.user_study_table_excerpt import MovieDB, AdvisingDB
from src.VQL.EVQL import Aggregator, Clause, EVQLNode, EVQLTree, Grouping, Header, Operator, Ordering, Selecting
from src.utils.example_queries import TestQuery, find_nth_occurrence_index


class MovieQuery1(TestQuery):
    def __init__(self):
        super(MovieQuery1, self).__init__()
        self._sql = """SELECT T1.title FROM movie T1 WHERE T1.year > 2000
                    """
    @misc_utils.property_with_cache
    def evql(self) -> EVQLTree:
        # Create tree node
        node = EVQLNode(f"movie_query_1", MovieDB.table("movie"))
        node.add_projection(Header(node.headers.index("title")))

        # Create conditions for the node
        cond1 = Selecting(node.headers.index("year"), Operator.greaterThan, "2000")
        clause = Clause([cond1])
        node.add_predicate(clause)

        # Construct tree
        return EVQLTree(node)
        
    @misc_utils.property_with_cache
    def query_graphs(self) -> List[Query_graph]:
        def graph_1() -> Query_graph:
            ## Initialize nodes
            # Relation
            movie = Relation("movie", "movie")
            # Attribute
            title = Attribute("title", "title")
            year = Attribute("year", "year")
            v_year = Value("2000", "2000")
            # Function
            # avg = Function(FunctionType.Avg)
            ## Construct graph
            query_graph = Query_graph("MovieQuery1")
            query_graph.connect_membership(movie, title)
            # query_graph.connect_transformation(avg, max_speed)
            query_graph.connect_selection(movie, year)
            query_graph.connect_predicate(year, v_year, OperatorType.GreaterThan)
            return query_graph

        return [graph_1()]

    @misc_utils.property_with_cache
    def query_tree(self):
        pass


class MovieQuery2(TestQuery):
    def __init__(self):
        super(MovieQuery2, self).__init__()
        self._sql = """SELECT T1.first_name, T1.last_name FROM actor T1 ORDER BY first_name
                    """
    @misc_utils.property_with_cache
    def evql(self) -> EVQLTree:
        # Create tree node
        node = EVQLNode(f"movie_query_2", MovieDB.table("actor"))
        node.add_projection(Header(node.headers.index("first_name")))
        node.add_projection(Header(node.headers.index("last_name")))

        # Create conditions for the node
        cond1 = Ordering(node.headers.index("first_name"), is_ascending=True)
        clause = Clause([cond1])
        node.add_predicate(clause)

        # Construct tree
        return EVQLTree(node)
        
    @misc_utils.property_with_cache
    def query_graphs(self) -> List[Query_graph]:
        def graph_1() -> Query_graph:
            ## Initialize nodes
            # Relation
            actor = Relation("actor", "actor")
            # Attribute
            first_name = Attribute("first_name", "first_name")
            last_name = Attribute("last_name", "last_name")
            first_name_o = Attribute("first_name", "first_name")
            # Function
            # avg = Function(FunctionType.Avg)
            ## Construct graph
            query_graph = Query_graph("MovieQuery2")
            query_graph.connect_membership(actor, first_name)
            query_graph.connect_membership(actor, last_name)
            # query_graph.connect_transformation(avg, max_speed)
            query_graph.connect_order(actor, first_name_o, is_asc=True)
            return query_graph

        return [graph_1()]

    @misc_utils.property_with_cache
    def query_tree(self):
        pass