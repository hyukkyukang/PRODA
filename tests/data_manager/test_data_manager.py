import io
import json
import os
import sys
import unittest
from typing import Any

import hkkang_utils.io as io_utils
import hkkang_utils.testing as test_utils

from src.utils.data_manager import load_and_print_data, save_data
from src.utils.example_queries import (
    AndOrQuery,
    CorrelatedNestedQuery,
    CorrelatedNestedQuery2,
    CountAvgSumQuery,
    GroupByQuery,
    HavingQuery,
    MinMaxQuery,
    MultipleSublinksQuery,
    NestedQuery,
    OrderByQuery,
    ProjectionQuery,
    SelectionQuery,
    SelectionQueryWithAnd,
    SelectionQueryWithOr,
)

EVQL_TEST_DIR = "./tests_data_manager_evql/"
TABLE_TEST_DIR = "./tests_data_manager_table/"


class Test_data_manager(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        super(Test_data_manager, self).__init__(*args, **kwargs)
        self.example_query_classes = [
            ProjectionQuery,
            MinMaxQuery,
            CountAvgSumQuery,
            SelectionQuery,
            AndOrQuery,
            SelectionQueryWithAnd,
            SelectionQueryWithOr,
            OrderByQuery,
            GroupByQuery,
            HavingQuery,
            NestedQuery,
            CorrelatedNestedQuery,
            CorrelatedNestedQuery2,
            MultipleSublinksQuery,
        ]

    def _get_file_path(self, dir_path: str, object: Any) -> str:
        return os.path.join(dir_path, f"{object.__class__.__name__}.pkl")

    def _get_evql_file_path(self, query_object: Any) -> str:
        return self._get_file_path(EVQL_TEST_DIR, query_object)

    def _test_loading_evql(self) -> None:
        for query_class in self.example_query_classes:
            # Get file path and load data
            file_path = self._get_evql_file_path(query_class())
            # Load the data and Intercept stdout to get the json string
            json_string = io_utils.intercept_stdout(load_and_print_data)(file_path)
            # Check if output is indeed json string
            self.assertIsNotNone(json.loads(json_string))
            os.remove(file_path)
        print("Test loading EVQL Done!")

    def _test_saving_evql(self) -> None:
        for query_class in self.example_query_classes:
            # Initiate the query object
            query_object = query_class()
            file_path = self._get_evql_file_path(query_object)
            # Load the query object from the json file
            save_data(query_object.evql, file_path)
            # Check if the file exists
            self.assertTrue(os.path.exists(file_path))
        print("Test loading EVQL Done!")

    # Test data structure for EVQL
    @test_utils.set_and_clean_test_dir(EVQL_TEST_DIR)
    def test_managing_eqvl(self) -> None:
        # Test saving
        self._test_saving_evql()
        # Test loading
        self._test_loading_evql()

    # Testing data strcuture for table excerpt and result table
    @test_utils.set_and_clean_test_dir(TABLE_TEST_DIR)
    def test_managing_table(self) -> None:
        pass


if __name__ == "__main__":
    unittest.main()
