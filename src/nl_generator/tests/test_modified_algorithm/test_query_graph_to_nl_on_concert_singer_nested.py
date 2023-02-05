import copy
import unittest

import networkx as nx
# Load template class
from src.template.template import Template_instance, Generic_template, Specific_template, template_selection, template_composition
# Load template files
from src.template.generic_template import generic_templates
from src.template.specific_template_student import specific_templates
from src.template.schema_templates.schema_template_concert_singer import schema_template
from tests.test_modified_algorithm.utils_hjkim import load_graphs

from src.query_graph import Relation, Projection

import numpy as np

TEST_GRAPH_FILE_PATH = "/Users/hyukyu/github/nl2sql_web/translation_module/tests/graph_test/concert_singer/concert_singer_nested.sql.graph"
TEST_SQL_FILE_PATH = "/Users/hyukyu/github/nl2sql_web/translation_module/tests/graph_test/concert_singer/concert_singer_nested.sql"

class Test_template_composition(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        super(Test_template_composition, self).__init__(*args, **kwargs)
        self._templates = None

    def _load_sql_from_file(self):
        with open(TEST_SQL_FILE_PATH) as f:
            return [line.strip("\n") for line in f.readlines()]

    @property
    def templates(self):
        if not self._templates:
            g_templates = []
            s_templates = []
            for g_raw_template in generic_templates:
                g_template = Generic_template(g_raw_template)
                g_templates.append(g_template)

            for s_raw_template in specific_templates:
                s_template = Specific_template(s_raw_template)
                s_templates.append(s_template)

            self._templates = {
                "generic": g_templates, 
                "specific": s_templates
            }

        return self._templates

    def _load_query_graph(self):
        query_graphs = load_graphs(TEST_GRAPH_FILE_PATH, 20)
        return query_graphs


    def change_nested_edge_direction(self, query_graph):
        def reverse_direction(src, dst, edge):
            # Swap info in edge
            tmp = edge.src
            edge.src = edge.dst
            edge.dst = tmp
            # change direction in query graph
            query_graph.remove_edge(src, dst)
            query_graph.add_edge(dst, src, data=edge)
        def recursively_reverse_direction(node):
            tmps = []
            for src, dst in query_graph.edges(node):
                edge = query_graph.edges[src, dst]['data']
                tmps.append((src, dst, edge))
            for src, dst, edge in tmps:
                recursively_reverse_direction(dst)
                reverse_direction(src, dst, edge)
        stop = 1
        for node in query_graph.nodes:
            if type(node) == Relation and node.nesting_level == 1:
                # Find projection edges and change to incoming directions
                tmps = []
                for src, dst in query_graph.edges(node):
                    edge = query_graph.edges[src, dst]['data']
                    tmps.append((src, dst, edge))
                for src, dst, edge in tmps:
                    if type(edge) == Projection:
                        recursively_reverse_direction(dst)
                        reverse_direction(src, dst, edge)
        # query_graph.draw()
        return query_graph

    def test_spider_concert_singer_db(self):
        # Prepare data
        sqls = self._load_sql_from_file()
        query_graphs = self._load_query_graph()
        succeed_cnt = 0
        for idx, (sql, query_graph) in enumerate(zip(sqls, query_graphs)):
            try:
                # query_graph.draw()
                query_graph = self.change_nested_edge_direction(query_graph)
                templates = copy.deepcopy(self.templates)
                selected_templates = template_selection(query_graph, templates)
                # Add edges to attribute: query_graph_path
                selected_templates = [Template_instance.add_edge_to_query_graph_path(template, query_graph) for template in selected_templates]
                # Create mapping to perform template composition
                [template.create_template_to_query_graph_idx_mapping() for template in selected_templates]
                # Add schema template
                [template.add_schema_template(schema_template) for template in selected_templates]
                # NL Composition
                composed_NL = template_composition(selected_templates, query_graph.root)
                print(f"idx:{idx}")
                print(f"SQL:{sql}")
                print(f"composed NL:{composed_NL}")
                succeed_cnt += 1
            except Exception as E:
                print(f"Error when generating NL.. idx:{idx} ({E})")
                # labels = nx.get_node_attributes(query_graph, 'data') 
                # nx.draw(query_graph,labels=labels)
                # sto = 1
        print(f"{succeed_cnt}/{len(query_graphs)} succeed")

if __name__ == "__main__":
    # unittest.main()
    test_template_composition = Test_template_composition()
    test_template_composition.test_spider_concert_singer_db()