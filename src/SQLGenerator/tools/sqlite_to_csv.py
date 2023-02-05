import sqlite3
import glob
import csv
import os

dbs = glob.glob('data/database/*/*.sqlite')

for db in dbs:
    db_name = db.split('/')[2]
    csv_dir = 'data/csv/' + db_name + '/'
    if not os.path.isdir(csv_dir):
        os.makedirs(csv_dir)

    con = sqlite3.connect(db)
    con.text_factory = lambda b: b.decode(errors = 'ignore') # ignoring non-UTF8 texts
    cur = con.cursor()

    cur.execute("SELECT name FROM sqlite_master WHERE type = 'table';")
    tables = [t[0] for t in cur.fetchall()]

    for table in tables:
        cur.execute("PRAGMA table_info(" + table + ")")
        columns = [c[1] for c in cur.fetchall()]

        cur.execute("SELECT * FROM " + table + ";")
        rows = cur.fetchall()

        csv_file = open(csv_dir + table + '.csv', 'w')
        writer = csv.writer(csv_file)
        writer.writerow(columns)
        writer.writerows(rows)

    con.close()




