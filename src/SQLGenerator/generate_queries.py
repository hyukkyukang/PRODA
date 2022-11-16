import subprocess
import glob

dbs = glob.glob('data/csv/*')

for db in dbs:
    db_name = db.split('/')[-1]

    subprocess.run(["python3", "generate_queires.py",
                    "--num_queries", "100",
                    "--output", db_name + ".out",
                    "--schema_name", db_name, 
                    "--db", "spider"])