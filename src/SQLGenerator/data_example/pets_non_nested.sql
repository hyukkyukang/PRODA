SELECT Student.Major, COUNT(DISTINCT Student.LName) FROM Student GROUP BY Student.Major
SELECT Student.Fname, COUNT(DISTINCT Student.LName) FROM Student WHERE Student.LName != "Goldman" GROUP BY Student.Fname HAVING (COUNT(Student.Advisor) > 2 OR AVG(Student.Age) != 17) ORDER BY Student.city_code LIMIT 3
SELECT * FROM Student WHERE ((Student.Advisor = 8722 OR Student.Advisor = 2311) OR Student.Fname LIKE "Mark%")
SELECT Student.Sex, Student.StuID FROM Student WHERE (Student.Advisor = 7712 AND Student.Age = 19) ORDER BY Student.Fname LIMIT 3
SELECT COUNT(DISTINCT Student.Major) FROM Student WHERE (Student.Fname LIKE "%Tracy" AND Student.LName IN "('Kim','Wilson','Brody','Han','Pang')") ORDER BY Student.Advisor LIMIT 1
SELECT Student.city_code, MAX(Student.Major) FROM Student GROUP BY Student.city_code HAVING (SUM(Student.Advisor) = 2192 OR (MIN(Student.Major) <= 600 AND MIN(Student.Advisor) < 2192))
SELECT Student.Major FROM Student WHERE (Student.Age <= 26 OR (Student.Fname = "'Paul'" OR Student.LName LIKE "Schultz%")) ORDER BY Student.Major
SELECT COUNT(*) FROM Student WHERE (Student.Fname != "Derek" OR Student.city_code IN "('YYZ','HKG','HOU','BAL')")
SELECT Student.Age FROM Student ORDER BY Student.Fname
SELECT COUNT(DISTINCT Student.city_code) FROM Student
SELECT Student.Sex, Student.Advisor FROM Student ORDER BY Student.city_code LIMIT 2
SELECT COUNT(DISTINCT Student.LName), COUNT(DISTINCT Student.city_code) FROM Student WHERE (Student.Fname NOT IN "('Steven','Ian')" OR Student.city_code LIKE "%PEK%") ORDER BY Student.Sex
SELECT Student.Advisor, AVG(Student.Age) FROM Student GROUP BY Student.Advisor ORDER BY COUNT(Student.LName) LIMIT 4
SELECT * FROM Student WHERE (Student.Fname IN "('Bruce','George','Lisa','Eric','Arthur')" AND Student.Advisor != 2192)
SELECT Student.Fname, COUNT(DISTINCT Student.LName) FROM Student WHERE Student.Major > 50 GROUP BY Student.Fname HAVING (COUNT(Student.Sex) > 4 OR Student.Fname NOT LIKE "Lisa%")
SELECT Student.Major, COUNT(DISTINCT Student.Major), SUM(Student.Major) FROM Student GROUP BY Student.Major HAVING COUNT(Student.LName) <= 1 ORDER BY Student.city_code LIMIT 2
SELECT Pets.pet_age, MIN(Pets.pet_age), COUNT(DISTINCT Pets.PetType) FROM Pets GROUP BY Pets.pet_age HAVING (AVG(Pets.weight) < 12.0 OR COUNT(Pets.PetType) >= 3)
SELECT Student.Major, Student.Age FROM Student ORDER BY Student.Advisor
SELECT Student.Age, COUNT(*) FROM Student GROUP BY Student.Age
SELECT * FROM Student ORDER BY Student.Sex
SELECT Student.StuID FROM Student WHERE Student.Major = 600 ORDER BY Student.Fname LIMIT 4
SELECT Pets.weight FROM Pets
SELECT COUNT(DISTINCT Student.LName) FROM Student WHERE Student.Major < 600
SELECT Student.Major, COUNT(*) FROM Student GROUP BY Student.Major HAVING ((COUNT(Student.Age) > 1 OR COUNT(Student.Sex) != 4) AND COUNT(Student.Fname) <= 2) ORDER BY Student.LName
SELECT Student.Fname, SUM(Student.Age) FROM Student WHERE Student.Age != 20 GROUP BY Student.Fname
SELECT * FROM Student ORDER BY Student.Age LIMIT 1
SELECT Student.Major, COUNT(DISTINCT Student.StuID), COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.Major HAVING (COUNT(Student.LName) <= 4 OR SUM(Student.Age) < 20) ORDER BY Student.Sex
SELECT COUNT(DISTINCT Student.LName) FROM Student WHERE Student.LName IN "('Schultz','Jones','Kim','Thornton')" ORDER BY Student.Major LIMIT 1
SELECT Student.Sex, COUNT(DISTINCT Student.city_code) FROM Student GROUP BY Student.Sex HAVING ((AVG(Student.Age) <= 22 AND COUNT(Student.city_code) > 2) AND Student.Sex LIKE "%M") ORDER BY Student.Major
SELECT Student.Sex, COUNT(DISTINCT Student.city_code), COUNT(DISTINCT Student.Fname) FROM Student GROUP BY Student.Sex ORDER BY Student.city_code
SELECT Student.city_code, MIN(Student.Advisor), COUNT(DISTINCT Student.StuID) FROM Student GROUP BY Student.city_code HAVING COUNT(Student.LName) >= 4 ORDER BY Student.city_code LIMIT 3
SELECT Student.city_code, COUNT(DISTINCT Student.LName) FROM Student WHERE ((Student.LName NOT LIKE "%Schultz" AND Student.city_code != "PHL") OR Student.Fname NOT IN "('Bruce','Linda','William','Mark','David')") GROUP BY Student.city_code
SELECT Student.StuID, Student.city_code FROM Student WHERE (Student.Sex != "'M'" AND (Student.Advisor = 5718 OR Student.city_code NOT LIKE "%PHL"))
SELECT Student.Age, COUNT(*) FROM Student WHERE (Student.LName LIKE "%Pang" AND Student.Sex != "'M'") GROUP BY Student.Age ORDER BY Student.Sex
SELECT Student.LName, COUNT(*) FROM Student GROUP BY Student.LName HAVING COUNT(Student.Fname) <= 2 ORDER BY Student.Major
SELECT Student.Age, COUNT(*) FROM Student GROUP BY Student.Age HAVING ((COUNT(Student.city_code) != 1 AND Student.Age <= 18) OR COUNT(Student.LName) > 1)
SELECT Student.Age, COUNT(DISTINCT Student.Fname), COUNT(DISTINCT Student.StuID) FROM Student GROUP BY Student.Age ORDER BY Student.Fname
SELECT Student.Fname, COUNT(DISTINCT Student.Fname), COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.Fname HAVING (COUNT(Student.Sex) < 3 OR (COUNT(Student.LName) != 1 AND MIN(Student.Advisor) > 2192))
SELECT * FROM Student WHERE Student.Fname LIKE "%Lisa"
SELECT * FROM Student WHERE Student.LName != "Schmidt" ORDER BY Student.Sex
SELECT Student.Sex, COUNT(DISTINCT Student.city_code) FROM Student GROUP BY Student.Sex HAVING (MAX(Student.Advisor) != 1148 OR Student.Sex NOT LIKE "F%") ORDER BY COUNT(Student.LName)
SELECT Student.Sex FROM Student WHERE (Student.Major > 520 AND Student.city_code != "PHL") ORDER BY Student.Age
SELECT Student.Major, COUNT(DISTINCT Student.city_code), SUM(Student.Major) FROM Student GROUP BY Student.Major HAVING (MIN(Student.Age) < 18 AND COUNT(Student.Sex) > 1)
SELECT Student.Age, SUM(Student.StuID) FROM Student GROUP BY Student.Age ORDER BY Student.Sex
SELECT Student.Age, COUNT(DISTINCT Student.Sex), SUM(Student.Advisor) FROM Student WHERE ((Student.city_code NOT LIKE "%LOS%" AND Student.LName LIKE "Prater%") AND Student.city_code != "PHL") GROUP BY Student.Age
SELECT Student.Sex, COUNT(DISTINCT Student.city_code) FROM Student GROUP BY Student.Sex
SELECT Student.Fname FROM Student WHERE (Student.city_code NOT LIKE "%YYZ%" AND Student.city_code IN "('ROC','NYC','WAS','PHL','NAR')")
SELECT * FROM Student ORDER BY Student.LName
SELECT Student.Fname, COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.Fname
SELECT Student.Sex, AVG(Student.StuID) FROM Student WHERE (Student.Advisor != 7792 AND Student.Age = 19) GROUP BY Student.Sex HAVING COUNT(Student.city_code) > 2 ORDER BY Student.Sex LIMIT 4
SELECT * FROM Student
SELECT Student.city_code FROM Student ORDER BY Student.Sex
SELECT Student.Sex FROM Student WHERE Student.Advisor != 1121 ORDER BY Student.Advisor
SELECT Student.LName, COUNT(*) FROM Student WHERE ((Student.city_code = "PHL" OR Student.Sex LIKE "%M%") AND Student.Major = 540) GROUP BY Student.LName
SELECT Student.StuID, Student.Fname FROM Student WHERE (Student.Major <= 50 AND (Student.Major < 520 OR Student.Major = 100))
SELECT Student.city_code, COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.city_code
SELECT Student.Sex, COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.Sex ORDER BY Student.Major
SELECT Student.Age, COUNT(DISTINCT Student.Advisor), MIN(Student.Age) FROM Student GROUP BY Student.Age HAVING (MIN(Student.Advisor) <= 5718 OR (COUNT(Student.Fname) >= 4 AND COUNT(Student.Sex) != 1))
SELECT Student.Advisor, COUNT(DISTINCT Student.Sex) FROM Student WHERE Student.Age != 20 GROUP BY Student.Advisor HAVING (COUNT(Student.Sex) <= 3 OR COUNT(Student.Fname) >= 4)
SELECT Student.Major, AVG(Student.Advisor) FROM Student GROUP BY Student.Major
SELECT Student.Major, COUNT(DISTINCT Student.LName) FROM Student GROUP BY Student.Major HAVING (COUNT(Student.Fname) < 1 AND Student.Major >= 540)
SELECT Student.Sex FROM Student
SELECT Student.Advisor, COUNT(*) FROM Student GROUP BY Student.Advisor
SELECT Student.Age, Student.city_code FROM Student WHERE ((Student.LName NOT IN "('Smith','Wilson','Shieber','Brody','Epp')" AND Student.Major <= 600) AND Student.Major <= 600)
SELECT Pets.weight, COUNT(*) FROM Pets WHERE ((Pets.PetType = "dog" OR Pets.PetType = "dog") OR Pets.pet_age = 2.0) GROUP BY Pets.weight HAVING COUNT(Pets.PetType) < 3
SELECT Student.Major, Student.Advisor FROM Student
SELECT Student.city_code, MIN(Student.StuID), MAX(Student.Advisor) FROM Student WHERE Student.Fname LIKE "%Mark%" GROUP BY Student.city_code HAVING COUNT(Student.Age) >= 4 ORDER BY Student.Fname LIMIT 4
SELECT Student.Age, COUNT(DISTINCT Student.Major), MAX(Student.Age) FROM Student WHERE Student.Age > 18 GROUP BY Student.Age
SELECT Student.Advisor, Student.LName FROM Student
SELECT * FROM Student ORDER BY Student.Age LIMIT 3
SELECT Student.Age, MAX(Student.Major), COUNT(DISTINCT Student.Advisor) FROM Student GROUP BY Student.Age ORDER BY Student.city_code
SELECT Student.LName, COUNT(*) FROM Student WHERE Student.Advisor >= 7712 GROUP BY Student.LName HAVING ((COUNT(Student.Sex) != 2 AND COUNT(Student.Fname) <= 2) OR AVG(Student.Advisor) <= 1148)
SELECT Student.Major, COUNT(DISTINCT Student.Fname) FROM Student WHERE (Student.Major >= 600 OR (Student.Sex NOT LIKE "%M%" OR Student.city_code != "NAR")) GROUP BY Student.Major ORDER BY Student.Advisor
SELECT Student.Fname, MIN(Student.StuID), COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.Fname HAVING (SUM(Student.Advisor) >= 9172 OR COUNT(Student.LName) >= 2)
SELECT Student.Age FROM Student
SELECT Student.Advisor, Student.StuID FROM Student
SELECT Student.Age, COUNT(DISTINCT Student.LName), COUNT(DISTINCT Student.Sex) FROM Student WHERE ((Student.Advisor = 1148 AND Student.Age != 27) AND Student.Fname != "Paul") GROUP BY Student.Age
SELECT Student.Major, COUNT(DISTINCT Student.LName), COUNT(DISTINCT Student.city_code) FROM Student WHERE ((Student.Advisor < 9172 OR Student.city_code = "PHL") OR Student.Fname != "George") GROUP BY Student.Major
SELECT Student.Major, COUNT(*) FROM Student GROUP BY Student.Major HAVING (COUNT(Student.Sex) > 4 AND (COUNT(Student.Age) != 4 AND AVG(Student.Advisor) >= 2192)) ORDER BY Student.Major LIMIT 3
SELECT Student.Advisor, COUNT(DISTINCT Student.city_code), COUNT(DISTINCT Student.Advisor) FROM Student WHERE (Student.Advisor < 1148 OR Student.LName NOT LIKE "%Rugh%") GROUP BY Student.Advisor HAVING (COUNT(Student.LName) < 2 OR Student.Advisor <= 2192)
SELECT Student.Fname, Student.Sex FROM Student ORDER BY Student.Sex
SELECT * FROM Student ORDER BY Student.Advisor
SELECT Student.Sex FROM Student WHERE (Student.Fname != "'William'" OR (Student.Sex NOT LIKE "%M" OR Student.LName NOT IN "('Epp','Simms')"))
SELECT Student.Major FROM Student
SELECT Student.Age, COUNT(*) FROM Student GROUP BY Student.Age
SELECT MIN(Student.Advisor), MAX(Student.Major) FROM Student WHERE (Student.Fname IN "('Andy','Stacy','Sarah','Shiela','Jandy')" OR (Student.Advisor < 5718 AND Student.city_code = "PHL")) ORDER BY Student.Sex
SELECT Student.LName, Student.Major FROM Student ORDER BY Student.Age
SELECT Student.Major, COUNT(DISTINCT Student.city_code), AVG(Student.Advisor) FROM Student WHERE ((Student.Fname NOT IN "('Jandy','George')" OR Student.Major <= 50) OR Student.Major <= 600) GROUP BY Student.Major HAVING Student.Major <= 520 ORDER BY SUM(Student.Age)
SELECT Student.Advisor, Student.Major FROM Student ORDER BY Student.Age
SELECT Student.Sex, MAX(Student.Advisor), MIN(Student.Age) FROM Student WHERE (Student.Fname != "Linda" AND Student.Fname != "David") GROUP BY Student.Sex ORDER BY Student.city_code LIMIT 1
SELECT * FROM Student
SELECT COUNT(DISTINCT Student.LName) FROM Student
SELECT Student.Age, COUNT(DISTINCT Student.LName) FROM Student WHERE (Student.Age = 20 AND Student.Advisor >= 8722) GROUP BY Student.Age HAVING (COUNT(Student.LName) = 3 OR COUNT(Student.LName) <= 4) ORDER BY Student.Fname LIMIT 2
SELECT Student.Sex, COUNT(*) FROM Student GROUP BY Student.Sex HAVING (MAX(Student.Advisor) != 1148 OR (AVG(Student.Age) <= 27 AND MAX(Student.Age) != 27)) ORDER BY Student.Advisor LIMIT 2
SELECT * FROM Student WHERE (Student.Sex NOT LIKE "%F" OR (Student.LName NOT LIKE "%Leighto%" AND Student.Major > 100))
SELECT COUNT(DISTINCT Student.Fname) FROM Student ORDER BY Student.city_code LIMIT 3
SELECT Student.Advisor, COUNT(*) FROM Student GROUP BY Student.Advisor ORDER BY COUNT(Student.Fname)
SELECT Has_Pet.PetID, Has_Pet.StuID FROM Has_Pet JOIN Pets ON Pets.PetID=Has_Pet.PetID WHERE ((Pets.PetType IN "('dog','cat')" AND Pets.PetType = "dog") OR Pets.weight >= 13.4) ORDER BY Pets.weight LIMIT 4
SELECT Student.city_code, Student.Sex FROM Student
SELECT COUNT(*) FROM Student WHERE Student.Sex != "M" ORDER BY Student.city_code LIMIT 3
