from __future__ import annotations
from enum import IntEnum
from abc import *
from typing import List
import networkx as nx
import copy

# Type Definition
class AggregationType(IntEnum):
    Min = 0
    Max = 1
    Sum = 2
    Avg = 3
    Count = 4

class OperatorType(IntEnum):
    Greaterthan = 0
    Lessthan = 1
    Equal = 2
    Geq = 3
    Leq = 4
    In = 5
    NotIn = 6
    Exists = 7
    NotExists = 8
    Like = 9
    NotLike = 10
    NotEqual = 11

aggregationNameToType = {
    "Min": AggregationType.Min,
    "Max": AggregationType.Max,
    "Sum": AggregationType.Sum,
    "Avg": AggregationType.Avg,
    "Count": AggregationType.Count
}
operatorNameToType = {
    ">": OperatorType.Greaterthan,
    "<": OperatorType.Lessthan,
    "=": OperatorType.Equal,
    "!=": OperatorType.NotEqual,
    ">=": OperatorType.Geq,
    "<=": OperatorType.Leq,
    "IN": OperatorType.In,
    "NOT IN": OperatorType.NotIn,
    "EXISTS": OperatorType.Exists,
    "NOT EXISTS": OperatorType.NotExists,
    "LIKE": OperatorType.Like,
    "NOT LIKE": OperatorType.NotLike,
}

operatorTypeToName = [">", "<", "=", ">=", "<=", "In", "NotIn", "Exists", "NotExists", "Like", "NotLike", "!="]
aggregationTypeToName = ["Min", "Max", "Sum", "Avg", "Count"]

class OrderingType(IntEnum):
    Ascending = 0
    Descending = 1  
 
# Node
class Node(metaclass=ABCMeta):
    def __init__(self, name, query_block_idx=0, nesting_level=0):
        self.name = name
        self.edges = None # Outgoing edges
        self.query_block_idx = query_block_idx
        self.nesting_level = nesting_level
    
    @staticmethod
    def is_equivalent(node1, node2):
        return node1.name == node2.name and \
            node1.query_block_idx == node2.query_block_idx and \
                node1.nesting_level == node2.nesting_level
    
    @staticmethod
    def is_similar(node1, node2):
        return node1.name == node2.name
        
    @property
    # Return 1-hop neighbors traversal with its edges (edge direction considered)
    def neighbors(self):
        return []
        
    @property  
    def outgoing_edges(self):
        return [edge for edge in self.edges if edge.src == self]
    
    @property  
    def incoming_edges(self):
        return [edge for edge in self.edges if edge.dst == self]
    
    @property
    def set_query_block_idx(idx): # [ADDED]
        query_block_idx = idx
    
    @property
    def set_nesting_level(level): # [ADDED]
        nesting_level = level
 
class Relation(Node):
    def __init__(self, name, query_block_idx=0, nesting_level=0):
        super().__init__(name, query_block_idx=query_block_idx, nesting_level=nesting_level)
        self.abbre = 'R'
        self.limit: int # -1 not necessary

class Attribute(Node):
    def __init__(self, name, query_block_idx=0, nesting_level=0):
        super().__init__(name, query_block_idx=query_block_idx, nesting_level=nesting_level)
        self.abbre = 'A'
        
class Value(Node):
    def __init__(self, name, query_block_idx=0, nesting_level=0):
        super().__init__(name, query_block_idx=query_block_idx, nesting_level=nesting_level)
        self.abbre = 'V'

class Function(Node):
    def __init__(self, aggregation_type, query_block_idx=0, nesting_level=0):
        super().__init__(aggregationTypeToName[aggregation_type], query_block_idx=query_block_idx, nesting_level=nesting_level)
        self.abbre = 'F'
 
# Edge
class Edge(metaclass=ABCMeta):
    def __init__(self, name, src, dst):
        self.name = name
        self.abbre = 'Edge'
        self.src = src
        self.dst = dst
    
    @staticmethod
    def is_similar(edge1, edge2):
        try:
            return edge1.name == edge2.name and \
                Node.is_similar(edge1.src, edge2.src) and \
                    Node.is_similar(edge1.dst, edge2.dst)
        except:
            return False
    @staticmethod
    def is_equivalent(edge1, edge2):
        if '*' in [edge1, edge2]:
            return True
        return edge1.name == edge2.name and \
            Node.is_equivalent(edge1.src, edge2.src) and \
                Node.is_equivalent(edge1.dst, edge2.dst)

class Projection(Edge):
    def __init__(self, src, dst):
        super().__init__("projection", src=src, dst=dst)
        self.abbre = "Proj"

class Join(Edge):
    def __init__(self, src, dst):
        super().__init__("join", src=src, dst=dst)
        self.abbre = "Join"
 
class Selection(Edge):
    def __init__(self, src, dst, operation_idx=0):
        super().__init__("selection", src=src, dst=dst)
        self.abbre = "Sel"
        # index for clauses in CNF
        self.operation_idx = operation_idx

class Grouping(Edge):
    def __init__(self, src, dst):
        super().__init__("grouping", src=src, dst=dst)
        self.abbre = "Group"
 
class Having(Edge):
    def __init__(self, src, dst, operation_idx=0):
        super().__init__("having", src=src, dst=dst)
        self.abbre = "Hav"
        # index for clauses in CNF
        self.operation_idx = operation_idx

class Ordering(Edge):
    def __init__(self, src, dst, ordering_direction=OrderingType.Ascending):
        super().__init__("ordering", src=src, dst=dst)
        self.abbre = "Ord"
        self.type = ordering_direction

