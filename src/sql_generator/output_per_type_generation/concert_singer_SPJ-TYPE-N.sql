SELECT O_stadium.Lowest FROM stadium O_stadium WHERE O_stadium.Location LIKE (SELECT I_stadium.Location FROM stadium I_stadium WHERE (I_stadium.Lowest < 533.0 AND I_stadium.Capacity >= 3808.0))
SELECT O_singer.Is_male, O_singer.Song_release_year FROM singer O_singer WHERE (O_singer.Name LIKE "%Joe%" OR O_singer.Age IN (SELECT I_singer.Age FROM concert I_concert JOIN singer I_singer JOIN singer_in_concert I_singer_in_concert JOIN stadium I_stadium ON I_concert.concert_ID=I_singer_in_concert.concert_ID AND I_singer.Singer_ID=I_singer_in_concert.Singer_ID AND I_stadium.Stadium_ID=I_concert.Stadium_ID WHERE (I_stadium.Highest > 1980.0 AND (I_singer.Singer_ID = 6 OR I_concert.Theme IN "('Happy Tonight','Bleeding Love','Wide Awake')"))))
SELECT O_stadium.Stadium_ID FROM stadium O_stadium WHERE (O_stadium.Location IN (SELECT I_stadium.Location FROM concert I_concert JOIN singer I_singer JOIN singer_in_concert I_singer_in_concert JOIN stadium I_stadium ON I_concert.concert_ID=I_singer_in_concert.concert_ID AND I_singer.Singer_ID=I_singer_in_concert.Singer_ID AND I_stadium.Stadium_ID=I_concert.Stadium_ID WHERE (I_singer.Country LIKE "%France" AND (I_singer.Singer_ID != 1 AND I_singer.Age > 32))) AND O_stadium.Highest > 1763.0)
SELECT COUNT(DISTINCT O_stadium.Location) FROM concert O_concert JOIN stadium O_stadium ON O_stadium.Stadium_ID=O_concert.Stadium_ID WHERE (O_concert.Theme = "Free choice" AND O_concert.concert_Name NOT IN (SELECT I_concert.concert_Name FROM concert I_concert WHERE I_concert.concert_Name IN "('Week 2','Auditions','Super bootcamp','Week 1','Home Visits')"))
SELECT COUNT(*) FROM stadium O_stadium WHERE (O_stadium.Lowest != 1057.0 OR O_stadium.Highest != (SELECT I_stadium.Highest FROM stadium I_stadium WHERE (I_stadium.Location NOT IN "('Peterhead','Arbroath','East Fife','Ayr United','Alloa Athletic')" OR I_stadium.Average >= 615.0)))
SELECT * FROM concert O_concert JOIN stadium O_stadium ON O_stadium.Stadium_ID=O_concert.Stadium_ID WHERE (O_stadium.Name NOT IN "('Glebe Park','Recreation Park','Somerset Park','Hampden Park')" OR O_concert.concert_ID IN (SELECT I_concert.concert_ID FROM concert I_concert JOIN stadium I_stadium ON I_stadium.Stadium_ID=I_concert.Stadium_ID WHERE (I_stadium.Location NOT LIKE "%Fife%" OR I_stadium.Name NOT LIKE "%Glebe")))
SELECT O_singer.Country, O_singer.Singer_ID FROM singer O_singer WHERE ((O_singer.Country NOT LIKE "%States" AND O_singer.Singer_ID >= (SELECT I_singer.Singer_ID FROM singer I_singer WHERE I_singer.Is_male != "T")) AND O_singer.Is_male != "F")
SELECT O_singer.Country FROM singer O_singer WHERE (O_singer.Age != 25 AND O_singer.Is_male != (SELECT I_singer.Is_male FROM singer I_singer WHERE (I_singer.Singer_ID != 5 OR (I_singer.Is_male != "F" AND I_singer.Name = "Justin Brown"))))
SELECT COUNT(*) FROM stadium O_stadium WHERE O_stadium.Average IN (SELECT I_stadium.Average FROM concert I_concert JOIN singer I_singer JOIN singer_in_concert I_singer_in_concert JOIN stadium I_stadium ON I_concert.concert_ID=I_singer_in_concert.concert_ID AND I_singer.Singer_ID=I_singer_in_concert.Singer_ID AND I_stadium.Stadium_ID=I_concert.Stadium_ID WHERE I_singer.Song_Name IN "('Gentleman','Sun','You','Love','Hey Oh')")
SELECT O_concert.Theme FROM concert O_concert WHERE O_concert.concert_Name NOT IN (SELECT I_concert.concert_Name FROM concert I_concert JOIN stadium I_stadium ON I_stadium.Stadium_ID=I_concert.Stadium_ID WHERE (I_stadium.Stadium_ID = 2.0 AND I_stadium.Lowest >= 1057.0))
