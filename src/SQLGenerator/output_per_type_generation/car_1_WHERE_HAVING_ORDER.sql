SELECT continents.Continent, COUNT(*) FROM continents WHERE (continents.ContId = 3.0 OR continents.ContId = 3.0) GROUP BY continents.Continent HAVING AVG(continents.ContId) <= 2.0 ORDER BY continents.ContId
SELECT car_names.Model, COUNT(DISTINCT model_list.Model) FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker WHERE ((car_makers.Country != 2.0 OR car_makers.Country != 4.0) OR car_makers.Country = 1.0) GROUP BY car_names.Model HAVING (COUNT(car_names.Make) <= 2 AND COUNT(car_names.Make) = 2) ORDER BY model_list.Model
SELECT countries.CountryId, COUNT(DISTINCT countries.CountryName) FROM countries WHERE ((countries.CountryName IN "('japan','new zealand','sweden')" OR countries.CountryName LIKE "%sweden") OR countries.CountryName LIKE "%sweden") GROUP BY countries.CountryId HAVING COUNT(countries.CountryName) >= 1 ORDER BY countries.CountryId
SELECT cars_data.Year, MAX(cars_data.Cylinders), AVG(cars_data.Id) FROM cars_data WHERE cars_data.MPG <= 24.0 GROUP BY cars_data.Year HAVING COUNT(car_names.Make) <= 4 ORDER BY car_names.Make
SELECT countries.CountryId, COUNT(*) FROM countries WHERE (countries.CountryName IN "('usa','uk','new zealand','japan')" AND countries.CountryName != "new zealand") GROUP BY countries.CountryId HAVING countries.CountryId != 1.0 ORDER BY COUNT(countries.CountryName)
SELECT car_names.Model, COUNT(*) FROM cars_data WHERE (cars_data.Edispl > 119.0 OR cars_data.Weight = 3907.0) GROUP BY car_names.Model HAVING ((MAX(cars_data.MPG) < 18.0 AND car_names.Model IN "("('amc','mazda','buick','chrysler')", 4)") AND COUNT(car_makers.FullName) > 3) ORDER BY COUNT(car_names.Make)
SELECT car_makers.FullName, COUNT(DISTINCT car_makers.Maker) FROM car_makers WHERE (car_makers.Maker IN "('ford','bmw','fiat','amc')" OR car_makers.Maker NOT IN "('daimler benz','volvo','citroen','ford')") GROUP BY car_makers.FullName HAVING MAX(car_makers.Id) = 19.0 ORDER BY car_makers.Country
SELECT model_list.Model, COUNT(*) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE (car_names.MakeId != 82.0 AND (cars_data.Horsepower > 75.0 OR cars_data.Horsepower = 139.0)) GROUP BY model_list.Model HAVING (COUNT(model_list.Maker) = 3 AND SUM(cars_data.Edispl) > 108.0) ORDER BY cars_data.Weight
SELECT countries.Continent, COUNT(DISTINCT car_makers.Maker) FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE (countries.Continent = 3.0 AND (countries.CountryName NOT LIKE "uk%" AND continents.Continent NOT IN "('america','africa','europe','australia')")) GROUP BY countries.Continent HAVING (SUM(countries.CountryId) = 4.0 AND MAX(model_list.Maker) <= 19.0) ORDER BY model_list.Maker
SELECT cars_data.MPG, SUM(cars_data.Horsepower), COUNT(DISTINCT cars_data.Cylinders) FROM cars_data WHERE cars_data.Horsepower < 92.0 GROUP BY cars_data.MPG HAVING (MAX(cars_data.Edispl) < 151.0 AND MIN(cars_data.Accelerate) != 20.1) ORDER BY cars_data.MPG
SELECT continents.ContId, COUNT(*) FROM continents WHERE (continents.Continent NOT IN "('australia','africa')" OR continents.Continent NOT LIKE "africa%") GROUP BY continents.ContId HAVING (COUNT(continents.Continent) < 4 AND COUNT(continents.Continent) <= 2) ORDER BY continents.Continent
SELECT car_makers.FullName, COUNT(*) FROM model_list WHERE (model_list.ModelId >= 25.0 OR (model_list.Maker != 5.0 OR model_list.ModelId = 24.0)) GROUP BY car_makers.FullName HAVING (COUNT(car_makers.Maker) <= 2 AND SUM(car_makers.Id) >= 9.0) ORDER BY SUM(car_makers.Id)
SELECT countries.Continent, COUNT(DISTINCT countries.CountryName) FROM countries WHERE ((countries.Continent != 3.0 AND countries.CountryName NOT LIKE "italy%") AND countries.CountryName LIKE "%usa") GROUP BY countries.Continent HAVING MAX(countries.CountryId) > 2.0 ORDER BY COUNT(countries.CountryName)
SELECT model_list.ModelId, SUM(model_list.ModelId) FROM model_list WHERE (model_list.Maker != 21.0 AND (model_list.ModelId != 8.0 AND model_list.Maker != 5.0)) GROUP BY model_list.ModelId HAVING ((COUNT(model_list.Model) < 1 OR model_list.ModelId = 8.0) AND AVG(model_list.Maker) = 6.0) ORDER BY model_list.Model
SELECT model_list.Maker, COUNT(DISTINCT model_list.Model), MAX(car_names.MakeId) FROM car_names JOIN model_list ON model_list.Model=car_names.Model WHERE (car_names.MakeId != 242.0 AND (car_names.MakeId != 167.0 OR model_list.Maker != 6.0)) GROUP BY model_list.Maker HAVING (COUNT(car_names.Make) > 3 AND MAX(model_list.ModelId) < 7.0) ORDER BY COUNT(car_names.Make)
SELECT car_makers.Maker, MAX(car_makers.Id) FROM car_makers WHERE (car_makers.Maker != "hyundai" AND car_makers.FullName IN "('Ford Motor Company','BMW','Volvo','Hyundai')") GROUP BY car_makers.Maker HAVING ((car_makers.Maker NOT LIKE "amc%" AND COUNT(car_makers.FullName) != 2) AND AVG(car_makers.Id) != 4.0) ORDER BY AVG(car_makers.Country)
SELECT countries.Continent, COUNT(*) FROM countries WHERE countries.CountryName NOT LIKE "%russia" GROUP BY countries.Continent HAVING COUNT(countries.CountryName) >= 3 ORDER BY countries.CountryName
SELECT car_makers.FullName, COUNT(*) FROM car_makers WHERE ((car_makers.FullName IN "('Honda','Kia Motors')" OR car_makers.FullName NOT LIKE "%Subaru%") AND car_makers.FullName NOT LIKE "%Renault") GROUP BY car_makers.FullName HAVING (MIN(car_makers.Country) < 3.0 AND MIN(car_makers.Country) != 3.0) ORDER BY car_makers.FullName
SELECT model_list.Model, COUNT(DISTINCT car_makers.FullName) FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE (cars_data.Accelerate > 16.0 OR (model_list.Model LIKE "%plymout%" OR car_makers.Id != 15.0)) GROUP BY model_list.Model HAVING (AVG(cars_data.MPG) != 32.4 OR COUNT(car_names.Make) = 2) ORDER BY AVG(cars_data.Accelerate)
SELECT car_makers.FullName, COUNT(DISTINCT car_makers.Maker) FROM car_makers WHERE ((car_makers.Id != 2.0 AND car_makers.Country != 4.0) AND car_makers.Maker IN "('gm','fiat','bmw','honda','daimler benz')") GROUP BY car_makers.FullName HAVING AVG(car_makers.Id) >= 5.0 ORDER BY car_makers.FullName