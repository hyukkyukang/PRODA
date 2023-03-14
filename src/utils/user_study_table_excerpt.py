from src.table_excerpt.table_excerpt import TableExcerpt
import sqlite3

def get_table_names(cur):
    sql_query = """SELECT name FROM sqlite_master WHERE type='table';"""
    cur.execute(sql_query)
    table_names = list(map(lambda x: x[0], cur.fetchall()))

    return table_names

def get_table_headers(cur, table):
    sql_query = """SELECT * FROM {}""".format(table)
    cur.execute(sql_query)
    headers = list(map(lambda x: x[0], cur.description))

    return headers

def get_table_col_types(cur, table):
    sql_query = """SELECT name, type FROM pragma_table_info({})""".format(table)
    cur.execute(sql_query)
    types = list(map(lambda x: x[0], cur.fetchall()))
    types = [ "number" if cur_type.lower() in ("int", "real") else "string" for cur_type in types ]

    return types

def get_table_rows(cur, table):
    sql_query = """SELECT * FROM {}""".format(table)
    rows = list(map(lambda x: list(x), cur.fetchall()))

    return rows


class BaseDB:
    def __init__(self):
        self._tables = {}
        self._sqlite3 = None
    
    def table(name) -> TableExcerpt:
        return self._tables[name]


headers = ["id", "title", "year", "time", "language", "release_date", "country"]
col_types = ["number", "string", "number", "number", "string", "string", "string"]
rows = [[1, "The Shawshank Redemption", 1994, 142, "English", "14 October 1994", "USA"]]

class MovieDB(BaseDB):
    def __init__(self):
        self._sqlite3 = "movie.sqlite3"

        conn = sqlite3.conect(self._sqlite3)
        cur = conn.cursor()

        table_names = get_table_names(cur)
        for table in table_names:
            headers = get_table_headers(cur, table)
            col_types = get_table_col_types(cur, table)
            rows = get_table_rows(cur, table)
            self._tables[table]=TableExcerpt(table, headers, col_types, rows=rows)

class AdvisingDB(BaseDB):
    def __init__(self):
        self._sqlite3 = "advising.sqlite3"

        conn = sqlite3.conect(self._sqlite3)
        cur = conn.cursor()

        table_names = get_table_names(cur)
        for table in table_names:
            headers = get_table_headers(cur, table)
            col_types = get_table_col_types(cur, table)
            rows = get_table_rows(cur, table)
            self._tables[table]=TableExcerpt(table, headers, col_types, rows=rows)

        

        
