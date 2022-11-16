SELECT O_Student.city_code, O_Student.Sex FROM Student O_Student WHERE (O_Student.Major < (SELECT MAX(I_Student.Major) FROM Student I_Student) OR (O_Student.Major < 600 OR O_Student.StuID = 1012))
SELECT O_Student.Fname, O_Student.LName FROM Student O_Student WHERE O_Student.StuID < (SELECT MAX(I_Student.StuID) FROM Student I_Student WHERE (I_Student.Major > 550 AND (I_Student.LName != "Woods" OR I_Student.Sex = "M")))
SELECT * FROM Student O_Student WHERE O_Student.StuID <= (SELECT MAX(I_Student.StuID) FROM Student I_Student WHERE (I_Student.city_code != "DAL" OR I_Student.Sex LIKE "%F"))
SELECT * FROM Student O_Student WHERE ((O_Student.Major >= 520 OR O_Student.Age = (SELECT MAX(I_Student.Age) FROM Student I_Student WHERE (I_Student.Advisor > 1148 AND I_Student.city_code IN "('NAR','WAS','DET','HOU','PIT')"))) OR O_Student.city_code IN "('HKG','HOU','LON','BAL')")
SELECT O_Student.StuID, O_Student.city_code FROM Student O_Student WHERE O_Student.Age < (SELECT MAX(I_Student.Age) FROM Student I_Student)
SELECT O_Student.LName FROM Student O_Student WHERE O_Student.StuID < (SELECT AVG(I_Student.StuID) FROM Student I_Student)
SELECT O_Student.Advisor FROM Student O_Student WHERE (O_Student.LName NOT LIKE "%Smith%" AND O_Student.StuID != (SELECT SUM(I_Student.StuID) FROM Student I_Student))
SELECT O_Student.StuID, O_Student.Major FROM Student O_Student WHERE O_Student.StuID < (SELECT MAX(I_Student.StuID) FROM Student I_Student)
SELECT O_Student.Age, O_Student.StuID FROM Student O_Student WHERE O_Student.StuID != (SELECT SUM(I_Student.StuID) FROM Student I_Student WHERE I_Student.Advisor = 8918)
SELECT * FROM Student O_Student WHERE O_Student.StuID != (SELECT AVG(I_Student.StuID) FROM Student I_Student WHERE (I_Student.Age >= 22 AND I_Student.Age = 27))
