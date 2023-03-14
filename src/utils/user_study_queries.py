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
        self._DB=MovieDB()
    @misc_utils.property_with_cache
    def evql(self) -> EVQLTree:
        # Create tree node
        node = EVQLNode(f"movie_query_1", self._DB.get_table("movie"))
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
    def result_tables(self) -> List[TableExcerpt]:
        def result_1() -> TableExcerpt:
            result_table=self._DB.get_result_table(self._sql, "MovieQuery1")
            return result_table
        return [result_1()]
        
    @misc_utils.property_with_cache
    def query_tree(self):
        pass


class MovieQuery2(TestQuery):
    def __init__(self):
        super(MovieQuery2, self).__init__()
        self._sql = """SELECT T1.first_name, T1.last_name FROM actor T1 ORDER BY first_name
                    """
        self._DB=MovieDB()
    @misc_utils.property_with_cache
    def evql(self) -> EVQLTree:
        # Create tree node
        node = EVQLNode(f"movie_query_2", self._DB.get_table("actor"))
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
    def result_tables(self) -> List[TableExcerpt]:
        def result_1() -> TableExcerpt:
            result_table=self._DB.get_result_table(self._sql, "MovieQuery1")
            return result_table
        return [result_1()]

    @misc_utils.property_with_cache
    def query_tree(self):
        pass


class MovieQuery3(TestQuery):
    def __init__(self):
        super(MovieQuery3, self).__init__()
        self._sql = """SELECT T1.title, T2.stars FROM movie AS T1 
        JOIN rating AS T2 ON T1.id=T2.mov_id JOIN reviewer AS T3 ON T2.rev_id = T3.id 
        WHERE T3.name = "Josh Cates" and T2.stars > 4.5;
                    """
        self._DB=MovieDB()

    @misc_utils.property_with_cache
    def evql(self) -> EVQLTree:
        #init_table1 = TableExcerpt.fake_join("movie_rating_reviewer", [self._DB.get_table("movie"), self._DB.get_table("rating"), self._DB.get_table("reviewer")], ["movie_", "rating_", "reviewer_"])
        init_table1 = TableExcerpt.fake_join("movie_rating_reviewer", [self._DB.get_table("movie"), self._DB.get_table("rating"), self._DB.get_table("reviewer")])

        #mapping1 = [
        #    (0, init_table1.headers.index("id"), "id"),
        #    (0, init_table1.headers.index("stars"), "stars"),
        #    (1, init_table1.headers.index("id"), "id"),
        #]# (evql_row_idx, evql_colum_idx, sql_colum_name)

        # Create tree node
        node = EVQLNode(f"movie_query_3", init_table1)
        print(node.headers)
        #node_1 = EVQLNode(f"movie_query_3", init_table1, mapping=mapping1)
        #node.add_projection(Header(node.headers.index("movie_title")))
        #node.add_projection(Header(node.headers.index("rating_stars")))
        node.add_projection(Header(node.headers.index("title")))
        node.add_projection(Header(node.headers.index("stars")))

        # Create conditions for the node
        #cond1 = Selecting(node.headers.index("reviewer_name"), Operator.equal, "Josh Cates")
        #cond2 = Selecting(node.headers.index("rating_stars"), Operator.greaterThan, "4.5")
        cond1 = Selecting(node.headers.index("name"), Operator.equal, "Josh Cates")
        cond2 = Selecting(node.headers.index("stars"), Operator.greaterThan, "4.5")
        clause = Clause([cond1, cond2])
        node.add_predicate(clause)

        # Construct tree
        return EVQLTree(node)
        
    @misc_utils.property_with_cache
    def query_graphs(self) -> List[Query_graph]:
        def graph_1() -> Query_graph:
            ## Initialize nodes
            # Relation
            movie = Relation("movie", "movie")
            rating = Relation("rating", "rating")
            reviewer = Relation("reviewer", "reviewer")

            # Attribute
            mov_title = Attribute("mov_title", "title")
            rating_stars = Attribute("rating_stars", "stars")
            #mov_id = Attribute("mov_id", "id")
            #rating_mov_id = Attribute("rating_mov_id", "mov_id")
            #rating_rev_id = Attribute("rating_rev_id", "rev_id")
            #rev_id = Attribute("rev_id", "id")
            rev_name = Attribute("rev_name", "name")
            rating_stars_2 = Attribute("rating_stars_2", "stars")
            
            # Values
            v_rev_name = Value("Josh Cates", "Josh Cates")
            v_stars = Value("4.5", "4.5")
            
            # Function
            # avg = Function(FunctionType.Avg)
            ## Construct graph
            query_graph = Query_graph("MovieQuery3")
            query_graph.connect_membership(movie, mov_title)
            query_graph.connect_membership(reviewer, rev_name)
            # query_graph.connect_transformation(avg, max_speed)
            
            query_graph.connect_simplified_join(movie, rating)
            query_graph.connect_simplified_join(rating, reviewer)

            query_graph.connect_selection(reviewer, rev_name)
            query_graph.connect_predicate(rev_name, v_rev_name)

            query_graph.connect_selection(rating, rating_stars_2)
            query_graph.connect_predicate(rating_stars_2, v_stars, OperatorType.GreaterThan)
            return query_graph

        return [graph_1()]

    @misc_utils.property_with_cache
    def result_tables(self) -> List[TableExcerpt]:
        def result_1() -> TableExcerpt:
            result_table=self._DB.get_result_table(self._sql, "MovieQuery3")
            return result_table
        return [result_1()]
        
    @misc_utils.property_with_cache
    def query_tree(self):
        pass


