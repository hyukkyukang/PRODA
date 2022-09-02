import json
import argparse


IMPORT_VIA_RELATIVE_PATH = True
if IMPORT_VIA_RELATIVE_PATH:
    import os, sys
    sys.path.append(os.path.join(os.path.dirname(sys.path[0]), 'tests/EVQL'))
    from utils import ProjectionQuery, MinMaxQuery, CountAvgSumQuery, SelectionQuery, AndOrQuery, SelectionQueryWithOr, SelectionQueryWithAnd, OrderByQuery, GroupByQuery, HavingQuery, NestedQuery, CorrelatedNestedQuery
else:
    from tests.EVQL.utils import ProjectionQuery, MinMaxQuery, CountAvgSumQuery, SelectionQuery, AndOrQuery, SelectionQueryWithAnd, SelectionQueryWithOr, OrderByQuery, GroupByQuery, HavingQuery, NestedQuery, CorrelatedNestedQuery

QUERY_TYPE_TO_CLASS_MAPPING = {
        "projection": ProjectionQuery,
        "minMax": MinMaxQuery,
        "countAvgSum": CountAvgSumQuery,
        "selection": SelectionQuery,
        "andOr": AndOrQuery,
        "selectionWithOr": SelectionQueryWithOr,
        "selectionWithAnd": SelectionQueryWithAnd,
        "orderBy": OrderByQuery,
        "groupBy": GroupByQuery,
        "having": HavingQuery,
        "nested": NestedQuery,
        "correlatedNested": CorrelatedNestedQuery
    }

def parse_args():
    parser = argparse.ArgumentParser(description="Translate EVQL to SQL")
    parser.add_argument(
        "--query_type",
        type=str,
        help="Tell the type of example query")
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    query_type = args.query_type
    
    if query_type in QUERY_TYPE_TO_CLASS_MAPPING.keys():
        query = QUERY_TYPE_TO_CLASS_MAPPING[query_type]()
    else:
        raise RuntimeError("Should not be here")
    dumped_query = query.evql.dump_json()
    print(json.dumps(dumped_query, indent=4))
