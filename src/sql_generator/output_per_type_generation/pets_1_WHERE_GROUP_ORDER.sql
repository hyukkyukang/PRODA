SELECT Student.city_code, COUNT(DISTINCT Student.Sex), MAX(Student.StuID) FROM Student WHERE (Student.Advisor > 2311 OR Student.Sex IN "('M','F')") GROUP BY Student.city_code ORDER BY Student.Advisor
SELECT Student.StuID, COUNT(*) FROM Student WHERE Student.Fname NOT LIKE "%Linda" GROUP BY Student.StuID ORDER BY COUNT(Student.Sex)
SELECT Student.city_code, COUNT(*) FROM Student WHERE (Student.Major < 600 OR Student.Sex != "'M'") GROUP BY Student.city_code ORDER BY Student.LName
SELECT Student.StuID, COUNT(DISTINCT Student.Advisor) FROM Student WHERE (Student.Sex IN "('M','F')" OR Student.Advisor >= 7792) GROUP BY Student.StuID ORDER BY COUNT(Student.Fname)
SELECT Student.city_code, COUNT(DISTINCT Student.Sex) FROM Student WHERE (Student.Fname != "Arthur" AND Student.Major = 520) GROUP BY Student.city_code ORDER BY Student.StuID
SELECT Student.city_code, COUNT(*) FROM Student WHERE Student.Fname LIKE "%George%" GROUP BY Student.city_code ORDER BY Student.StuID
SELECT Student.Sex, COUNT(DISTINCT Student.Sex) FROM Student WHERE Student.Sex != "F" GROUP BY Student.Sex ORDER BY SUM(Student.Major)
SELECT Student.Age, AVG(Student.Major), COUNT(DISTINCT Student.city_code) FROM Student WHERE (Student.Fname != "Jun" OR (Student.Age >= 19 AND Student.Age > 19)) GROUP BY Student.Age ORDER BY COUNT(Student.city_code)
SELECT Student.Fname, COUNT(*) FROM Student WHERE ((Student.StuID != 1030 OR Student.Fname NOT LIKE "%Sarah%") OR Student.LName IN "('Apap','Goldman','Adams','Norris')") GROUP BY Student.Fname ORDER BY Student.city_code
SELECT Student.LName, COUNT(DISTINCT Student.LName), MIN(Student.StuID) FROM Student WHERE ((Student.Advisor < 2311 OR Student.city_code LIKE "YYZ%") AND Student.Advisor > 1148) GROUP BY Student.LName ORDER BY Student.StuID
SELECT Student.StuID, COUNT(*) FROM Student WHERE (Student.LName NOT IN "('Tai','Gompers','Han')" OR Student.LName != "Rugh") GROUP BY Student.StuID ORDER BY Student.StuID
SELECT Student.city_code, MAX(Student.Advisor), COUNT(DISTINCT Student.Sex) FROM Student WHERE ((Student.LName LIKE "%Goldman%" AND Student.Fname LIKE "%Mark") OR Student.LName LIKE "%Goldman%") GROUP BY Student.city_code ORDER BY Student.Advisor
SELECT Student.Age, COUNT(*) FROM Student WHERE (Student.Advisor = 9172 AND Student.Advisor > 2192) GROUP BY Student.Age ORDER BY COUNT(Student.city_code)
SELECT Student.StuID, SUM(Student.Advisor), COUNT(DISTINCT Student.city_code) FROM Student WHERE Student.Major < 600 GROUP BY Student.StuID ORDER BY SUM(Student.Major)
SELECT Student.Advisor, COUNT(DISTINCT Student.Fname) FROM Student WHERE Student.LName NOT LIKE "%Kumar" GROUP BY Student.Advisor ORDER BY Student.StuID
SELECT Student.Fname, SUM(Student.Advisor) FROM Student WHERE Student.Advisor >= 8423 GROUP BY Student.Fname ORDER BY COUNT(Student.LName)
SELECT Pets.pet_age, COUNT(*) FROM Has_Pet JOIN Pets ON Pets.PetID=Has_Pet.PetID WHERE (Has_Pet.PetID != 2002.0 OR Pets.PetType IN "('dog','cat')") GROUP BY Pets.pet_age ORDER BY MAX(Has_Pet.PetID)
SELECT Student.StuID, MIN(Student.Advisor) FROM Student WHERE (Student.Advisor >= 2192 AND Student.Sex != "F") GROUP BY Student.StuID ORDER BY Student.LName
SELECT Student.Sex, MIN(Student.Major) FROM Student WHERE Student.Age <= 18 GROUP BY Student.Sex ORDER BY Student.Advisor
SELECT Student.city_code, COUNT(DISTINCT Student.Sex) FROM Student WHERE Student.Fname = "Susan" GROUP BY Student.city_code ORDER BY MAX(Student.Major)
