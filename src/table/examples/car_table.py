from src.table.table import Table

headers = ["id", "model", "horsepower", "max_speed", "year", "price"]
col_types = ["number", "string", "number", "number", "number", "number"]
rows = [
    [1, "ford", 10, 200, 2019, 20000],
    [2, "cherlet", 10, 180, 2018, 15000],
    [3, "toyota", 10, 160, 2017, 10000],
    [4, "volkswage", 10, 140, 2016, 8000],
    [5, "amc", 10, 180, 2018, 15000],
    [6, "pontiac", 10, 720, 2012, 71000],
    [7, "datsun", 10, 830, 2013, 81000],
    [8, "hyundai", 10, 930, 2013, 91000],
    [9, "hyundai", 11, 940, 2014, 92000],
    [10, "kia", 10, 1030, 2014, 101000],
    [11, "genesis", 10, 1130, 2014, 111000],
    [12, "genesis", 11, 1140, 2015, 112000]
]

car_table = Table(headers, col_types, table_name="cars", rows=rows)

if __name__ == "__main__":
    stop = 1