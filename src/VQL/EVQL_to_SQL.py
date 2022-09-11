import json
import argparse

from VQL.EVQL import EVQLTree

def parse_args():
    parser = argparse.ArgumentParser(description="Translate EVQL to SQL")
    parser.add_argument(
        "--evql_in_json_str",
        type=str,
        help="dumped EVQL in json format",
    )
    return parser.parse_args()


if __name__ == "__main__":
    # Parse arguments
    args = parse_args()
    evql_in_json = json.loads(args.evql_in_json_str)
    evql_tree = EVQLTree.load_json(evql_in_json)
    print(f"{evql_tree.to_sql}")

