SELECT cars_data.Weight, COUNT(*) FROM cars_data WHERE (cars_data.Accelerate > 16.5 OR cars_data.Horsepower = 67.0) GROUP BY cars_data.Weight
SELECT model_list.ModelId, COUNT(*) FROM model_list WHERE model_list.Model NOT LIKE "%ford" GROUP BY model_list.ModelId
SELECT continents.Continent, COUNT(DISTINCT continents.ContId) FROM continents WHERE continents.ContId = 1.0 GROUP BY continents.Continent
SELECT countries.Continent, COUNT(*) FROM countries WHERE ((countries.Continent != 2.0 AND countries.Continent != 1.0) OR countries.CountryId != 4.0) GROUP BY countries.Continent
SELECT cars_data.Cylinders, SUM(cars_data.MPG), COUNT(DISTINCT cars_data.Accelerate) FROM cars_data WHERE (cars_data.Cylinders <= 4.0 OR cars_data.Edispl = 72.0) GROUP BY cars_data.Cylinders
SELECT model_list.ModelId, COUNT(DISTINCT model_list.Maker), MAX(model_list.ModelId) FROM model_list WHERE (model_list.Model IN "('mazda','kia')" AND model_list.Maker = 12.0) GROUP BY model_list.ModelId
SELECT continents.ContId, COUNT(*) FROM continents WHERE continents.Continent != "africa" GROUP BY continents.ContId
SELECT car_makers.Id, COUNT(*) FROM car_makers WHERE (car_makers.Id = 2.0 OR car_makers.Id != 5.0) GROUP BY car_makers.Id
SELECT countries.Continent, COUNT(DISTINCT countries.CountryName), COUNT(DISTINCT countries.CountryId) FROM countries WHERE (countries.CountryName NOT IN "('uk','mexico','france','korea')" OR countries.Continent != 2.0) GROUP BY countries.Continent
SELECT car_makers.FullName, AVG(cars_data.Weight) FROM car_makers JOIN car_names JOIN cars_data JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model WHERE continents.ContId = 1.0 GROUP BY car_makers.FullName
SELECT continents.ContId, MAX(continents.ContId) FROM continents WHERE (continents.ContId = 1.0 OR continents.Continent NOT LIKE "europe%") GROUP BY continents.ContId
SELECT continents.ContId, MAX(countries.CountryId), COUNT(DISTINCT car_makers.FullName) FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE continents.Continent NOT IN "('america','africa','europe','australia')" GROUP BY continents.ContId
SELECT cars_data.MPG, SUM(cars_data.Cylinders) FROM cars_data WHERE ((cars_data.MPG <= 19.9 OR cars_data.Cylinders >= 4.0) OR cars_data.Weight < 3433.0) GROUP BY cars_data.MPG
SELECT car_names.Make, COUNT(*) FROM car_names WHERE (car_names.Make LIKE "%rabbit%" OR car_names.Model != "'volkswagen'") GROUP BY car_names.Make
SELECT continents.ContId, COUNT(DISTINCT model_list.Model) FROM car_makers JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE (continents.Continent NOT LIKE "%asia%" OR model_list.ModelId <= 16.0) GROUP BY continents.ContId
SELECT continents.ContId, COUNT(*) FROM countries WHERE countries.Continent != 1.0 GROUP BY continents.ContId
SELECT cars_data.Id, MIN(cars_data.Accelerate) FROM cars_data WHERE (cars_data.MPG < 34.1 AND cars_data.Horsepower < 80.0) GROUP BY cars_data.Id
SELECT cars_data.Weight, MIN(car_names.MakeId), SUM(cars_data.Weight) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE car_names.MakeId = 295.0 GROUP BY cars_data.Weight
SELECT car_names.Model, SUM(car_names.MakeId), COUNT(DISTINCT car_names.Make) FROM car_names WHERE ((car_names.Model != "amc" OR car_names.MakeId != 264.0) AND car_names.Make NOT LIKE "rx3%") GROUP BY car_names.Model
SELECT car_names.Model, COUNT(*) FROM car_names WHERE car_names.Model NOT LIKE "%saab" GROUP BY car_names.Model