class MovieQuery4(TestQuery):
    def __init__(self):
        super(MovieQuery2, self).__init__()
        self._sql = """SELECT T1.first_name, T1.last_name FROM actor T1 ORDER BY first_name
                    """
        self._DB=MovieDB()
    @misc_utils.property_with_cache
    def evql(self) -> EVQLTree:
        # Create tree node
        node = EVQLNode(f"movie_query_2", self._DB.get_table("actor"))
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
    def result_tables(self) -> List[TableExcerpt]:
        def result_1() -> TableExcerpt:
            result_table=self._DB.get_result_table(self._sql, "MovieQuery1")
            return result_table
        return [result_1()]
        
    @misc_utils.property_with_cache
    def query_tree(self):
        pass


class MovieQuery5(TestQuery):
    def __init__(self):
        super(MovieQuery2, self).__init__()
        self._sql = """SELECT T1.first_name, T1.last_name FROM actor T1 ORDER BY first_name
                    """
        self._DB=MovieDB()
    @misc_utils.property_with_cache
    def evql(self) -> EVQLTree:
        # Create tree node
        node = EVQLNode(f"movie_query_2", self._DB.get_table("actor"))
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
    def result_tables(self) -> List[TableExcerpt]:
        def result_1() -> TableExcerpt:
            result_table=self._DB.get_result_table(self._sql, "MovieQuery1")
            return result_table
        return [result_1()]
        
    @misc_utils.property_with_cache
    def query_tree(self):
        pass



class MovieQuery6(TestQuery):
    def __init__(self):
        super(MovieQuery2, self).__init__()
        self._sql = """SELECT T1.first_name, T1.last_name FROM actor T1 ORDER BY first_name
                    """
        self._DB=MovieDB()
    @misc_utils.property_with_cache
    def evql(self) -> EVQLTree:
        # Create tree node
        node = EVQLNode(f"movie_query_2", self._DB.get_table("actor"))
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
    def result_tables(self) -> List[TableExcerpt]:
        def result_1() -> TableExcerpt:
            result_table=self._DB.get_result_table(self._sql, "MovieQuery1")
            return result_table
        return [result_1()]
        
    @misc_utils.property_with_cache
    def query_tree(self):
        pass
