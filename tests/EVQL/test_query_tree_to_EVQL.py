import unittest
from src.utils.example_queries import (
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

from src.VQL.query_tree_to_EVQL import convert_queryTree_to_EVQLTree
from src.VQL.EVQL import check_evql_equivalence


class Test_QueryTree_to_EVQL(unittest.TestCase):
    def _test_translation(self, query):
        query_tree = query.query_tree
        converted_evql = convert_queryTree_to_EVQLTree(query_tree)

        self.assertTrue(
            check_evql_equivalence(query.evql, converted_evql),
            "EVQL converted from query tree is different from the original EVQL",
        )
        self.assertTrue(query.evql == converted_evql)

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
