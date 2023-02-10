SELECT * FROM stadium WHERE (stadium.Average > 637.0 OR stadium.Highest = 1763.0)
SELECT COUNT(DISTINCT singer_in_concert.Singer_ID) FROM singer_in_concert WHERE singer_in_concert.concert_ID = 1.0
SELECT stadium.Highest FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID
SELECT singer.Age FROM singer
SELECT concert.Theme FROM concert
SELECT singer.Singer_ID FROM singer WHERE singer.Is_male != "T"
SELECT singer.Song_Name FROM singer WHERE singer.Song_Name != "Sun"
SELECT singer.Song_Name, singer.Song_release_year FROM singer WHERE singer.Is_male = "F"
SELECT COUNT(DISTINCT singer_in_concert.Singer_ID) FROM concert JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND stadium.Stadium_ID=concert.Stadium_ID
SELECT COUNT(*) FROM stadium
SELECT COUNT(*) FROM stadium WHERE (stadium.Location = "Raith Rovers" AND stadium.Location IN "('Raith Rovers','Queen\'s Park','Ayr United','Alloa Athletic','Stirling Albion')")
SELECT COUNT(DISTINCT singer.Name) FROM singer
SELECT * FROM stadium
SELECT concert.Year FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID WHERE (stadium.Stadium_ID = 1.0 OR concert.concert_Name NOT LIKE "Week%")
SELECT singer.Song_release_year, singer.Song_Name FROM singer WHERE (singer.Age != 32 OR (singer.Is_male NOT LIKE "%F%" AND singer.Singer_ID = 2))
SELECT singer.Age, singer.Country FROM singer WHERE singer.Singer_ID != 1
SELECT singer.Song_release_year FROM singer WHERE (singer.Song_Name NOT IN "('Sun','Gentleman','Love','Dangerous')" AND singer.Age != 43)
SELECT * FROM concert
SELECT singer.Name FROM singer WHERE singer.Name IN "('Tribal King','Justin Brown')"
SELECT COUNT(DISTINCT singer_in_concert.Singer_ID), COUNT(DISTINCT concert.Theme) FROM concert JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND stadium.Stadium_ID=concert.Stadium_ID