class Operation(Edge):
    def __init__(self, op_type, src, dst, quantifier=''):
        super().__init__("operation", src=src, dst=dst)
        self.abbre = "Op"
        self.operator_name = operatorTypeToName[op_type]
        self.op_type = op_type
        self.quantifier = quantifier

class Aggregation(Edge):
    def __init__(self, src, dst):
        super().__init__("aggregation", src=src, dst=dst)
        self.abbre = "Agg"
 
class Limit(Edge):
    def __init__(self, src, dst):
        super().__init__("limit", src=src, dst=dst)

class Query_graph(nx.DiGraph):
    def __init__(self):
        super().__init__()

    @property
    def root(self):
        def number_of_proj_att(node):
            return len([1 for src, dst in self.edges(node) if type(self.edges[src, dst]['data']) == Projection])
        # Extract level 0, block 0
        outer_block_relations = filter(lambda k: k.query_block_idx == 0 and k.nesting_level == 0 and type(k) == Relation, self.nodes._nodes)
        relations_sorted_by_proj_att = sorted(outer_block_relations, key= lambda k: -number_of_proj_att(k))
        return relations_sorted_by_proj_att[0] if relations_sorted_by_proj_att else None

    def set_join_directions(self, given_node=None):
        """Has side effect"""
        def is_for_join(n1, edge, n2):
            # (Join edge) or (equality edge for join)
            return type(edge['data']) == Join or (type(edge['data']) == Operation and type(n1) == Attribute and type(n2) == Attribute)
        # Initial call
        if not given_node:
            self.visited_nodes = []
            given_node = self.root

        # Remember visited nodes
        if given_node in self.visited_nodes:
            return None
        else:
            self.visited_nodes.append(given_node)
        # Main logic
        ## Find all outgoing and incoming edges. (If has outgoging join and incoming join, remove incoming join condition)
        for neighbor in self.neighbors(given_node):
            out_edge = self.edges[given_node, neighbor]
            # TODO: Change try and catch to checking logic
            try: in_edge = self.edges[neighbor, given_node]
            except: in_edge = None
            # Remove incoming join edge
            if in_edge and is_for_join(neighbor, in_edge, given_node) and is_for_join(given_node, out_edge, neighbor):
                self.remove_edge(neighbor, given_node)

        ## For all outgoing nodes, recursive call
        for neighbor in self.neighbors(given_node):
            self.set_join_directions(neighbor)

        # Clean up at initial call
        if not given_node:
            delattr(self, "visited_nodes")
        else:
            self.visited_nodes.remove(given_node)
        return None

    def get_all_similar_edges(self, edge):
        return [e for e in self.edges(data='data') if Edge.is_similar(e, edge)]

    def get_all_similar_nodes(self, node):
        return [n for n in self.nodes._nodes if Node.is_similar(n, node)]

    def get_equivalent_node(self, node):
        for n in self.nodes._nodes:
            if Node.is_equivalent(n, node):
                return n
        return None

    def get_equivalent_edge(self, edge):
        for e in self.edges(data='data'):
            if Edge.is_equivalent(e, edge):
                return e
        return None

    def add_node_if_not_exist(self, node):
        if node not in self: self.add_node(node, data=node)

    def bidirectional_connect(self, node1, edge, node2):
        def get_edge_in_opposite_direction(e):
            e = copy.copy(e)
            new_src, new_dst = e.dst, e.src
            e.dst = new_dst
            e.src = new_src
            return e
        self.unidirectional_connect(node1, edge, node2)
        self.unidirectional_connect(node2, get_edge_in_opposite_direction(edge), node1)

    def unidirectional_connect(self, node1, edge, node2):
        # Add node if not exist
        self.add_node_if_not_exist(node1)
        self.add_node_if_not_exist(node2)
        # TODO: Not sure what happens if the edge already exists
        self.add_edge(node1, node2, data=edge)

    def connect_projection(self, src_node, dst_node):
        self.unidirectional_connect(src_node, Projection(src_node, dst_node), dst_node)

    def connect_selection(self, src_node, dst_node):
        self.unidirectional_connect(src_node, Selection(src_node, dst_node), dst_node)

    def connect_join(self, relation1, r1_attribute, r2_attribute, relation2):
        self.bidirectional_connect(relation1, Join(relation1, r1_attribute), r1_attribute)
        self.bidirectional_connect(relation2, Join(relation2, r2_attribute), r2_attribute)
        self.bidirectional_connect(r1_attribute, Operation(OperatorType.Equal, r1_attribute, r2_attribute), r2_attribute)

    def connect_operation(self, relation, operator_type, attribute, quantifier=''):
        self.unidirectional_connect(relation, Operation(operator_type, relation, attribute, quantifier), attribute)

    def connect_aggregation(self, attribute, aggregation_func):
        self.unidirectional_connect(attribute, Aggregation(attribute, aggregation_func), aggregation_func)

    def connect_group(self, relation, attribute):
        self.unidirectional_connect(relation, Grouping(relation, attribute), attribute)

    def connect_having(self, relation, attribute):
        self.unidirectional_connect(relation, Having(relation, attribute), attribute)

    def connect_order(self, relation, attribute, is_asc=True):
        self.unidirectional_connect(relation, Ordering(OrderingType.Ascending if is_asc else OrderingType.Descending, relation, attribute), attribute)

    def connect_limit(self, relation, value):
        self.unidirectional_connect(relation, Limit(relation, value), value)
