SELECT COUNT(DISTINCT car_names.Model), COUNT(DISTINCT car_names.Make) FROM car_names
SELECT COUNT(DISTINCT car_makers.Maker) FROM car_makers
SELECT COUNT(DISTINCT model_list.Maker) FROM model_list WHERE (model_list.Model != "audi" AND model_list.Maker = 14.0)
SELECT AVG(cars_data.Id) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE (car_names.Model != "bmw" AND cars_data.MPG > 26.6)
SELECT countries.CountryName, countries.CountryId FROM countries WHERE (countries.CountryName LIKE "%usa" AND countries.CountryId = 1.0)
SELECT countries.CountryName FROM countries WHERE (countries.CountryId = 4.0 AND (countries.CountryId = 4.0 OR countries.CountryName != "'uk'"))
SELECT COUNT(DISTINCT countries.CountryName) FROM countries
SELECT model_list.ModelId, model_list.Model FROM model_list
SELECT continents.Continent FROM continents WHERE continents.ContId != 2.0
SELECT cars_data.Weight FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model
SELECT COUNT(DISTINCT car_makers.Id) FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker
SELECT car_makers.Id, car_makers.Maker FROM car_makers
SELECT COUNT(DISTINCT continents.Continent), MIN(continents.ContId) FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE (countries.CountryName LIKE "usa%" OR countries.CountryName IN "('usa','australia')")
SELECT MIN(cars_data.MPG), MIN(cars_data.Accelerate) FROM cars_data WHERE (cars_data.Weight != 2255.0 OR cars_data.Weight < 4456.0)
SELECT car_makers.Maker FROM car_makers
SELECT COUNT(DISTINCT continents.Continent), AVG(continents.ContId) FROM continents
SELECT SUM(model_list.ModelId) FROM model_list WHERE model_list.ModelId = 7.0
SELECT AVG(car_makers.Id) FROM car_makers WHERE car_makers.Country != 1.0
SELECT countries.CountryName FROM countries WHERE (countries.CountryName NOT LIKE "%france" OR (countries.Continent = 1.0 OR countries.CountryName = "usa"))
SELECT MIN(cars_data.Year), AVG(cars_data.Weight) FROM cars_data WHERE (cars_data.Edispl > 89.0 AND cars_data.Id != 210.0)
SELECT MIN(model_list.Maker) FROM model_list
SELECT model_list.Model FROM car_names JOIN model_list ON model_list.Model=car_names.Model
SELECT cars_data.Edispl FROM cars_data WHERE cars_data.Horsepower != 115.0
SELECT MAX(car_makers.Id) FROM car_makers JOIN car_names JOIN model_list ON car_makers.Id=model_list.Maker AND model_list.Model=car_names.Model WHERE (model_list.ModelId = 1.0 AND (car_names.MakeId = 15.0 AND car_names.MakeId = 15.0))
SELECT countries.CountryName FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country
SELECT MIN(model_list.ModelId), SUM(model_list.ModelId) FROM model_list
SELECT continents.ContId, car_makers.Country FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE car_makers.Maker IN "('ford','chrysler','opel')"
SELECT COUNT(DISTINCT car_makers.Maker), COUNT(DISTINCT car_makers.Country) FROM car_makers WHERE (car_makers.FullName LIKE "%Chrysle%" AND car_makers.Maker NOT IN "('gm','bmw','opel','subaru','hyundai')")
SELECT car_names.MakeId FROM car_names
SELECT COUNT(DISTINCT model_list.Maker) FROM model_list
SELECT car_names.MakeId FROM car_names
SELECT COUNT(DISTINCT car_names.Model), COUNT(DISTINCT car_names.Make) FROM car_names WHERE car_names.Make IN "('citroen ds-21 pallas','ford granada ghia','plymouth cuda 340','ford mustang ii','mercedes-benz 240d')"
SELECT COUNT(DISTINCT car_names.Model) FROM car_names
SELECT SUM(car_makers.Id) FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker WHERE (model_list.Model LIKE "buick%" OR (car_makers.FullName IN "('Fiat','General Motors','Chrysler','BMW','Toyota')" OR car_makers.Country = 1.0))
SELECT COUNT(DISTINCT car_makers.Country), COUNT(DISTINCT countries.CountryName) FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country
SELECT cars_data.Year, cars_data.Weight FROM cars_data WHERE ((cars_data.Cylinders < 4.0 AND cars_data.MPG = 23.7) AND cars_data.Weight = 2420.0)
SELECT model_list.ModelId, model_list.Model FROM car_names JOIN model_list ON model_list.Model=car_names.Model
SELECT countries.Continent, countries.CountryId FROM countries WHERE (countries.Continent = 1.0 OR countries.CountryId = 4.0)
SELECT model_list.ModelId FROM car_names JOIN model_list ON model_list.Model=car_names.Model
SELECT car_makers.Id, car_makers.FullName FROM car_makers
SELECT COUNT(DISTINCT model_list.Maker) FROM model_list WHERE model_list.ModelId > 13.0
SELECT continents.ContId FROM continents WHERE (continents.Continent != "australia" AND continents.Continent = "asia")
SELECT MAX(model_list.Maker), COUNT(DISTINCT model_list.ModelId) FROM model_list WHERE (model_list.Model LIKE "subaru%" OR (model_list.Maker = 11.0 AND model_list.Maker = 18.0))
SELECT countries.CountryId FROM countries
SELECT COUNT(DISTINCT car_names.Make) FROM car_names WHERE (car_names.Model NOT LIKE "triumph%" AND car_names.MakeId != 37.0)
SELECT COUNT(DISTINCT model_list.Model), COUNT(DISTINCT countries.Continent) FROM car_makers JOIN car_names JOIN cars_data JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model WHERE cars_data.Accelerate < 13.6
SELECT MAX(cars_data.Id), COUNT(DISTINCT cars_data.Weight) FROM cars_data
SELECT car_makers.Maker FROM car_makers
SELECT SUM(countries.CountryId), MAX(continents.ContId) FROM continents JOIN countries ON continents.ContId=countries.Continent
SELECT model_list.ModelId, countries.CountryName FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country WHERE car_makers.Country != 4.0
SELECT SUM(model_list.ModelId) FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE (cars_data.MPG = 19.0 OR (cars_data.Edispl != 120.0 AND car_makers.Country = 1.0))
SELECT COUNT(DISTINCT car_names.Make), COUNT(DISTINCT car_names.Model) FROM car_names
SELECT COUNT(DISTINCT car_makers.Maker), COUNT(DISTINCT model_list.Model) FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker
SELECT model_list.Model, model_list.Maker FROM model_list
SELECT countries.CountryName FROM countries WHERE (countries.Continent = 1.0 OR (countries.Continent = 2.0 OR countries.CountryName = "usa"))
SELECT SUM(car_makers.Country), COUNT(DISTINCT model_list.Model) FROM car_makers JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country
SELECT model_list.Model FROM car_names JOIN cars_data JOIN model_list ON car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE (car_names.MakeId != 241.0 OR (cars_data.Year >= 1981.0 AND cars_data.Horsepower > 152.0))
SELECT MIN(car_makers.Id), COUNT(DISTINCT car_makers.FullName) FROM car_makers
SELECT countries.CountryName FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE (countries.CountryName NOT LIKE "nigeria%" AND continents.Continent IN "('america','europe','asia','australia')")
SELECT COUNT(DISTINCT model_list.Model) FROM model_list WHERE (model_list.Model = "honda" OR (model_list.ModelId = 15.0 OR model_list.ModelId = 2.0))
SELECT continents.ContId FROM continents
SELECT COUNT(DISTINCT car_names.Model) FROM car_names WHERE (car_names.Make IN "('volkswagen rabbit','ford escort 2h','toyota corolla tercel','dodge charger 2.2','ford mustang boss 302')" OR car_names.Make != "'datsun 510'")
SELECT continents.Continent FROM continents WHERE continents.ContId = 1.0
SELECT SUM(continents.ContId), SUM(countries.Continent) FROM continents JOIN countries ON continents.ContId=countries.Continent
SELECT AVG(model_list.ModelId) FROM model_list WHERE (model_list.ModelId = 24.0 AND model_list.ModelId < 32.0)
SELECT car_names.Make, model_list.ModelId FROM car_makers JOIN car_names JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model
SELECT countries.CountryName, car_makers.Maker FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country WHERE model_list.Model NOT IN "('honda','citroen')"
SELECT countries.Continent FROM countries
SELECT MIN(model_list.Maker) FROM model_list WHERE (model_list.Maker = 1.0 OR (model_list.Model NOT LIKE "%triumph" AND model_list.ModelId = 1.0))
SELECT car_makers.Id FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker WHERE (model_list.Maker != 4.0 AND (car_makers.FullName IN "('Chrysler','Saab','American Motor Company','Honda')" OR car_makers.Id = 15.0))
SELECT countries.CountryId FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country
SELECT AVG(countries.Continent) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country WHERE car_makers.Maker IN "('gm','volvo','subaru')"
SELECT model_list.Model FROM car_names JOIN cars_data JOIN model_list ON car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model
SELECT car_makers.FullName FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE cars_data.Year <= 1975.0
SELECT model_list.Maker FROM car_names JOIN model_list ON model_list.Model=car_names.Model
SELECT MIN(car_names.MakeId), SUM(model_list.ModelId) FROM car_names JOIN model_list ON model_list.Model=car_names.Model WHERE (car_names.Model NOT LIKE "%dsmobil%" AND car_names.Make NOT LIKE "%chevy%")
SELECT car_makers.Maker FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country
SELECT COUNT(DISTINCT countries.CountryName), COUNT(DISTINCT continents.ContId) FROM continents JOIN countries ON continents.ContId=countries.Continent
SELECT car_makers.FullName FROM car_makers
SELECT COUNT(DISTINCT continents.Continent) FROM continents JOIN countries ON continents.ContId=countries.Continent
SELECT AVG(cars_data.Cylinders), COUNT(DISTINCT cars_data.Accelerate) FROM cars_data WHERE (cars_data.Id = 25.0 AND cars_data.Cylinders = 4.0)
SELECT model_list.Maker, car_makers.Maker FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker
SELECT COUNT(DISTINCT cars_data.Id) FROM cars_data
SELECT countries.CountryName, countries.Continent FROM countries
SELECT SUM(cars_data.Weight) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE car_names.Make != "plymouth reliant"
SELECT countries.Continent, countries.CountryName FROM continents JOIN countries ON continents.ContId=countries.Continent
SELECT SUM(countries.Continent), SUM(car_makers.Id) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country WHERE car_makers.Maker != "volvo"
SELECT car_names.Model FROM car_names
SELECT MIN(car_names.MakeId), COUNT(DISTINCT car_makers.FullName) FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model
SELECT SUM(model_list.Maker) FROM model_list WHERE model_list.Model NOT LIKE "%jeep%"
SELECT car_names.MakeId FROM car_names
SELECT AVG(countries.CountryId) FROM countries WHERE countries.Continent = 2.0
SELECT cars_data.Year FROM cars_data
SELECT cars_data.Edispl, cars_data.Year FROM cars_data WHERE cars_data.Id = 72.0
SELECT countries.CountryName FROM countries
SELECT cars_data.Id FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE car_names.MakeId = 284.0
SELECT cars_data.MPG, cars_data.Year FROM cars_data WHERE (cars_data.Year < 1975.0 AND cars_data.Cylinders <= 6.0)
SELECT car_names.Make FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model
SELECT COUNT(DISTINCT car_makers.FullName), MAX(car_makers.Id) FROM car_makers WHERE ((car_makers.Maker = "citroen" AND car_makers.FullName = "Citroen") OR car_makers.Country != 4.0)
SELECT model_list.Model FROM model_list
SELECT O_cars_data.Year, O_cars_data.Id FROM car_names O_car_names JOIN cars_data O_cars_data JOIN model_list O_model_list ON O_car_names.MakeId=O_cars_data.Id AND O_model_list.Model=O_car_names.Model WHERE O_model_list.Model = (SELECT I_model_list.Model FROM car_makers I_car_makers JOIN model_list I_model_list ON I_car_makers.Id=I_model_list.Maker WHERE (I_car_makers.Maker NOT IN "('renault','ford','mazda','chrysler','honda')" AND (I_car_makers.Id != 8.0 AND I_car_makers.FullName != "Toyota")))
SELECT COUNT(DISTINCT O_countries.CountryName) FROM countries O_countries WHERE ((SELECT I_countries.Continent FROM continents I_continents JOIN countries I_countries ON I_continents.ContId=I_countries.Continent WHERE (O_countries.CountryName = I_countries.CountryName AND (I_countries.CountryName != "germany" AND I_continents.Continent NOT LIKE "%asia"))) != 1.0 OR O_countries.CountryName NOT LIKE "uk%")
SELECT O_car_names.Model, O_car_names.MakeId FROM car_names O_car_names WHERE (SELECT MAX(I_car_names.MakeId) FROM car_names I_car_names WHERE (O_car_names.Model = I_car_names.Model AND (I_car_names.Make NOT LIKE "%custom" OR I_car_names.MakeId != 45.0))) != 383.0
SELECT MIN(O_continents.ContId) FROM continents O_continents JOIN countries O_countries ON O_continents.ContId=O_countries.Continent WHERE ((O_continents.Continent != "europe" OR O_continents.ContId >= (SELECT AVG(I_continents.ContId) FROM continents I_continents)) AND O_countries.CountryName LIKE "japan%")
SELECT car_names.Make, model_list.Maker FROM car_names JOIN model_list ON model_list.Model=car_names.Model WHERE (model_list.Model = "plymouth" OR car_names.MakeId != 287.0)
SELECT O_cars_data.Weight FROM cars_data O_cars_data WHERE O_cars_data.Cylinders < (SELECT I_cars_data.Cylinders FROM car_names I_car_names JOIN cars_data I_cars_data ON I_car_names.MakeId=I_cars_data.Id WHERE (I_car_names.MakeId = 57.0 OR I_car_names.Make != "'mercury marquis'"))
SELECT COUNT(DISTINCT O_countries.CountryName), AVG(O_continents.ContId) FROM continents O_continents JOIN countries O_countries ON O_continents.ContId=O_countries.Continent WHERE (O_continents.Continent IN (SELECT I_continents.Continent FROM continents I_continents WHERE (I_continents.ContId != 3.0 AND I_continents.Continent = "america")) OR O_continents.Continent LIKE "%asia")
SELECT cars_data.MPG FROM car_names JOIN cars_data JOIN model_list ON car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE (cars_data.Year != 1978.0 AND model_list.Model LIKE "%volvo")
SELECT car_makers.Id, car_makers.Country FROM car_makers
SELECT COUNT(DISTINCT O_car_names.Model) FROM car_names O_car_names WHERE (SELECT SUM(I_cars_data.Edispl) FROM car_makers I_car_makers JOIN car_names I_car_names JOIN cars_data I_cars_data JOIN model_list I_model_list ON I_car_makers.Id=I_model_list.Maker AND I_car_names.MakeId=I_cars_data.Id AND I_model_list.Model=I_car_names.Model WHERE (O_car_names.MakeId = I_car_names.MakeId AND (I_cars_data.Id != 91.0 OR (I_car_makers.Country != 2.0 AND I_cars_data.Accelerate < 20.4)))) > 250.0
SELECT O_car_makers.FullName, O_cars_data.Id FROM car_makers O_car_makers JOIN car_names O_car_names JOIN cars_data O_cars_data JOIN model_list O_model_list ON O_car_makers.Id=O_model_list.Maker AND O_car_names.MakeId=O_cars_data.Id AND O_model_list.Model=O_car_names.Model WHERE (O_model_list.Maker = 5.0 AND O_cars_data.Accelerate IN (SELECT I_cars_data.Accelerate FROM cars_data I_cars_data WHERE (I_cars_data.Edispl >= 250.0 OR (I_cars_data.MPG = 34.5 AND I_cars_data.Year != 1975.0))))
SELECT O_cars_data.Accelerate, O_car_names.Make FROM car_makers O_car_makers JOIN car_names O_car_names JOIN cars_data O_cars_data JOIN model_list O_model_list ON O_car_makers.Id=O_model_list.Maker AND O_car_names.MakeId=O_cars_data.Id AND O_model_list.Model=O_car_names.Model WHERE (O_cars_data.Id = 45.0 OR O_car_makers.Id >= (SELECT SUM(I_car_makers.Id) FROM car_makers I_car_makers))
SELECT O_cars_data.Weight FROM cars_data O_cars_data WHERE (O_cars_data.MPG > 25.5 OR (O_cars_data.Edispl <= (SELECT I_cars_data.Edispl FROM cars_data I_cars_data WHERE ((I_cars_data.Accelerate = 12.0 OR I_cars_data.Edispl >= 304.0) AND I_cars_data.Cylinders > 4.0)) AND O_cars_data.Cylinders < 8.0))
SELECT COUNT(DISTINCT O_countries.CountryName) FROM car_makers O_car_makers JOIN car_names O_car_names JOIN cars_data O_cars_data JOIN countries O_countries JOIN model_list O_model_list ON O_car_makers.Id=O_model_list.Maker AND O_car_names.MakeId=O_cars_data.Id AND O_countries.CountryId=O_car_makers.Country AND O_model_list.Model=O_car_names.Model WHERE ((O_cars_data.MPG <= 24.3 AND O_model_list.Maker = 1.0) AND O_countries.CountryName = (SELECT I_countries.CountryName FROM car_makers I_car_makers JOIN countries I_countries JOIN model_list I_model_list ON I_car_makers.Id=I_model_list.Maker AND I_countries.CountryId=I_car_makers.Country WHERE (O_car_makers.FullName = I_car_makers.FullName AND (I_model_list.ModelId != 36.0 OR I_countries.CountryName != "japan"))))
SELECT O_cars_data.MPG, O_cars_data.Accelerate FROM car_names O_car_names JOIN cars_data O_cars_data ON O_car_names.MakeId=O_cars_data.Id WHERE (O_cars_data.Year NOT IN (SELECT I_cars_data.Year FROM cars_data I_cars_data WHERE ((I_cars_data.Weight >= 2900.0 OR I_cars_data.Weight >= 3830.0) OR I_cars_data.Year >= 1973.0)) AND (O_cars_data.Year <= 1970.0 AND O_car_names.Model NOT LIKE "%chrysle%"))
SELECT model_list.Model, model_list.Maker FROM model_list
SELECT O_countries.CountryName, O_car_makers.FullName FROM car_makers O_car_makers JOIN countries O_countries JOIN model_list O_model_list ON O_car_makers.Id=O_model_list.Maker AND O_countries.CountryId=O_car_makers.Country WHERE O_model_list.ModelId > (SELECT I_model_list.ModelId FROM car_names I_car_names JOIN cars_data I_cars_data JOIN model_list I_model_list ON I_car_names.MakeId=I_cars_data.Id AND I_model_list.Model=I_car_names.Model WHERE (I_model_list.ModelId <= 23.0 OR (I_cars_data.Edispl = 108.0 AND I_cars_data.Edispl < 98.0)))
SELECT COUNT(DISTINCT countries.CountryName), COUNT(DISTINCT car_makers.Id) FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country WHERE (model_list.ModelId >= 31.0 OR car_makers.Id != 8.0)
SELECT O_continents.Continent, O_continents.ContId FROM continents O_continents WHERE O_continents.ContId != (SELECT I_continents.ContId FROM continents I_continents WHERE (I_continents.Continent IN "('america','europe','asia','africa','australia')" OR I_continents.Continent IN "('asia','africa','australia','europe','america')"))
SELECT SUM(O_car_names.MakeId), COUNT(DISTINCT O_car_names.Make) FROM car_names O_car_names JOIN model_list O_model_list ON O_model_list.Model=O_car_names.Model WHERE ((O_car_names.MakeId <= (SELECT I_car_names.MakeId FROM car_names I_car_names WHERE (O_car_names.Model = I_car_names.Model AND I_car_names.MakeId != 19.0)) OR O_car_names.Model != "oldsmobile") OR O_model_list.Maker != 6.0)
SELECT O_cars_data.Weight, O_cars_data.Cylinders FROM cars_data O_cars_data WHERE (O_cars_data.Horsepower != (SELECT MAX(I_cars_data.Horsepower) FROM cars_data I_cars_data) AND O_cars_data.Accelerate = 16.2)
SELECT cars_data.MPG FROM cars_data WHERE ((cars_data.Cylinders != 4.0 OR cars_data.Edispl <= 250.0) AND cars_data.Horsepower = 165.0)
SELECT O_model_list.Model, O_car_makers.Maker FROM car_makers O_car_makers JOIN continents O_continents JOIN countries O_countries JOIN model_list O_model_list ON O_car_makers.Id=O_model_list.Maker AND O_continents.ContId=O_countries.Continent AND O_countries.CountryId=O_car_makers.Country WHERE O_continents.ContId > (SELECT AVG(I_continents.ContId) FROM continents I_continents)
SELECT O_continents.Continent FROM continents O_continents WHERE ((SELECT I_continents.Continent FROM continents I_continents JOIN countries I_countries ON I_continents.ContId=I_countries.Continent WHERE (O_continents.ContId = I_continents.ContId AND I_countries.Continent != 2.0)) != "asia" AND O_continents.Continent NOT LIKE "africa%")
SELECT O_car_makers.Maker, O_car_makers.FullName FROM car_makers O_car_makers WHERE O_car_makers.Id >= (SELECT I_car_makers.Id FROM car_makers I_car_makers WHERE ((I_car_makers.Country != 1.0 AND I_car_makers.FullName != "Renault") OR I_car_makers.Maker != "nissan"))
SELECT COUNT(DISTINCT O_car_names.Model) FROM car_names O_car_names JOIN model_list O_model_list ON O_model_list.Model=O_car_names.Model WHERE O_model_list.ModelId = (SELECT MAX(I_model_list.ModelId) FROM car_names I_car_names JOIN model_list I_model_list ON I_model_list.Model=I_car_names.Model WHERE (O_car_names.MakeId = I_car_names.MakeId AND I_car_names.Make != "pontiac firebird"))
SELECT O_car_makers.Maker FROM car_makers O_car_makers WHERE (O_car_makers.Id != 4.0 AND O_car_makers.Id >= (SELECT AVG(I_car_makers.Id) FROM car_makers I_car_makers WHERE (I_car_makers.Maker != "'peugeaut'" AND I_car_makers.Id != 8.0)))
SELECT AVG(O_countries.Continent), COUNT(DISTINCT O_countries.Continent) FROM countries O_countries WHERE O_countries.CountryName = (SELECT I_countries.CountryName FROM countries I_countries WHERE (I_countries.CountryName LIKE "%japan%" AND (I_countries.Continent != 1.0 AND I_countries.CountryName NOT LIKE "%egypt")))
SELECT COUNT(DISTINCT O_model_list.ModelId), COUNT(DISTINCT O_model_list.Maker) FROM model_list O_model_list WHERE (O_model_list.ModelId > 13.0 OR ((SELECT COUNT(I_model_list.Model) FROM model_list I_model_list WHERE (O_model_list.Maker = I_model_list.Maker AND I_model_list.ModelId > 21.0)) <= 13 OR O_model_list.Model != "datsun"))
SELECT MAX(countries.CountryId) FROM countries
SELECT MAX(O_cars_data.Accelerate) FROM cars_data O_cars_data WHERE (O_cars_data.Accelerate >= (SELECT MIN(I_cars_data.Accelerate) FROM cars_data I_cars_data WHERE (O_cars_data.MPG = I_cars_data.MPG AND ((I_cars_data.MPG >= 15.0 AND I_cars_data.Cylinders > 6.0) AND I_cars_data.Weight <= 3840.0))) AND O_cars_data.Horsepower >= 87.0)
SELECT MAX(O_continents.ContId) FROM continents O_continents WHERE O_continents.Continent LIKE (SELECT I_continents.Continent FROM continents I_continents JOIN countries I_countries ON I_continents.ContId=I_countries.Continent WHERE (O_continents.ContId = I_continents.ContId AND I_countries.CountryId = 1.0))
SELECT O_cars_data.Id, O_model_list.ModelId FROM car_names O_car_names JOIN cars_data O_cars_data JOIN model_list O_model_list ON O_car_names.MakeId=O_cars_data.Id AND O_model_list.Model=O_car_names.Model WHERE (O_cars_data.Cylinders NOT IN (SELECT I_cars_data.Cylinders FROM cars_data I_cars_data WHERE (O_cars_data.Accelerate = I_cars_data.Accelerate AND (I_cars_data.Edispl >= 304.0 OR I_cars_data.Edispl >= 350.0))) OR O_cars_data.Horsepower <= 71.0)
SELECT COUNT(DISTINCT car_names.Make) FROM car_names WHERE car_names.MakeId = 83.0
SELECT O_cars_data.Weight, O_cars_data.Year FROM cars_data O_cars_data WHERE ((SELECT SUM(I_cars_data.Accelerate) FROM car_names I_car_names JOIN cars_data I_cars_data JOIN model_list I_model_list ON I_car_names.MakeId=I_cars_data.Id AND I_model_list.Model=I_car_names.Model WHERE (O_cars_data.Edispl = I_cars_data.Edispl AND I_model_list.Maker != 4.0)) >= 19.6 AND O_cars_data.MPG > 22.5)
SELECT AVG(O_continents.ContId), MAX(O_continents.ContId) FROM continents O_continents WHERE O_continents.ContId > (SELECT AVG(I_continents.ContId) FROM continents I_continents WHERE I_continents.ContId != 1.0)
SELECT COUNT(DISTINCT O_model_list.ModelId) FROM model_list O_model_list WHERE (O_model_list.Model IN "('chevrolet','toyota')" AND O_model_list.Model IN (SELECT I_model_list.Model FROM car_makers I_car_makers JOIN car_names I_car_names JOIN model_list I_model_list ON I_car_makers.Id=I_model_list.Maker AND I_model_list.Model=I_car_names.Model WHERE ((I_model_list.ModelId != 13.0 OR I_car_names.MakeId != 232.0) AND I_car_makers.Maker != "citroen")))
SELECT O_continents.Continent, O_countries.CountryId FROM continents O_continents JOIN countries O_countries ON O_continents.ContId=O_countries.Continent WHERE ((SELECT I_countries.CountryId FROM countries I_countries WHERE (O_countries.Continent = I_countries.Continent AND I_countries.Continent = 2.0)) < 6.0 AND O_countries.CountryName = "italy")
SELECT AVG(O_countries.Continent) FROM countries O_countries WHERE (O_countries.Continent >= (SELECT AVG(I_countries.Continent) FROM car_makers I_car_makers JOIN countries I_countries JOIN model_list I_model_list ON I_car_makers.Id=I_model_list.Maker AND I_countries.CountryId=I_car_makers.Country WHERE (O_countries.CountryName = I_countries.CountryName AND (I_model_list.Maker = 2.0 AND I_countries.CountryId = 2.0))) OR O_countries.Continent != 1.0)
SELECT car_makers.FullName, COUNT(DISTINCT car_makers.FullName), COUNT(DISTINCT car_makers.Country) FROM car_makers GROUP BY car_makers.FullName HAVING (car_makers.FullName NOT LIKE "%Motors%" AND AVG(car_makers.Country) <= 6.0) ORDER BY SUM(car_makers.Country) LIMIT 1
SELECT cars_data.Id, COUNT(DISTINCT cars_data.Id) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id GROUP BY cars_data.Id HAVING (COUNT(cars_data.Accelerate) < 3 AND COUNT(car_names.Make) < 2) ORDER BY cars_data.Cylinders LIMIT 2
SELECT model_list.ModelId, model_list.Model FROM model_list WHERE model_list.ModelId = 15.0 ORDER BY model_list.Model LIMIT 2
SELECT car_names.MakeId, MIN(car_names.MakeId), MAX(car_names.MakeId) FROM car_names WHERE car_names.Model != "nissan" GROUP BY car_names.MakeId HAVING car_names.MakeId != 340.0
SELECT cars_data.Weight, COUNT(DISTINCT car_makers.Maker), MAX(model_list.ModelId) FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE ((car_names.MakeId = 137.0 OR cars_data.Horsepower < 90.0) AND cars_data.Accelerate > 16.5) GROUP BY cars_data.Weight ORDER BY COUNT(model_list.ModelId) LIMIT 4
SELECT car_names.Make, MIN(car_names.MakeId), MAX(car_names.MakeId) FROM car_names WHERE car_names.Model != "'hi'" GROUP BY car_names.Make HAVING car_names.Make NOT IN "("('plymouth volare custom','hi 1200d','dodge monaco (sw)')", 3)"
SELECT countries.CountryName, car_makers.FullName FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country WHERE (car_makers.Id != 6.0 AND (car_makers.Country != 1.0 AND car_makers.Id != 4.0))
SELECT COUNT(DISTINCT car_names.Make), COUNT(DISTINCT car_names.Model) FROM car_names
SELECT COUNT(DISTINCT continents.Continent) FROM continents
SELECT cars_data.Weight, cars_data.Edispl FROM cars_data WHERE (cars_data.Accelerate < 16.5 OR cars_data.Accelerate > 15.7)
SELECT countries.Continent, COUNT(DISTINCT car_makers.FullName), MIN(cars_data.Cylinders) FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE (car_names.Model IN "('datsun','toyota','amc','volkswagen')" OR cars_data.Weight > 3211.0) GROUP BY countries.Continent
SELECT cars_data.Edispl, MAX(cars_data.Accelerate) FROM cars_data GROUP BY cars_data.Edispl
SELECT cars_data.Year, AVG(car_makers.Country) FROM car_makers JOIN car_names JOIN cars_data JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model WHERE ((car_names.MakeId != 378.0 AND countries.Continent = 3.0) OR cars_data.Edispl >= 86.0) GROUP BY cars_data.Year
SELECT model_list.ModelId, COUNT(DISTINCT model_list.Maker) FROM model_list WHERE model_list.Model NOT LIKE "fiat%" GROUP BY model_list.ModelId HAVING ((COUNT(model_list.Model) > 3 OR SUM(model_list.Maker) != 6.0) OR COUNT(model_list.Model) >= 1)
SELECT car_makers.Maker, SUM(continents.ContId), MIN(model_list.ModelId) FROM car_makers JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country GROUP BY car_makers.Maker HAVING SUM(car_makers.Id) != 4.0
SELECT continents.Continent, continents.ContId FROM continents ORDER BY continents.ContId
SELECT car_makers.Maker, MAX(countries.CountryId), COUNT(DISTINCT continents.Continent) FROM continents JOIN countries ON continents.ContId=countries.Continent GROUP BY car_makers.Maker HAVING MAX(countries.Continent) < 1.0
SELECT model_list.ModelId, COUNT(DISTINCT model_list.Model), COUNT(DISTINCT model_list.ModelId) FROM model_list GROUP BY model_list.ModelId HAVING (model_list.ModelId != 23.0 AND model_list.ModelId <= 23.0) ORDER BY model_list.ModelId
SELECT car_makers.FullName, AVG(model_list.Maker), COUNT(DISTINCT model_list.Model) FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker GROUP BY car_makers.FullName ORDER BY car_makers.FullName
SELECT continents.Continent FROM continents WHERE continents.Continent NOT IN "('america','europe')" ORDER BY countries.Continent
SELECT MAX(countries.Continent), AVG(countries.CountryId) FROM countries WHERE (countries.CountryName = "japan" AND countries.CountryName LIKE "%japan")
SELECT continents.ContId, continents.Continent FROM continents WHERE continents.Continent NOT LIKE "europe%"
SELECT car_names.MakeId, COUNT(DISTINCT car_names.Model), COUNT(DISTINCT car_names.Make) FROM car_names GROUP BY car_names.MakeId ORDER BY car_names.MakeId LIMIT 1
SELECT model_list.Model, COUNT(DISTINCT model_list.Model), COUNT(DISTINCT car_makers.FullName) FROM car_makers JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country GROUP BY model_list.Model HAVING (COUNT(countries.CountryName) = 2 OR SUM(car_makers.Id) != 11.0) ORDER BY AVG(countries.Continent)
SELECT COUNT(DISTINCT countries.CountryName) FROM countries WHERE ((countries.Continent = 1.0 AND countries.CountryName IN "('usa','brazil','nigeria','new zealand')") OR countries.CountryName != "korea") ORDER BY countries.CountryName LIMIT 4
SELECT continents.ContId, COUNT(DISTINCT continents.Continent), COUNT(DISTINCT continents.ContId) FROM continents GROUP BY continents.ContId ORDER BY continents.ContId
SELECT car_makers.FullName, COUNT(DISTINCT car_makers.Maker) FROM car_makers GROUP BY car_makers.FullName ORDER BY model_list.Model
SELECT countries.Continent, COUNT(DISTINCT countries.CountryName), AVG(countries.CountryId) FROM countries GROUP BY countries.Continent HAVING (countries.Continent = 1.0 AND COUNT(countries.CountryName) = 1) ORDER BY countries.CountryName
SELECT car_names.Make, COUNT(DISTINCT car_names.Model) FROM car_makers JOIN car_names JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model GROUP BY car_names.Make
SELECT car_makers.Country, COUNT(DISTINCT countries.CountryName) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country WHERE (car_makers.Id = 6.0 AND (car_makers.Maker NOT IN "('honda','nissan','kia','subaru')" AND car_makers.FullName LIKE "%Chrysle%")) GROUP BY car_makers.Country
SELECT MIN(continents.ContId), COUNT(DISTINCT continents.ContId) FROM continents WHERE (continents.Continent != "europe" OR continents.Continent = "america") ORDER BY continents.ContId LIMIT 2
SELECT car_makers.Id, COUNT(DISTINCT cars_data.Accelerate) FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model GROUP BY car_makers.Id HAVING (MAX(car_makers.Country) < 4.0 OR COUNT(cars_data.MPG) >= 1)
SELECT car_names.MakeId, COUNT(DISTINCT car_names.Model) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id GROUP BY car_names.MakeId HAVING COUNT(model_list.Maker) != 1 ORDER BY MIN(cars_data.Year)
SELECT car_names.Make, COUNT(DISTINCT car_names.Model), COUNT(DISTINCT car_names.Make) FROM car_names GROUP BY car_names.Make HAVING SUM(car_names.MakeId) > 335.0 ORDER BY car_names.MakeId
SELECT COUNT(DISTINCT cars_data.Weight) FROM cars_data WHERE (cars_data.Edispl > 140.0 AND cars_data.Horsepower = 140.0)
SELECT continents.Continent FROM continents JOIN countries ON continents.ContId=countries.Continent ORDER BY countries.Continent LIMIT 3
SELECT car_makers.Id, AVG(car_makers.Id) FROM car_makers GROUP BY car_makers.Id HAVING car_makers.Id >= 8.0
SELECT MIN(continents.ContId), COUNT(DISTINCT continents.Continent) FROM continents WHERE continents.ContId = 1.0
SELECT model_list.ModelId FROM car_names JOIN model_list ON model_list.Model=car_names.Model
SELECT car_makers.FullName, AVG(countries.CountryId), COUNT(DISTINCT car_makers.Maker) FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country GROUP BY car_makers.FullName
SELECT car_makers.FullName, COUNT(DISTINCT car_makers.Country) FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country GROUP BY car_makers.FullName HAVING ((car_makers.FullName NOT IN "("('Peugeaut')", 1)" OR car_makers.FullName = "American Motor Company") AND COUNT(continents.Continent) <= 1)
SELECT MIN(cars_data.Year) FROM cars_data WHERE (cars_data.Cylinders >= 4.0 AND cars_data.Id != 406.0) ORDER BY cars_data.Horsepower LIMIT 3
SELECT model_list.Model, COUNT(DISTINCT model_list.Maker), COUNT(DISTINCT model_list.ModelId) FROM model_list GROUP BY model_list.Model ORDER BY model_list.Maker LIMIT 4
SELECT car_makers.Maker, COUNT(DISTINCT car_makers.FullName) FROM car_makers GROUP BY car_makers.Maker HAVING (COUNT(car_makers.Id) < 3 AND car_makers.Maker = "chrysler") ORDER BY AVG(car_makers.Id) LIMIT 3
SELECT countries.CountryName, SUM(countries.CountryId) FROM countries WHERE countries.Continent = 1.0 GROUP BY countries.CountryName ORDER BY countries.Continent LIMIT 3
SELECT continents.Continent, SUM(continents.ContId), COUNT(DISTINCT continents.Continent) FROM continents GROUP BY continents.Continent HAVING (AVG(continents.ContId) >= 1.0 AND continents.Continent IN "("('america','australia')", 2)")
SELECT COUNT(DISTINCT countries.Continent), MIN(countries.CountryId) FROM countries WHERE (countries.CountryName LIKE "%japan" AND countries.CountryName != "'france'")
SELECT countries.CountryId FROM countries WHERE countries.CountryName IN "('usa','russia','nigeria','australia')" ORDER BY countries.CountryId LIMIT 4
SELECT continents.ContId, COUNT(DISTINCT countries.CountryName) FROM continents JOIN countries ON continents.ContId=countries.Continent GROUP BY continents.ContId HAVING ((MAX(countries.CountryId) < 1.0 OR COUNT(continents.Continent) < 1) OR COUNT(continents.Continent) = 4) ORDER BY AVG(countries.Continent)
SELECT car_makers.FullName, car_names.Model FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model
SELECT cars_data.Edispl, COUNT(DISTINCT countries.Continent), MAX(cars_data.Accelerate) FROM car_makers JOIN car_names JOIN cars_data JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model WHERE car_makers.Id = 4.0 GROUP BY cars_data.Edispl HAVING (COUNT(car_makers.Maker) != 2 AND COUNT(model_list.Maker) < 3) ORDER BY car_makers.Country LIMIT 3
SELECT cars_data.Accelerate, MIN(cars_data.Edispl) FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE car_makers.Maker != "'fiat'" GROUP BY cars_data.Accelerate
SELECT COUNT(DISTINCT car_makers.Maker) FROM car_makers ORDER BY car_makers.FullName LIMIT 1
SELECT MIN(cars_data.MPG), MIN(cars_data.Edispl) FROM cars_data WHERE cars_data.Horsepower <= 100.0
SELECT countries.CountryId, MIN(continents.ContId), COUNT(DISTINCT car_makers.FullName) FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country GROUP BY countries.CountryId HAVING (COUNT(car_makers.FullName) < 3 OR (COUNT(countries.CountryName) = 3 AND COUNT(car_makers.FullName) < 2))
SELECT car_names.Make, COUNT(DISTINCT car_names.Make) FROM car_names WHERE car_names.Make != "amc pacer d/l" GROUP BY car_names.Make
SELECT MIN(countries.CountryId) FROM countries WHERE countries.Continent = 1.0
SELECT cars_data.MPG, MIN(cars_data.Edispl), SUM(cars_data.Cylinders) FROM cars_data GROUP BY cars_data.MPG HAVING cars_data.MPG >= 35.0
SELECT MIN(model_list.Maker), COUNT(DISTINCT model_list.ModelId) FROM model_list WHERE model_list.Model = "honda" ORDER BY model_list.Model
SELECT car_makers.FullName FROM car_makers WHERE ((car_makers.Id = 4.0 AND car_makers.Country = 1.0) AND car_makers.Id = 4.0) ORDER BY car_makers.Maker
SELECT car_makers.Country, COUNT(DISTINCT car_makers.FullName) FROM car_makers GROUP BY car_makers.Country HAVING ((COUNT(car_makers.Maker) <= 1 OR MIN(car_makers.Id) > 2.0) OR car_makers.Country < 2.0)
SELECT cars_data.Year, SUM(car_makers.Id), MAX(model_list.ModelId) FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE (cars_data.MPG != 19.0 AND car_names.Model = "toyota") GROUP BY cars_data.Year ORDER BY COUNT(model_list.ModelId) LIMIT 1
SELECT MIN(cars_data.Weight) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE car_names.Model IN "('chrysler','dodge','hi','fiat')" ORDER BY cars_data.Id
SELECT countries.CountryId, COUNT(DISTINCT countries.CountryName), COUNT(DISTINCT continents.Continent) FROM car_makers JOIN car_names JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model WHERE (car_names.Make NOT LIKE "d/l%" AND model_list.Model IN "('buick','amc','toyota','mercury')") GROUP BY countries.CountryId HAVING MAX(car_makers.Id) >= 6.0
SELECT MIN(model_list.Maker) FROM model_list ORDER BY model_list.Maker LIMIT 3
SELECT cars_data.Weight, MIN(cars_data.MPG), SUM(cars_data.Weight) FROM cars_data WHERE (cars_data.Weight > 1800.0 AND cars_data.MPG < 38.0) GROUP BY cars_data.Weight HAVING ((MAX(cars_data.MPG) < 15.0 OR COUNT(cars_data.Cylinders) != 4) AND SUM(cars_data.Accelerate) != 8.5)
SELECT model_list.ModelId, SUM(model_list.ModelId) FROM model_list WHERE model_list.ModelId <= 10.0 GROUP BY model_list.ModelId HAVING COUNT(model_list.Model) < 4 ORDER BY model_list.Model
SELECT cars_data.Edispl, COUNT(DISTINCT car_makers.Maker), COUNT(DISTINCT cars_data.Id) FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE model_list.Model NOT LIKE "%subaru%" GROUP BY cars_data.Edispl HAVING MAX(cars_data.Year) < 1976.0
SELECT COUNT(DISTINCT continents.ContId), COUNT(DISTINCT continents.Continent) FROM continents WHERE continents.Continent NOT IN "('europe','asia','australia','africa')" ORDER BY continents.ContId LIMIT 2
SELECT car_makers.Country, AVG(car_makers.Id), SUM(car_makers.Id) FROM car_makers WHERE (car_makers.Maker != "daimler benz" AND (car_makers.Country != 4.0 AND car_makers.Maker NOT LIKE "%fiat%")) GROUP BY car_makers.Country HAVING COUNT(car_makers.Maker) >= 4 ORDER BY MIN(car_makers.Id) LIMIT 4
SELECT COUNT(DISTINCT countries.CountryId) FROM countries WHERE (countries.Continent != 1.0 AND countries.CountryName = "germany")
SELECT AVG(continents.ContId), SUM(continents.ContId) FROM continents
SELECT COUNT(DISTINCT countries.CountryName) FROM continents JOIN countries ON continents.ContId=countries.Continent ORDER BY countries.CountryId LIMIT 2
SELECT countries.CountryId FROM car_makers JOIN car_names JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model
SELECT car_makers.Id, COUNT(DISTINCT car_names.Model) FROM car_names WHERE car_names.Model NOT LIKE "renault%" GROUP BY car_makers.Id ORDER BY car_names.MakeId LIMIT 2
SELECT car_makers.FullName, COUNT(DISTINCT car_makers.FullName) FROM car_makers WHERE (car_makers.Maker NOT LIKE "%volkswa" OR car_makers.Id != 17.0) GROUP BY car_makers.FullName ORDER BY car_makers.Id LIMIT 1
SELECT COUNT(DISTINCT cars_data.Horsepower), MIN(cars_data.Cylinders) FROM cars_data WHERE (cars_data.Edispl != 120.0 AND cars_data.Year != 1972.0)
SELECT countries.Continent, SUM(countries.Continent) FROM countries GROUP BY countries.Continent HAVING (COUNT(countries.CountryName) >= 3 AND COUNT(countries.CountryName) > 2) ORDER BY countries.Continent
SELECT MIN(countries.CountryId) FROM countries WHERE (countries.Continent != 1.0 AND countries.CountryName != "australia") ORDER BY countries.CountryId
SELECT MAX(car_makers.Country), COUNT(DISTINCT car_makers.Maker) FROM car_makers ORDER BY car_makers.Id
SELECT model_list.Model, COUNT(DISTINCT model_list.ModelId) FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker GROUP BY model_list.Model
SELECT model_list.Maker, car_names.Make FROM car_names JOIN model_list ON model_list.Model=car_names.Model ORDER BY car_names.Make
SELECT car_names.Model FROM car_names ORDER BY car_names.MakeId
SELECT countries.Continent, COUNT(DISTINCT countries.CountryName), COUNT(DISTINCT countries.Continent) FROM countries WHERE countries.Continent = 3.0 GROUP BY countries.Continent HAVING ((countries.Continent != 2.0 AND countries.Continent > 2.0) OR countries.Continent <= 2.0) ORDER BY countries.CountryId LIMIT 4
SELECT model_list.ModelId, MIN(car_makers.Country) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country GROUP BY model_list.ModelId ORDER BY COUNT(countries.CountryName)
SELECT COUNT(DISTINCT car_names.Model), SUM(car_names.MakeId) FROM car_names ORDER BY car_names.Make
SELECT model_list.Maker, MIN(car_makers.Country) FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker GROUP BY model_list.Maker HAVING (COUNT(car_names.Model) >= 1 OR (COUNT(car_makers.FullName) > 4 AND COUNT(car_names.Model) > 1))
SELECT car_makers.FullName, COUNT(DISTINCT car_makers.FullName) FROM car_makers WHERE car_makers.Country != 2.0 GROUP BY car_makers.FullName
SELECT cars_data.Edispl, MAX(cars_data.Edispl) FROM cars_data GROUP BY cars_data.Edispl HAVING (MIN(cars_data.Horsepower) <= 165.0 AND AVG(cars_data.Horsepower) >= 165.0)
SELECT continents.Continent, continents.ContId FROM continents ORDER BY continents.ContId
SELECT countries.CountryName, countries.CountryId FROM countries WHERE countries.Continent != 3.0 ORDER BY countries.CountryName LIMIT 3
SELECT car_names.MakeId, cars_data.Cylinders FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE (cars_data.Id != 15.0 OR cars_data.Weight < 1835.0) ORDER BY cars_data.Weight
SELECT SUM(cars_data.Accelerate), COUNT(DISTINCT car_names.Model) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id ORDER BY cars_data.Weight
SELECT car_names.MakeId, COUNT(DISTINCT car_names.Model) FROM car_names GROUP BY car_names.MakeId HAVING (car_names.MakeId >= 198.0 AND (COUNT(car_names.Make) = 3 OR COUNT(car_names.Make) >= 3))
SELECT car_names.Model, COUNT(DISTINCT car_names.Model) FROM car_names GROUP BY car_names.Model HAVING ((COUNT(car_names.Make) > 4 OR COUNT(car_names.Make) >= 1) AND car_names.Model = "plymouth") ORDER BY car_names.Model
SELECT continents.ContId FROM continents WHERE continents.ContId = 2.0
SELECT COUNT(DISTINCT car_makers.FullName), COUNT(DISTINCT car_makers.Country) FROM car_makers
SELECT car_names.Make FROM car_makers JOIN car_names JOIN model_list ON car_makers.Id=model_list.Maker AND model_list.Model=car_names.Model WHERE (car_names.MakeId != 390.0 OR car_makers.Maker NOT LIKE "%hyundai") ORDER BY model_list.ModelId
SELECT car_names.Model, COUNT(DISTINCT car_names.Make), AVG(car_names.MakeId) FROM car_names WHERE (car_names.Make NOT IN "('chevrolet chevette','datsun 200sx','ford granada ghia','volvo 145e (sw)','peugeot 304')" AND (car_names.Model LIKE "%mercury%" OR car_names.MakeId = 202.0)) GROUP BY car_names.Model HAVING car_names.Model != "volkswagen" ORDER BY COUNT(car_names.Make)
SELECT model_list.Model, COUNT(DISTINCT car_names.Make), COUNT(DISTINCT model_list.ModelId) FROM car_names JOIN model_list ON model_list.Model=car_names.Model GROUP BY model_list.Model
