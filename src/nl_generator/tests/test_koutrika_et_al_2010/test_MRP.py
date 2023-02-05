import unittest
from src.algorithm.MRP import MRP
from tests.test_koutrika_et_al_2010.utils import SPJ_query, GroupBy_query, Nested_with_correlation_query, Nested_with_multisublink_query, Nested_with_groupby_query, Nested_with_multilevel_query


class Test_MRP(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        super(Test_MRP, self).__init__(*args, **kwargs)
        self.algorithm = MRP()

    def _test_query(self, query, test_name):
        query_graph = query.simplified_graph
        gold = query.MRP_nl.lower()
        # query_graph.draw()
        #TODO: need to give reference point and parent node for the initial call
        reference_point, parent_node = None, None
        composed_nl = self.algorithm(query_graph.query_subjects[0], parent_node, reference_point, query_graph).lower()
        self.assertTrue(gold == composed_nl, f"MRP: Incorrect translation of {test_name} query!\nGOLD:{gold}\nResult:{composed_nl}")

    def test_spj(self):
        self._test_query(SPJ_query(), "SPJ")

    def test_group(self):
        self._test_query(GroupBy_query(), "GroupBy")

    def test_nested_with_correlation(self):
        self._test_query(Nested_with_correlation_query(), "correlation")

    def test_nested_with_multi_sublink(self):
        self._test_query(Nested_with_multisublink_query(), "multiple-sublink")

    def test_nested_with_groupby(self):
        self._test_query(Nested_with_groupby_query(), "nested-with-groupby")

    def test_nested_with_multi_levl(self):
        self._test_query(Nested_with_multilevel_query(), "multi-level-nested")

if __name__ == "__main__":
     unittest.main()
