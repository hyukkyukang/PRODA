SELECT Student.city_code, COUNT(DISTINCT Student.Sex), MAX(Student.StuID) FROM Student GROUP BY Student.city_code
SELECT Student.StuID, COUNT(*) FROM Student GROUP BY Student.StuID
SELECT Student.city_code, COUNT(*) FROM Student GROUP BY Student.city_code
SELECT Student.StuID, COUNT(DISTINCT Student.Advisor) FROM Student GROUP BY Student.StuID
SELECT Student.city_code, COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.city_code
SELECT Student.city_code, COUNT(*) FROM Student GROUP BY Student.city_code
SELECT Student.Sex, COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.Sex
SELECT Student.Age, AVG(Student.Major), COUNT(DISTINCT Student.city_code) FROM Student GROUP BY Student.Age
SELECT Student.Fname, COUNT(*) FROM Student GROUP BY Student.Fname
SELECT Student.LName, COUNT(DISTINCT Student.LName), MIN(Student.StuID) FROM Student GROUP BY Student.LName
SELECT Student.StuID, COUNT(*) FROM Student GROUP BY Student.StuID
SELECT Student.city_code, MAX(Student.Advisor), COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.city_code
SELECT Student.Age, COUNT(*) FROM Student GROUP BY Student.Age
SELECT Student.StuID, SUM(Student.Advisor), COUNT(DISTINCT Student.city_code) FROM Student GROUP BY Student.StuID
SELECT Student.Advisor, COUNT(DISTINCT Student.Fname) FROM Student GROUP BY Student.Advisor
SELECT Student.Fname, SUM(Student.Advisor) FROM Student GROUP BY Student.Fname
SELECT Student.city_code, COUNT(DISTINCT Student.Fname), SUM(Has_Pet.StuID) FROM Has_Pet JOIN Student ON Student.StuID=Has_Pet.StuID GROUP BY Student.city_code
SELECT Student.StuID, COUNT(DISTINCT Student.LName) FROM Student GROUP BY Student.StuID
SELECT Student.city_code, COUNT(*) FROM Student GROUP BY Student.city_code
SELECT Student.city_code, COUNT(DISTINCT Student.Sex) FROM Student GROUP BY Student.city_code
SELECT Student.Sex, COUNT(DISTINCT Student.Sex), MAX(Student.StuID) FROM Student GROUP BY Student.Sex
SELECT Student.Sex, COUNT(DISTINCT Student.Sex), MAX(Student.StuID) FROM Student GROUP BY Student.Sex
SELECT Student.Sex, COUNT(DISTINCT Student.Sex), MAX(Student.StuID) FROM Student GROUP BY Student.Sex
SELECT Student.Sex, SUM(Student.Advisor), COUNT(DISTINCT Student.city_code) FROM Student GROUP BY Student.Sex
SELECT Student.Sex, COUNT(DISTINCT Student.Sex), MAX(Student.StuID) FROM Student GROUP BY Student.Sex
SELECT Student.Sex, SUM(Student.Advisor), COUNT(DISTINCT Student.city_code) FROM Student GROUP BY Student.Sex
SELECT Student.city_code, AVG(Student.Major) FROM Student GROUP BY Student.city_code
SELECT Student.Fname, COUNT(*) FROM Student GROUP BY Student.Fname
SELECT Student.Major, SUM(Student.StuID) FROM Student GROUP BY Student.Major
SELECT Student.Major, COUNT(DISTINCT Student.LName) FROM Student GROUP BY Student.Major
SELECT Student.Age, COUNT(*) FROM Student GROUP BY Student.Age
SELECT Student.Age, COUNT(DISTINCT Student.city_code) FROM Student GROUP BY Student.Age
SELECT Student.Major, COUNT(DISTINCT Student.city_code) FROM Student GROUP BY Student.Major
SELECT Student.Advisor, COUNT(DISTINCT Student.Sex), SUM(Student.Advisor) FROM Student GROUP BY Student.Advisor
SELECT Student.LName, COUNT(DISTINCT Student.Fname), MAX(Student.Age) FROM Student GROUP BY Student.LName
SELECT Student.Advisor, SUM(Student.Age), MIN(Student.Major) FROM Student GROUP BY Student.Advisor
SELECT Student.city_code, COUNT(*) FROM Student GROUP BY Student.city_code
SELECT Student.Fname, COUNT(*) FROM Student GROUP BY Student.Fname
SELECT Student.LName, MAX(Student.Age) FROM Student GROUP BY Student.LName
SELECT Student.Age, MIN(Student.Major) FROM Student GROUP BY Student.Age
SELECT Student.Major, MAX(Student.Age), COUNT(DISTINCT Student.city_code) FROM Student GROUP BY Student.Major
SELECT Student.LName, COUNT(*) FROM Student GROUP BY Student.LName
SELECT Student.LName, COUNT(*) FROM Student GROUP BY Student.LName
SELECT Student.LName, COUNT(*) FROM Student GROUP BY Student.LName
