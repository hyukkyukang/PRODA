import unittest
from src.algorithm.BST import BST
# from tests.test_koutrika_et_al_2010.utils import SPJ_query, GroupBy_query, Nested_query, compare_string_without_newline


class Test_BST(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        super(Test_BST, self).__init__(*args, **kwargs)
        self.algorithm = BST()

    # def _test_query(self, query, test_name):
    #     query_graph = query.simplified_graph
    #     gold = query.BST_nl.lower()
    #     query_graph.draw()
    #     composed_nl = self.algorithm(query_graph.query_subjects[0], query_graph).lower()
    #     self.assertTrue(compare_string_without_newline(gold,composed_nl), f"BST: Incorrect translation of {test_name} query!\nGOLD:{gold}\nResult:{composed_nl}")

    # def test_spj(self):
    #     self._test_query(SPJ_query(), "SPJ")

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

