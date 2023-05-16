import unittest
from src.pylogos.algorithm.MRP import MRP
from utils import (
    Query,
    SPJ_query,
    SPJ_query2,
    GroupBy_query,
    Nested_with_correlation_query,
    Nested_with_multisublink_query,
    Nested_with_groupby_query,
    Nested_with_multilevel_query,
    TestQuery2,
)


class Test_MRP(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        super(Test_MRP, self).__init__(*args, **kwargs)
        self.algorithm = MRP()

    def _test_query(self, query: Query, test_name: str):
        query_graph = query.simplified_graph
        gold = query.MRP_nl.lower()
        # query_graph.draw()
        # TODO: need to give reference point and parent node for the initial call
        reference_point, parent_node = None, None
        composed_nl, mapping = self.algorithm(query_graph.query_subjects[0], parent_node, reference_point, query_graph)
        print(composed_nl)
        self.assertTrue(
            gold == composed_nl.lower(),
            f"MRP: Incorrect translation of {test_name} query!\nGOLD:{gold}\nResult:{composed_nl}",
        )

    def test_spj(self):
        self._test_query(SPJ_query(), "SPJ")

    def test_spj2(self):
        self._test_query(SPJ_query2(), "SPJ2")

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

    def test_query_2(self):
        self._test_query(TestQuery2(), "TestQuery2")


if __name__ == "__main__":
    # test = Test_MRP()
    # test.test_spj2()
    unittest.main()
