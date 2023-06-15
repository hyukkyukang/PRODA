SELECT O_stadium.Average, O_stadium.Name FROM stadium O_stadium WHERE (SELECT MAX(I_stadium.Highest) FROM stadium I_stadium WHERE (O_stadium.Stadium_ID = I_stadium.Stadium_ID AND I_stadium.Name NOT LIKE "%Stadium%")) != 2363.0
SELECT O_stadium.Lowest, O_stadium.Average FROM stadium O_stadium WHERE O_stadium.Stadium_ID <= (SELECT SUM(I_stadium.Stadium_ID) FROM stadium I_stadium WHERE (O_stadium.Highest = I_stadium.Highest AND (I_stadium.Highest = 1057.0 OR I_stadium.Location NOT LIKE "%Arbroat%")))
SELECT O_singer_in_concert.concert_ID, O_singer_in_concert.Singer_ID FROM singer_in_concert O_singer_in_concert WHERE O_singer_in_concert.concert_ID != (SELECT MIN(I_singer_in_concert.concert_ID) FROM concert I_concert JOIN singer_in_concert I_singer_in_concert JOIN stadium I_stadium ON I_concert.concert_ID=I_singer_in_concert.concert_ID AND I_stadium.Stadium_ID=I_concert.Stadium_ID WHERE (O_singer_in_concert.Singer_ID = I_singer_in_concert.Singer_ID AND (I_stadium.Capacity != 3808.0 OR (I_stadium.Location NOT IN "('Alloa Athletic','Ayr United','Stirling Albion')" OR I_stadium.Location NOT LIKE "eterhea%"))))
SELECT O_singer.Song_release_year FROM singer O_singer WHERE ((O_singer.Country LIKE "%France" OR O_singer.Name NOT LIKE "%Justin") OR (SELECT AVG(I_singer_in_concert.concert_ID) FROM concert I_concert JOIN singer I_singer JOIN singer_in_concert I_singer_in_concert JOIN stadium I_stadium ON I_concert.concert_ID=I_singer_in_concert.concert_ID AND I_singer.Singer_ID=I_singer_in_concert.Singer_ID AND I_stadium.Stadium_ID=I_concert.Stadium_ID WHERE (O_singer.Is_male = I_singer.Is_male AND (I_stadium.Highest > 1980.0 OR I_singer.Country NOT IN "('France','Netherlands')"))) != 1.6986666666666668)
SELECT COUNT(DISTINCT O_singer.Country) FROM singer O_singer WHERE (O_singer.Is_male != "T" OR O_singer.Age = (SELECT AVG(I_singer.Age) FROM singer I_singer WHERE (O_singer.Is_male = I_singer.Is_male AND (I_singer.Singer_ID = 6 OR I_singer.Name LIKE "%White"))))
SELECT O_singer.Singer_ID FROM concert O_concert JOIN singer O_singer JOIN singer_in_concert O_singer_in_concert JOIN stadium O_stadium ON O_concert.concert_ID=O_singer_in_concert.concert_ID AND O_singer.Singer_ID=O_singer_in_concert.Singer_ID AND O_stadium.Stadium_ID=O_concert.Stadium_ID WHERE (O_stadium.Lowest != (SELECT SUM(I_stadium.Lowest) FROM stadium I_stadium WHERE (O_stadium.Highest = I_stadium.Highest AND (I_stadium.Highest < 837.0 OR (I_stadium.Name = "Glebe Park" AND I_stadium.Stadium_ID != 10.0)))) OR O_singer.Age != 25)
SELECT * FROM concert O_concert JOIN singer O_singer JOIN singer_in_concert O_singer_in_concert JOIN stadium O_stadium ON O_concert.concert_ID=O_singer_in_concert.concert_ID AND O_singer.Singer_ID=O_singer_in_concert.Singer_ID AND O_stadium.Stadium_ID=O_concert.Stadium_ID WHERE (O_stadium.Average = (SELECT MAX(I_stadium.Average) FROM stadium I_stadium WHERE (O_singer_in_concert.concert_ID = I_singer_in_concert.concert_ID AND I_stadium.Location = "Peterhead")) OR O_singer.Name != "Tribal King")
SELECT * FROM singer O_singer WHERE (O_singer.Age <= 52 OR (SELECT MAX(I_singer_in_concert.concert_ID) FROM concert I_concert JOIN singer I_singer JOIN singer_in_concert I_singer_in_concert ON I_concert.concert_ID=I_singer_in_concert.concert_ID AND I_singer.Singer_ID=I_singer_in_concert.Singer_ID WHERE (O_singer.Country = I_singer.Country AND (I_singer.Country NOT LIKE "herland%" AND I_concert.concert_ID != 2.0))) > 6.0)
SELECT O_singer.Is_male FROM singer O_singer WHERE (SELECT COUNT(I_singer.Song_Name) FROM singer I_singer WHERE (O_singer.Singer_ID = I_singer.Singer_ID AND I_singer.Country LIKE "%France%")) < 187
SELECT O_concert.Year FROM concert O_concert JOIN stadium O_stadium ON O_stadium.Stadium_ID=O_concert.Stadium_ID WHERE (O_stadium.Lowest = 400.0 OR (SELECT MAX(I_stadium.Stadium_ID) FROM stadium I_stadium WHERE (O_stadium.Location = I_stadium.Location AND I_stadium.Capacity <= 11998.0)) != 5.0)