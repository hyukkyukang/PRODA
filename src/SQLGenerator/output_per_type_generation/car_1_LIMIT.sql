SELECT * FROM countries ORDER BY countries.Continent LIMIT 4
SELECT continents.Continent FROM continents ORDER BY continents.ContId LIMIT 2
SELECT MIN(cars_data.Weight) FROM cars_data ORDER BY cars_data.Horsepower LIMIT 3
SELECT countries.CountryId, countries.CountryName FROM countries ORDER BY countries.CountryName LIMIT 2
SELECT SUM(cars_data.Weight), MIN(cars_data.Cylinders) FROM cars_data ORDER BY cars_data.Id LIMIT 2
SELECT * FROM car_names ORDER BY car_names.Model LIMIT 1
SELECT COUNT(DISTINCT car_makers.Maker) FROM car_makers ORDER BY model_list.Model LIMIT 3
SELECT * FROM cars_data ORDER BY cars_data.Year LIMIT 4
SELECT * FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country ORDER BY countries.CountryId LIMIT 2
SELECT continents.Continent, countries.Continent FROM continents JOIN countries ON continents.ContId=countries.Continent ORDER BY continents.Continent LIMIT 1
SELECT continents.Continent, continents.ContId FROM continents ORDER BY continents.Continent LIMIT 4
SELECT continents.ContId, continents.Continent FROM continents ORDER BY continents.ContId LIMIT 3
SELECT MAX(model_list.Maker) FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country ORDER BY model_list.Model LIMIT 2
SELECT COUNT(*) FROM model_list ORDER BY model_list.ModelId LIMIT 3
SELECT * FROM car_makers JOIN car_names JOIN cars_data JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model ORDER BY countries.CountryName LIMIT 4
SELECT continents.ContId, continents.Continent FROM continents ORDER BY continents.Continent LIMIT 3
SELECT cars_data.Accelerate FROM cars_data ORDER BY car_names.MakeId LIMIT 2
SELECT car_makers.Country, car_makers.FullName FROM car_makers ORDER BY countries.CountryName LIMIT 3
SELECT car_makers.Country, car_makers.FullName FROM car_makers ORDER BY car_makers.Country LIMIT 3
SELECT * FROM model_list ORDER BY car_names.Make LIMIT 2
