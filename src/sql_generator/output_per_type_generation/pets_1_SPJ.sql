SELECT Student.LName FROM Student
SELECT COUNT(DISTINCT Student.Fname) FROM Student
SELECT COUNT(*) FROM Student WHERE Student.Sex LIKE "%M"
SELECT * FROM Student WHERE (Student.StuID != 1005 OR (Student.Age = 20 OR Student.Sex != "F"))
SELECT Student.Fname, Student.city_code FROM Student
SELECT Student.city_code FROM Student WHERE (Student.Age != 19 OR Student.Fname = "Stacy")
SELECT Student.LName FROM Student
SELECT * FROM Student
SELECT Student.Fname FROM Student WHERE (Student.Major >= 520 AND Student.Age >= 16)
SELECT Student.StuID, Student.Fname FROM Student WHERE (Student.StuID != 1032 AND Student.Fname != "Steven")
SELECT * FROM Student WHERE (Student.Fname = "Ian" OR Student.LName NOT LIKE "Prater%")
SELECT Student.Fname, Student.city_code FROM Student WHERE Student.Sex IN "('M','F')"
SELECT * FROM Student WHERE (Student.Fname NOT LIKE "Arthur%" OR (Student.Advisor = 8772 AND Student.StuID != 1015))
SELECT Student.LName FROM Student WHERE ((Student.city_code = "BAL" OR Student.Fname = "Jandy") AND Student.LName NOT IN "('Davis','Apap','Prater','Schmidt')")
SELECT Student.StuID, Student.LName FROM Student WHERE (Student.Major < 600 OR (Student.Fname != "'Eric'" OR Student.Fname IN "('Jun','Andy','Michael')"))
SELECT Student.Sex FROM Student
SELECT COUNT(*) FROM Pets
SELECT Student.Age FROM Student WHERE Student.Fname = "Susan"
SELECT Student.city_code, Student.Major FROM Student
SELECT Student.Age, Student.Fname FROM Student WHERE ((Student.Fname IN "('Steven','Ian')" AND Student.Fname NOT LIKE "%Michael") AND Student.StuID = 1012)
