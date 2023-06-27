import psycopg
from src.utils.pg_connector import DBConnector
import traceback

from typing import Any, List


class PostgreSQLDatabase(DBConnector):
    def __init__(self, user_id: str, passwd: str, host: str, port: str, db_id: str):
        super(PostgreSQLDatabase, self).__init__(db_id=db_id)
        self.connect(user_id, passwd, host, port, db_id)
        self.conn.autocommit = True

    def __new__(cls, user_id, passwd, host, port, db_id):
        return super(PostgreSQLDatabase, cls).__new__(cls, db_id)

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
        self.cur.execute(sql)
        tables = [
            f"{str(table[0].lower())}.{str(table[1].lower())}".replace("public.", "") for table in self.fetchall()
        ]
        return tables

    def fetch_column_names(self, table_name: str) -> List[str]:
        sql = f"""
            SELECT *
            FROM
                {table_name}
            LIMIT 0;
            """
        self.execute(sql)
        return [desc[0] for desc in self.description()]

    def fetch_all_values(self, table_name: str, column_name: str):
        sql = f"""
            SELECT {column_name}
            FROM
                {table_name};
            """
        self.execute(sql)
        return [data[0] for data in self.fetchall()]

    def fetch_distinct_values(self, table_name: str, column_name: str):
        sql = f"""
            SELECT DISTINCT {column_name}
            FROM
                {table_name}
            WHERE {column_name} IS NOT NULL;
            """
        self.execute(sql)
        return [data[0] for data in self.fetchall()]

    def check_row_exists(self, table_name: str, additional_clauses: str = None):
        sql = f"""
            SELECT COUNT(*)
            FROM
                {table_name}
            """
        if additional_clauses is not None:
            sql += f""" {additional_clauses}"""
        sql += "LIMIT 2;"
        self.execute(sql)
        return (self.fetchall())[0][0]

    def check_distinct_value_exists(self, table_name: str, column_name: str, additional_clauses: str = None):
        sql = f"""
            SELECT COUNT(DISTINCT {column_name})
            FROM
                {table_name}
            """
        if additional_clauses is not None:
            sql += f""" {additional_clauses}"""
        sql += "LIMIT 2;"
        self.execute(sql)
        return (self.fetchall())[0][0]

    def get_row_counts(self, table_name: str, additional_clauses: str = None):
        sql = f"""
            SELECT COUNT(*)
            FROM
                {table_name}
            """
        if additional_clauses is not None:
            sql += f""" {additional_clauses}"""
        sql += ";"
        self.execute(sql)
        return (self.fetchall())[0][0]

    def get_distinct_value_counts(self, table_name: str, column_name: str, additional_clauses: str = None):
        sql = f"""
            SELECT COUNT(DISTINCT {column_name})
            FROM
                {table_name}
            """
        if additional_clauses is not None:
            sql += f""" {additional_clauses}"""
        sql += ";"
        self.execute(sql)
        return (self.fetchall())[0][0]

    def get_primary_keys(self, table_name: str):
        sql = f"""select conrelid::regclass, conname AS primary_key, pg_get_constraintdef(oid) 
        from pg_constraint where conrelid::regclass::text = '{table_name}' and pg_get_constraintdef(oid) LIKE 'PRIMARY%'
        """
        self.execute(sql)
        data = self.fetchall()
        assert len(data) == 1
        key_state = (data[0][2].replace("PRIMARY KEY (", "").strip())[:-1]
        keys = key_state.split(", ")
        return keys

    def sample_rows(self, table_name: str, sample_size: int, is_virtual=False):
        if is_virtual:
            row_counts = self.get_row_counts(table_name)
            percentage = min(1, (sample_size / row_counts))
            sample_rows_sql = f"""SELECT * FROM {table_name} WHERE random() < {percentage} LIMIT {sample_size}"""
        else:
            row_counts = self.get_row_counts(table_name)
            percentage = min(100, (sample_size / row_counts) * 100)
            sample_rows_sql = f"""SELECT * FROM {table_name} TABLESAMPLE SYSTEM ({percentage}) LIMIT {sample_size};"""
        self.execute(sample_rows_sql)
        data = self.fetchall()
        cols = [desc[0] for desc in self.description()]
        return data, cols

    def sample_rows_with_cond(self, table_name: str, cond: str, sample_size: int):
        row_counts = self.get_row_counts(table_name)
        percentage = min(1, (sample_size / row_counts))
        sample_rows_sql = (
            f"""SELECT * FROM {table_name} WHERE random() < {percentage} AND {cond} LIMIT {sample_size};"""
        )
        self.execute(sample_rows_sql)
        data = self.fetchall()
        cols = [desc[0] for desc in self.description()]
        return data, cols

    def is_existing_view(self, view_id, type="materialized"):
        check_view_sql = "SELECT COUNT(*) "
        if type == "materialized":
            check_view_sql += f"""FROM pg_catalog.pg_matviews WHERE matviewname = '{view_id.lower()}';"""
        else:
            check_view_sql += f"""FROM pg_catalog.pg_views WHERE viewname = '{view_id.lower()}';"""
        self.execute(check_view_sql)
        count = self.fetchall()[0][0]
        assert count in (0, 1)

        return count == 1

    def create_view(self, logger, view_id, sql, type="materialized", drop_if_exists=False):
        # Check if view_id already exists
        if self.is_existing_view(view_id, type):
            if drop_if_exists:
                logger.info(f"DROP exisiting view named {view_id}")
                self.drop_view(logger, view_id, type, cascade=True)
            else:
                logger.info(f"Skip creating view named {view_id}: already exists")
                return

        if type == "materialized":
            view_sql = "CREATE MATERIALIZED VIEW "
        else:
            view_sql = "CREATE VIEW "
        view_sql += f""" {view_id} AS {sql};"""
        self.execute(view_sql)
        return

    def drop_view(self, logger, view_id, type="materialized", cascade=False):
        if not self.is_existing_view(view_id, type):
            logger.warning(f"Skip drop view named {view_id} typed {type}: not exists")
            return

        if type == "materialized":
            view_sql = f"""DROP MATERIALIZED VIEW {view_id}"""
        else:
            view_sql = f"""DROP VIEW {view_id}"""

        if cascade:
            view_sql += " CASCADE;"
        else:
            view_sql += ";"
        # logger.info(f"Drop view named {view_id} typed {type}")
        self.execute(view_sql)
        return
