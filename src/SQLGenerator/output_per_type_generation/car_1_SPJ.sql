SELECT AVG(model_list.Maker) FROM model_list
SELECT * FROM car_makers
SELECT COUNT(DISTINCT continents.Continent), MIN(continents.ContId) FROM continents WHERE continents.ContId = 5.0
SELECT countries.CountryId, continents.Continent FROM continents JOIN countries ON continents.ContId=countries.Continent
SELECT MAX(countries.Continent) FROM continents JOIN countries ON continents.ContId=countries.Continent WHERE ((continents.ContId != 2.0 AND continents.Continent NOT IN "('australia','europe','africa','asia')") AND countries.Continent = 1.0)
SELECT * FROM car_makers JOIN countries ON countries.CountryId=car_makers.Country
SELECT * FROM countries
SELECT * FROM car_names JOIN model_list ON model_list.Model=car_names.Model
SELECT countries.CountryId FROM countries
SELECT car_names.MakeId, model_list.Model FROM car_makers JOIN car_names JOIN countries JOIN model_list ON car_makers.Id=model_list.Maker AND countries.CountryId=car_makers.Country AND model_list.Model=car_names.Model WHERE countries.CountryName NOT IN "('russia','nigeria','brazil','mexico')"
SELECT cars_data.MPG, cars_data.Cylinders FROM cars_data
SELECT COUNT(*) FROM car_names
SELECT car_names.Make FROM car_names
SELECT car_makers.Maker, model_list.Model FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker
SELECT * FROM cars_data WHERE cars_data.Cylinders = 8.0
SELECT car_names.Make FROM car_names JOIN model_list ON model_list.Model=car_names.Model WHERE ((model_list.Model LIKE "%subaru%" OR model_list.Model = "'subaru'") AND model_list.ModelId > 26.0)
SELECT COUNT(*) FROM car_makers WHERE car_makers.FullName != "Citroen"
SELECT * FROM car_names WHERE (car_names.Model NOT LIKE "%pontiac%" OR car_names.Make NOT LIKE "%custom%")
SELECT car_makers.Country, model_list.Maker FROM car_makers JOIN model_list ON car_makers.Id=model_list.Maker WHERE ((car_makers.Id = 6.0 OR model_list.Model != "capri") OR car_makers.Id = 6.0)
SELECT * FROM cars_data WHERE cars_data.Weight >= 1836.0
