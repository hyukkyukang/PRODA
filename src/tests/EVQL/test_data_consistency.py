import unittest
from VQL.example_queries import SelectionQueryWithAnd, SelectionQueryWithOr, OrderByQuery, GroupByQuery, HavingQuery, NestedQuery, CorrelatedNestedQuery
from VQL.EVQL import EVQLTree

class Test_data_consistency(unittest.TestCase):
    def _test_consistency(self, query):
        json_obj = query.evql.dump_json()
        new_query_obj = EVQLTree.load_json(json_obj)
        self.assertTrue(query.evql.to_sql == new_query_obj.to_sql, f'\nExpected: "{query.evql.to_sql}". \nGot: "{new_query_obj.to_sql}"')

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

if __name__ == "__main__":
    unittest.main()
