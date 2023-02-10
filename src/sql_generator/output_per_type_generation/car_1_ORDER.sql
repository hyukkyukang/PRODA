SELECT * FROM car_names ORDER BY car_names.MakeId
SELECT countries.Continent, car_makers.FullName FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country ORDER BY countries.CountryId
SELECT car_names.MakeId, cars_data.Horsepower FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id ORDER BY cars_data.Horsepower
SELECT cars_data.Year, cars_data.Id FROM cars_data ORDER BY cars_data.Year
SELECT continents.Continent FROM continents ORDER BY continents.Continent
SELECT countries.CountryName FROM countries ORDER BY countries.CountryName
SELECT * FROM car_makers ORDER BY model_list.Maker
SELECT SUM(cars_data.Id), MAX(cars_data.Weight) FROM cars_data ORDER BY car_names.Model
SELECT * FROM continents ORDER BY continents.ContId
SELECT * FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country ORDER BY car_makers.Maker
SELECT countries.CountryId, countries.Continent FROM countries ORDER BY countries.CountryName
SELECT cars_data.Edispl, cars_data.Horsepower FROM cars_data ORDER BY cars_data.Cylinders
SELECT * FROM countries ORDER BY countries.Continent
SELECT SUM(cars_data.Weight) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id ORDER BY car_names.MakeId
SELECT continents.Continent, continents.ContId FROM continents ORDER BY continents.Continent
SELECT cars_data.MPG FROM cars_data ORDER BY cars_data.Cylinders
SELECT car_makers.Id, car_makers.Country FROM car_makers ORDER BY car_makers.Maker
SELECT COUNT(*) FROM countries ORDER BY countries.CountryName
SELECT model_list.ModelId FROM model_list ORDER BY model_list.Model
SELECT car_names.MakeId FROM car_names ORDER BY car_makers.Id
