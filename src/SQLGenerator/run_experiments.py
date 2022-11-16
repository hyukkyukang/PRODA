

non_nested_query_types = [
        ['SPJ', '--query_type spj-non-nested'],
        ['GROUP', '--query_type non-nested --set_clause_by_clause --has_group'],
        ['HAVING', '--query_type non-nested --set_clause_by_clause --has_group --has_having'],
        ['ORDER', '--query_type non-nested --set_clause_by_clause --has_order'],
        ['LIMIT', '--query_type non-nested --set_clause_by_clause --has_order --has_limit'],
        ['WHERE_GROUP', '--query_type non-nested --set_clause_by_clause --has_where --has_group'],
        ['WHERE_HAVING', '--query_type non-nested --set_clause_by_clause --has_where --has_group --has_having'],
        ['WHERE_ORDER', '--query_type non-nested --set_clause_by_clause --has_where --has_order'],
        ['WHERE_GROUP_ORDER', '--query_type non-nested --set_clause_by_clause --has_where --has_group --has_order'],
        ['WHERE_HAVING_ORDER', '--query_type non-nested --set_clause_by_clause --has_where --has_group --has_having --has_order'],
]

nested_query_types = [
        ['SPJ-TYPE-N', '--query_type spj-nested --set_nested_query_type --has_type_n'],
        ['SPJ-TYPE-A', '--query_type spj-nested --set_nested_query_type --has_type_a'],
        ['SPJ-TYPE-J', '--query_type spj-nested --set_nested_query_type --has_type_j'],
        ['SPJ-TYPE-JA', '--query_type spj-nested --set_nested_query_type --has_type_ja'],
        ['TYPE-N', '--query_type nested --set_nested_query_type --has_type_n'],
        ['TYPE-A', '--query_type nested --set_nested_query_type --has_type_a'],
        ['TYPE-J', '--query_type nested --set_nested_query_type --has_type_j'],
        ['TYPE-JA', '--query_type nested --set_nested_query_type --has_type_ja'],
        ]

for db in ['pets_1', 'concert_singer', 'car_1']:
    for label, query_type in non_nested_query_types:
        command = "python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/"+db+"_"+label+".sql --db spider --schema_name "+db+" "+query_type
        echo_command = "echo 'run for "+db+" type "+query_type+"'"
        print(echo_command)
        print(command)
    for label, query_type in nested_query_types:
        command = "python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/"+db+"_"+label+".sql --db spider --schema_name "+db+" "+query_type
        echo_command = "echo 'run for "+db+" type "+query_type+"'"
        print(echo_command)
        print(command)

