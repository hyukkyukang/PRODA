from src.table.table import Table

headers = ["id", "model", "horsepower", "max_speed", "year", "price"]
col_types = ["number", "string", "number", "number", "number", "number"]
rows = [
    [1, "ford", 10, 200, 2019, 20000],
    [2, "cherlet", 10, 180, 2018, 15000],
    [3, "toyota", 10, 160, 2017, 10000],
    [4, "volkswage", 10, 140, 2016, 8000],
    [5, "amc", 10, 180, 2018, 15000],
]

car_table = Table(headers, col_types, table_name="cars", rows=rows)

if __name__ == "__main__":
    stop = 1