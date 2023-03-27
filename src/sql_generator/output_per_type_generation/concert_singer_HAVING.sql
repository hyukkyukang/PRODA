SELECT singer.Name, COUNT(DISTINCT singer.Song_release_year) FROM singer GROUP BY singer.Name HAVING ((COUNT(singer.Song_release_year) > 1 AND MIN(singer.Singer_ID) < 1) OR AVG(singer.Singer_ID) <= 1)
SELECT stadium.Capacity, COUNT(*) FROM stadium GROUP BY stadium.Capacity HAVING (COUNT(stadium.Average) > 2 OR COUNT(stadium.Name) = 3)
SELECT concert.concert_ID, COUNT(DISTINCT concert.Theme), COUNT(DISTINCT concert.concert_Name) FROM concert GROUP BY concert.concert_ID HAVING ((COUNT(concert.Year) >= 1 AND COUNT(concert.concert_Name) = 4) AND COUNT(concert.Stadium_ID) != 4)
SELECT concert.concert_ID, MAX(stadium.Lowest), COUNT(DISTINCT singer.Country) FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID GROUP BY concert.concert_ID HAVING (COUNT(singer_in_concert.Singer_ID) > 2 OR COUNT(singer_in_concert.Singer_ID) = 4)
SELECT singer.Song_release_year, COUNT(*) FROM singer GROUP BY singer.Song_release_year HAVING (MAX(singer.Age) >= 43.0 OR MIN(singer_in_concert.concert_ID) <= 3.0)
SELECT singer.Song_Name, COUNT(DISTINCT singer.Name) FROM singer GROUP BY singer.Song_Name HAVING MAX(singer.Singer_ID) > 3
SELECT singer.Country, COUNT(DISTINCT singer.Country) FROM singer GROUP BY singer.Country HAVING ((COUNT(singer_in_concert.concert_ID) > 3 AND COUNT(singer.Song_release_year) >= 1) AND MAX(singer_in_concert.concert_ID) < 5.0)
SELECT stadium.Highest, AVG(stadium.Highest), AVG(stadium.Stadium_ID) FROM stadium GROUP BY stadium.Highest HAVING (COUNT(stadium.Capacity) <= 2 OR (stadium.Highest != 780.0 AND AVG(stadium.Capacity) > 3960.0))
SELECT concert.Year, SUM(singer_in_concert.concert_ID) FROM concert JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND stadium.Stadium_ID=concert.Stadium_ID GROUP BY concert.Year HAVING (concert.Year = "2015.0" OR (COUNT(concert.Theme) != 4 AND COUNT(singer_in_concert.Singer_ID) = 2))
SELECT singer.Singer_ID, COUNT(DISTINCT singer.Song_Name) FROM singer GROUP BY singer.Singer_ID HAVING (COUNT(singer.Song_release_year) < 4 OR (COUNT(singer.Country) >= 2 OR COUNT(singer.Song_release_year) > 2))
SELECT singer.Country, COUNT(*) FROM singer GROUP BY singer.Country HAVING (COUNT(singer.Name) < 4 AND (COUNT(singer.Song_Name) <= 4 OR SUM(singer.Singer_ID) != 1))
SELECT stadium.Highest, COUNT(*) FROM stadium GROUP BY stadium.Highest HAVING (MIN(stadium.Lowest) >= 411.0 AND stadium.Highest != 921.0)
SELECT singer.Song_release_year, SUM(singer.Singer_ID) FROM singer GROUP BY singer.Song_release_year HAVING (COUNT(singer.Country) != 3 AND (COUNT(singer.Age) < 3 OR singer.Song_release_year NOT IN "("('2008.0','2014.0','2016.0','2003.0')", 4)"))
SELECT stadium.Average, COUNT(DISTINCT concert.Stadium_ID), SUM(stadium.Capacity) FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID GROUP BY stadium.Average HAVING (AVG(stadium.Lowest) > 1057.0 OR MAX(stadium.Capacity) < 11998.0)
SELECT stadium.Highest, COUNT(*) FROM stadium GROUP BY stadium.Highest HAVING MAX(stadium.Capacity) <= 52500.0
SELECT stadium.Name, AVG(stadium.Average), COUNT(DISTINCT stadium.Name) FROM stadium GROUP BY stadium.Name HAVING (stadium.Name NOT IN "("('Hampden Park','Recreation Park','Glebe Park')", 3)" AND SUM(stadium.Average) > 864.0)
SELECT singer.Name, COUNT(DISTINCT singer.Age) FROM singer GROUP BY singer.Name HAVING ((COUNT(singer.Song_Name) > 1 AND COUNT(singer.Song_Name) > 4) OR COUNT(singer.Country) <= 4)
SELECT singer.Country, COUNT(*) FROM singer GROUP BY singer.Country HAVING (COUNT(singer.Name) > 2 OR COUNT(singer.Name) <= 3)
SELECT stadium.Location, COUNT(*) FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID GROUP BY stadium.Location HAVING ((COUNT(stadium.Name) >= 4 OR COUNT(stadium.Name) >= 3) AND MIN(stadium.Stadium_ID) < 9.0)
SELECT concert.Year, COUNT(DISTINCT concert.Year) FROM concert JOIN singer JOIN singer_in_concert ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID GROUP BY concert.Year HAVING ((SUM(singer.Singer_ID) >= 6 OR COUNT(singer.Country) > 2) OR COUNT(concert.Theme) >= 1)
