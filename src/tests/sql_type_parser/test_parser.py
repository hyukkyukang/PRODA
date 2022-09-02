import unittest
from server_utils.parse_sql_nested_types import get_sql_type


class Test_SQL_type_parser(unittest.TestCase):
    def test_from(self):
        test_set = {
            "from__scalar_subquery": [
                "SELECT col2 FROM (SELECT col1 FROM tab1 LIMIT 1) as col2"
            ],
            "from__subquery_with_aggregation": [
                "SELECT col2 FROM (SELECT count(col1) FROM tab1) as col2"
            ],
            "from__subquery_without_aggregation": [
                "SELECT col2 FROM (SELECT col1 FROM tab1) as col2"
            ],
        }
        for key, examples in test_set.items():
            for sql_str in examples:
                sql_type = get_sql_type(sql_str)
                self.assertTrue(sql_type[key], f"SQL:{sql_str}:\nType:{key}")
        return True

    def test_where(self):
        test_set = {
            "where__scalar_comparison": [
                "SELECT col1 FROM tab1 WHERE col2 = (SELECT col3 FROM tab2 limit 1)"
            ],
            "where__quantified_scalar_comparison": [
                "SELECT col1 FROM tab1 WHERE col2 > ANY (SELECT col3 FROM tab2)",
                "SELECT col1 FROM tab1 WHERE col2 > ALL (SELECT col3 FROM tab2)",
            ],
            "where__attribute_aggregation_comparison": [
                "SELECT col1 FROM tab1 WHERE col2 = (SELECT max(col3) FROM tab2)"
            ],
            "where__constant_aggregation_comparison": [
                "SELECT col1 FROM tab1 WHERE 1 = (SELECT max(col3) FROM tab2)"
            ],
            "where__set_membership_checking_in": [
                "SELECT col1 FROM tab1 WHERE col2 IN (SELECT col3 FROM tab2)"
            ],
            "where__set_membership_checking_not_in": [
                "SELECT col1 FROM tab1 WHERE col2 NOT IN (SELECT col3 FROM tab2)"
            ],
            "where__existential_checking_exists": [
                "SELECT col1 FROM tab1 WHERE EXISTS (SELECT col3 FROM tab2)"
            ],
            "where__existential_checking_not_exists": [
                "SELECT col1 FROM tab1 WHERE NOT EXISTS (SELECT col3 FROM tab2)"
            ],
        }
        for key, examples in test_set.items():
            for sql_str in examples:
                print(sql_str)
                sql_type = get_sql_type(sql_str)
                self.assertTrue(sql_type[key], f"SQL:{sql_str}:\nType:{key}")
        return True

    def test_having(self):
        test_set = {
            "having__scalar_comparison": [
                "SELECT col1 FROM tab1 GROUP BY col1 HAVING col2 = (SELECT col3 FROM tab2 limit 1)"
            ],
            "having__quantified_scalar_comparison": [
                "SELECT col1 FROM tab1 GROUP BY col1 HAVING col2 > ANY (SELECT col3 FROM tab2)",
                "SELECT col1 FROM tab1 GROUP BY col1 HAVING col2 > ALL (SELECT col3 FROM tab2)",
            ],
            "having__attribute_aggregation_comparison": [
                "SELECT col1 FROM tab1 GROUP BY col1 HAVING col2 = (SELECT max(col3) FROM tab2)"
            ],
            "having__constant_aggregation_comparison": [
                "SELECT col1 FROM tab1 GROUP BY col1 HAVING 1 = (SELECT max(col3) FROM tab2)"
            ],
            "having__set_membership_checking_in": [
                "SELECT col1 FROM tab1 GROUP BY col1 HAVING col2 IN (SELECT col3 FROM tab2)"
            ],
            "having__set_membership_checking_not_in": [
                "SELECT col1 FROM tab1 GROUP BY col1 HAVING col2 NOT IN (SELECT col3 FROM tab2)"
            ],
            "having__existential_checking_exists": [
                "SELECT col1 FROM tab1 GROUP BY col1 HAVING EXISTS (SELECT col3 FROM tab2)"
            ],
            "having__existential_checking_not_exists": [
                "SELECT col1 FROM tab1 GROUP BY col1 HAVING NOT EXISTS (SELECT col3 FROM tab2)"
            ],
        }
        for key, examples in test_set.items():
            for sql_str in examples:
                sql_type = get_sql_type(sql_str)
                self.assertTrue(sql_type[key], f"SQL:{sql_str}:\nType:{key}")
        return True

    def test_multi_sublink(self):
        test_set = {
            "multiple_sublinks": [
                "SELECT col1 FROM tab1 WHERE col2 = (SELECT col3 FROM tab2 limit 1) OR col3 = (SELECT col3 FROM tab2 limit 1)"
            ]
        }
        for key, examples in test_set.items():
            for sql_str in examples:
                sql_type = get_sql_type(sql_str)
                self.assertTrue(sql_type[key], f"SQL:{sql_str}:\nType:{key}")
        return True

    def test_nested_sublinks(self):
        test_set = {
            "nested_sublinks": [
                "SELECT col1 FROM tab1 WHERE col2 = (SELECT col2 FROM tab2 WHERE col3 = (SELECT col4 FROM tab3 limit 1) limit 1)"
            ]
        }
        for key, examples in test_set.items():
            for sql_str in examples:
                sql_type = get_sql_type(sql_str)
                self.assertTrue(sql_type[key], f"SQL:{sql_str}:\nType:{key}")
        return True


if __name__ == "__main__":
    unittest.main()
