import unittest
from VQL.example_queries import (
    ProjectionQuery,
    MinMaxQuery,
    CountAvgSumQuery,
    SelectionQuery,
    AndOrQuery,
    OrderByQuery,
    GroupByQuery,
    HavingQuery,
    NestedQuery,
    CorrelatedNestedQuery,
)

from VQL.query_tree_to_EVQL import convert_queryTree_to_EVQLTree


class Test_QueryTree_to_EVQL(unittest.TestCase):
    def _test_translation(self, query):
        query_tree = query.query_tree
        object_EVQL = convert_queryTree_to_EVQLTree(query_tree)
        self.assertTrue(object_EVQL != None, f'\nExpected: "{object_EVQL}". \nGot: "{object_EVQL}"')

    def test_projection(self):
        self._test_translation(ProjectionQuery())

    def test_selection(self):
        self._test_translation(SelectionQuery())

    def test_order_by(self):
        self._test_translation(OrderByQuery())

    def test_group_by(self):
        self._test_translation(GroupByQuery())

    def test_having(self):
        self._test_translation(HavingQuery())

    def test_nested(self):
        self._test_translation(NestedQuery())

    def test_correlated_nested(self):
        self._test_translation(CorrelatedNestedQuery())

    def test_min_max(self):
        self._test_translation(MinMaxQuery())

    def test_count_avg_sum(self):
        self._test_translation(CountAvgSumQuery())

    def test_and_or(self):
        self._test_translation(AndOrQuery())


if __name__ == "__main__":
    unittest.main()
