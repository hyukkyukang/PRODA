SELECT Student.StuID, Student.LName FROM Student ORDER BY Student.Advisor
SELECT * FROM Student ORDER BY Student.Fname
SELECT Student.city_code FROM Student ORDER BY Student.StuID
SELECT * FROM Student ORDER BY Student.Sex
SELECT Student.Major FROM Student ORDER BY Student.Age
SELECT * FROM Student ORDER BY Student.Advisor
SELECT * FROM Student ORDER BY Student.Sex
SELECT * FROM Student ORDER BY Student.Advisor
SELECT Student.Advisor, Student.LName FROM Student ORDER BY Student.Age
SELECT Student.LName FROM Student ORDER BY Student.Age
SELECT Student.StuID, Student.Major FROM Student ORDER BY Student.Fname
SELECT Student.LName FROM Student ORDER BY Student.Advisor
SELECT COUNT(*) FROM Student ORDER BY Student.Age
SELECT Student.LName, Student.city_code FROM Student ORDER BY Student.Major
SELECT Student.Age, Student.StuID FROM Student ORDER BY Student.Advisor
SELECT Student.Major, Student.Fname FROM Student ORDER BY Student.LName
SELECT Pets.PetType, Pets.weight FROM Pets ORDER BY Pets.PetType
SELECT Student.Advisor FROM Student ORDER BY Student.Age
SELECT Student.StuID, Student.Fname FROM Student ORDER BY Student.Age
SELECT COUNT(DISTINCT Student.city_code), COUNT(DISTINCT Student.Advisor) FROM Student ORDER BY Student.Advisor
