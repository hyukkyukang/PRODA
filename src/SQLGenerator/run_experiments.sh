echo 'run for pets_1 type --query_type non-nested --set_clause_by_clause --has_group'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/pets_1_GROUP.sql --db spider --schema_name pets_1 --query_type non-nested --set_clause_by_clause --has_group
echo 'run for pets_1 type --query_type non-nested --set_clause_by_clause --has_group --has_having'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/pets_1_HAVING.sql --db spider --schema_name pets_1 --query_type non-nested --set_clause_by_clause --has_group --has_having
echo 'run for pets_1 type --query_type non-nested --set_clause_by_clause --has_order'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/pets_1_ORDER.sql --db spider --schema_name pets_1 --query_type non-nested --set_clause_by_clause --has_order
echo 'run for pets_1 type --query_type non-nested --set_clause_by_clause --has_order --has_limit'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/pets_1_LIMIT.sql --db spider --schema_name pets_1 --query_type non-nested --set_clause_by_clause --has_order --has_limit
echo 'run for pets_1 type --query_type non-nested --set_clause_by_clause --has_where --has_group'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/pets_1_WHERE_GROUP.sql --db spider --schema_name pets_1 --query_type non-nested --set_clause_by_clause --has_where --has_group
echo 'run for pets_1 type --query_type non-nested --set_clause_by_clause --has_where --has_group --has_having'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/pets_1_WHERE_HAVING.sql --db spider --schema_name pets_1 --query_type non-nested --set_clause_by_clause --has_where --has_group --has_having
echo 'run for pets_1 type --query_type non-nested --set_clause_by_clause --has_where --has_order'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/pets_1_WHERE_ORDER.sql --db spider --schema_name pets_1 --query_type non-nested --set_clause_by_clause --has_where --has_order
echo 'run for pets_1 type --query_type non-nested --set_clause_by_clause --has_where --has_group --has_order'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/pets_1_WHERE_GROUP_ORDER.sql --db spider --schema_name pets_1 --query_type non-nested --set_clause_by_clause --has_where --has_group --has_order
echo 'run for pets_1 type --query_type non-nested --set_clause_by_clause --has_where --has_group --has_having --has_order'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/pets_1_WHERE_HAVING_ORDER.sql --db spider --schema_name pets_1 --query_type non-nested --set_clause_by_clause --has_where --has_group --has_having --has_order
echo 'run for pets_1 type --query_type spj-nested --set_nested_query_type --has_type_n'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/pets_1_SPJ-TYPE-N.sql --db spider --schema_name pets_1 --query_type spj-nested --set_nested_query_type --has_type_n
echo 'run for pets_1 type --query_type spj-nested --set_nested_query_type --has_type_a'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/pets_1_SPJ-TYPE-A.sql --db spider --schema_name pets_1 --query_type spj-nested --set_nested_query_type --has_type_a
echo 'run for pets_1 type --query_type spj-nested --set_nested_query_type --has_type_j'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/pets_1_SPJ-TYPE-J.sql --db spider --schema_name pets_1 --query_type spj-nested --set_nested_query_type --has_type_j
echo 'run for pets_1 type --query_type spj-nested --set_nested_query_type --has_type_ja'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/pets_1_SPJ-TYPE-JA.sql --db spider --schema_name pets_1 --query_type spj-nested --set_nested_query_type --has_type_ja
echo 'run for pets_1 type --query_type nested --set_nested_query_type --has_type_n'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/pets_1_TYPE-N.sql --db spider --schema_name pets_1 --query_type nested --set_nested_query_type --has_type_n
echo 'run for pets_1 type --query_type nested --set_nested_query_type --has_type_a'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/pets_1_TYPE-A.sql --db spider --schema_name pets_1 --query_type nested --set_nested_query_type --has_type_a
echo 'run for pets_1 type --query_type nested --set_nested_query_type --has_type_j'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/pets_1_TYPE-J.sql --db spider --schema_name pets_1 --query_type nested --set_nested_query_type --has_type_j
echo 'run for pets_1 type --query_type nested --set_nested_query_type --has_type_ja'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/pets_1_TYPE-JA.sql --db spider --schema_name pets_1 --query_type nested --set_nested_query_type --has_type_ja
echo 'run for concert_singer type --query_type spj-non-nested'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/concert_singer_SPJ.sql --db spider --schema_name concert_singer --query_type spj-non-nested
echo 'run for concert_singer type --query_type non-nested --set_clause_by_clause --has_group'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/concert_singer_GROUP.sql --db spider --schema_name concert_singer --query_type non-nested --set_clause_by_clause --has_group
echo 'run for concert_singer type --query_type non-nested --set_clause_by_clause --has_group --has_having'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/concert_singer_HAVING.sql --db spider --schema_name concert_singer --query_type non-nested --set_clause_by_clause --has_group --has_having
echo 'run for concert_singer type --query_type non-nested --set_clause_by_clause --has_order'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/concert_singer_ORDER.sql --db spider --schema_name concert_singer --query_type non-nested --set_clause_by_clause --has_order
echo 'run for concert_singer type --query_type non-nested --set_clause_by_clause --has_order --has_limit'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/concert_singer_LIMIT.sql --db spider --schema_name concert_singer --query_type non-nested --set_clause_by_clause --has_order --has_limit
echo 'run for concert_singer type --query_type non-nested --set_clause_by_clause --has_where --has_group'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/concert_singer_WHERE_GROUP.sql --db spider --schema_name concert_singer --query_type non-nested --set_clause_by_clause --has_where --has_group
echo 'run for concert_singer type --query_type non-nested --set_clause_by_clause --has_where --has_group --has_having'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/concert_singer_WHERE_HAVING.sql --db spider --schema_name concert_singer --query_type non-nested --set_clause_by_clause --has_where --has_group --has_having
echo 'run for concert_singer type --query_type non-nested --set_clause_by_clause --has_where --has_order'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/concert_singer_WHERE_ORDER.sql --db spider --schema_name concert_singer --query_type non-nested --set_clause_by_clause --has_where --has_order
echo 'run for concert_singer type --query_type non-nested --set_clause_by_clause --has_where --has_group --has_order'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/concert_singer_WHERE_GROUP_ORDER.sql --db spider --schema_name concert_singer --query_type non-nested --set_clause_by_clause --has_where --has_group --has_order
echo 'run for concert_singer type --query_type non-nested --set_clause_by_clause --has_where --has_group --has_having --has_order'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/concert_singer_WHERE_HAVING_ORDER.sql --db spider --schema_name concert_singer --query_type non-nested --set_clause_by_clause --has_where --has_group --has_having --has_order
echo 'run for concert_singer type --query_type spj-nested --set_nested_query_type --has_type_n'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/concert_singer_SPJ-TYPE-N.sql --db spider --schema_name concert_singer --query_type spj-nested --set_nested_query_type --has_type_n
echo 'run for concert_singer type --query_type spj-nested --set_nested_query_type --has_type_a'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/concert_singer_SPJ-TYPE-A.sql --db spider --schema_name concert_singer --query_type spj-nested --set_nested_query_type --has_type_a
echo 'run for concert_singer type --query_type spj-nested --set_nested_query_type --has_type_j'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/concert_singer_SPJ-TYPE-J.sql --db spider --schema_name concert_singer --query_type spj-nested --set_nested_query_type --has_type_j
echo 'run for concert_singer type --query_type spj-nested --set_nested_query_type --has_type_ja'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/concert_singer_SPJ-TYPE-JA.sql --db spider --schema_name concert_singer --query_type spj-nested --set_nested_query_type --has_type_ja
echo 'run for concert_singer type --query_type nested --set_nested_query_type --has_type_n'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/concert_singer_TYPE-N.sql --db spider --schema_name concert_singer --query_type nested --set_nested_query_type --has_type_n
echo 'run for concert_singer type --query_type nested --set_nested_query_type --has_type_a'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/concert_singer_TYPE-A.sql --db spider --schema_name concert_singer --query_type nested --set_nested_query_type --has_type_a
echo 'run for concert_singer type --query_type nested --set_nested_query_type --has_type_j'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/concert_singer_TYPE-J.sql --db spider --schema_name concert_singer --query_type nested --set_nested_query_type --has_type_j
echo 'run for concert_singer type --query_type nested --set_nested_query_type --has_type_ja'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/concert_singer_TYPE-JA.sql --db spider --schema_name concert_singer --query_type nested --set_nested_query_type --has_type_ja
echo 'run for car_1 type --query_type spj-non-nested'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/car_1_SPJ.sql --db spider --schema_name car_1 --query_type spj-non-nested
echo 'run for car_1 type --query_type non-nested --set_clause_by_clause --has_group'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/car_1_GROUP.sql --db spider --schema_name car_1 --query_type non-nested --set_clause_by_clause --has_group
echo 'run for car_1 type --query_type non-nested --set_clause_by_clause --has_group --has_having'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/car_1_HAVING.sql --db spider --schema_name car_1 --query_type non-nested --set_clause_by_clause --has_group --has_having
echo 'run for car_1 type --query_type non-nested --set_clause_by_clause --has_order'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/car_1_ORDER.sql --db spider --schema_name car_1 --query_type non-nested --set_clause_by_clause --has_order
echo 'run for car_1 type --query_type non-nested --set_clause_by_clause --has_order --has_limit'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/car_1_LIMIT.sql --db spider --schema_name car_1 --query_type non-nested --set_clause_by_clause --has_order --has_limit
echo 'run for car_1 type --query_type non-nested --set_clause_by_clause --has_where --has_group'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/car_1_WHERE_GROUP.sql --db spider --schema_name car_1 --query_type non-nested --set_clause_by_clause --has_where --has_group
echo 'run for car_1 type --query_type non-nested --set_clause_by_clause --has_where --has_group --has_having'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/car_1_WHERE_HAVING.sql --db spider --schema_name car_1 --query_type non-nested --set_clause_by_clause --has_where --has_group --has_having
echo 'run for car_1 type --query_type non-nested --set_clause_by_clause --has_where --has_order'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/car_1_WHERE_ORDER.sql --db spider --schema_name car_1 --query_type non-nested --set_clause_by_clause --has_where --has_order
echo 'run for car_1 type --query_type non-nested --set_clause_by_clause --has_where --has_group --has_order'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/car_1_WHERE_GROUP_ORDER.sql --db spider --schema_name car_1 --query_type non-nested --set_clause_by_clause --has_where --has_group --has_order
echo 'run for car_1 type --query_type non-nested --set_clause_by_clause --has_where --has_group --has_having --has_order'
python3 query_generator_v2.py --num_queries 20 --output output_per_type_generation/car_1_WHERE_HAVING_ORDER.sql --db spider --schema_name car_1 --query_type non-nested --set_clause_by_clause --has_where --has_group --has_having --has_order
echo 'run for car_1 type --query_type spj-nested --set_nested_query_type --has_type_n'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/car_1_SPJ-TYPE-N.sql --db spider --schema_name car_1 --query_type spj-nested --set_nested_query_type --has_type_n
echo 'run for car_1 type --query_type spj-nested --set_nested_query_type --has_type_a'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/car_1_SPJ-TYPE-A.sql --db spider --schema_name car_1 --query_type spj-nested --set_nested_query_type --has_type_a
echo 'run for car_1 type --query_type spj-nested --set_nested_query_type --has_type_j'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/car_1_SPJ-TYPE-J.sql --db spider --schema_name car_1 --query_type spj-nested --set_nested_query_type --has_type_j
echo 'run for car_1 type --query_type spj-nested --set_nested_query_type --has_type_ja'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/car_1_SPJ-TYPE-JA.sql --db spider --schema_name car_1 --query_type spj-nested --set_nested_query_type --has_type_ja
echo 'run for car_1 type --query_type nested --set_nested_query_type --has_type_n'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/car_1_TYPE-N.sql --db spider --schema_name car_1 --query_type nested --set_nested_query_type --has_type_n
echo 'run for car_1 type --query_type nested --set_nested_query_type --has_type_a'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/car_1_TYPE-A.sql --db spider --schema_name car_1 --query_type nested --set_nested_query_type --has_type_a
echo 'run for car_1 type --query_type nested --set_nested_query_type --has_type_j'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/car_1_TYPE-J.sql --db spider --schema_name car_1 --query_type nested --set_nested_query_type --has_type_j
echo 'run for car_1 type --query_type nested --set_nested_query_type --has_type_ja'
python3 query_generator_v2.py --num_queries 10 --output output_per_type_generation/car_1_TYPE-JA.sql --db spider --schema_name car_1 --query_type nested --set_nested_query_type --has_type_ja
