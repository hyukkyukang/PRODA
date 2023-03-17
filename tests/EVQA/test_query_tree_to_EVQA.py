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

from src.VQA.query_tree_to_EVQA import convert_queryTree_to_EVQATree
from src.VQA.EVQA import check_evqa_equivalence


class Test_QueryTree_to_EVQA(unittest.TestCase):
    def _test_translation(self, query):
        query_tree = query.query_tree
        converted_evqa = convert_queryTree_to_EVQATree(query_tree)
        self.assertTrue(
            query_tree.height == converted_evqa.height,
            f"Height of query tree and EVQA tree are different, {query_tree.height} vs {converted_evqa.height}",
        )
        self.assertTrue(
            query_tree.num_nodes == converted_evqa.num_nodes,
            f"Number of nodes of query tree and EVQA tree are different, {query_tree.num_nodes} vs {converted_evqa.num_nodes}",
        )
        self.assertTrue(
            check_evqa_equivalence(query.evqa, converted_evqa),
            "EVQA converted from query tree is different from the original EVQA",
        )
        self.assertTrue(query.evqa == converted_evqa)

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
