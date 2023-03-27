SELECT countries.CountryName, COUNT(*) FROM countries WHERE (countries.Continent != 2.0 OR countries.Continent = 1.0) GROUP BY countries.CountryName ORDER BY countries.CountryName
SELECT cars_data.Id, AVG(cars_data.Accelerate) FROM cars_data WHERE cars_data.Edispl <= 105.0 GROUP BY cars_data.Id ORDER BY COUNT(cars_data.Year)
SELECT continents.Continent, AVG(countries.Continent), COUNT(DISTINCT countries.CountryName) FROM countries WHERE (countries.Continent != 3.0 OR countries.CountryId != 2.0) GROUP BY continents.Continent ORDER BY MAX(countries.Continent)
SELECT car_names.Make, COUNT(DISTINCT car_names.Model) FROM car_names WHERE (car_names.Make = "amc matador" OR car_names.MakeId != 226.0) GROUP BY car_names.Make ORDER BY car_names.MakeId
SELECT countries.Continent, COUNT(DISTINCT countries.CountryName), MAX(countries.CountryId) FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE continents.Continent != "europe" GROUP BY countries.Continent ORDER BY continents.Continent
SELECT countries.CountryId, COUNT(DISTINCT countries.Continent) FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE (continents.ContId = 1.0 OR continents.Continent LIKE "%america") GROUP BY countries.CountryId ORDER BY COUNT(countries.CountryName)
SELECT continents.ContId, COUNT(DISTINCT continents.Continent), SUM(continents.ContId) FROM continents WHERE continents.ContId != 1.0 GROUP BY continents.ContId ORDER BY COUNT(continents.Continent)
SELECT cars_data.Horsepower, MIN(car_names.MakeId) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE cars_data.Year > 1979.0 GROUP BY cars_data.Horsepower ORDER BY COUNT(cars_data.Cylinders)
SELECT cars_data.Cylinders, MAX(cars_data.Accelerate), MIN(cars_data.Cylinders) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE (cars_data.MPG >= 29.8 OR car_names.Model LIKE "%dodge") GROUP BY cars_data.Cylinders ORDER BY cars_data.Cylinders
SELECT cars_data.Horsepower, SUM(cars_data.MPG), AVG(cars_data.Edispl) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE car_names.MakeId = 144.0 GROUP BY cars_data.Horsepower ORDER BY COUNT(car_names.Model)
SELECT cars_data.Year, MAX(cars_data.MPG), MAX(cars_data.Horsepower) FROM cars_data WHERE (cars_data.Year = 1973.0 AND cars_data.Accelerate > 16.0) GROUP BY cars_data.Year ORDER BY SUM(cars_data.Cylinders)
SELECT model_list.Maker, MAX(model_list.Maker) FROM model_list WHERE (model_list.Model = "plymouth" OR model_list.ModelId = 15.0) GROUP BY model_list.Maker ORDER BY model_list.Maker
SELECT model_list.Maker, COUNT(DISTINCT continents.Continent) FROM car_makers JOIN car_names JOIN cars_data JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model WHERE (cars_data.Edispl >= 250.0 AND cars_data.Horsepower > 170.0) GROUP BY model_list.Maker ORDER BY SUM(cars_data.Horsepower)
SELECT countries.CountryName, MAX(countries.Continent) FROM countries WHERE ((countries.CountryId = 1.0 OR countries.Continent != 1.0) AND countries.CountryName NOT LIKE "%korea") GROUP BY countries.CountryName ORDER BY countries.CountryId
SELECT continents.ContId, COUNT(*) FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE (countries.CountryName LIKE "japan%" AND (continents.Continent NOT LIKE "%america" OR continents.Continent NOT LIKE "%africa")) GROUP BY continents.ContId ORDER BY COUNT(countries.CountryName)
SELECT cars_data.Cylinders, SUM(cars_data.Horsepower), AVG(cars_data.Year) FROM cars_data WHERE (cars_data.Weight < 2500.0 AND cars_data.Year != 1978.0) GROUP BY cars_data.Cylinders ORDER BY cars_data.Cylinders
SELECT continents.Continent, COUNT(DISTINCT continents.ContId), COUNT(DISTINCT continents.Continent) FROM continents WHERE continents.ContId != 2.0 GROUP BY continents.Continent ORDER BY MAX(continents.ContId)
SELECT car_makers.FullName, SUM(car_makers.Country) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country WHERE countries.CountryName = "usa" GROUP BY car_makers.FullName ORDER BY COUNT(continents.Continent)
SELECT countries.CountryName, SUM(countries.Continent) FROM countries WHERE countries.CountryId != 1.0 GROUP BY countries.CountryName ORDER BY continents.Continent
SELECT cars_data.Horsepower, MIN(car_names.MakeId) FROM car_names WHERE car_names.MakeId != 156.0 GROUP BY cars_data.Horsepower ORDER BY SUM(cars_data.Edispl)
