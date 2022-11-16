SELECT O_stadium.Lowest FROM stadium O_stadium WHERE O_stadium.Name = (SELECT I_stadium.Name FROM concert I_concert JOIN singer I_singer JOIN singer_in_concert I_singer_in_concert JOIN stadium I_stadium ON I_concert.concert_ID=I_singer_in_concert.concert_ID AND I_singer.Singer_ID=I_singer_in_concert.Singer_ID AND I_stadium.Stadium_ID=I_concert.Stadium_ID WHERE (O_stadium.Location = I_stadium.Location AND ((I_singer.Name NOT LIKE "Brown%" AND I_stadium.Location != "Ayr United") OR I_concert.concert_Name LIKE "%Super%")))
SELECT O_singer.Singer_ID FROM singer O_singer WHERE O_singer.Name NOT IN (SELECT I_singer.Name FROM singer I_singer WHERE (O_singer.Country = I_singer.Country AND (I_singer.Is_male LIKE "%F%" AND (I_singer.Name NOT LIKE "imbalan%" OR I_singer.Age != 25))))
SELECT O_concert.concert_ID, O_concert.Stadium_ID FROM concert O_concert WHERE O_concert.concert_ID NOT IN (SELECT I_concert.concert_ID FROM concert I_concert WHERE (O_concert.Stadium_ID = I_concert.Stadium_ID AND I_concert.Theme IN "('Free choice','Wide Awake','Bleeding Love','Happy Tonight')"))
SELECT COUNT(*) FROM concert O_concert JOIN stadium O_stadium ON O_stadium.Stadium_ID=O_concert.Stadium_ID WHERE (O_stadium.Capacity != 3960.0 OR (O_concert.concert_Name IN "('Super bootcamp','Week 2','Week 1','Auditions')" OR O_stadium.Location NOT IN (SELECT I_stadium.Location FROM stadium I_stadium WHERE (O_stadium.Average = I_stadium.Average AND I_stadium.Average <= 615.0))))
SELECT COUNT(DISTINCT O_singer_in_concert.Singer_ID), SUM(O_singer_in_concert.concert_ID) FROM singer_in_concert O_singer_in_concert WHERE O_singer_in_concert.concert_ID IN (SELECT I_singer_in_concert.concert_ID FROM singer I_singer JOIN singer_in_concert I_singer_in_concert ON I_singer.Singer_ID=I_singer_in_concert.Singer_ID WHERE (O_singer_in_concert.Singer_ID = I_singer_in_concert.Singer_ID AND I_singer.Is_male LIKE "%F%"))
SELECT O_singer.Song_release_year, O_singer.Is_male FROM singer O_singer WHERE ((O_singer.Name LIKE "John%" AND O_singer.Song_Name = "Gentleman") AND O_singer.Singer_ID <= (SELECT I_singer.Singer_ID FROM concert I_concert JOIN singer I_singer JOIN singer_in_concert I_singer_in_concert ON I_concert.concert_ID=I_singer_in_concert.concert_ID AND I_singer.Singer_ID=I_singer_in_concert.Singer_ID WHERE (O_singer.Song_release_year = I_singer.Song_release_year AND I_concert.concert_ID = 1.0)))
SELECT O_stadium.Stadium_ID FROM stadium O_stadium WHERE O_stadium.Location IN (SELECT I_stadium.Location FROM stadium I_stadium WHERE (O_stadium.Capacity = I_stadium.Capacity AND ((I_stadium.Highest < 837.0 AND I_stadium.Capacity <= 3960.0) AND I_stadium.Name = "Glebe Park")))
SELECT AVG(O_stadium.Average) FROM concert O_concert JOIN singer O_singer JOIN singer_in_concert O_singer_in_concert JOIN stadium O_stadium ON O_concert.concert_ID=O_singer_in_concert.concert_ID AND O_singer.Singer_ID=O_singer_in_concert.Singer_ID AND O_stadium.Stadium_ID=O_concert.Stadium_ID WHERE (O_singer.Song_Name = "Love" AND O_concert.Theme LIKE (SELECT I_concert.Theme FROM concert I_concert JOIN singer I_singer JOIN singer_in_concert I_singer_in_concert JOIN stadium I_stadium ON I_concert.concert_ID=I_singer_in_concert.concert_ID AND I_singer.Singer_ID=I_singer_in_concert.Singer_ID AND I_stadium.Stadium_ID=I_concert.Stadium_ID WHERE (O_stadium.Lowest = I_stadium.Lowest AND (I_stadium.Average > 638.0 AND I_singer.Country != "United States"))))
SELECT O_stadium.Capacity, O_singer.Name FROM concert O_concert JOIN singer O_singer JOIN singer_in_concert O_singer_in_concert JOIN stadium O_stadium ON O_concert.concert_ID=O_singer_in_concert.concert_ID AND O_singer.Singer_ID=O_singer_in_concert.Singer_ID AND O_stadium.Stadium_ID=O_concert.Stadium_ID WHERE (O_stadium.Lowest >= 1294.0 AND O_concert.concert_ID != (SELECT I_concert.concert_ID FROM concert I_concert JOIN singer I_singer JOIN singer_in_concert I_singer_in_concert ON I_concert.concert_ID=I_singer_in_concert.concert_ID AND I_singer.Singer_ID=I_singer_in_concert.Singer_ID WHERE (O_singer.Age = I_singer.Age AND (I_singer.Name NOT LIKE "Tribal%" OR (I_singer_in_concert.concert_ID != 1.0 OR I_concert.Theme LIKE "%Wide")))))
SELECT O_singer.Age, O_singer.Song_release_year FROM singer O_singer WHERE ((O_singer.Is_male LIKE (SELECT I_singer.Is_male FROM singer I_singer WHERE (O_singer.Singer_ID = I_singer.Singer_ID AND (I_singer.Name IN "('Justin Brown','John Nizinik')" OR I_singer.Singer_ID = 4))) OR O_singer.Song_Name NOT LIKE "%angerou") OR O_singer.Age < 52)