SELECT continents.Continent, COUNT(DISTINCT O_car_makers.Maker), MIN(O_car_makers.Country) FROM car_makers O_car_makers WHERE O_car_makers.Id <= (SELECT SUM(I_car_makers.Id) FROM car_makers I_car_makers WHERE (I_car_makers.FullName IN "('American Motor Company','Daimler Benz')" OR I_car_makers.Id = 9.0)) GROUP BY continents.Continent ORDER BY countries.Continent
SELECT car_makers.Id, COUNT(*) FROM car_makers O_car_makers WHERE O_car_makers.Country != (SELECT cars_data.Horsepower, MAX(I_car_makers.Country) FROM car_makers I_car_makers JOIN continents I_continents JOIN countries I_countries ON I_continents.ContId=I_countries.Continent AND I_countries.CountryId=I_car_makers.Country WHERE (I_continents.Continent NOT LIKE "%america%" OR (I_countries.Continent = 2.0 OR I_countries.CountryId != 2.0)) GROUP BY cars_data.Horsepower) GROUP BY car_makers.Id HAVING AVG(car_makers.Country) = 1.0
SELECT O_model_list.Maker, O_model_list.ModelId FROM model_list O_model_list WHERE (O_model_list.ModelId != (SELECT MIN(I_model_list.ModelId) FROM car_makers I_car_makers JOIN model_list I_model_list ON I_car_makers.Id=I_model_list.Maker WHERE I_car_makers.Maker NOT LIKE "ford%" ORDER BY car_makers.Maker) AND O_model_list.Model NOT LIKE "%nissan") ORDER BY model_list.ModelId LIMIT 2
SELECT continents.Continent, AVG(O_countries.Continent), COUNT(DISTINCT O_countries.CountryName) FROM continents O_continents JOIN countries O_countries ON O_continents.ContId=O_countries.Continent WHERE ((O_countries.CountryId = 1.0 AND O_continents.ContId <= (SELECT continents.ContId, SUM(I_continents.ContId) FROM continents I_continents GROUP BY continents.ContId ORDER BY COUNT(car_makers.Maker))) AND O_continents.Continent IN "('america','asia','africa','europe')") GROUP BY continents.Continent HAVING COUNT(countries.CountryName) = 3 ORDER BY continents.ContId LIMIT 4
SELECT cars_data.MPG, MAX(O_cars_data.Accelerate) FROM cars_data O_cars_data WHERE (O_cars_data.Accelerate >= (SELECT cars_data.Year, MIN(I_cars_data.Accelerate) FROM cars_data I_cars_data WHERE I_cars_data.Edispl >= 304.0 GROUP BY cars_data.Year HAVING (cars_data.Year < 1980.0 AND SUM(cars_data.Weight) > 3003.0) ORDER BY COUNT(car_names.Model)) AND (O_cars_data.MPG != 29.0 AND O_cars_data.Weight = 4498.0)) GROUP BY cars_data.MPG
SELECT O_countries.Continent FROM car_makers O_car_makers JOIN countries O_countries ON O_countries.CountryId=O_car_makers.Country WHERE ((O_countries.CountryId <= (SELECT SUM(I_countries.CountryId) FROM countries I_countries WHERE (I_countries.CountryName = "usa" OR (I_countries.Continent = 1.0 OR I_countries.Continent = 1.0)) ORDER BY countries.Continent) OR O_car_makers.Country = 1.0) AND O_countries.CountryId != 3.0)
SELECT countries.CountryId, COUNT(*) FROM countries O_countries WHERE (O_countries.CountryName != "brazil" OR O_countries.Continent > (SELECT car_makers.FullName, SUM(I_countries.Continent) FROM countries I_countries GROUP BY car_makers.FullName HAVING (COUNT(car_makers.Maker) != 1 OR SUM(countries.CountryId) = 1.0))) GROUP BY countries.CountryId HAVING (COUNT(countries.CountryName) <= 4 AND countries.CountryId != 4.0) ORDER BY SUM(countries.Continent)
SELECT MAX(O_countries.CountryId) FROM continents O_continents JOIN countries O_countries ON O_continents.ContId=O_countries.Continent WHERE (O_continents.ContId != (SELECT countries.CountryId, MAX(I_continents.ContId) FROM continents I_continents GROUP BY countries.CountryId ORDER BY countries.CountryName LIMIT 4) OR O_continents.Continent NOT LIKE "%europe")
SELECT * FROM cars_data O_cars_data WHERE O_cars_data.Id = (SELECT model_list.ModelId, MAX(I_cars_data.Id) FROM car_names I_car_names JOIN cars_data I_cars_data JOIN model_list I_model_list ON I_car_names.MakeId=I_cars_data.Id AND I_model_list.Model=I_car_names.Model WHERE (I_model_list.Maker = 19.0 OR I_model_list.Maker = 19.0) GROUP BY model_list.ModelId HAVING (COUNT(car_names.MakeId) < 2 OR (COUNT(model_list.Model) = 2 OR SUM(cars_data.Horsepower) < 79.0)) ORDER BY car_names.Model LIMIT 2) ORDER BY cars_data.Cylinders LIMIT 4
SELECT O_cars_data.Id, O_cars_data.Accelerate FROM cars_data O_cars_data WHERE (O_cars_data.Id <= (SELECT cars_data.Accelerate, AVG(I_cars_data.Id) FROM cars_data I_cars_data GROUP BY cars_data.Accelerate HAVING (COUNT(car_names.Make) = 1 AND MAX(cars_data.Weight) < 1845.0)) AND O_cars_data.Horsepower = 98.0)