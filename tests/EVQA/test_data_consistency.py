import unittest
from src.utils.example_queries import (
    SelectionQueryWithAnd,
    SelectionQueryWithOr,
    OrderByQuery,
    GroupByQuery,
    HavingQuery,
    NestedQuery,
    CorrelatedNestedQuery,
    CorrelatedNestedQuery2,
    MultipleSublinksQuery,
)
from src.VQA.EVQA import EVQATree


class Test_data_consistency(unittest.TestCase):
    def _test_consistency(self, query):
        json_obj = query.evqa.dump_json()
        new_query_obj = EVQATree.load_json(json_obj)
        ori = query.evqa.to_sql
        new = new_query_obj.to_sql
        self.assertTrue(
            query.evqa.to_sql == new_query_obj.to_sql,
            f'\nExpected: "{query.evqa.to_sql}". \nGot: "{new_query_obj.to_sql}"',
        )

    def test_selection_with_or(self):
        self._test_consistency(SelectionQueryWithOr())

    def test_selection_with_and(self):
        self._test_consistency(SelectionQueryWithAnd())

    def test_order_by(self):
        self._test_consistency(OrderByQuery())

    def test_group_by(self):
        self._test_consistency(GroupByQuery())

    def test_having(self):
        self._test_consistency(HavingQuery())

    def test_nested(self):
        self._test_consistency(NestedQuery())

    def test_correlated_nested(self):
        self._test_consistency(CorrelatedNestedQuery())

    def test_correlated_nested2(self):
        self._test_consistency(CorrelatedNestedQuery2())

    def test_multiple_sublinks(self):
        self._test_consistency(MultipleSublinksQuery())


if __name__ == "__main__":
    unittest.main()
