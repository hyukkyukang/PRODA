SELECT Student.city_code, COUNT(DISTINCT Student.Sex), MAX(Student.StuID) FROM Student GROUP BY Student.city_code HAVING (Student.city_code LIKE "PHL%" AND SUM(Student.Advisor) = 8722)
SELECT Student.StuID, COUNT(*) FROM Student GROUP BY Student.StuID HAVING COUNT(Student.Fname) > 3
SELECT Student.city_code, COUNT(*) FROM Student GROUP BY Student.city_code HAVING COUNT(Student.Fname) > 4
SELECT Student.StuID, COUNT(DISTINCT Student.Advisor) FROM Student GROUP BY Student.StuID HAVING COUNT(Student.LName) <= 2
SELECT Student.city_code, COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.city_code HAVING COUNT(Student.Age) <= 3
SELECT Student.city_code, COUNT(*) FROM Student GROUP BY Student.city_code HAVING (Student.city_code NOT LIKE "%DET" OR (MAX(Student.Major) <= 600 AND COUNT(Student.Sex) <= 2))
SELECT Student.Sex, COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.Sex HAVING MIN(Student.StuID) < 1029
SELECT Student.Age, AVG(Student.Major), COUNT(DISTINCT Student.city_code) FROM Student GROUP BY Student.Age HAVING COUNT(Student.Fname) > 2
SELECT Student.Fname, COUNT(*) FROM Student GROUP BY Student.Fname HAVING AVG(Student.StuID) < 1031
SELECT Student.LName, COUNT(DISTINCT Student.LName), MIN(Student.StuID) FROM Student GROUP BY Student.LName HAVING (COUNT(Student.Sex) >= 4 AND COUNT(Student.Fname) = 4)
SELECT Student.StuID, COUNT(*) FROM Student GROUP BY Student.StuID HAVING COUNT(Student.Sex) >= 3
SELECT Student.city_code, MAX(Student.Advisor), COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.city_code HAVING (MAX(Student.Advisor) >= 7271 AND SUM(Student.Advisor) < 7271)
SELECT Student.Age, COUNT(*) FROM Student GROUP BY Student.Age HAVING (COUNT(Student.LName) = 1 AND (SUM(Student.Advisor) >= 7134 OR COUNT(Student.Major) != 2))
SELECT Student.StuID, SUM(Student.Advisor), COUNT(DISTINCT Student.city_code) FROM Student GROUP BY Student.StuID HAVING (Student.StuID <= 1012 OR AVG(Student.Major) > 600)
SELECT Student.Advisor, COUNT(DISTINCT Student.Fname) FROM Student GROUP BY Student.Advisor HAVING COUNT(Student.LName) < 4
SELECT Student.Fname, SUM(Student.Advisor) FROM Student GROUP BY Student.Fname HAVING (COUNT(Student.city_code) = 4 AND COUNT(Student.city_code) <= 4)
SELECT Pets.pet_age, COUNT(*) FROM Has_Pet JOIN Pets ON Pets.PetID=Has_Pet.PetID GROUP BY Pets.pet_age HAVING SUM(Has_Pet.PetID) != 2001.0
SELECT Student.StuID, MIN(Student.Advisor) FROM Student GROUP BY Student.StuID HAVING AVG(Student.Advisor) > 2311
SELECT Student.Sex, MIN(Student.Major) FROM Student GROUP BY Student.Sex HAVING (Student.Sex NOT IN "("('M')", 1)" OR (COUNT(Student.Fname) != 3 AND MIN(Student.Major) > 550))
SELECT Student.city_code, COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.city_code HAVING COUNT(Student.Sex) <= 2
