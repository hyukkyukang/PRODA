SELECT cars_data.Weight, COUNT(*) FROM cars_data GROUP BY cars_data.Weight
SELECT countries.CountryId, COUNT(*) FROM countries GROUP BY countries.CountryId
SELECT car_names.Model, COUNT(*) FROM car_names GROUP BY car_names.Model
SELECT continents.ContId, COUNT(*) FROM countries GROUP BY continents.ContId
SELECT model_list.Maker, MAX(model_list.Maker) FROM model_list GROUP BY model_list.Maker
SELECT car_names.Model, COUNT(*) FROM car_names GROUP BY car_names.Model
SELECT continents.Continent, COUNT(DISTINCT model_list.Model) FROM car_makers JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country GROUP BY continents.Continent
SELECT car_makers.Country, COUNT(*) FROM countries GROUP BY car_makers.Country
SELECT car_makers.Country, COUNT(*) FROM car_makers GROUP BY car_makers.Country
SELECT car_makers.Maker, COUNT(DISTINCT car_names.Make) FROM car_names JOIN model_list ON model_list.Model=car_names.Model GROUP BY car_makers.Maker
SELECT car_makers.Maker, COUNT(*) FROM car_makers GROUP BY car_makers.Maker
SELECT car_makers.Id, MAX(cars_data.MPG) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id GROUP BY car_makers.Id
SELECT model_list.Model, COUNT(*) FROM car_names JOIN model_list ON model_list.Model=car_names.Model GROUP BY model_list.Model
SELECT car_names.Make, COUNT(DISTINCT car_names.Make), MAX(car_names.MakeId) FROM car_names GROUP BY car_names.Make
SELECT countries.CountryName, COUNT(*) FROM countries GROUP BY countries.CountryName
SELECT continents.ContId, COUNT(*) FROM continents GROUP BY continents.ContId
SELECT continents.ContId, COUNT(DISTINCT continents.Continent) FROM continents GROUP BY continents.ContId
SELECT car_makers.Country, COUNT(DISTINCT countries.Continent) FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country GROUP BY car_makers.Country
SELECT continents.ContId, COUNT(*) FROM continents GROUP BY continents.ContId
SELECT countries.CountryId, SUM(continents.ContId) FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country GROUP BY countries.CountryId
