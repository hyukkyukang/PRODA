import psycopg
import traceback

from typing import Any, List


class DBConnector:
    # Static attributes
    connector_cache = {}

    def __init__(self, db_id: str):
        self.db_id = db_id
        self.conn = None
        self.cur = None

    def __new__(cls, db_id):
        if not db_id in DBConnector.connector_cache.keys():
            DBConnector.connector_cache[db_id] = super(DBConnector, cls).__new__(cls)
        return DBConnector.connector_cache[db_id]

    def execute(self, sql: str) -> List[Any]:
        return self.cur.execute(sql)

    def fetchall(self) -> List[Any]:
        return self.cur.fetchall()

    def fetchone(self) -> List[Any]:
        return self.cur.fetchone()

    def close(self) -> None:
        self.conn.close()

    def __del__(self):
        self.close()

    def __enter__(self):
        return self.conn

    def __exit__(self, exc_type, exc_value, tb):
        if exc_type is not None:
            traceback.print_exception(exc_type, exc_value, tb)
        self.conn.close()
        return True


class PostgresConnector(DBConnector):
    def __init__(self, user_id: str, passwd: str, host: str, port: str, db_id: str):
        super(PostgresConnector, self).__init__(db_id=db_id)
        self.connect(user_id, passwd, host, port, db_id)
        self.conn.autocommit = True

    def __new__(cls, user_id, passwd, host, port, db_id):
        return super(PostgresConnector, cls).__new__(cls, db_id)

    def connect(self, user_id, passwd, host, port, db_id):
        self.conn = psycopg.connect(f"user={user_id} password={passwd} host={host} port={port} dbname={db_id}")
        self.cur = self.conn.cursor()

    def fetch_table_names(self) -> List[str]:
        sql = """
            SELECT *
            FROM pg_catalog.pg_tables
            WHERE schemaname != 'pg_catalog' AND 
                  schemaname != 'information_schema';
        """
        self.cursor.execute(sql)
        tables = [
            f"{str(table[0].lower())}.{str(table[1].lower())}".replace("public.", "")
            for table in self.cursor.fetchall()
        ]
        return tables

    def fetch_column_names(self, table_ref: str) -> List[str]:
        def table_name_contains_schema(table_ref):
            return "." in table_ref

        if table_name_contains_schema(table_ref):
            table_schema = table_ref.split(".")[0]
            table_name = table_ref.split(".")[1]
        else:
            table_schema = "public"
            table_name = table_ref
        sql = f"""
            SELECT *
            FROM
                information_schema.columns
            WHERE
                table_schema = '{table_schema}'
                AND table_name = '{table_name}';
            """
        self.execute(sql)
        return [str(col[3].lower()) for col in self.fetchall()]

    def fetch_column_types(self, table_ref: str) -> List[str]:
        def table_name_contains_schema(table_ref):
            return "." in table_ref

        if table_name_contains_schema(table_ref):
            table_schema = table_ref.split(".")[0]
            table_name = table_ref.split(".")[1]
        else:
            table_schema = "public"
            table_name = table_ref
        sql = f"""
            SELECT *
            FROM
                information_schema.columns
            WHERE
                table_schema = '{table_schema}'
                AND table_name = '{table_name}';
            """
        self.execute(sql)
        return [str(col[7].lower()) for col in self.fetchall()]
