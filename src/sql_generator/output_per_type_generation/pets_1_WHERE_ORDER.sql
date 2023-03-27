SELECT Student.StuID, Student.LName FROM Student WHERE (Student.Advisor > 2311 OR Student.Sex IN "('M','F')") ORDER BY Student.Advisor
SELECT * FROM Student WHERE (Student.Advisor > 7271 OR (Student.LName NOT IN "('Schwartz','Schultz','Woods','Han','Tai')" OR Student.Sex LIKE "%F%")) ORDER BY Student.Fname
SELECT Student.city_code FROM Student WHERE (Student.Fname != "Arthur" AND Student.Major = 520) ORDER BY Student.StuID
SELECT * FROM Student WHERE ((Student.Major < 520 OR Student.LName != "Woods") AND Student.Age > 18) ORDER BY Student.Sex
SELECT Student.Major FROM Student WHERE (Student.city_code != "HOU" AND Student.Fname NOT LIKE "%Derek%") ORDER BY Student.Age
SELECT * FROM Student WHERE (Student.Fname NOT LIKE "%Sarah%" OR Student.StuID != 1030) ORDER BY Student.Advisor
SELECT * FROM Student WHERE (Student.Fname NOT IN "('David','William','Charles','Dinesh')" OR Student.Fname NOT LIKE "%Lisa") ORDER BY Student.Sex
SELECT * FROM Student WHERE ((Student.LName IN "('Schwartz','Davis','Epp')" AND Student.Age = 17) OR Student.StuID = 1029) ORDER BY Student.Advisor
SELECT Student.Advisor, Student.LName FROM Student WHERE (Student.LName IN "('Norris','Brody','Epp','Adams')" AND (Student.LName NOT IN "('Epp','Han','Schultz','Nelson')" AND Student.Fname LIKE "%Charles")) ORDER BY Student.Age
SELECT Student.LName FROM Student WHERE (Student.Age > 20 OR (Student.Sex LIKE "M%" AND Student.LName IN "('Thornton','Smith','Cheng','Davis','Tai')")) ORDER BY Student.Age
SELECT Student.StuID, Student.Major FROM Student WHERE Student.StuID != 1001 ORDER BY Student.Fname
SELECT Student.LName FROM Student WHERE Student.Advisor > 2192 ORDER BY Student.Advisor
SELECT COUNT(*) FROM Student WHERE Student.Major != 600 ORDER BY Student.Age
SELECT Student.LName, Student.city_code FROM Student WHERE (Student.Sex != "F" AND (Student.Age < 18 OR Student.Advisor > 1148)) ORDER BY Student.Major
SELECT Student.Age, Student.StuID FROM Student WHERE Student.Major != 520 ORDER BY Student.Advisor
SELECT Student.Major, Student.Fname FROM Student WHERE Student.StuID != 1019 ORDER BY Student.LName
SELECT Has_Pet.PetID, Has_Pet.StuID FROM Has_Pet WHERE Has_Pet.PetID != 2001.0 ORDER BY Has_Pet.PetID
SELECT COUNT(DISTINCT Student.Sex) FROM Student WHERE Student.StuID = 1031 ORDER BY Student.Age
SELECT Student.city_code, Student.Age FROM Student WHERE (Student.city_code != "PHL" OR Student.Fname NOT IN "('Jun','George')") ORDER BY Student.Advisor
SELECT COUNT(*) FROM Student WHERE Student.Age > 20 ORDER BY Student.LName
