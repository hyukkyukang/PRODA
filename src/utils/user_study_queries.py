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
        self._DB = MovieDB()

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
            result_table = self._DB.get_result_table(self._sql, "MovieQuery1")
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
        self._DB = MovieDB()

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
            query_graph.connect_order(actor, first_name_o)
            return query_graph

        return [graph_1()]

    @misc_utils.property_with_cache
    def result_tables(self) -> List[TableExcerpt]:
        def result_1() -> TableExcerpt:
            result_table = self._DB.get_result_table(self._sql, "MovieQuery1")
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
        self._DB = MovieDB()

    @misc_utils.property_with_cache
    def evql(self) -> EVQLTree:
        # init_table1 = TableExcerpt.fake_join("movie_rating_reviewer", [self._DB.get_table("movie"), self._DB.get_table("rating"), self._DB.get_table("reviewer")], ["movie_", "rating_", "reviewer_"])
        init_table1 = TableExcerpt.fake_join(
            "movie_rating_reviewer",
            [self._DB.get_table("movie"), self._DB.get_table("rating"), self._DB.get_table("reviewer")],
        )

        # mapping1 = [
        #    (0, init_table1.headers.index("id"), "id"),
        #    (0, init_table1.headers.index("stars"), "stars"),
        #    (1, init_table1.headers.index("id"), "id"),
        # ]# (evql_row_idx, evql_colum_idx, sql_colum_name)

        # Create tree node
        node = EVQLNode(f"movie_query_3", init_table1)
        print(node.headers)
        # node_1 = EVQLNode(f"movie_query_3", init_table1, mapping=mapping1)
        # node.add_projection(Header(node.headers.index("movie_title")))
        # node.add_projection(Header(node.headers.index("rating_stars")))
        node.add_projection(Header(node.headers.index("title")))
        node.add_projection(Header(node.headers.index("stars")))

        # Create conditions for the node
        # cond1 = Selecting(node.headers.index("reviewer_name"), Operator.equal, "Josh Cates")
        # cond2 = Selecting(node.headers.index("rating_stars"), Operator.greaterThan, "4.5")
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
            # mov_id = Attribute("mov_id", "id")
            # rating_mov_id = Attribute("rating_mov_id", "mov_id")
            # rating_rev_id = Attribute("rating_rev_id", "rev_id")
            # rev_id = Attribute("rev_id", "id")
            rev_name = Attribute("rev_name", "name")
            rev_name_2 = Attribute("rev_name_2", "name")
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

            query_graph.connect_selection(reviewer, rev_name_2)
            query_graph.connect_predicate(rev_name_2, v_rev_name)

            query_graph.connect_selection(rating, rating_stars_2)
            query_graph.connect_predicate(rating_stars_2, v_stars, OperatorType.GreaterThan)
            return query_graph

        return [graph_1()]

    @misc_utils.property_with_cache
    def result_tables(self) -> List[TableExcerpt]:
        def result_1() -> TableExcerpt:
            result_table = self._DB.get_result_table(self._sql, "MovieQuery3")
            return result_table

        return [result_1()]

    @misc_utils.property_with_cache
    def query_tree(self):
        pass


