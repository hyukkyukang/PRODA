import unittest
from VQL.example_queries import ProjectionQuery, MinMaxQuery, CountAvgSumQuery, SelectionQuery, AndOrQuery, SelectionQueryWithAnd, SelectionQueryWithOr, OrderByQuery, GroupByQuery, HavingQuery, NestedQuery, CorrelatedNestedQuery, CorrelatedNestedQuery2, MultipleSublinksQuery

class Test_EVQL_to_SQL(unittest.TestCase):
    def _test_translation(self, query):
        gold_sql = query.sql.lower()
        generated_sql = query.evql.to_sql.lower()
        self.assertTrue(gold_sql == generated_sql, f'\nExpected: "{gold_sql}". \nGot: "{generated_sql}"')

    def test_selection_with_or(self):
        self._test_translation(SelectionQueryWithOr())

    def test_selection_with_and(self):
        self._test_translation(SelectionQueryWithAnd())

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

    def test_correlated_nested2(self):
        self._test_translation(CorrelatedNestedQuery2())

    def test_projection(self):
        self._test_translation(ProjectionQuery())

    def test_min_max(self):
        self._test_translation(MinMaxQuery())

    def test_count_avg_sum(self):
        self._test_translation(CountAvgSumQuery())
        
    def test_and_or(self):
        self._test_translation(AndOrQuery())

    def test_selection(self):
        self._test_translation(SelectionQuery())

    def test_multiple_sublinks(self):
        self._test_translation(MultipleSublinksQuery())

if __name__ == "__main__":
    unittest.main()
