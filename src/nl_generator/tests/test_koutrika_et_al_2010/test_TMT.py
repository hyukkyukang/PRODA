import unittest
from src.algorithm.TMT import TMT
# from tests.test_koutrika_et_al_2010.utils import SPJ_query, GroupBy_query, Nested_query

class Test_TMT(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        super(Test_TMT, self).__init__(*args, **kwargs)
        self.algorithm = TMT()

    # def _test_query(self, query, test_name):
    #     query_graph = query.simplified_graph
    #     gold = query.TMT_nl.lower()
    #     composed_nl = self.algorithm(query_graph, query.specific_templates).lower()
    #     self.assertTrue(gold == composed_nl, f"TMT: Incorrect translation of {test_name} query!\nGOLD:{gold}\nResult:{composed_nl}")

    # def _test_template_selection(self, query, test_name):
    #     query_graph = query.simplified_graph
    #     # gold = query.template_set
    #     selected_templates = self.algorithm.template_selection(query_graph, query.specific_templates)
    #     self.assertTrue(selected_templates)

    # def test_spj(self):
    #     query = SPJ_query()
    #     self._test_template_selection(query, "SPJ")
    #     self._test_query(query, "SPJ")

    # def test_group(self):
    #     query = GroupBy_query()
    #     query_graph = query.simplified_graph
    #     query_graph.draw()
    #     composed_nl = self.algorithm(query_graph.query_subjects[0], query_graph).lower()
    #     print(f"Composed NL: {composed_nl}")
    #     self.assertTrue(composed_nl)

    # def test_nested(self):
    #     query = Nested_query()
    #     query_graph = query.simplified_graph
    #     query_graph.draw()
    #     composed_nl = self.algorithm(query_graph.query_subjects[0], query_graph).lower()
    #     print(f"Composed NL: {composed_nl}")
    #     self.assertTrue(composed_nl)


if __name__ == "__main__":
     unittest.main()
