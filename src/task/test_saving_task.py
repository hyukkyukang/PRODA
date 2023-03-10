import os
from src.utils.data_manager import save_task_in_db, save_data
from src.utils.example_queries import MultipleSublinksQuery2

DATA_DIR = "/home/proda/database/dataCollection/tasks/"

if __name__ == "__main__":
    query = MultipleSublinksQuery2()

    nl = "dummy_nl"
    sql = "dummy_sql"
    query_type = 1
    db_name = "dummy_db_name"
    task_type = 2

    # Save evql
    evql = query.evql
    evql_path = os.path.join(DATA_DIR, "evql.pkl")
    save_data(evql, evql_path)

    # Save table_excerpt
    table_excerpt = query.evql.node.table_excerpt
    table_excerpt_path = os.path.join(DATA_DIR, "table_excerpt.pkl")
    save_data(table_excerpt, table_excerpt_path)

    # Save result_table
    result_table = query.evql.node.table_excerpt
    result_table_path = os.path.join(DATA_DIR, "result_table.pkl")
    save_data(result_table, result_table_path)

    save_task_in_db(nl, sql, evql_path, query_type, table_excerpt_path, result_table_path, db_name, task_type)

    evql = query.evql
    print("Done!")
