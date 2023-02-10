SELECT singer.Song_release_year, singer.Country FROM singer WHERE (singer.Age != 29 AND (singer.Age != 25 OR singer.Is_male != "F"))
SELECT stadium.Name, MIN(stadium.Highest) FROM stadium WHERE (stadium.Lowest != 331.0 OR stadium.Name != "Gayfield Park") GROUP BY stadium.Name ORDER BY stadium.Highest LIMIT 3
SELECT concert.concert_Name, COUNT(*) FROM concert JOIN singer JOIN singer_in_concert ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID WHERE (singer.Country = "France" AND concert.Theme = "Bleeding Love") GROUP BY concert.concert_Name ORDER BY COUNT(concert.Theme)
SELECT singer.Age FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID ORDER BY singer.Age LIMIT 1
SELECT concert.Year, COUNT(*) FROM concert WHERE (concert.concert_Name != "Home Visits" AND concert.concert_Name NOT IN "('Week 1','Super bootcamp','Auditions','Home Visits')") GROUP BY concert.Year ORDER BY concert.concert_Name LIMIT 2
SELECT concert.Theme FROM concert JOIN singer JOIN singer_in_concert ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID ORDER BY concert.Year
SELECT singer.Is_male, concert.Theme FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID ORDER BY singer.Song_release_year
SELECT singer.Name, COUNT(DISTINCT singer.Country), COUNT(DISTINCT singer.Name) FROM singer WHERE (singer.Country NOT LIKE "%France%" AND (singer.Is_male = "T" OR singer.Country LIKE "%France")) GROUP BY singer.Name HAVING (singer.Name = "Rose White" AND (COUNT(singer.Age) >= 3 AND COUNT(singer.Country) > 2))
SELECT stadium.Location, SUM(stadium.Capacity) FROM stadium GROUP BY stadium.Location HAVING (stadium.Location NOT LIKE "%Stirlin" OR SUM(stadium.Capacity) > 4000.0)
SELECT COUNT(DISTINCT singer.Song_release_year) FROM singer
SELECT stadium.Lowest FROM stadium ORDER BY stadium.Average LIMIT 4
SELECT stadium.Average FROM stadium ORDER BY stadium.Location
SELECT SUM(singer.Singer_ID), COUNT(DISTINCT singer.Name) FROM singer ORDER BY singer.Song_release_year LIMIT 4
SELECT * FROM singer WHERE singer.Is_male != "'F'"
SELECT stadium.Location FROM stadium WHERE stadium.Highest >= 2363.0
SELECT stadium.Highest, AVG(stadium.Lowest), COUNT(DISTINCT stadium.Location) FROM stadium WHERE stadium.Highest > 780.0 GROUP BY stadium.Highest ORDER BY AVG(stadium.Average) LIMIT 3
SELECT singer.Country, COUNT(DISTINCT singer.Name) FROM singer WHERE singer.Age > 41 GROUP BY singer.Country HAVING singer.Country != "France" ORDER BY COUNT(singer.Song_release_year)
SELECT singer.Singer_ID, concert.Stadium_ID FROM concert JOIN singer JOIN singer_in_concert ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID WHERE (singer.Is_male = "F" OR singer.Name NOT IN "('Rose White','John Nizinik','Tribal King')") ORDER BY concert.Year LIMIT 3
SELECT concert.Theme, stadium.Name FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID
SELECT stadium.Lowest, COUNT(DISTINCT concert.Stadium_ID), AVG(stadium.Capacity) FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID GROUP BY stadium.Lowest HAVING COUNT(concert.concert_Name) > 4
SELECT stadium.Lowest FROM stadium ORDER BY stadium.Average
SELECT COUNT(DISTINCT singer.Name) FROM singer WHERE singer.Age < 29
SELECT singer.Country, COUNT(DISTINCT singer.Is_male), COUNT(DISTINCT singer.Age) FROM singer GROUP BY singer.Country ORDER BY COUNT(singer.Is_male)
SELECT stadium.Capacity, stadium.Average FROM stadium WHERE stadium.Highest = 1057.0
SELECT * FROM stadium
SELECT * FROM stadium ORDER BY stadium.Name
SELECT stadium.Lowest, COUNT(DISTINCT singer.Country), COUNT(DISTINCT stadium.Highest) FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID GROUP BY stadium.Lowest ORDER BY COUNT(concert.concert_Name) LIMIT 2
SELECT singer.Name, COUNT(*) FROM singer GROUP BY singer.Name HAVING COUNT(singer.Song_release_year) <= 4
SELECT stadium.Capacity, COUNT(*) FROM stadium GROUP BY stadium.Capacity
SELECT singer.Song_Name FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID
SELECT singer.Song_release_year, AVG(singer.Age), COUNT(DISTINCT singer.Song_Name) FROM singer GROUP BY singer.Song_release_year HAVING (singer.Song_release_year = "2013" OR (COUNT(singer.Is_male) <= 4 AND COUNT(singer.Country) != 2))
SELECT stadium.Capacity, COUNT(*) FROM stadium WHERE ((stadium.Capacity > 10104.0 AND stadium.Capacity = 11998.0) OR stadium.Capacity > 3808.0) GROUP BY stadium.Capacity
SELECT stadium.Capacity, COUNT(*) FROM stadium GROUP BY stadium.Capacity ORDER BY stadium.Capacity LIMIT 1
SELECT singer.Song_Name, COUNT(DISTINCT singer.Song_release_year) FROM singer WHERE singer.Age = 29 GROUP BY singer.Song_Name ORDER BY COUNT(singer.Is_male) LIMIT 2
SELECT stadium.Location, COUNT(DISTINCT stadium.Location) FROM stadium GROUP BY stadium.Location
SELECT stadium.Average, COUNT(*) FROM singer WHERE singer.Song_Name = "Dangerous" GROUP BY stadium.Average
SELECT stadium.Name, COUNT(DISTINCT stadium.Highest) FROM stadium WHERE stadium.Location NOT LIKE "Arbroat%" GROUP BY stadium.Name ORDER BY stadium.Name LIMIT 1
SELECT stadium.Capacity, COUNT(*) FROM stadium WHERE (stadium.Highest <= 2363.0 AND stadium.Location = "Ayr United") GROUP BY stadium.Capacity
SELECT stadium.Lowest, COUNT(*) FROM stadium WHERE (stadium.Location NOT IN "('Queen\'s Park','Stirling Albion','Raith Rovers','East Fife','Arbroath')" AND stadium.Name LIKE "Balmoor%") GROUP BY stadium.Lowest ORDER BY MIN(stadium.Highest)
SELECT singer.Name, COUNT(DISTINCT singer.Name), COUNT(DISTINCT singer.Age) FROM singer GROUP BY singer.Name ORDER BY AVG(singer.Age)
SELECT stadium.Average FROM stadium WHERE stadium.Highest >= 1763.0 ORDER BY stadium.Capacity
SELECT singer.Country, SUM(singer.Age), COUNT(DISTINCT singer.Song_release_year) FROM singer WHERE singer.Is_male = "F" GROUP BY singer.Country
SELECT stadium.Capacity, COUNT(*) FROM stadium WHERE stadium.Average > 615.0 GROUP BY stadium.Capacity ORDER BY stadium.Highest
SELECT stadium.Name, SUM(stadium.Highest), AVG(stadium.Capacity) FROM stadium WHERE (stadium.Lowest > 315.0 AND stadium.Highest < 1057.0) GROUP BY stadium.Name
SELECT stadium.Name, COUNT(DISTINCT stadium.Location), COUNT(DISTINCT stadium.Stadium_ID) FROM stadium GROUP BY stadium.Name
SELECT COUNT(DISTINCT singer.Song_release_year), COUNT(DISTINCT singer.Is_male) FROM singer ORDER BY singer.Song_release_year
SELECT stadium.Name FROM stadium ORDER BY stadium.Highest
SELECT stadium.Lowest FROM stadium
SELECT stadium.Highest, COUNT(*) FROM stadium WHERE stadium.Capacity <= 4000.0 GROUP BY stadium.Highest HAVING (stadium.Highest <= 1980.0 OR COUNT(stadium.Name) != 2) ORDER BY stadium.Name LIMIT 2
SELECT * FROM singer WHERE singer.Name NOT LIKE "%Nizinik%" ORDER BY singer.Name
SELECT stadium.Lowest, stadium.Location FROM stadium WHERE (stadium.Lowest != 400.0 AND stadium.Average <= 615.0)
SELECT * FROM stadium WHERE (stadium.Lowest < 1057.0 OR stadium.Lowest < 315.0)
SELECT singer.Song_release_year, COUNT(*) FROM singer GROUP BY singer.Song_release_year ORDER BY COUNT(singer.Age)
SELECT stadium.Location, COUNT(*) FROM stadium WHERE (stadium.Highest != 4812.0 OR stadium.Lowest = 533.0) GROUP BY stadium.Location HAVING (AVG(stadium.Average) != 642.0 AND stadium.Location = "Stirling Albion")
SELECT singer.Is_male, MIN(singer.Singer_ID) FROM singer WHERE (singer.Is_male != "'F'" AND singer.Song_Name IN "('Love','Gentleman','You','Hey Oh','Sun')") GROUP BY singer.Is_male
SELECT stadium.Lowest, COUNT(DISTINCT stadium.Location), COUNT(DISTINCT concert.Theme) FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID WHERE (stadium.Average != 1477.0 AND stadium.Capacity >= 3960.0) GROUP BY stadium.Lowest HAVING (COUNT(concert.concert_Name) <= 3 AND COUNT(concert.Year) <= 1)
SELECT stadium.Average, COUNT(DISTINCT stadium.Location) FROM stadium GROUP BY stadium.Average
SELECT concert.concert_Name, COUNT(DISTINCT concert.concert_Name) FROM concert GROUP BY concert.concert_Name HAVING COUNT(concert.Year) < 3
SELECT stadium.Average, COUNT(DISTINCT stadium.Name) FROM stadium WHERE (stadium.Location = "Alloa Athletic" AND stadium.Name = "Recreation Park") GROUP BY stadium.Average
SELECT singer.Age, SUM(singer.Singer_ID), COUNT(DISTINCT singer.Song_release_year) FROM singer WHERE singer.Song_Name IN "('You','Gentleman')" GROUP BY singer.Age ORDER BY singer.Name
SELECT stadium.Location, COUNT(DISTINCT stadium.Lowest), SUM(stadium.Lowest) FROM stadium GROUP BY stadium.Location
SELECT stadium.Average, COUNT(*) FROM stadium GROUP BY stadium.Average HAVING COUNT(stadium.Location) >= 2
SELECT concert.Year, stadium.Stadium_ID FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID WHERE stadium.Capacity = 10104.0
SELECT stadium.Location FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID WHERE concert.concert_Name != "'Auditions'"
SELECT COUNT(*) FROM singer ORDER BY singer.Age LIMIT 1
SELECT * FROM singer WHERE (singer.Country IN "('France','United States','Netherlands')" OR singer.Name LIKE "%King%")
SELECT singer.Country, MIN(singer.Singer_ID), SUM(singer.Singer_ID) FROM singer WHERE singer.Song_Name = "Gentleman" GROUP BY singer.Country
SELECT COUNT(*) FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID
SELECT stadium.Average, MAX(stadium.Lowest), SUM(stadium.Lowest) FROM stadium GROUP BY stadium.Average ORDER BY stadium.Average LIMIT 3
SELECT singer.Song_Name, MIN(singer.Singer_ID), COUNT(DISTINCT singer.Song_release_year) FROM singer GROUP BY singer.Song_Name HAVING COUNT(singer.Name) < 2
SELECT singer.Is_male, singer.Singer_ID FROM singer ORDER BY singer.Is_male
SELECT stadium.Name, stadium.Lowest FROM stadium
SELECT singer.Age, COUNT(DISTINCT singer.Age), COUNT(DISTINCT singer.Is_male) FROM concert JOIN singer JOIN singer_in_concert ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID GROUP BY singer.Age HAVING (COUNT(singer.Name) < 2 AND singer.Age = 43)
SELECT stadium.Average, AVG(stadium.Capacity), COUNT(DISTINCT concert.Year) FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID GROUP BY stadium.Average ORDER BY singer.Age LIMIT 1
SELECT stadium.Location, COUNT(DISTINCT stadium.Name), MIN(stadium.Highest) FROM stadium WHERE ((stadium.Average <= 638.0 OR stadium.Average > 552.0) AND stadium.Name LIKE "%Glebe%") GROUP BY stadium.Location ORDER BY COUNT(stadium.Name)
SELECT stadium.Average, COUNT(DISTINCT concert.Year), SUM(singer_in_concert.concert_ID) FROM concert JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND stadium.Stadium_ID=concert.Stadium_ID WHERE stadium.Highest <= 1980.0 GROUP BY stadium.Average HAVING COUNT(singer.Song_release_year) = 3 ORDER BY COUNT(concert.Theme)
SELECT MIN(singer.Singer_ID), COUNT(DISTINCT singer.Song_Name) FROM singer ORDER BY singer.Song_release_year LIMIT 3
SELECT singer.Age, COUNT(DISTINCT singer.Song_release_year), COUNT(DISTINCT singer.Song_Name) FROM singer WHERE singer.Name = "Justin Brown" GROUP BY singer.Age HAVING ((COUNT(singer.Song_Name) > 1 AND COUNT(singer.Name) > 2) OR COUNT(singer.Name) <= 1) ORDER BY COUNT(singer.Is_male)
SELECT stadium.Highest, MIN(stadium.Highest), COUNT(DISTINCT stadium.Location) FROM stadium WHERE ((stadium.Name = "Forthbank Stadium" AND stadium.Lowest < 1057.0) OR stadium.Location NOT LIKE "City%") GROUP BY stadium.Highest HAVING COUNT(stadium.Capacity) = 3 ORDER BY stadium.Highest LIMIT 4
SELECT stadium.Lowest FROM stadium WHERE stadium.Location NOT LIKE "Arbroat%"
SELECT * FROM singer ORDER BY singer.Song_release_year LIMIT 4
SELECT concert.Theme, COUNT(DISTINCT stadium.Highest), COUNT(DISTINCT singer.Song_release_year) FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID GROUP BY concert.Theme HAVING (AVG(singer.Age) != 29 OR COUNT(singer.Country) <= 2)
SELECT singer.Is_male, COUNT(DISTINCT singer.Is_male), COUNT(DISTINCT singer.Country) FROM singer WHERE ((singer.Country NOT IN "('United States','France')" OR singer.Country NOT IN "('United States','France')") OR singer.Age <= 25) GROUP BY singer.Is_male ORDER BY singer.Song_Name
SELECT stadium.Location, COUNT(*) FROM stadium WHERE (stadium.Lowest <= 400.0 OR stadium.Capacity <= 52500.0) GROUP BY stadium.Location HAVING ((SUM(stadium.Lowest) <= 411.0 OR stadium.Location LIKE "%Arbroat%") AND SUM(stadium.Average) <= 638.0) ORDER BY stadium.Average LIMIT 3
SELECT concert.Year, COUNT(*) FROM concert GROUP BY concert.Year HAVING (COUNT(concert.Theme) <= 2 AND COUNT(concert.Theme) != 1)
SELECT singer.Age, singer.Is_male FROM singer ORDER BY singer.Age LIMIT 1
SELECT COUNT(*) FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID WHERE ((concert.Theme = "Free choice" OR concert.Theme != "Happy Tonight") OR stadium.Name LIKE "%Stark's%")
SELECT stadium.Stadium_ID, stadium.Highest FROM stadium WHERE (stadium.Capacity >= 11998.0 OR (stadium.Average >= 552.0 AND stadium.Name != "Recreation Park"))
SELECT concert.Theme, MIN(concert.concert_ID), COUNT(DISTINCT concert.Year) FROM concert GROUP BY concert.Theme ORDER BY concert.Theme
SELECT * FROM singer ORDER BY singer.Song_Name LIMIT 3
SELECT stadium.Lowest, COUNT(DISTINCT stadium.Location) FROM stadium WHERE (stadium.Lowest = 400.0 OR stadium.Location = "Peterhead") GROUP BY stadium.Lowest
SELECT COUNT(DISTINCT singer.Country) FROM singer ORDER BY singer.Age LIMIT 2
SELECT stadium.Average, COUNT(DISTINCT stadium.Location) FROM stadium GROUP BY stadium.Average
SELECT singer.Singer_ID, singer.Name FROM singer WHERE ((singer.Country NOT LIKE "%States" AND singer.Age = 52) AND singer.Age <= 52)
SELECT stadium.Highest, MIN(stadium.Capacity) FROM stadium WHERE (stadium.Lowest < 404.0 OR stadium.Location IN "('Peterhead','Alloa Athletic','Ayr United','Brechin City','Stirling Albion')") GROUP BY stadium.Highest HAVING MIN(stadium.Capacity) > 2000.0
SELECT stadium.Location, SUM(stadium.Lowest), MAX(stadium.Lowest) FROM stadium WHERE (stadium.Lowest > 400.0 AND (stadium.Name NOT LIKE "%Glebe" OR stadium.Lowest < 411.0)) GROUP BY stadium.Location ORDER BY stadium.Highest
SELECT singer.Is_male, COUNT(DISTINCT singer.Song_release_year), COUNT(DISTINCT concert.concert_Name) FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID WHERE (singer.Is_male != "T" OR stadium.Name = "Recreation Park") GROUP BY singer.Is_male HAVING (COUNT(singer.Name) > 4 AND COUNT(singer.Song_Name) <= 3) ORDER BY singer.Is_male
SELECT COUNT(DISTINCT singer.Song_release_year) FROM singer WHERE (singer.Name != "Rose White" AND singer.Song_Name LIKE "Love%")
SELECT MAX(stadium.Capacity) FROM stadium ORDER BY stadium.Highest LIMIT 3
SELECT singer.Country FROM singer
