from typing import List, Any
import src.query_tree.query_tree as QueryTree
import src.query_tree.operator as QueryTreeOperator
import src.VQA.EVQA as EVQA
import src.table_excerpt.table_excerpt as TableExcerpt
import hkkang_utils.list as list_utils

RANDOMSTRING = "RANDOMSTRING"


def convert_queryTree_to_EVQATree(query_tree: QueryTree.QueryTree) -> EVQA.EVQATree:
    return convert_node(query_tree.root)


def convert_node(query_tree_node: QueryTree.Node) -> EVQA.EVQATree:
    # Create current EVQA Node
    ## Create Table excerpt
    # TODO: base table can be more dynamic. Table excerpt should be the a table that is the combination of all the tables in children nodes
    all_headers = list_utils.do_flatten_list(
        [child_table.child.get_headers() for child_table in query_tree_node.child_tables]
    )
    table_excerpt = TableExcerpt.TableExcerpt(
        name=RANDOMSTRING,
        headers=all_headers,
        col_types=[TableExcerpt.DString() for _ in all_headers],
        rows=query_tree_node.get_rows(),
    )

    ## Finalize the node
    evqa_node: EVQA.EVQANode = EVQA.EVQANode(name=RANDOMSTRING, table_excerpt=table_excerpt)

    # Add projections
    for header in create_projection_headers(query_tree_node):
        evqa_node.add_projection(header)

    # Add Predicates
    for clause in create_predicate_clauses(query_tree_node):
        evqa_node.add_predicate(clause)

    # Create Children EVQA Nodes
    children: List[EVQA.EVQATree] = []
    for edge_to_child in query_tree_node.child_tables:
        if type(edge_to_child.child) == QueryTree.QueryBlock:
            children.append(convert_node(edge_to_child.child))

    return EVQA.EVQATree(node=evqa_node, children=children)


def create_projection_headers(query_tree_node: QueryTree.QueryBlock) -> List[EVQA.Header]:
    # Get all the projections and aggregations
    projections: List[QueryTreeOperator.Projection] = list(
        filter(lambda k: type(k) == QueryTreeOperator.Projection, query_tree_node.operations)
    )
    aggregations: List[QueryTreeOperator.Aggregation] = list(
        filter(lambda k: type(k) == QueryTreeOperator.Aggregation, query_tree_node.operations)
    )
    foreaches: List[QueryTreeOperator.Foreach] = list(
        filter(lambda k: type(k) == QueryTreeOperator.Foreach, query_tree_node.operations)
    )

    # Create header for all projectoin attributes
    headers = []
    for projection in projections:
        column_id = projection.column_id
        # Get aggregation
        agg_list = list(filter(lambda agg: agg.column_id == column_id, aggregations))
        agg_type = None
        if agg_list:
            assert len(agg_list) == 1
            agg_type = EVQA.Aggregator.from_str(agg_list[0].func_type)
        # Append header
        headers.append(EVQA.Header(column_id + 1, agg_type))
    # Add attributes for correlation
    for foreach in foreaches:
        headers.append(EVQA.Header(foreach.column_id + 1))

    return headers


def create_predicate_clauses(qt_node: QueryTree.QueryBlock) -> List[EVQA.Clause]:
    """Assumption: all predicate are given in Disjunctive Normal Form (DNF)"""

    evqa_clauses: List[EVQA.Clause] = []
    selection_clauses = convert_selection(qt_node)
    if selection_clauses:
        evqa_clauses.extend(selection_clauses)

    # Convert Grouping
    grouping_clauses = convert_grouping(qt_node)
    if grouping_clauses:
        evqa_clauses.extend(grouping_clauses)

    # Convert Ordering
    ordering_clauses = convert_ordering(qt_node)
    if ordering_clauses:
        evqa_clauses.extend(ordering_clauses)

    return evqa_clauses


def convert_selection(qt_node: QueryTree.QueryBlock) -> List[EVQA.Clause]:
    def create_r_operand(r_operand: Any) -> Any:
        if type(r_operand) == int:
            # When the operand is column id
            return f"${r_operand+1}"
        elif type(r_operand) == str:
            # When the operand is a value
            return r_operand
        else:
            # When the operand is a nested query
            return r_operand

    def convert_selection_clause(qt_clause: QueryTreeOperator.Clause) -> EVQA.Clause:
        conditions: List[EVQA.Selecting] = []
        for qt_condition in qt_clause.conditions:
            conditions.append(
                EVQA.Selecting(
                    header_id=qt_condition.l_operand + 1,
                    op_type=EVQA.Operator.from_str(qt_condition.operator),
                    r_operand=create_r_operand(qt_condition.r_operand),
                )
            )
        return EVQA.Clause(conditions=conditions)

    evqa_clauses: List[EVQA.Clause] = []
    selections = list(filter(lambda k: type(k) == QueryTreeOperator.Selection, qt_node.operations))
    if selections:
        assert (
            len(selections) == 1
        ), f"Only one selection operator is allowed per query block, but {len(selections)} were found."
        # Convert all clauses
        for clause in selections[0].clauses:
            evqa_clauses.append(convert_selection_clause(clause))
    return evqa_clauses


def convert_grouping(qt_node: QueryTree.QueryBlock) -> List[EVQA.Clause]:
    evqa_clauses: List[EVQA.Clause] = []
    groupings = list(filter(lambda k: type(k) == QueryTreeOperator.Grouping, qt_node.operations))
    if groupings:
        for grouping in groupings:
            evqa_clauses.append(EVQA.Clause(conditions=[EVQA.Grouping(header_id=grouping.column_id + 1)]))
    return evqa_clauses


def convert_ordering(qt_node: QueryTree.QueryBlock) -> List[EVQA.Clause]:
    evqa_clauses: List[EVQA.Clause] = []
    orderings = list(filter(lambda k: type(k) == QueryTreeOperator.Ordering, qt_node.operations))
    if orderings:
        for ordering in orderings:
            evqa_clauses.append(
                EVQA.Clause(
                    conditions=[EVQA.Ordering(header_id=ordering.column_id + 1, is_ascending=ordering.ascending)]
                )
            )
    return evqa_clauses


if __name__ == "__main__":
    pass