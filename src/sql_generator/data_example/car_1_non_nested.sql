SELECT countries.CountryName, SUM(countries.Continent) FROM countries GROUP BY countries.CountryName HAVING countries.CountryName LIKE "%sweden%" ORDER BY countries.CountryName LIMIT 4
SELECT car_names.Model, model_list.Model FROM car_names JOIN model_list ON model_list.Model=car_names.Model WHERE (model_list.ModelId >= 7.0 AND car_names.Make NOT IN "('oldsmobile omega','pontiac astro','mazda glc 4','chevrolet woody','buick skylark 320')") ORDER BY car_names.Make LIMIT 3
SELECT countries.CountryName FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE continents.Continent LIKE "%america" ORDER BY continents.Continent
SELECT countries.CountryName, SUM(continents.ContId), AVG(countries.CountryId) FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE (countries.CountryName != "mexico" OR continents.Continent IN "('europe','america')") GROUP BY countries.CountryName
SELECT continents.Continent, COUNT(*) FROM continents WHERE continents.Continent NOT IN "('africa','australia','asia','europe')" GROUP BY continents.Continent
SELECT car_makers.Maker, MIN(car_makers.Id) FROM car_makers WHERE (car_makers.Maker IN "('ford','chrysler','peugeaut')" AND car_makers.Maker != "volvo") GROUP BY car_makers.Maker HAVING (car_makers.Maker IN "("('amc','bmw','kia')", 3)" OR (COUNT(car_makers.FullName) != 4 OR AVG(model_list.ModelId) != 1.0)) ORDER BY car_makers.Maker
SELECT model_list.ModelId FROM model_list WHERE model_list.ModelId < 13.0 ORDER BY model_list.ModelId
SELECT countries.CountryName, COUNT(DISTINCT countries.Continent), COUNT(DISTINCT countries.CountryName) FROM countries WHERE countries.CountryName != "new zealand" GROUP BY countries.CountryName
SELECT model_list.Maker FROM car_names JOIN cars_data JOIN model_list ON car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE (cars_data.MPG < 14.0 AND cars_data.Year > 1973.0)
SELECT continents.Continent, COUNT(*) FROM continents WHERE continents.Continent = "america" GROUP BY continents.Continent
SELECT car_names.Model FROM car_names
SELECT * FROM model_list WHERE model_list.ModelId > 7.0
SELECT car_makers.Country, car_makers.FullName FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker
SELECT car_makers.FullName, AVG(car_makers.Country), COUNT(DISTINCT car_makers.Maker) FROM car_makers WHERE (car_makers.Maker != "renault" OR car_makers.FullName != "Renault") GROUP BY car_makers.FullName ORDER BY car_makers.FullName LIMIT 3
SELECT car_makers.Id FROM car_makers WHERE (car_makers.Maker NOT LIKE "%volvo" OR car_makers.Maker NOT LIKE "%gm%")
SELECT countries.CountryName, COUNT(*) FROM car_makers GROUP BY countries.CountryName HAVING (COUNT(car_makers.FullName) <= 3 AND (COUNT(car_makers.FullName) > 1 AND COUNT(car_makers.FullName) >= 4)) ORDER BY COUNT(continents.Continent) LIMIT 3
SELECT continents.Continent, COUNT(DISTINCT continents.Continent) FROM continents GROUP BY continents.Continent
SELECT cars_data.MPG, AVG(model_list.ModelId), SUM(countries.Continent) FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country WHERE (car_makers.FullName LIKE "Mazda%" OR car_makers.Maker NOT IN "('chrysler','gm','volvo')") GROUP BY cars_data.MPG
SELECT * FROM model_list WHERE model_list.ModelId = 10.0
SELECT model_list.ModelId FROM car_makers JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE ((continents.Continent NOT IN "('africa','europe')" OR car_makers.Maker = "gm") AND car_makers.FullName NOT LIKE "Benz%")
SELECT car_makers.Maker, MAX(car_makers.Id), COUNT(DISTINCT car_makers.Maker) FROM car_makers WHERE (car_makers.Maker = "gm" OR car_makers.FullName NOT LIKE "%olkswag%") GROUP BY car_makers.Maker HAVING (COUNT(car_makers.FullName) > 4 AND COUNT(car_makers.FullName) <= 1) ORDER BY car_makers.Maker LIMIT 2
SELECT car_names.Make, MAX(car_names.MakeId) FROM car_names GROUP BY car_names.Make HAVING car_names.Make IN "("('ford gran torino','buick regal sport coupe (turbo)','plymouth satellite custom')", 3)" ORDER BY car_names.Make
SELECT * FROM car_names
SELECT cars_data.MPG, car_names.Make FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE car_names.Make NOT IN "('plymouth champ','buick estate wagon (sw)')" ORDER BY cars_data.Accelerate LIMIT 2
SELECT car_makers.Maker, COUNT(*) FROM car_makers WHERE (car_makers.FullName NOT LIKE "%Citroen" OR car_makers.Maker NOT IN "('citroen','hyundai','opel','volvo','subaru')") GROUP BY car_makers.Maker HAVING car_makers.Maker NOT IN "("('nissan','renault','citroen','daimler benz','amc')", 5)" ORDER BY car_makers.Maker
SELECT AVG(countries.Continent), MAX(cars_data.Year) FROM car_makers JOIN car_names JOIN cars_data JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model WHERE cars_data.Accelerate > 19.5 ORDER BY car_makers.FullName
SELECT car_names.Make, MIN(model_list.Maker), COUNT(DISTINCT car_makers.Maker) FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker WHERE ((car_makers.FullName != "Kia Motors" OR car_makers.FullName IN "('American Motor Company','Nissan Motors','Volkswagen')") OR car_makers.Maker = "gm") GROUP BY car_names.Make
SELECT * FROM model_list WHERE model_list.ModelId < 10.0
SELECT car_makers.Maker, COUNT(DISTINCT car_makers.FullName), MAX(car_makers.Country) FROM car_makers GROUP BY car_makers.Maker HAVING COUNT(car_makers.FullName) > 4 ORDER BY car_makers.Maker
SELECT model_list.Model, car_makers.Country FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker WHERE car_makers.Maker = "chrysler" ORDER BY car_makers.Maker LIMIT 1
SELECT cars_data.Id FROM car_makers JOIN car_names JOIN cars_data JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model WHERE (cars_data.Weight = 2464.0 OR continents.Continent = "'europe'") ORDER BY cars_data.MPG
SELECT COUNT(*) FROM countries
SELECT cars_data.Edispl FROM cars_data WHERE cars_data.Weight != 4274.0
SELECT continents.Continent, MAX(continents.ContId), COUNT(DISTINCT continents.ContId) FROM continents WHERE continents.Continent LIKE "%america" GROUP BY continents.Continent
SELECT model_list.ModelId, MIN(model_list.ModelId) FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker WHERE (model_list.ModelId < 25.0 OR car_makers.FullName IN "('Subaru','Triumph')") GROUP BY model_list.ModelId HAVING model_list.ModelId = 17.0
SELECT countries.CountryName, COUNT(DISTINCT car_makers.FullName), COUNT(DISTINCT model_list.Model) FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country GROUP BY countries.CountryName HAVING countries.CountryName LIKE "%usa"
SELECT COUNT(DISTINCT car_makers.FullName), MIN(car_makers.Id) FROM car_makers
SELECT car_names.Make, COUNT(DISTINCT car_names.Model) FROM car_names JOIN model_list ON model_list.Model=car_names.Model WHERE (model_list.ModelId > 21.0 OR model_list.ModelId >= 24.0) GROUP BY car_names.Make HAVING AVG(model_list.ModelId) >= 25.0 ORDER BY model_list.ModelId LIMIT 3
SELECT car_names.Make, COUNT(*) FROM car_names WHERE car_names.Make = "plymouth volare" GROUP BY car_names.Make HAVING car_names.Make = "datsun 510 (sw)" ORDER BY car_names.Make LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE ((cars_data.Year = 1975.0 AND cars_data.Accelerate > 18.5) AND cars_data.Year >= 1975.0)
SELECT car_makers.Maker, AVG(countries.Continent) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country GROUP BY car_makers.Maker
SELECT cars_data.Accelerate, COUNT(*) FROM cars_data WHERE cars_data.Edispl <= 71.0 GROUP BY cars_data.Accelerate HAVING (cars_data.Accelerate != 19.5 OR MIN(cars_data.Horsepower) >= 72.0) ORDER BY cars_data.Accelerate LIMIT 2
SELECT continents.Continent FROM continents
SELECT model_list.ModelId, COUNT(DISTINCT model_list.Maker) FROM car_names JOIN cars_data JOIN model_list ON car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model GROUP BY model_list.ModelId ORDER BY cars_data.Accelerate LIMIT 1
SELECT car_makers.Maker, COUNT(*) FROM car_makers GROUP BY car_makers.Maker ORDER BY car_makers.FullName
SELECT cars_data.Horsepower, AVG(cars_data.Accelerate) FROM cars_data GROUP BY cars_data.Horsepower
SELECT continents.Continent, COUNT(*) FROM continents WHERE continents.Continent = "australia" GROUP BY continents.Continent ORDER BY continents.Continent
SELECT countries.CountryName, COUNT(*) FROM countries GROUP BY countries.CountryName ORDER BY countries.CountryName LIMIT 3
SELECT car_names.Make, COUNT(DISTINCT car_names.Make), COUNT(DISTINCT car_names.Model) FROM car_names JOIN model_list ON model_list.Model=car_names.Model GROUP BY car_names.Make HAVING car_names.Make != "pontiac phoenix"
SELECT COUNT(*) FROM model_list WHERE model_list.ModelId = 22.0 ORDER BY model_list.ModelId LIMIT 4
SELECT cars_data.Accelerate, cars_data.Cylinders FROM cars_data WHERE (cars_data.Accelerate != 12.9 AND (cars_data.Edispl = 98.0 AND cars_data.Accelerate != 15.0)) ORDER BY cars_data.Year
SELECT model_list.ModelId, model_list.Model FROM model_list WHERE model_list.ModelId != 31.0 ORDER BY model_list.ModelId
SELECT model_list.ModelId, SUM(model_list.ModelId) FROM model_list WHERE model_list.ModelId >= 31.0 GROUP BY model_list.ModelId ORDER BY model_list.ModelId LIMIT 2
SELECT continents.Continent FROM continents ORDER BY continents.Continent LIMIT 2
SELECT model_list.ModelId, COUNT(DISTINCT model_list.Maker) FROM model_list GROUP BY model_list.ModelId
SELECT countries.CountryId FROM countries WHERE countries.CountryName LIKE "%usa" ORDER BY countries.CountryName
SELECT cars_data.Year, COUNT(DISTINCT car_names.Model) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE cars_data.Accelerate = 11.2 GROUP BY cars_data.Year HAVING MAX(cars_data.Horsepower) <= 193.0
SELECT countries.CountryName, COUNT(DISTINCT countries.CountryName), COUNT(DISTINCT car_makers.Maker) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country GROUP BY countries.CountryName HAVING (countries.CountryName LIKE "japan%" OR countries.CountryName IN "("('japan','brazil')", 2)")
SELECT car_makers.Maker, COUNT(*) FROM car_makers GROUP BY car_makers.Maker
SELECT * FROM car_names
SELECT model_list.Maker, model_list.ModelId FROM model_list WHERE model_list.ModelId <= 29.0 ORDER BY model_list.ModelId
SELECT model_list.ModelId, MIN(car_names.MakeId) FROM car_names GROUP BY model_list.ModelId HAVING COUNT(car_names.Make) <= 3
SELECT model_list.Model, model_list.ModelId FROM model_list WHERE model_list.ModelId = 21.0
SELECT continents.Continent, MAX(continents.ContId), MIN(continents.ContId) FROM continents GROUP BY continents.Continent
SELECT continents.ContId FROM continents WHERE continents.Continent NOT LIKE "%africa%" ORDER BY continents.Continent
SELECT countries.CountryId, cars_data.Horsepower FROM car_makers JOIN car_names JOIN cars_data JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model ORDER BY cars_data.Edispl LIMIT 4
SELECT COUNT(DISTINCT countries.Continent), SUM(countries.Continent) FROM countries ORDER BY continents.Continent LIMIT 1
SELECT car_makers.FullName, COUNT(*) FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE (continents.Continent = "america" AND car_makers.FullName LIKE "%Chrysle%") GROUP BY car_makers.FullName HAVING (COUNT(car_makers.Maker) > 2 AND COUNT(continents.Continent) <= 1)
SELECT car_makers.FullName, COUNT(DISTINCT car_makers.FullName), COUNT(DISTINCT countries.CountryName) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country WHERE (car_makers.Maker NOT IN "('triumph','amc')" AND car_makers.Maker NOT LIKE "%peugeau") GROUP BY car_makers.FullName HAVING (COUNT(car_makers.Maker) != 4 AND COUNT(countries.CountryName) <= 1)
SELECT car_makers.FullName, COUNT(DISTINCT car_names.Model), SUM(car_names.MakeId) FROM car_makers JOIN car_names JOIN model_list ON car_makers.Id=model_list.Maker AND model_list.Model=car_names.Model GROUP BY car_makers.FullName ORDER BY car_makers.FullName
SELECT cars_data.Year, COUNT(*) FROM cars_data GROUP BY cars_data.Year HAVING ((AVG(cars_data.Edispl) < 250.0 OR MAX(cars_data.Weight) < 3781.0) OR COUNT(cars_data.Edispl) = 3) ORDER BY MIN(cars_data.Weight)
SELECT cars_data.Edispl, AVG(cars_data.Accelerate) FROM cars_data GROUP BY cars_data.Edispl
SELECT AVG(cars_data.MPG) FROM cars_data WHERE cars_data.Year = 1973.0
SELECT cars_data.Year, cars_data.Horsepower FROM cars_data
SELECT countries.CountryId, model_list.ModelId FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country ORDER BY car_names.Make LIMIT 1
SELECT continents.Continent, COUNT(DISTINCT continents.Continent) FROM continents WHERE continents.Continent LIKE "%america%" GROUP BY continents.Continent HAVING continents.Continent = "america"
SELECT car_names.Make, COUNT(*) FROM car_names WHERE car_names.Make LIKE "%128%" GROUP BY car_names.Make HAVING car_names.Make LIKE "ford%" ORDER BY car_names.Make LIMIT 3
SELECT car_makers.Country, continents.Continent FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE ((countries.CountryName LIKE "%usa%" AND countries.CountryName LIKE "%usa%") AND car_makers.FullName != "'Daimler Benz'")
SELECT countries.CountryName, COUNT(*) FROM countries GROUP BY countries.CountryName
SELECT continents.Continent, MIN(continents.ContId), MAX(continents.ContId) FROM continents GROUP BY continents.Continent HAVING continents.Continent NOT IN "("('africa','europe','asia','australia')", 4)"
SELECT cars_data.Year, SUM(cars_data.Cylinders) FROM cars_data WHERE cars_data.Year <= 1974.0 GROUP BY cars_data.Year HAVING (AVG(cars_data.Horsepower) <= 175.0 AND MAX(cars_data.Cylinders) < 8.0)
SELECT COUNT(DISTINCT car_names.Make) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE ((cars_data.Year > 1970.0 AND cars_data.Year >= 1973.0) AND cars_data.Year <= 1976.0)
SELECT model_list.ModelId, COUNT(*) FROM car_makers WHERE (car_makers.Maker NOT IN "('mazda','fiat','opel','amc')" AND (car_makers.Maker = "renault" AND car_makers.Maker = "renault")) GROUP BY model_list.ModelId
SELECT model_list.ModelId, COUNT(*) FROM model_list GROUP BY model_list.ModelId
SELECT model_list.ModelId, model_list.Model FROM model_list WHERE model_list.ModelId <= 21.0
SELECT model_list.ModelId, AVG(model_list.Maker), MAX(model_list.Maker) FROM model_list GROUP BY model_list.ModelId HAVING model_list.ModelId != 31.0
SELECT car_names.Make, COUNT(DISTINCT car_names.Model) FROM car_names WHERE car_names.Make != "toyota celica gt" GROUP BY car_names.Make
SELECT COUNT(DISTINCT car_names.Model) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id WHERE (cars_data.Year <= 1974.0 AND cars_data.MPG >= 21.0)
SELECT countries.CountryName, COUNT(DISTINCT countries.CountryId), MAX(countries.Continent) FROM countries GROUP BY countries.CountryName HAVING countries.CountryName NOT IN "("('nigeria','mexico')", 2)" ORDER BY countries.CountryName
SELECT car_makers.FullName, COUNT(DISTINCT car_makers.FullName) FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model GROUP BY car_makers.FullName
SELECT countries.CountryName, MAX(continents.ContId) FROM continents JOIN countries ON continents.ContId=countries.Continent GROUP BY countries.CountryName HAVING (countries.CountryName = "usa" AND countries.CountryName != "korea")
SELECT cars_data.Cylinders, SUM(cars_data.Weight) FROM cars_data WHERE ((cars_data.Weight = 3907.0 AND cars_data.Weight = 3907.0) AND cars_data.Edispl <= 231.0) GROUP BY cars_data.Cylinders HAVING ((AVG(cars_data.Edispl) > 250.0 OR AVG(cars_data.Edispl) >= 250.0) OR AVG(cars_data.Accelerate) > 15.0) ORDER BY cars_data.Horsepower LIMIT 2
SELECT countries.CountryId, countries.Continent FROM continents JOIN countries ON continents.ContId=countries.Continent
SELECT countries.CountryName, countries.CountryId FROM countries WHERE countries.CountryName LIKE "%japan"
SELECT car_makers.FullName, COUNT(DISTINCT countries.Continent) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country GROUP BY car_makers.FullName HAVING COUNT(countries.CountryName) != 4
SELECT COUNT(DISTINCT car_makers.Id), COUNT(DISTINCT continents.Continent) FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE (continents.Continent IN "('america','australia','asia','europe','africa')" OR (continents.Continent NOT LIKE "%asia" AND car_makers.Maker LIKE "%gm%")) ORDER BY continents.Continent
SELECT model_list.Model, model_list.Maker FROM model_list WHERE model_list.ModelId = 5.0 ORDER BY model_list.ModelId LIMIT 3
SELECT model_list.ModelId, SUM(model_list.Maker) FROM model_list WHERE model_list.ModelId <= 24.0 GROUP BY model_list.ModelId ORDER BY model_list.ModelId LIMIT 2
SELECT countries.CountryName, COUNT(*) FROM continents WHERE (continents.Continent NOT IN "('africa','asia','america','australia')" AND continents.Continent IN "('europe','america','australia','asia')") GROUP BY countries.CountryName HAVING countries.CountryName NOT IN "("('australia','egypt')", 2)" ORDER BY countries.CountryName LIMIT 2
SELECT car_names.Make, COUNT(*) FROM car_makers JOIN car_names JOIN model_list ON car_makers.Id=model_list.Maker AND model_list.Model=car_names.Model WHERE ((car_makers.FullName = "Ford Motor Company" AND car_names.Make IN "('plymouth fury gran sedan','ford pinto')") OR car_names.Make != "peugeot 304") GROUP BY car_names.Make HAVING (COUNT(car_makers.Maker) != 1 OR COUNT(car_makers.FullName) != 3)
SELECT model_list.ModelId, COUNT(DISTINCT model_list.Model) FROM model_list GROUP BY model_list.ModelId HAVING model_list.ModelId = 32.0 ORDER BY model_list.ModelId LIMIT 3
SELECT * FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country WHERE (car_makers.FullName != "Peugeaut" OR (countries.CountryName != "russia" OR car_makers.Maker NOT LIKE "%saab%")) ORDER BY car_makers.Maker
SELECT model_list.ModelId, MAX(model_list.Maker), SUM(model_list.Maker) FROM model_list GROUP BY model_list.ModelId HAVING model_list.ModelId = 31.0
SELECT * FROM cars_data WHERE ((cars_data.Year = 1974.0 OR cars_data.MPG >= 32.0) AND cars_data.Horsepower != 65.0) ORDER BY cars_data.Accelerate LIMIT 2
SELECT car_names.Make, COUNT(DISTINCT car_names.Model) FROM car_names WHERE car_names.Make NOT IN "('plymouth valiant custom','chevrolet monza 2+2')" GROUP BY car_names.Make HAVING car_names.Make NOT LIKE "%sedan"
SELECT car_names.Make, COUNT(DISTINCT car_names.Make) FROM car_names GROUP BY car_names.Make
SELECT * FROM countries WHERE countries.CountryName LIKE "%japan%" ORDER BY countries.CountryName LIMIT 2
SELECT car_names.Make, SUM(model_list.ModelId) FROM car_names JOIN model_list ON model_list.Model=car_names.Model WHERE (model_list.ModelId < 11.0 OR car_names.Make IN "('amc rebel sst (sw)','chrysler lebaron town @ country (sw)','datsun f-10 hatchback')") GROUP BY car_names.Make HAVING AVG(model_list.ModelId) < 29.0
SELECT continents.Continent, MAX(continents.ContId), AVG(continents.ContId) FROM continents GROUP BY continents.Continent HAVING continents.Continent IN "("('asia','australia','europe','africa')", 4)" ORDER BY continents.Continent LIMIT 3
SELECT car_names.Model, car_names.MakeId FROM car_names WHERE car_names.Make IN "('ford gran torino','plymouth fury gran sedan','amc concord d/l','toyota corona hardtop')" ORDER BY car_names.Make LIMIT 4
SELECT COUNT(*) FROM car_names ORDER BY car_names.Make
SELECT countries.CountryName, MAX(countries.Continent) FROM countries WHERE countries.CountryName LIKE "japan%" GROUP BY countries.CountryName
SELECT COUNT(DISTINCT continents.Continent) FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE countries.CountryName LIKE "%japan%" ORDER BY countries.CountryName
SELECT continents.Continent, SUM(continents.ContId), COUNT(DISTINCT continents.Continent) FROM continents GROUP BY continents.Continent HAVING continents.Continent NOT LIKE "asia%" ORDER BY continents.Continent
SELECT continents.ContId FROM continents WHERE continents.Continent IN "('europe','australia','asia')" ORDER BY continents.Continent
SELECT continents.ContId FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE countries.CountryName NOT IN "('russia','sweden','egypt','brazil')" ORDER BY continents.Continent LIMIT 2
SELECT SUM(model_list.Maker), COUNT(DISTINCT model_list.Model) FROM model_list WHERE model_list.ModelId != 34.0 ORDER BY model_list.ModelId
SELECT countries.CountryName, COUNT(*) FROM car_makers WHERE car_makers.FullName = "Chrysler" GROUP BY countries.CountryName ORDER BY COUNT(continents.Continent)
SELECT model_list.ModelId, COUNT(*) FROM model_list GROUP BY model_list.ModelId
SELECT car_names.Make, COUNT(*) FROM model_list GROUP BY car_names.Make HAVING car_names.Make != "opel manta"
SELECT cars_data.MPG, COUNT(*) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id GROUP BY cars_data.MPG ORDER BY cars_data.Weight
SELECT model_list.ModelId, COUNT(DISTINCT car_names.Make) FROM car_names JOIN model_list ON model_list.Model=car_names.Model WHERE (model_list.ModelId >= 8.0 AND car_names.Make != "mazda 626") GROUP BY model_list.ModelId HAVING (model_list.ModelId = 13.0 OR COUNT(car_names.Make) = 4) ORDER BY car_names.Make LIMIT 1
SELECT continents.ContId, continents.Continent FROM continents WHERE continents.Continent IN "('europe','america','asia','africa')"
SELECT countries.CountryId, countries.Continent FROM countries ORDER BY countries.CountryName LIMIT 1
SELECT countries.CountryName, COUNT(*) FROM countries WHERE countries.CountryName LIKE "japan%" GROUP BY countries.CountryName ORDER BY countries.CountryName
SELECT model_list.ModelId, COUNT(*) FROM car_makers GROUP BY model_list.ModelId HAVING COUNT(car_makers.FullName) < 1
SELECT cars_data.Edispl, SUM(cars_data.Id) FROM cars_data WHERE (cars_data.MPG != 13.0 AND (cars_data.Cylinders >= 4.0 AND cars_data.Weight <= 4615.0)) GROUP BY cars_data.Edispl HAVING (SUM(cars_data.Year) = 1978.0 AND MAX(cars_data.Year) <= 1978.0)
SELECT countries.CountryId FROM car_makers JOIN car_names JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model WHERE (car_names.Make != "'honda prelude'" OR model_list.ModelId <= 24.0) ORDER BY car_makers.Maker
SELECT * FROM car_names WHERE car_names.Make != "audi 4000" ORDER BY car_names.Make LIMIT 4
SELECT * FROM countries WHERE countries.CountryName != "'usa'" ORDER BY countries.CountryName
SELECT car_makers.Maker, COUNT(DISTINCT car_makers.Maker), COUNT(DISTINCT countries.Continent) FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE ((continents.Continent != "europe" AND continents.Continent = "africa") AND continents.Continent = "africa") GROUP BY car_makers.Maker
SELECT countries.CountryName, SUM(continents.ContId), COUNT(DISTINCT countries.CountryName) FROM continents JOIN countries ON continents.ContId=countries.Continent GROUP BY countries.CountryName HAVING (countries.CountryName IN "("('japan','italy')", 2)" OR countries.CountryName NOT IN "("('australia')", 1)")
SELECT model_list.ModelId, MAX(car_makers.Id), COUNT(DISTINCT car_names.Make) FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE ((car_makers.Maker LIKE "chrysle%" AND cars_data.Accelerate >= 16.0) OR cars_data.Weight > 3620.0) GROUP BY model_list.ModelId HAVING (MIN(cars_data.MPG) > 21.0 OR model_list.ModelId = 13.0) ORDER BY AVG(cars_data.Accelerate) LIMIT 2
SELECT cars_data.Horsepower, cars_data.Accelerate FROM cars_data WHERE cars_data.Horsepower > 112.0 ORDER BY cars_data.MPG LIMIT 3
SELECT model_list.ModelId, AVG(model_list.Maker), COUNT(DISTINCT model_list.Model) FROM model_list WHERE model_list.ModelId != 23.0 GROUP BY model_list.ModelId HAVING model_list.ModelId < 17.0 ORDER BY model_list.ModelId
SELECT continents.Continent, COUNT(DISTINCT car_makers.Maker) FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker WHERE model_list.ModelId < 12.0 GROUP BY continents.Continent
SELECT car_makers.FullName, COUNT(DISTINCT car_makers.Maker) FROM car_makers JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE (model_list.ModelId <= 10.0 AND continents.Continent != "australia") GROUP BY car_makers.FullName
SELECT cars_data.MPG, cars_data.Weight FROM cars_data WHERE (cars_data.Year = 1978.0 AND cars_data.MPG > 29.5) ORDER BY cars_data.Accelerate LIMIT 3
SELECT continents.Continent, countries.CountryId FROM continents JOIN countries ON continents.ContId=countries.Continent
SELECT countries.CountryId FROM countries WHERE countries.CountryName LIKE "usa%"
SELECT continents.Continent, COUNT(DISTINCT continents.Continent) FROM continents WHERE continents.Continent LIKE "%america%" GROUP BY continents.Continent HAVING continents.Continent = "america" ORDER BY continents.Continent LIMIT 2
SELECT car_makers.FullName, car_makers.Id FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country WHERE (car_makers.FullName IN "('Honda','Chrysler','Renault','BMW','Daimler Benz')" AND countries.CountryName = "japan") ORDER BY car_makers.Maker
SELECT car_names.Make, COUNT(DISTINCT car_names.Model) FROM car_names GROUP BY car_names.Make HAVING car_names.Make IN "("('peugeot 304')", 1)" ORDER BY car_names.Make LIMIT 2
SELECT cars_data.Id FROM cars_data WHERE ((cars_data.MPG > 18.5 AND cars_data.MPG < 22.0) AND cars_data.Weight > 2833.0) ORDER BY cars_data.Edispl LIMIT 1
SELECT * FROM cars_data
SELECT car_makers.Maker, car_makers.Country FROM car_makers WHERE (car_makers.FullName LIKE "%Chrysle%" OR car_makers.Maker != "bmw")
SELECT continents.Continent, COUNT(DISTINCT countries.CountryId), MIN(car_makers.Country) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country WHERE countries.CountryName = "japan" GROUP BY continents.Continent HAVING ((COUNT(car_makers.FullName) >= 2 OR COUNT(car_makers.Maker) < 4) AND COUNT(car_makers.Maker) < 4)
SELECT cars_data.Cylinders, COUNT(*) FROM car_makers JOIN car_names JOIN cars_data JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model WHERE (car_names.Make != "amc concord" AND (cars_data.Horsepower <= 69.0 AND countries.CountryName IN "('japan','brazil','new zealand','korea','nigeria')")) GROUP BY cars_data.Cylinders
SELECT * FROM countries ORDER BY countries.CountryName LIMIT 3
SELECT model_list.ModelId, MIN(model_list.Maker), SUM(car_names.MakeId) FROM car_names JOIN model_list ON model_list.Model=car_names.Model GROUP BY model_list.ModelId HAVING (COUNT(car_names.Make) > 2 AND model_list.ModelId != 13.0)
SELECT model_list.ModelId, car_makers.Id FROM car_makers JOIN continents JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE ((continents.Continent IN "('asia','europe','africa','australia','america')" AND car_makers.Maker = "honda") AND model_list.ModelId <= 15.0)
SELECT car_makers.FullName, COUNT(DISTINCT car_makers.Maker) FROM car_makers WHERE (car_makers.Maker IN "('gm','hyundai','honda','nissan','kia')" AND car_makers.Maker NOT LIKE "%nissan") GROUP BY car_makers.FullName ORDER BY car_makers.Maker LIMIT 2
SELECT continents.Continent FROM continents
SELECT countries.CountryName, COUNT(*) FROM continents GROUP BY countries.CountryName
SELECT countries.CountryName, COUNT(*) FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE ((car_makers.Maker NOT LIKE "%toyota%" OR car_makers.FullName LIKE "Company%") AND continents.Continent NOT IN "('asia','australia','europe','africa')") GROUP BY countries.CountryName
SELECT SUM(car_names.MakeId), COUNT(DISTINCT car_names.Model) FROM car_makers JOIN car_names JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model
SELECT car_names.MakeId, car_names.Model FROM car_names JOIN model_list ON model_list.Model=car_names.Model WHERE model_list.ModelId != 12.0
SELECT COUNT(*) FROM countries WHERE countries.CountryName != "'mexico'" ORDER BY countries.CountryName LIMIT 3
SELECT cars_data.Horsepower, MIN(cars_data.MPG), MAX(cars_data.Weight) FROM cars_data GROUP BY cars_data.Horsepower
SELECT cars_data.Weight, cars_data.Horsepower FROM cars_data WHERE cars_data.Cylinders = 6.0 ORDER BY cars_data.Horsepower LIMIT 2
SELECT countries.CountryName, MAX(countries.CountryId) FROM countries GROUP BY countries.CountryName
SELECT model_list.ModelId, MIN(model_list.ModelId), SUM(model_list.ModelId) FROM model_list GROUP BY model_list.ModelId
SELECT countries.CountryName FROM countries WHERE countries.CountryName IN "('germany','australia','france','new zealand','italy')" ORDER BY countries.CountryName
SELECT continents.Continent, AVG(countries.Continent), MIN(countries.Continent) FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE (countries.CountryName LIKE "%usa" OR continents.Continent != "australia") GROUP BY continents.Continent ORDER BY COUNT(countries.CountryName)
SELECT car_names.Make FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id ORDER BY cars_data.Year LIMIT 1
SELECT car_makers.FullName FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker WHERE model_list.ModelId >= 29.0 ORDER BY car_makers.FullName LIMIT 1
SELECT countries.CountryId, car_makers.Id FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country
SELECT COUNT(DISTINCT car_makers.Country), COUNT(DISTINCT car_makers.FullName) FROM car_makers WHERE (car_makers.Maker NOT IN "('amc','opel','hyundai','mazda')" OR car_makers.FullName LIKE "%Motor") ORDER BY car_makers.Maker
SELECT * FROM car_makers
SELECT cars_data.Weight, MIN(cars_data.Cylinders) FROM cars_data GROUP BY cars_data.Weight HAVING SUM(cars_data.Accelerate) >= 15.0 ORDER BY SUM(cars_data.MPG)
SELECT COUNT(*) FROM cars_data WHERE (cars_data.Accelerate != 16.9 OR cars_data.Weight != 2774.0)
SELECT model_list.ModelId, COUNT(DISTINCT model_list.Model), SUM(car_names.MakeId) FROM car_names JOIN model_list ON model_list.Model=car_names.Model GROUP BY model_list.ModelId ORDER BY model_list.ModelId
SELECT model_list.ModelId FROM model_list WHERE (model_list.ModelId < 16.0 AND model_list.ModelId <= 10.0)
SELECT countries.CountryName, COUNT(DISTINCT model_list.Model) FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country WHERE (countries.CountryName IN "('germany','nigeria','mexico','japan')" AND car_makers.FullName = "Mazda") GROUP BY countries.CountryName ORDER BY model_list.ModelId
SELECT countries.CountryName, MIN(continents.ContId), AVG(continents.ContId) FROM continents JOIN countries ON continents.ContId=countries.Continent GROUP BY countries.CountryName
SELECT car_names.Make, COUNT(DISTINCT car_names.Make), COUNT(DISTINCT car_names.Model) FROM car_names WHERE car_names.Make IN "('amc rebel sst','saab 99le','datsun b-210')" GROUP BY car_names.Make HAVING car_names.Make LIKE "%ford%" ORDER BY car_names.Make LIMIT 3
SELECT cars_data.Horsepower, cars_data.Edispl FROM cars_data
SELECT cars_data.Horsepower, COUNT(*) FROM car_makers JOIN car_names JOIN cars_data JOIN model_list ON car_makers.Id=model_list.Maker AND car_names.MakeId=cars_data.Id AND model_list.Model=car_names.Model WHERE (car_makers.FullName NOT IN "('Daimler Benz','Mazda','Kia Motors','Ford Motor Company')" OR cars_data.MPG > 15.0) GROUP BY cars_data.Horsepower
SELECT COUNT(DISTINCT car_names.Model) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id
SELECT continents.Continent FROM continents
SELECT COUNT(*) FROM cars_data
SELECT car_makers.Maker, COUNT(DISTINCT model_list.Model) FROM car_makers JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country WHERE ((countries.CountryName NOT IN "('uk','france','mexico')" OR car_makers.Maker LIKE "%gm%") AND car_makers.FullName NOT IN "('Opel','Volvo')") GROUP BY car_makers.Maker
SELECT countries.CountryName, COUNT(DISTINCT countries.CountryName), MIN(countries.Continent) FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE continents.Continent = "europe" GROUP BY countries.CountryName
SELECT model_list.Model FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker
SELECT MIN(countries.CountryId), COUNT(DISTINCT countries.CountryName) FROM countries
SELECT model_list.ModelId, MAX(model_list.Maker), COUNT(DISTINCT model_list.Model) FROM model_list GROUP BY model_list.ModelId HAVING model_list.ModelId != 31.0
SELECT cars_data.Edispl, COUNT(*) FROM cars_data GROUP BY cars_data.Edispl HAVING (AVG(cars_data.Horsepower) < 65.0 OR cars_data.Edispl > 86.0)
SELECT continents.Continent, countries.Continent FROM car_makers JOIN continents JOIN countries ON continents.ContId=countries.Continent AND countries.CountryId=car_makers.Country WHERE ((countries.CountryName NOT IN "('nigeria','italy','sweden','korea','russia')" OR car_makers.FullName LIKE "Subaru%") AND countries.CountryName IN "('japan','sweden','australia','egypt')")
SELECT * FROM countries WHERE countries.CountryName != "korea" ORDER BY car_makers.FullName
SELECT COUNT(DISTINCT car_names.Model), COUNT(DISTINCT cars_data.Accelerate) FROM car_names JOIN cars_data ON car_names.MakeId=cars_data.Id ORDER BY car_names.Make LIMIT 1
SELECT continents.Continent, COUNT(DISTINCT continents.Continent) FROM continents GROUP BY continents.Continent HAVING continents.Continent = "america"
SELECT car_makers.Maker, MIN(car_names.MakeId) FROM car_makers JOIN car_names JOIN model_list ON car_makers.Id=model_list.Maker AND model_list.Model=car_names.Model WHERE car_makers.Maker NOT IN "('honda','triumph')" GROUP BY car_makers.Maker HAVING car_makers.Maker != "bmw"
SELECT countries.CountryName, COUNT(DISTINCT countries.CountryName), AVG(countries.Continent) FROM countries GROUP BY countries.CountryName
SELECT countries.CountryId FROM countries ORDER BY car_makers.Maker LIMIT 1
SELECT countries.CountryName, AVG(countries.CountryId), COUNT(DISTINCT car_makers.FullName) FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country GROUP BY countries.CountryName HAVING (COUNT(car_makers.Maker) >= 1 AND countries.CountryName IN "("('usa','sweden','nigeria','korea','uk')", 5)") ORDER BY COUNT(car_makers.Maker) LIMIT 1
SELECT cars_data.MPG, AVG(cars_data.Weight) FROM cars_data WHERE cars_data.Horsepower >= 225.0 GROUP BY cars_data.MPG ORDER BY cars_data.Cylinders LIMIT 1
SELECT continents.Continent, COUNT(DISTINCT continents.ContId), SUM(continents.ContId) FROM continents WHERE continents.Continent NOT LIKE "africa%" GROUP BY continents.Continent ORDER BY continents.Continent
SELECT COUNT(DISTINCT car_makers.Maker) FROM car_makers ORDER BY countries.CountryName
SELECT countries.CountryId, countries.CountryName FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE continents.Continent NOT IN "('africa','australia','asia')" ORDER BY continents.Continent LIMIT 2
SELECT car_makers.Maker FROM car_makers WHERE car_makers.FullName = "Nissan Motors"