class MovieQuery4(TestQuery):
    def __init__(self):
        super(MovieQuery4, self).__init__()
        self._sql = """SELECT T3.id, T3.first_name, T3.last_name, count(*) 
FROM movie AS T1 JOIN direction AS T2 ON T1.id=T2.mov_id JOIN director AS T3 ON T2.dir_id = T3.id 
GROUP BY T3.id;
                    """
        self._DB = MovieDB()

    @misc_utils.property_with_cache
    def evql(self) -> EVQLTree:
        # init_table1 = TableExcerpt.fake_join("movie_rating_reviewer", [self._DB.get_table("movie"), self._DB.get_table("rating"), self._DB.get_table("reviewer")], ["movie_", "rating_", "reviewer_"])
        init_table1 = TableExcerpt.fake_join(
            "movie_direction_director",
            [self._DB.get_table("movie"), self._DB.get_table("direction"), self._DB.get_table("director")],
            prefixes=["movie_", "direction_", "director_"],
            join_atts=[[0, 1, "id", "mov_id", "inner"], [1, 2, "dir_id", "id", "inner"]],
        )

        # mapping1 = [
        #    (0, init_table1.headers.index("id"), "id"),
        #    (0, init_table1.headers.index("stars"), "stars"),
        #    (1, init_table1.headers.index("id"), "id"),
        # ]# (evql_row_idx, evql_colum_idx, sql_colum_name)

        # Create tree node
        node = EVQLNode(f"movie_query_4", init_table1)
        print(node.headers)
        # node_1 = EVQLNode(f"movie_query_3", init_table1, mapping=mapping1)
        # node.add_projection(Header(node.headers.index("movie_title")))
        # node.add_projection(Header(node.headers.index("rating_stars")))
        node.add_projection(Header(node.headers.index("director_id")))
        node.add_projection(Header(node.headers.index("director_first_name")))
        node.add_projection(Header(node.headers.index("director_last_name")))
        node.add_projection(Header(node.headers.index("director_last_name")))
        node.add_projection(
            Header(node.headers.index("movie_direction_director"), agg_type=Aggregator.count, alias="count")
        )

        # Create conditions for the node
        node.add_predicate(Clause([Grouping(node.headers.index("director_id"))]))

        # Construct tree
        return EVQLTree(node)

    @misc_utils.property_with_cache
    def query_graphs(self) -> List[Query_graph]:
        def graph_1() -> Query_graph:
            ## Initialize nodes
            # Relation
            movie = Relation("movie", "movie")
            direction = Relation("direction", "direction")
            director = Relation("director", "director")

            # Attribute
            mov_id = Attribute("dir_id", "id")
            director_first_name = Attribute("director_first_name", "first_name")
            director_last_name = Attribute("director_last_name", "last_name")
            star_node = Attribute("*", "all")
            # mov_id = Attribute("mov_id", "id")
            # rating_mov_id = Attribute("rating_mov_id", "mov_id")
            # rating_rev_id = Attribute("rating_rev_id", "rev_id")
            # rev_id = Attribute("rev_id", "id")
            dir_id = Attribute("dir_id", "id")

            # Function
            count = Function(FunctionType.Count)
            ## Construct graph
            query_graph = Query_graph("MovieQuery4")
            query_graph.connect_membership(director, dir_id)
            query_graph.connect_membership(director, director_first_name)
            query_graph.connect_membership(director, director_last_name)
            query_graph.connect_membership(movie, star_node)
            query_graph.connect_transformation(count, star_node)

            query_graph.connect_simplified_join(movie, direction)
            query_graph.connect_simplified_join(direction, director)

            query_graph.connect_grouping(director, dir_id)
            return query_graph

        return [graph_1()]

    @misc_utils.property_with_cache
    def result_tables(self) -> List[TableExcerpt]:
        def result_1() -> TableExcerpt:
            result_table = self._DB.get_result_table(self._sql, "MovieQuery3")
            return result_table

        return [result_1()]

    @misc_utils.property_with_cache
    def query_tree(self):
        pass


