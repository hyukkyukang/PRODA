SELECT cars_data.Weight, COUNT(*) FROM cars_data GROUP BY cars_data.Weight HAVING AVG(cars_data.MPG) <= 30.7
SELECT continents.ContId, COUNT(*) FROM continents GROUP BY continents.ContId HAVING (COUNT(continents.Continent) <= 1 OR continents.ContId != 1.0)
SELECT car_makers.Country, COUNT(DISTINCT car_makers.Id) FROM car_makers GROUP BY car_makers.Country HAVING (COUNT(car_makers.Maker) < 3 AND COUNT(car_makers.Maker) = 4)
SELECT continents.Continent, COUNT(DISTINCT continents.Continent), MIN(continents.ContId) FROM continents GROUP BY continents.Continent HAVING MIN(continents.ContId) = 2.0
SELECT model_list.ModelId, COUNT(DISTINCT model_list.Model), COUNT(DISTINCT model_list.Maker) FROM model_list GROUP BY model_list.ModelId HAVING (model_list.ModelId = 11.0 AND COUNT(model_list.Model) != 2)
SELECT car_names.Model, COUNT(DISTINCT car_makers.Maker) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country GROUP BY car_names.Model HAVING (MAX(car_makers.Country) > 1.0 OR (SUM(model_list.Maker) = 1.0 OR SUM(cars_data.Horsepower) >= 97.0))
SELECT model_list.ModelId, MIN(countries.CountryId) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country GROUP BY model_list.ModelId HAVING (model_list.ModelId <= 36.0 AND COUNT(car_makers.Maker) > 4)
SELECT model_list.Model, COUNT(*) FROM model_list GROUP BY model_list.Model HAVING (SUM(model_list.Maker) != 19.0 AND model_list.Model != "bmw")
SELECT cars_data.MPG, COUNT(*) FROM cars_data GROUP BY cars_data.MPG HAVING (AVG(cars_data.Edispl) <= 134.0 OR (cars_data.MPG <= 29.8 AND AVG(cars_data.Accelerate) <= 15.5))
SELECT model_list.Model, MIN(model_list.ModelId) FROM model_list GROUP BY model_list.Model HAVING (model_list.Model LIKE "%amc" OR model_list.Model IN "("('amc','opel','citroen','volvo')", 4)")
SELECT countries.Continent, COUNT(DISTINCT countries.CountryName) FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country GROUP BY countries.Continent HAVING (SUM(countries.CountryId) = 1.0 AND COUNT(car_makers.Maker) < 1)
SELECT car_makers.Country, COUNT(*) FROM car_makers GROUP BY car_makers.Country HAVING (COUNT(car_makers.Id) < 4 OR MIN(continents.ContId) < 2.0)
SELECT car_makers.FullName, COUNT(*) FROM model_list GROUP BY car_makers.FullName HAVING (COUNT(car_makers.Maker) <= 2 AND SUM(car_makers.Id) >= 2.0)
SELECT continents.Continent, COUNT(DISTINCT continents.Continent) FROM continents GROUP BY continents.Continent HAVING continents.Continent NOT LIKE "%asia"
SELECT cars_data.Weight, COUNT(*) FROM cars_data GROUP BY cars_data.Weight HAVING COUNT(cars_data.Edispl) > 4
SELECT car_makers.Maker, COUNT(DISTINCT car_makers.FullName) FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country GROUP BY car_makers.Maker HAVING COUNT(countries.CountryName) != 3
SELECT car_names.Model, SUM(car_names.MakeId), COUNT(DISTINCT car_names.Make) FROM car_names GROUP BY car_names.Model HAVING ((car_names.Model NOT LIKE "amc%" AND COUNT(car_names.Make) != 2) AND AVG(car_names.MakeId) != 358.0)
SELECT car_names.Model, COUNT(*) FROM car_names GROUP BY car_names.Model HAVING (COUNT(car_names.Make) >= 2 AND MIN(cars_data.MPG) <= 30.0)
SELECT car_makers.Maker, SUM(countries.Continent), MIN(car_makers.Id) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country GROUP BY car_makers.Maker HAVING SUM(countries.Continent) = 3.0
SELECT countries.CountryId, SUM(continents.ContId) FROM continents JOIN countries ON continents.ContId=countries.Continent GROUP BY countries.CountryId HAVING (COUNT(countries.CountryName) != 2 AND (COUNT(continents.Continent) >= 3 OR COUNT(continents.Continent) != 1))
