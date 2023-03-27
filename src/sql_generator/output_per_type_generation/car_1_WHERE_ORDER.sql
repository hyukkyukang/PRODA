SELECT * FROM cars_data WHERE (cars_data.Accelerate >= 15.5 AND cars_data.Accelerate = 15.5) ORDER BY cars_data.Edispl
SELECT * FROM car_makers WHERE car_makers.FullName NOT IN "('Citroen','Subaru','BMW','Chrysler','Ford Motor Company')" ORDER BY car_makers.FullName
SELECT * FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE (car_names.Make NOT IN "('chevrolet nova','mazda glc 4')" OR cars_data.MPG > 30.7) ORDER BY countries.CountryName
SELECT * FROM continents WHERE (continents.ContId != 3.0 OR continents.Continent != "'australia'") ORDER BY continents.Continent
SELECT AVG(cars_data.Id), COUNT(DISTINCT car_names.Make) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE cars_data.Edispl != 91.0 ORDER BY cars_data.MPG
SELECT * FROM car_makers WHERE (car_makers.Id = 4.0 OR car_makers.Country != 3.0) ORDER BY car_makers.Id
SELECT continents.Continent, countries.Continent FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE (countries.Continent != 1.0 OR countries.CountryId = 4.0) ORDER BY countries.CountryName
SELECT car_names.Model, car_names.Make FROM car_names WHERE ((car_names.MakeId != 55.0 OR car_names.MakeId != 300.0) OR car_names.MakeId != 195.0) ORDER BY car_names.Make
SELECT car_makers.Country FROM car_makers WHERE car_makers.Maker IN "('chrysler','volkswagen')" ORDER BY car_makers.Id
SELECT car_makers.Id, cars_data.MPG FROM car_makers JOIN car_names JOIN cars_data JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model WHERE (countries.CountryName NOT IN "('egypt','italy')" OR car_makers.Id = 4.0) ORDER BY cars_data.MPG
SELECT car_makers.Maker FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country WHERE (car_makers.FullName NOT LIKE "%Saab" AND (car_makers.Id = 1.0 OR countries.CountryName NOT IN "('egypt','france','italy')")) ORDER BY countries.CountryName
SELECT * FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country WHERE (countries.CountryId = 1.0 AND car_makers.FullName != "Chrysler") ORDER BY car_makers.Id
SELECT car_makers.Maker, countries.CountryName FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country WHERE car_makers.FullName LIKE "Ford%" ORDER BY car_makers.Country
SELECT * FROM car_makers WHERE car_makers.Country = 1.0 ORDER BY car_makers.Id
SELECT continents.ContId FROM continents WHERE (continents.ContId != 1.0 OR continents.Continent NOT IN "('europe','america','australia')") ORDER BY continents.Continent
SELECT * FROM cars_data WHERE (cars_data.Weight != 3265.0 OR (cars_data.Cylinders < 4.0 OR cars_data.Id != 347.0)) ORDER BY cars_data.Weight
SELECT COUNT(*) FROM car_names WHERE car_names.MakeId != 260.0 ORDER BY car_names.Make
SELECT * FROM countries WHERE countries.Continent != 1.0 ORDER BY countries.Continent
SELECT car_makers.FullName, countries.CountryId FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE ((continents.ContId = 1.0 OR car_makers.Id != 6.0) AND countries.Continent = 1.0) ORDER BY countries.CountryName
SELECT COUNT(*) FROM countries WHERE (countries.Continent != 1.0 AND countries.CountryId = 2.0) ORDER BY countries.CountryId
