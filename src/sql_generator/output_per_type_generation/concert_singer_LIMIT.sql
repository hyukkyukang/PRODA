SELECT singer.Name FROM singer ORDER BY singer.Name LIMIT 4
SELECT stadium.Lowest FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID ORDER BY singer.Song_Name LIMIT 4
SELECT * FROM singer JOIN singer_in_concert ON singer.Singer_ID=singer_in_concert.Singer_ID ORDER BY singer.Singer_ID LIMIT 4
SELECT singer_in_concert.concert_ID FROM concert JOIN singer JOIN singer_in_concert ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID ORDER BY concert.concert_ID LIMIT 3
SELECT SUM(stadium.Capacity), AVG(stadium.Capacity) FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID ORDER BY concert.concert_ID LIMIT 4
SELECT concert.concert_ID FROM concert ORDER BY concert.Theme LIMIT 3
SELECT stadium.Stadium_ID FROM stadium ORDER BY stadium.Name LIMIT 1
SELECT stadium.Location FROM stadium ORDER BY stadium.Highest LIMIT 2
SELECT * FROM singer ORDER BY singer.Singer_ID LIMIT 1
SELECT concert.concert_ID, singer_in_concert.Singer_ID FROM concert JOIN singer_in_concert ON concert.concert_ID=singer_in_concert.concert_ID ORDER BY singer_in_concert.concert_ID LIMIT 2
SELECT * FROM singer ORDER BY singer.Singer_ID LIMIT 1
SELECT stadium.Stadium_ID, stadium.Location FROM stadium ORDER BY stadium.Average LIMIT 2
SELECT MIN(stadium.Average), COUNT(DISTINCT stadium.Location) FROM stadium ORDER BY stadium.Lowest LIMIT 2
SELECT COUNT(*) FROM singer ORDER BY singer.Is_male LIMIT 4
SELECT * FROM stadium ORDER BY stadium.Name LIMIT 4
SELECT * FROM stadium ORDER BY stadium.Highest LIMIT 2
SELECT singer.Country FROM singer ORDER BY singer.Age LIMIT 3
SELECT COUNT(*) FROM singer ORDER BY singer.Age LIMIT 2
SELECT * FROM singer_in_concert ORDER BY singer.Country LIMIT 1
SELECT * FROM singer ORDER BY singer.Is_male LIMIT 2
