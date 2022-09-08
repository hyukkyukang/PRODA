import json 
binaryOperators = ["=", "<", ">"];
aggFunctions = ["none", "count", "sum", "avg", "min", "max"];

dummy_evql = {
    "node": {
        "header_names": ["cars", "model", "horsepower_avg", "max_speed_avg"],
        "header_aliases": ["cars", "model", "horsepower_avg", "max_speed_avg"],
        "foreach": None,
        "projection": {
            "headers": [
                { "id": 1, "agg_type": 0 },
                { "id": 2, "agg_type": 0 },
            ],
        },
        "predicate": {
            "clauses": [
                {
                    "conditions": [{ "header_id": 3, "func_type": "Selecting", "op_type": binaryOperators.index(">"), "r_operand": "200" }],
                },
            ],
        },
    },
    "children": [
        {
            "node": {
                "header_names": ["cars", "id", "model", "horsepower", "max_speed", "year", "price"],
                "header_aliases": ["cars", "id", "model", "horsepower", "max_speed", "year", "price"],
                "foreach": None,
                "projection": {
                    "headers": [
                        { "id": 2, "agg_type": aggFunctions.index("none") },
                        { "id": 3, "agg_type": aggFunctions.index("avg") },
                        { "id": 4, "agg_type": aggFunctions.index("avg") },
                    ],
                },
                "predicate": {
                    "clauses": [
                        {
                            "conditions": [{ "header_id": 2, "func_type": "Grouping" }],
                        },
                    ],
                },
            },
            "children": [],
            "enforce_t_alias": False,
        },
    ],
    "enforce_t_alias": False,
};


dummy_subtask1 = {
    "nl": 1
}

if __name__ == "__main__":
    print(json.dumps(dummy_task, indent=4))