class MovieQuery5(TestQuery):
    def __init__(self):
        super(MovieQuery5, self).__init__()
        self._sql = """SELECT M1.id
                    FROM   movie AS M1
                        JOIN rating AS R1
                            ON M1.id = R1.mov_id
                    WHERE  R1.stars < (SELECT Max(R2.stars)
                                    FROM   movie AS M2
                                            JOIN rating AS R2
                                                ON M2.id = R2.mov_id
                                    WHERE  M2.id = M1.id)
                        AND M1.id IN (SELECT M3.id
                                        FROM   movie AS M3
                                                JOIN direction AS MD
                                                ON M3.id = MD.mov_id
                                                JOIN director AS D
                                                ON MD.dir_id = D.id
                                        WHERE  D.first_name = "James"
                                                AND D.last_name = "Cameron")
                    GROUP  BY M1.id
                    HAVING Avg(R1.stars) >= 5.5
                    """
        self._DB = MovieDB()

    @misc_utils.property_with_cache
    def evql(self) -> EVQLTree:
        # Create tree node 1
        init_table1 = TableExcerpt.fake_join(
            "movie_rating",
            [self._DB.get_table("movie"), self._DB.get_table("rating")],
            prefixes=["movie_", "rating_"],
            join_atts=[[0, 1, "id", "mov_id", "inner"]],
        )
        result_tables = self.result_tables

        mapping1 = [
            (0, init_table1.headers.index("movie_id"), "id"),
            (0, init_table1.headers.index("rating_stars"), "stars"),
            (1, init_table1.headers.index("movie_id"), "id"),
        ]

        node_1 = EVQLNode(f"MovieQuery5_B1", init_table1, mapping=mapping1)
        node_1.add_projection(Header(node_1.headers.index("movie_id"), alias="movie_id"))
        node_1.add_projection(
            Header(node_1.headers.index("rating_stars"), agg_type=Aggregator.max, alias="max_rating_stars")
        )
        node_1.add_predicate(Clause([Grouping(node_1.headers.index("movie_id"))]))
        # Query result
        node_1_result = result_tables[0]

        # Create tree node 2
        init_table2 = TableExcerpt.fake_join(
            "movie_direction_director",
            [self._DB.get_table("movie"), self._DB.get_table("direction"), self._DB.get_table("director")],
            prefixes=["movie_", "direction_", "director_"],
            join_atts=[[0, 1, "id", "mov_id", "inner"], [1, 2, "dir_id", "id", "inner"]],
        )

        mapping2 = [
            (0, init_table2.headers.index("movie_id"), "id"),
            (1, init_table2.headers.index("director_first_name"), "first_name"),
            (2, init_table2.headers.index("director_last_name"), "last_name"),
        ]

        node_2 = EVQLNode(f"MovieQuery5_B2", init_table2, mapping=mapping2)
        node_2.add_projection(Header(node_2.headers.index("movie_id"), alias="movie_id"))
        node_2.add_predicate(
            Clause(
                [
                    Selecting(node_2.headers.index("director_first_name"), Operator.equal, "James"),
                    Selecting(node_2.headers.index("director_last_name"), Operator.equal, "Cameron"),
                ]
            )
        )

        node_2_result = result_tables[1]

        # Create tree node 3
        init_table3 = TableExcerpt.fake_join(
            "movie_rating_B2",
            [self._DB.get_table("movie"), self._DB.get_table("rating"), node_1_result],
            prefixes=["movie_", "rating_", "B1_"],
            join_atts=[[0, 1, "id", "mov_id", "inner"], [0, 2, "id", "movie_id", "left_outer"]],
        )
        init_table3 = TableExcerpt.concatenate("B3_table_excerpt", init_table3, node_2_result, prefixes=["", "B2_"])

        for row in init_table3.rows:
            row_printable = [cell.dtype for cell in row.cells]
            print(row_printable)
        mapping3 = [
            (0, init_table3.headers.index("movie_id"), "id"),
            (0, init_table3.headers.index("rating_stars"), "stars"),
            (1, init_table3.headers.index("movie_id"), "id"),
            (1, init_table3.headers.index("rating_stars"), "stars"),
        ]

        node_3 = EVQLNode(f"MovieQuery5_B3", init_table3, mapping=mapping3)
        node_3.add_projection(Header(node_3.headers.index("movie_id"), alias="movie_id"))
        node_3.add_projection(
            Header(node_3.headers.index("rating_stars"), agg_type=Aggregator.avg, alias="avg_rating_stars")
        )
        node_3.add_predicate(
            Clause(
                [
                    Selecting(
                        node_3.headers.index("movie_id"),
                        Operator.In,
                        Operator.add_idx_prefix(node_3.headers.index("B2_movie_id")),
                    ),
                    Selecting(
                        node_3.headers.index("rating_stars"),
                        Operator.lessThan,
                        Operator.add_idx_prefix(node_3.headers.index("B1_max_rating_stars")),
                    ),
                ]
            )
        )

        node_3_result = result_tables[2]

        # Create tree node 4
        mapping4 = [
            (0, node_3_result.headers.index("movie_id"), "movie_id"),
            (1, node_3_result.headers.index("avg_rating_stars"), "avg_rating_stars"),
        ]

        node_4 = EVQLNode(f"MovieQuery5_B4", node_3_result, mapping=mapping4)
        node_4.add_projection(Header(node_4.headers.index("movie_id"), alias="movie_id"))
        node_4.add_predicate(
            Clause([Selecting(node_4.headers.index("avg_rating_stars"), Operator.greaterThanOrEqual, 5.5)])
        )

        return EVQLTree(node_4, children=[EVQLTree(node_3, children=[EVQLTree(node_2), EVQLTree(node_1)])])

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
                    alias="movie_id",
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
                    r_operand="James",
                ),
                Selection(
                    l_operand=get_global_index(node_b2_tables, 2, "last_name"),
                    operator="=",
                    r_operand="Cameron",
                ),
            ],
            sql="""SELECT M3.id 
                    FROM movie AS M3 JOIN direction AS MD ON M3.id = MD.mov_id
                        JOIN director AS D ON MD.dir_id = D.id
                    WHERE D.first_name = 'James' AND D.last_name = 'Cameron'
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
                    r_operand=get_global_index(node_b3_tables, 2, "movie_id"),
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
            sql="SELECT B3.id as id FROM B3 WHERE B3.avg_stars >= 5.5",
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
            v_first_name = Value("James", "James")
            v_last_name = Value("Cameron", "Cameron")

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

            rating_1_stars0 = Attribute("r1_stars", "stars")
            rating_1_stars1 = Attribute("r1_stars1", "stars")
            rating_2_stars = Attribute("r2_stars", "stars")

            rating_1_stars2 = Attribute("r1_stars2", "stars")
            director_last_name = Attribute("last_name", "last_name")
            director_first_name = Attribute("first_name", "first_name")

            # Function
            rating_max = Function(FunctionType.Max)
            rating_avg = Function(FunctionType.Avg)

            # Values
            v_first_name = Value("James", "James")
            v_last_name = Value("Cameron", "Cameron")

            ## Construct graph
            query_graph = Query_graph("CorrelatedNestedQuery3")
            query_graph.connect_membership(movie_1, movie_1_id1)

            query_graph.connect_simplified_join(movie_1, rating_1, "", "belongs to")
            # hkkang
            query_graph.connect_membership(rating_1, rating_1_stars0)
            query_graph.connect_transformation(rating_avg, rating_1_stars0)

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

        def graph_3_individual() -> Query_graph:
            # Relation
            movie = Relation("movie", "movie", is_primary=True)
            Q1result = Relation("Q1result", "Q1's results")
            Q2result = Relation("Q2result", "Q2's results")
            rating = Relation("rating", "rating", is_primary=True)

            # Attribute
            movie_id1 = Attribute("m1_id1", "id")
            movie_id2 = Attribute("m1_id2", "id")
            movie_id3 = Attribute("m1_id3", "id")
            movie_id4 = Attribute("m1_id4", "id")

            rating_stars1 = Attribute("r1_stars", "stars")
            rating_stars2 = Attribute("r1_stars1", "stars")

            Q1_max_stars = Attribute("Q1_max_stars", "max_stars")
            Q1_movie_id = Attribute("Q1_movie_id", "movie_id")

            Q2_movie_ids = Attribute("Q2_movie_ids", "movie_id")

            rating_avg = Function(FunctionType.Avg)

            ## Construct graph
            query_graph = Query_graph("CorrelatedNestedQuery3")
            query_graph.connect_membership(movie, movie_id1)
            query_graph.connect_membership(rating, rating_stars1)
            query_graph.connect_transformation(rating_avg, rating_stars1)

            query_graph.connect_simplified_join(movie, rating, "", "belongs to")
            # query_graph.connect_simplified_join(movie, Q1result, "", "belongs to")
            # query_graph.connect_simplified_join(movie, Q2result)

            # Nesting
            query_graph.connect_selection(rating, rating_stars2)
            query_graph.connect_predicate(rating_stars2, Q1_max_stars, OperatorType.LessThan)

            query_graph.connect_membership(Q1result, Q1_max_stars)

            # Correlation - skip
            query_graph.connect_selection(Q1result, Q1_movie_id)
            query_graph.connect_predicate(Q1_movie_id, movie_id4)
            query_graph.connect_selection(movie_id4, movie)

            # Second Nesting
            query_graph.connect_selection(movie, movie_id2)
            query_graph.connect_predicate(movie_id2, Q2_movie_ids, OperatorType.In)

            query_graph.connect_membership(Q2result, Q2_movie_ids)
            # For grouping and having
            query_graph.connect_grouping(movie, movie_id3)
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
            v_first_name = Value("James", "James")
            v_last_name = Value("Cameron", "Cameron")
            v_3 = Value("5.5", "5.5")

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

        def graph_4_individual() -> Query_graph:
            ## Initialize nodes
            # Relation
            Q3result = Relation("Q3result", "Q3's results")

            # Attribute
            Q3_avg_stars = Attribute("Q3_avg_stars", "avg_stars")
            Q3_movie_id = Attribute("Q3_movie_id", "movie_id")

            ## Construct graph
            query_graph = Query_graph("CorrelatedNestedQuery4")
            query_graph.connect_membership(Q3result, Q3_movie_id)

            ## Value
            v_3 = Value("5.5", "5.5")

            # For grouping and having
            query_graph.connect_selection(Q3result, Q3_avg_stars)
            query_graph.connect_predicate(Q3_avg_stars, v_3, OperatorType.GEq)
            return query_graph

        return [graph_4_individual(), graph_3_individual(), graph_2(), graph_1()]

    @misc_utils.property_with_cache
    def result_tables(self) -> List[TableExcerpt]:
        def result_1() -> TableExcerpt:
            node_1_name = "MovieQuery5_B1"
            node_1_result_headers = ["movie_id", "max_rating_stars"]
            node_1_result_col_types = ["number", "list.number"]
            node_1_result_rows = [
                [914, [7]],
                [915, [9.7]],
                [916, [4]],
                [920, [8.1]],
                [922, [8.4]],
                [923, [6.7]],
                [925, [7.7]],
            ]
            # node_1_result_col_types = ["number", "number"]
            # node_1_result_rows = [[901, 8.4], [902, 7.9], [903, 8.3], [906, 8.2], [908, 8.6], [909, 5], [910, 6], [911, 8.1], [912, 4.4], [914, 7],
            # [915, 9.7], [916, 4], [918, 2], [920, 8.1], [921, 8], [922, 8.4], [923, 6.7], [924, 7.3], [925, 7.7]]
            print(node_1_result_rows)
            node_1_result = TableExcerpt(
                f"{node_1_name}_result", node_1_result_headers, node_1_result_col_types, rows=node_1_result_rows
            )
            return node_1_result

        def result_2() -> TableExcerpt:
            node_2_name = "MovieQuery5_B2"
            node_2_result_headers = ["movie_id"]
            node_2_result_col_types = ["number"]
            node_2_result_rows = [[915], [922]]
            node_2_result = TableExcerpt(
                f"{node_2_name}_result", node_2_result_headers, node_2_result_col_types, rows=node_2_result_rows
            )
            return node_2_result

        def result_3() -> TableExcerpt:
            node_3_name = "MovieQuery5_B3"
            node_3_result_headers = ["movie_id", "avg_rating_stars"]
            node_3_result_col_types = ["number", "number"]
            node_3_result_rows = [[915, 7.2], [922, 5.13333]]
            node_3_result = TableExcerpt(
                f"{node_3_name}_result", node_3_result_headers, node_3_result_col_types, rows=node_3_result_rows
            )
            return node_3_result

        def result_4() -> TableExcerpt:
            node_4_name = "MovieQuery5_B4"
            node_4_result_headers = ["movie_id"]
            node_4_result_col_types = ["number"]
            node_4_result_rows = [[915]]
            node_4_result = TableExcerpt(
                f"{node_4_name}_result", node_4_result_headers, node_4_result_col_types, rows=node_4_result_rows
            )
            return node_4_result

        return [result_1(), result_2(), result_3(), result_4()]


class MovieQuery6(TestQuery):
    def __init__(self):
        super(MovieQuery6, self).__init__()
        self._sql = """SELECT T3.name
            FROM movie AS T1 JOIN rating AS T2 ON T1.id=T2.mov_id JOIN reviewer AS T3 ON T2.rev_id = T3.id 
            WHERE T1.time > 130
            GROUP BY T3.id
            HAVING count(*) > 1
                    """
        self._DB = MovieDB()

    @misc_utils.property_with_cache
    def evql(self) -> EVQLTree:
        init_table1 = TableExcerpt.fake_join(
            "movie_rating_reviewer",
            [self._DB.get_table("movie"), self._DB.get_table("rating"), self._DB.get_table("reviewer")],
            ["movie_", "rating_", "reviewer_"],
            join_atts=[[0, 1, "id", "mov_id", "inner"], [1, 2, "rev_id", "id", "inner"]],
        )
        result_tables = self.result_tables
        # mapping1 = [
        #    (0, init_table1.headers.index("id"), "id"),
        #    (0, init_table1.headers.index("stars"), "stars"),
        #    (1, init_table1.headers.index("id"), "id"),
        # ]# (evql_row_idx, evql_colum_idx, sql_colum_name)

        # Create tree node
        node_1 = EVQLNode(f"movie_query_6_B1", init_table1)
        node_1.add_projection(Header(node_1.headers.index("reviewer_name")))
        node_1.add_projection(
            Header(node_1.headers.index("movie_rating_reviewer"), agg_type=Aggregator.count, alias="cnt")
        )

        # Create conditions for the node
        cond1 = Selecting(node_1.headers.index("movie_time"), Operator.greaterThan, "130")
        cond2 = Grouping(node_1.headers.index("reviewer_id"))
        clause = Clause([cond1, cond2])
        node_1.add_predicate(clause)

        result_table = result_tables[0]
        print(result_table.headers)
        node_2 = EVQLNode(f"movie_query_6_B2", result_table)
        print(node_2.headers)
        node_2.add_projection(Header(node_2.headers.index("reviewer_name")))
        cond3 = Selecting(find_nth_occurrence_index(node_2.headers, "cnt", 1), Operator.greaterThan, "1")
        node_2.add_predicate(Clause([cond3]))

        # Construct tree
        return EVQLTree(node_2, children=[EVQLTree(node_1)])

    @misc_utils.property_with_cache
    def query_graphs(self) -> List[Query_graph]:
        def graph_1() -> Query_graph:
            ## Initialize nodes
            # Relation
            movie = Relation("movie", "movie")
            rating = Relation("rating", "rating")
            reviewer = Relation("reviewer", "reviewer")

            # Attribute
            rev_name = Attribute("rev_name", "name")
            star_node = Attribute("*", "all")
            rev_id = Attribute("rev_id", "id")
            mov_time = Attribute("mov_time", "time")

            # Values
            v_130 = Value("130", "130")

            # Function
            cnt = Function(FunctionType.Count)

            ## Construct graph
            query_graph = Query_graph("MovieQuery6_B1")
            query_graph.connect_membership(reviewer, rev_name)
            query_graph.connect_membership(movie, star_node)
            query_graph.connect_transformation(cnt, star_node)

            query_graph.connect_simplified_join(movie, rating)
            query_graph.connect_simplified_join(rating, reviewer)

            query_graph.connect_selection(movie, mov_time)
            query_graph.connect_predicate(mov_time, v_130)

            return query_graph

        def graph_2() -> Query_graph:
            ## Initialize nodes
            # Relation
            movie = Relation("movie", "movie")
            rating = Relation("rating", "rating")
            reviewer = Relation("reviewer", "reviewer")

            # Attribute
            rev_name = Attribute("rev_name", "name")
            star_node = Attribute("*", "all")
            rev_id = Attribute("rev_id", "id")
            mov_time = Attribute("mov_time", "time")

            # Values
            v_130 = Value("130", "130")
            v_1 = Value("1", "1")

            # Function
            cnt = Function(FunctionType.Count)

            ## Construct graph
            query_graph = Query_graph("MovieQuery6_B1")
            query_graph.connect_membership(reviewer, rev_name)

            query_graph.connect_simplified_join(movie, rating)
            query_graph.connect_simplified_join(rating, reviewer)

            query_graph.connect_selection(movie, mov_time)
            query_graph.connect_predicate(mov_time, v_130, OperatorType.GreaterThan)

            query_graph.connect_grouping(reviewer, rev_id)
            query_graph.connect_having(movie, star_node)
            query_graph.connect_transformation(star_node, cnt)
            query_graph.connect_predicate(cnt, v_1, OperatorType.GreaterThan)

            return query_graph

        return [graph_2(), graph_1()]

    @misc_utils.property_with_cache
    def result_tables(self) -> List[TableExcerpt]:
        def result_1() -> TableExcerpt:
            sql = """SELECT T3.name as reviewer_name, count(*) as cnt
            FROM movie AS T1 JOIN rating AS T2 ON T1.id=T2.mov_id JOIN reviewer AS T3 ON T2.rev_id = T3.id 
            WHERE T1.time > 130
            GROUP BY T3.id
                    """
            result_table = self._DB.get_result_table(sql, "MovieQuery6")
            return result_table

        def result_2() -> TableExcerpt:
            result_table = self._DB.get_result_table(self._sql, "MovieQuery6")
            return result_table

        return [result_1(), result_2()]

    @misc_utils.property_with_cache
    def query_tree(self):
        pass
