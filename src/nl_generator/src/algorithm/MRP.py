import networkx as nx

from src.algorithm.string_builder import StringBuilder
from src.query_graph.koutrika_query_graph import (Attribute, Function,
                                                  Grouping, Having, Membership,
                                                  Node, Order, Predicate,
                                                  Query_graph, Relation,
                                                  Selection, Transformation,
                                                  Value)

IS_DEBUG = True


def debug_print(msg):
    if not IS_DEBUG:
        return None
    print(msg)


class MRP():
    """
        MULTIPLE_REFERENCE_POINTS algorithm
        Input:
            - current_node: node (the node being processed in each call)
            - rp: node (reference point for v)
            - parent_node: node (the parent node of v)
            - query_graph: graph 
            - open: list (nodes to be visited)
            - close: list (nodes already visited)
            - path: list (storing the edges between rp and v)
            - cStr: clause
        Output:
            - cStr (clause)
    """
    def __init__(self):
        self.visited_nodes = set()
        self.path = []
        self.group_by_nodes = []
        self.order_by_nodes = []
        self.having_clause = []

    @property
    def has_group_by(self):
        return len(self.group_by_nodes) > 0
    
    @property
    def has_having(self):
        return len(self.having_clause) > 0
    
    @property
    def has_order_by(self):
        return len(self.order_by_nodes) > 0

    def __call__(self, *args, **kwargs) -> str:
        string_builder = self._call(*args, **kwargs)
        cStr = f"{string_builder.to_text()}"

        # My logic
        # Add string for group by
        if self.has_group_by:
            # Return nodes for group by and the reference point is the same
            cStr += f". Create group according to {' and '.join(self.group_by_nodes)}"
        # Add string for having by
        if self.has_having:
            # Return nodes for group by and the reference point is the same
            cStr += f". Consider only groups whose  {' and '.join(self.having_clause)}"
        # Add string for order by
        if self.has_order_by:
            cStr += f" order by {' and '.join([node.label for node in self.order_by_nodes])}"

        return f"Find {cStr}."

    def _call(self, current_node, parent_node, previous_reference_point, query_graph, opened=[], cStr=""):
        def get_non_visited_outgoing_nodes(node: Node):
            return [dst for dst in query_graph.get_out_going_nodes(node) if dst not in self.visited_nodes]
        def get_next_non_visited_relation(node: Node):
            dst_nodes = get_non_visited_outgoing_nodes(node)
            assert len(dst_nodes) < 2, f"there should be only one out going node, but found {len(dst_nodes)}"
            dst_node = dst_nodes[0] if dst_nodes else None
            # Return relation node
            if type(dst_node) == Relation or dst_node is None:
                return dst_node
            return get_next_non_visited_relation(dst_node)
        def pop_nodes_from_path(has_membership):
            """Pop two nodes from the path:
                If the current node has membership edges, we generate the description from the current node to the previous reference point
                If the current node has no membership edges, we generate the description from the previous reference point to the current node
            """
            if has_membership:
                dst_node, src_node = self.path.pop(-1)
            else:
                src_node, dst_node = self.path.pop(0)
            return (src_node, dst_node)
            

        # Initialize the string builder
        string_builder = StringBuilder()

        # Set visited 
        debug_print(f"Current node: {current_node.name}")
        self.visited_nodes.add(current_node)
        
        # Save the traversed path
        if parent_node:
            assert query_graph.has_path(parent_node, current_node), f"Current node {current_node} is not reachable from Parent node {parent_node}"
            self.path.append([parent_node, current_node])

        # Construct a description for the reference point
        if current_node in query_graph.reference_points:
            # Check if the current node has an membership edge
            has_membership = query_graph.has_membership_edge(current_node)

            if has_membership:
                # Create a full description for the current node
                string_builder.add(self.label_mv(query_graph, current_node, current_node))

            # Create a description for traversed path
            while self.path:
                # Get nodes of an edge to translate
                src_node, dst_node = pop_nodes_from_path(has_membership)

                # Get the edge description
                edge_desc = self.label_edge(query_graph, src_node, dst_node)

                # Get the node description.    
                dst_desc = self.label_node(dst_node)

                # If the node is not the previous visited reference point, generate the full description (i.e., including predicate and etc)
                if dst_node != previous_reference_point:
                    reference_point_to_ground_to = current_node if has_membership else previous_reference_point
                    string_builder.add(self.label_v(query_graph, reference_point_to_ground_to, dst_node))

                # Add the join condition description
                string_builder.add_join_conditions(previous_reference_point.label, current_node.label, edge_desc, dst_desc, has_membership)

        # State changing: New reference point
        next_referece_point = current_node if current_node in query_graph.reference_points else previous_reference_point

        # Propagate recursive call to next non-visited nodes
        for dst in get_non_visited_outgoing_nodes(current_node):
            if dst not in self.visited_nodes:
                opened.append((dst, current_node, next_referece_point))

        while opened:
            pop_current_node, pop_parent_node, pop_referece_point = opened.pop(-1)
            string_builder.add(self._call(pop_current_node, pop_parent_node, pop_referece_point, query_graph, [], ""))

        return string_builder

    def label_node(self, node: Node) -> str:
        return node.label
    
    def label_edge(self, query_graph: Query_graph, src_node: Node, dst_node: Node) -> str:
        """Get the description of the edge between two nodes

        :param src_node: source node of the edge
        :type src_node: Node
        :param dst_node: destination node of the edge
        :type dst_node: Node
        :param query_graph: query graph
        :type query_graph: Query_graph
        :return: description of the edge
        :rtype: str
        """
        edge = query_graph.get_edge(src_node, dst_node)
        return edge.label
    
    def label_mv(self, query_graph: Query_graph, reference_point: Node, relation: Node) -> StringBuilder:
        """This function returns text description of the projected and selection attributes of a relation
        :param node: node of a query graph
        :type node: Node
        :param graph: query graph
        :type graph: Graph
        :return: description of the projected attribute of the relation
        :rtype: str
        """
        if type(relation) != Relation:
            return StringBuilder()
        assert type(relation) == Relation, f"Node must be a relation, but got {type(relation)}"
        string_builder = StringBuilder()

        # Check if aggregation function is applied
        # For all projected attributes of the relation
        for attribute in query_graph.get_membership_nodes(relation):
            # Check if any aggregation function is applied
            function_node = query_graph.get_function_node_to(attribute)
            agg_func_label = function_node.label if function_node else None
            # Add projection info
            string_builder.add_projection(relation.label, attribute.label, agg_func_label)
            # Mark visited
            self.visited_nodes.add(attribute)

        # Get description for the selection conditions
        string_builder.add(self.label_v(query_graph, reference_point, relation))
        
        return string_builder

    def label_v(self, graph: Query_graph, reference_point: Node, relation: Node) -> StringBuilder:
        """Return text description of node's where conditions
        :param graph: query graph
        :type graph: Graph
        :param node: node of a query graph
        :type node: Node
        :return: description of the where conditions of the node
        :rtype: str
        """
        if type(relation) != Relation:
            return StringBuilder()
        assert type(relation) == Relation, f"Node must be a relation, but got {type(relation)}"
        string_builder = StringBuilder()

        for att in graph.get_out_going_nodes(relation):
            out_edge_from_relation = graph.get_edge(relation, att)
            # Check if the edge is selection
            if type(out_edge_from_relation) == Selection:
                for dst in graph.get_out_going_nodes(att):
                    out_edge_from_att = graph.get_edge(att, dst)
                    # Create a description if: Relation_node -> Selection_edge -> Attribute_node -> Predicate_edge
                    if type(out_edge_from_att) == Predicate:
                        # Mark visited nodes
                        self.visited_nodes.add(att)
                        self.visited_nodes.add(dst)
                        if type(dst) == Value:
                            string_builder.add_selection(reference_point.label, relation.label, att.label, out_edge_from_att.label, dst.label)
                        elif type(dst) == Attribute:
                            # Get parent relations
                            associated_relations = list(filter(lambda n: type(n) == Relation, graph.get_out_going_nodes(dst)))
                            assert len(associated_relations) == 1, f"Unexpected number of parent relations, {len(associated_relations)} "
                            associated_relation = associated_relations[0]
                            # If the associated relation is already visited, there is a cycle in the query graph, which means correlated nested query
                            if associated_relation in self.visited_nodes:
                                dst_parent_label = reference_point.label if reference_point.label == associated_relation.label else relation.label
                                dst_label = f"{dst.label}"
                                string_builder.add_selection(reference_point.label, associated_relation.label, att.label, out_edge_from_att.label, dst_label, dst_parent_label)
                            else:
                                nested_string_builder = self._call(associated_relation, None, None, graph, [], "")
                                value_str = nested_string_builder.to_text()
                                string_builder.add_selection(reference_point.label, associated_relation.label, att.label, out_edge_from_att.label, value_str, None)
                        elif type(dst) == Function:
                            # Get attribute
                            node_list = [n for n in graph.get_out_going_nodes(dst) if type(n) == Attribute]
                            assert len(node_list) == 1, f"Unexpected number of attirbute, {len(node_list)} "
                            next_att_node = node_list[0]
                            # Get parent relations
                            associated_relations = [n for n in graph.get_out_going_nodes(next_att_node) if type(n) == Relation]
                            assert len(associated_relations) == 1, f"Unexpected number of parent relations, {len(associated_relations)} "
                            associated_relation = associated_relations[0]
                            # If the associated relation is already visited, there is a cycle in the query graph, which means correlated nested query
                            if associated_relation in self.visited_nodes:
                                dst_parent_label = reference_point.label if reference_point.label == associated_relation.label else relation.label
                                dst_label = f"{dst.label} {next_att_node}"
                                string_builder.add_selection(reference_point.label, associated_relation.label, att.label, out_edge_from_att.label, dst_label, dst_parent_label)
                            else:
                                nested_string_builder = self._call(associated_relation, None, None, graph, [], "")
                                value_str = nested_string_builder.to_text()
                                string_builder.add_selection(reference_point.label, associated_relation.label, att.label, out_edge_from_att.label, value_str, None)

            elif type(out_edge_from_relation) == Grouping:
                # Initialize the state for traversing all grouping attributes
                selected_node = att
                selected_edge = out_edge_from_relation
                # Get all attributes for grouping
                while type(selected_edge) == Grouping and type(selected_node) == Attribute:
                    # Mark visited
                    self.visited_nodes.add(selected_node)
                    
                    # Add the description for the grouping
                    string_builder.add_grouping(reference_point.label, relation.label, selected_node.label)
                    
                    # Get next node and stop if there is no next node
                    next_nodes = graph.get_out_going_nodes(selected_node)
                    assert len(next_nodes) < 2, f"Expected only one outgoing node connnected to grouping attribute, but found {len(next_nodes)} "
                    if not next_nodes:
                        break
                    
                    # State change: to the next node
                    next_node = next_nodes[0]
                    
                    # State change: to the next edge
                    selected_edge = graph.get_edge(selected_node, next_node)
                    selected_node = next_node

            elif type(out_edge_from_relation) == Having:
                # Get function node
                function_node = graph.get_function_node_from(att)
                assert function_node, f"Having condition must be connected to function node, but found {function_node} "
                
                # Get value node
                out_nodes = graph.get_out_going_nodes(function_node)
                assert len(out_nodes) == 1, f"Having condition must be connected to only one node, but found {len(out_nodes)} "
                assert type(out_nodes[0]) == Value, f"Having condition must be connected to value node, but found {type(out_nodes[0])} "
                value_node = out_nodes[0]
                
                # Check edge type
                out_edge = graph.get_edge(function_node, value_node)
                assert type(out_edge) == Predicate, f"Having attribute must be connected to value node through Predicate edge, but found {type(out_edge)} "
                
                # Mark visited
                self.visited_nodes.add(function_node)
                self.visited_nodes.add(value_node)
                
                # Append description for the having condition
                string_builder.add_having(reference_point.label, relation.label, att.label, function_node.label, out_edge.label, value_node.label)

        # Check if current node has attributes and values
        return string_builder
    
    def label_having(self, graph: Query_graph, relation: Node, attribute: Node) -> StringBuilder:
        """Return text description of node's having conditions
        :param graph: query graph
        :type graph: Graph
        :param node: node of a query graph
        :type node: Node
        :return: description of the where conditions of the node
        :rtype: str
        """
        string_builder = StringBuilder()
        # Get function node
        function_node = graph.get_function_node_from(attribute)
        if function_node:
            for dst in graph.get_out_going_nodes(function_node):
                edge = graph.get_edge(function_node, dst)
                if type(edge) == Predicate and type(dst) == Value:
                    self.visited_nodes.add(function_node)
                    self.visited_nodes.add(dst)
                    string_builder.add_having(relation.label, attribute.label, function_node.label, edge.label, dst.label)

        return string_builder