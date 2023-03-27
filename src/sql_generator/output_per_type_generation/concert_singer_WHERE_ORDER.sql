SELECT stadium.Location FROM stadium WHERE (stadium.Average > 637.0 OR stadium.Highest = 1763.0) ORDER BY stadium.Capacity
SELECT singer.Song_Name, singer.Song_release_year FROM singer WHERE singer.Song_Name IN "('Love','Gentleman','You')" ORDER BY singer_in_concert.Singer_ID
SELECT concert.Theme FROM concert JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND stadium.Stadium_ID=concert.Stadium_ID WHERE (stadium.Capacity >= 2000.0 OR singer_in_concert.concert_ID != 6.0) ORDER BY stadium.Name
SELECT singer_in_concert.Singer_ID FROM concert JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND stadium.Stadium_ID=concert.Stadium_ID WHERE (concert.concert_ID != 3.0 AND stadium.Name LIKE "Recreat%") ORDER BY stadium.Capacity
SELECT stadium.Name FROM stadium WHERE (stadium.Average != 642.0 AND stadium.Name = "Stark's Park") ORDER BY stadium.Highest
SELECT COUNT(DISTINCT concert.Year) FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID WHERE stadium.Lowest >= 400.0 ORDER BY stadium.Lowest
SELECT stadium.Average FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID WHERE ((singer.Singer_ID != 2 AND singer.Singer_ID != 6) OR stadium.Capacity < 52500.0) ORDER BY concert.Theme
SELECT concert.concert_Name, stadium.Average FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID WHERE (stadium.Name LIKE "%Park%" OR stadium.Lowest <= 1057.0) ORDER BY stadium.Location
SELECT * FROM stadium WHERE (stadium.Highest < 1057.0 AND stadium.Stadium_ID != 10.0) ORDER BY stadium.Capacity
SELECT concert.concert_Name, stadium.Lowest FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID WHERE stadium.Capacity < 4000.0 ORDER BY singer_in_concert.Singer_ID
SELECT stadium.Highest FROM stadium WHERE (stadium.Location NOT IN "('Peterhead','Arbroath','East Fife','Ayr United','Alloa Athletic')" OR stadium.Average >= 615.0) ORDER BY stadium.Capacity
SELECT COUNT(*) FROM stadium WHERE (stadium.Lowest != 466.0 OR stadium.Average > 864.0) ORDER BY stadium.Highest
SELECT singer.Song_Name, singer.Song_release_year FROM singer WHERE ((singer.Age != 32 OR singer.Singer_ID = 2) AND singer.Singer_ID != 3) ORDER BY singer.Country
SELECT * FROM stadium WHERE (stadium.Location IN "('East Fife','Arbroath','Alloa Athletic','Peterhead','Queen\'s Park')" AND stadium.Name IN "('Gayfield Park','Stark\'s Park','Hampden Park')") ORDER BY stadium.Highest
SELECT COUNT(DISTINCT singer.Song_release_year) FROM singer WHERE singer.Singer_ID = 6 ORDER BY singer.Name
SELECT stadium.Name, stadium.Stadium_ID FROM stadium WHERE (stadium.Capacity != 10104.0 OR stadium.Lowest < 404.0) ORDER BY stadium.Name
SELECT * FROM singer WHERE (singer.Age >= 41 OR (singer.Age = 43 AND singer.Name NOT LIKE "%Brown%")) ORDER BY singer.Song_Name
SELECT stadium.Stadium_ID, stadium.Average FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID WHERE singer.Age < 43 ORDER BY singer.Singer_ID
SELECT singer_in_concert.Singer_ID, stadium.Name FROM concert JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND stadium.Stadium_ID=concert.Stadium_ID WHERE stadium.Stadium_ID != 6.0 ORDER BY stadium.Lowest
SELECT SUM(stadium.Lowest) FROM stadium WHERE ((stadium.Stadium_ID = 7.0 OR stadium.Lowest < 331.0) OR stadium.Highest = 1057.0) ORDER BY stadium.Stadium_ID
