from src.task import Task


def create_task(sql_type) -> Task:
    # Generate SQL query
    sql = "SELECT name FROM students"

    # Create EVQL

    # Create NL

    # Wrap with Task class
    task = Task(
        nl=None,
        sql=None,
        evql=None,
        table_excerpt=None,
        result_table=None,
        query_type=None,
        task_type=None,
        db_name=None,
    )

    return task


if __name__ == "__main__":
    pass
