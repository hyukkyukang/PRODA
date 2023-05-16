import os
import sys
sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))))
from src.table_excerpt.table_excerpt import TableExcerpt

# Car table
headers = ["id", "model", "horsepower", "max_speed", "year", "price"]
col_types = ["number", "string", "number", "number", "number", "number"]
rows = [
    [1, "ford", 10, 230, 2010, 20000],
    [2, "cherlet", 10, 330, 2010, 15000],
    [3, "toyota", 10, 430, 2011, 10000],
    [4, "volkswage", 10, 530, 2011, 8000],
    [5, "amc", 10, 630, 2012, 15000],
    [6, "pontiac", 10, 730, 2012, 71000],
    [7, "datsun", 10, 830, 2013, 81000],
    [8, "hyundai", 10, 930, 2013, 91000],
    [9, "hyundai", 11, 940, 2014, 92000],
    [10, "kia", 10, 1030, 2014, 101000],
    [11, "genesis", 10, 1130, 2014, 111000],
    [12, "genesis", 11, 1140, 2015, 112000],
]

car_table = TableExcerpt("cars", headers, col_types, rows=rows)

# IDMB Movie table
headers = ["id", "title", "year", "time", "language", "release_date", "country"]
col_types = ["number", "string", "number", "number", "string", "string", "string"]
rows = [[1, "The Shawshank Redemption", 1994, 142, "English", "14 October 1994", "USA"]]
rows.append([2, "The Godfather", 1972, 175, "English", "24 March 1972", "USA"])
rows.append([3, "The Godfather: Part II", 1974, 202, "English", "20 December 1974", "USA"])

movie_table = TableExcerpt("movie", headers, col_types, rows=rows)

# IDMB director table
headers = ["id", "first_name", "last_name"]
col_types = ["number", "string", "string"]
rows = [[1, "Frank", "Darabont"]]
rows.append([2, "Francis Ford", "Coppola"])
rows.append([3, "Francis Ford", "Coppola"])

director_table = TableExcerpt("director", headers, col_types, rows=rows)

# IDMB direction table
headers = ["mov_id", "dir_id"]
col_types = ["number", "number"]
rows = [[1, 1]]
rows.append([2, 2])

direction_table = TableExcerpt("direction", headers, col_types, rows=rows)

# IDMB rating table
headers = ["rev_id", "mov_id", "stars", "review"]
col_types = ["number", "number", "number", "string"]
rows = [[1, 1, 5, "This is a great movie!"]]
rows.append([2, 2, 4, "This is a good movie!"])
rows.append([3, 3, 3, "This is a so-so movie!"])

rating_table = TableExcerpt("rating", headers, col_types, rows=rows)

if __name__ == "__main__":
    pass
