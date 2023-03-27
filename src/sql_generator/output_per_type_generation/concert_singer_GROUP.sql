SELECT singer.Name, COUNT(DISTINCT singer.Song_release_year) FROM singer GROUP BY singer.Name
SELECT concert.Stadium_ID, COUNT(DISTINCT concert.concert_Name) FROM concert GROUP BY concert.Stadium_ID
SELECT stadium.Name, COUNT(DISTINCT singer.Song_release_year), COUNT(DISTINCT singer.Is_male) FROM singer GROUP BY stadium.Name
SELECT concert.Theme, COUNT(*) FROM singer GROUP BY concert.Theme
SELECT singer.Singer_ID, AVG(singer.Age), COUNT(DISTINCT singer.Country) FROM singer GROUP BY singer.Singer_ID
SELECT stadium.Stadium_ID, COUNT(*) FROM singer GROUP BY stadium.Stadium_ID
SELECT stadium.Location, AVG(stadium.Stadium_ID), COUNT(DISTINCT stadium.Stadium_ID) FROM stadium GROUP BY stadium.Location
SELECT concert.Theme, COUNT(DISTINCT concert.concert_Name) FROM concert GROUP BY concert.Theme
SELECT stadium.Stadium_ID, COUNT(*) FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID GROUP BY stadium.Stadium_ID
SELECT stadium.Name, MAX(stadium.Highest), COUNT(DISTINCT stadium.Stadium_ID) FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID GROUP BY stadium.Name
SELECT stadium.Name, MAX(stadium.Stadium_ID) FROM stadium GROUP BY stadium.Name
SELECT stadium.Name, COUNT(*) FROM stadium GROUP BY stadium.Name
SELECT stadium.Average, COUNT(*) FROM stadium GROUP BY stadium.Average
SELECT singer.Name, SUM(stadium.Lowest) FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID GROUP BY singer.Name
SELECT stadium.Location, SUM(stadium.Highest) FROM stadium GROUP BY stadium.Location
SELECT singer.Is_male, COUNT(DISTINCT singer.Singer_ID) FROM singer GROUP BY singer.Is_male
SELECT singer.Song_release_year, COUNT(DISTINCT singer.Song_Name), SUM(singer.Age) FROM singer GROUP BY singer.Song_release_year
SELECT stadium.Location, SUM(stadium.Stadium_ID) FROM stadium GROUP BY stadium.Location
SELECT stadium.Name, SUM(concert.concert_ID) FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID GROUP BY stadium.Name
SELECT stadium.Name, AVG(stadium.Stadium_ID), SUM(stadium.Capacity) FROM stadium GROUP BY stadium.Name
