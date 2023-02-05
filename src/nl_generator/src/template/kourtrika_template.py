import abc
import copy
import networkx as nx

from src.query_graph.koutrika_query_graph import OperatorType, Predicate, Membership, Selection, Edge, Node, Relation, Attribute, Value, Function
"""
    - Label: NL to describe the conceptual meaning of a node or edge
        e.g.: l(node) -> str
             l(edge) -> str
    - Template: NL to describe the conceptual meaning of a path from node u to node v
        e.g.: l(u,v) -> str
"""

class Template(metaclass=abc.ABCMeta):
    _DAG = None
    def __init__(self, query_graph):
        # Entire query graph
        self.query_graph = query_graph
        self.DAG_to_QG = self._create_mapping()

    def _create_mapping(self):
        # Add bidirectional edges b/w two relations
        copied_graph = copy.deepcopy(self.graph)
        for src, dst in copied_graph.edges:
            if issubclass(type(src), Relation) and issubclass(type(dst), Relation):
                copied_graph.connect(dst, src)

        # Prepare matchers
        node_matcher = lambda n1,n2: n1==n2
        edge_matcher = lambda e1,e2: e1==e2
        # Subgraph matching
        subgraphs = [i for i in nx.algorithms.isomorphism.vf2userfunc.DiGraphMatcher(self.query_graph, copied_graph, 
                                                                                     node_match=node_matcher, 
                                                                                     edge_match=edge_matcher).subgraph_isomorphisms_iter()]
        assert len(subgraphs) > 0, f"Error on finding mapping between query graph and template graph"
        subgraph = subgraphs[0]
        
        # Create mapping from template graph to query graph
        mapping = {}
        for node in self.graph.nodes:
            matched_nodes = [n for n in subgraph if node == n]
            assert len(matched_nodes) == 1, f"Error on finding mapping between query graph and template graph"
            mapping[node] = matched_nodes[0]

        return mapping

    @property
    @abc.abstractmethod
    def nl_description(self):
        pass

    @property
    @abc.abstractmethod
    def graph(self):
        pass

    @property
    def reference_points(self):
        if not self.query_graph:
            raise RuntimeError("Assign query graph to retrieve reference points!")
        return [rp for rp in self.query_graph.reference_points if rp in self.DAG_to_QG.values()]

    @property
    def roots(self):
        # Assumption: root can be any nodes other than reference points
        return list(filter(lambda rp: len(self.graph.in_edges(rp)) == 0, self.graph.nodes))

    @property
    def root_relation(self):
        def retrieve_first_met_relation(node):
            # End condition
            if issubclass(type(node), Relation):
                return node
            # Check neighboring nodes
            for src, dst in self.graph.out_edges(node):
                result = retrieve_first_met_relation(dst)
                if result:
                    return result
            return None
        
        for root in self.roots:
            result = retrieve_first_met_relation(root)
            if result:
                return result
        return None

    def composable_with(self, template2):
        # Get reference points of this template
        rp_set1 = set(self.reference_points)
        # Get reference points of comparing template
        rp_set2 = set(template2.reference_poionts)
        # Check if any intersection
        return bool(rp_set1.intersection(rp_set2))


class Generic_template(Template):
    def __init__(self, graph, query_graph, nl_description=None):
        self._DAG = graph
        self._nl_description = nl_description
        super().__init__(query_graph)

    @property
    def nl_description(self):
        if self._nl_description:
            return self._nl_description
        else:
            # TODO: Need to compose nl description naturally
            labels = []
            for src, dst in self.graph.edges:
                edge = self.graph.edges[src, dst]['data']
                labels.append(edge.one_hop_path_description(src, dst))
            
            # Resolve common expressions
            nl_exp = " ".join(labels)
            words = nl_exp.split(" ")
            tmp = [words[0]]
            for word in words:
                if tmp[-1] != word:
                    tmp.append(word)
            return " ".join(tmp)

    @nl_description.setter
    def nl_description(self, value):
        self._nl_description = value

    @property
    def graph(self):
        return self._DAG

    @graph.setter
    def graph(self, value):
        self._DAG = value


class Template_matcher():
    def __init__(self, query_graph, templates):
        self.query_graph = query_graph
        self.templates = templates

    def find_maximum_covering_templates():
        pass

