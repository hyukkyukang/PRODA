SELECT singer.Name FROM singer ORDER BY singer.Name
SELECT stadium.Lowest FROM concert JOIN singer JOIN singer_in_concert JOIN stadium ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID AND stadium.Stadium_ID=concert.Stadium_ID ORDER BY singer.Song_Name
SELECT * FROM singer JOIN singer_in_concert ON singer.Singer_ID=singer_in_concert.Singer_ID ORDER BY singer.Singer_ID
SELECT singer_in_concert.concert_ID FROM concert JOIN singer JOIN singer_in_concert ON concert.concert_ID=singer_in_concert.concert_ID AND singer.Singer_ID=singer_in_concert.Singer_ID ORDER BY concert.concert_ID
SELECT SUM(stadium.Capacity), AVG(stadium.Capacity) FROM concert JOIN stadium ON stadium.Stadium_ID=concert.Stadium_ID ORDER BY concert.concert_ID
SELECT concert.concert_ID FROM concert ORDER BY concert.Theme
SELECT stadium.Stadium_ID FROM stadium ORDER BY stadium.Name
SELECT stadium.Location FROM stadium ORDER BY stadium.Highest
SELECT * FROM singer ORDER BY singer.Singer_ID
SELECT concert.concert_ID, singer_in_concert.Singer_ID FROM concert JOIN singer_in_concert ON concert.concert_ID=singer_in_concert.concert_ID ORDER BY singer_in_concert.concert_ID
SELECT * FROM singer ORDER BY singer.Singer_ID
SELECT stadium.Stadium_ID, stadium.Location FROM stadium ORDER BY stadium.Average
SELECT MIN(stadium.Average), COUNT(DISTINCT stadium.Location) FROM stadium ORDER BY stadium.Lowest
SELECT COUNT(*) FROM singer ORDER BY singer.Is_male
SELECT * FROM stadium ORDER BY stadium.Name
SELECT * FROM stadium ORDER BY stadium.Highest
SELECT singer.Country FROM singer ORDER BY singer.Age
SELECT COUNT(*) FROM singer ORDER BY singer.Age
SELECT * FROM singer_in_concert ORDER BY singer.Country
SELECT * FROM singer ORDER BY singer.Is_male
