SELECT COUNT(DISTINCT O_Student.Sex), COUNT(DISTINCT O_Student.Fname) FROM Student O_Student WHERE ((O_Student.Major >= 50 AND O_Student.LName LIKE "Schmidt%") OR O_Student.Advisor IN (SELECT I_Student.Advisor FROM Student I_Student WHERE I_Student.Fname NOT LIKE "%Linda"))
SELECT MIN(O_Student.Major) FROM Student O_Student WHERE (O_Student.Advisor IN (SELECT I_Student.Advisor FROM Student I_Student WHERE (I_Student.Advisor >= 7723 AND I_Student.Major = 600)) AND O_Student.Advisor <= 8741)
SELECT COUNT(DISTINCT O_Student.city_code) FROM Student O_Student WHERE O_Student.Fname = (SELECT I_Student.Fname FROM Student I_Student WHERE ((I_Student.LName LIKE "%Cheng%" OR I_Student.Major = 550) AND I_Student.Fname IN "('Lisa','Bruce')"))
SELECT COUNT(*) FROM Student O_Student WHERE ((O_Student.LName != "'Kim'" AND O_Student.Advisor != (SELECT I_Student.Advisor FROM Student I_Student WHERE (I_Student.Fname = "Tracy" AND I_Student.Advisor >= 7271))) AND O_Student.StuID = 1026)
SELECT COUNT(DISTINCT O_Student.Age) FROM Student O_Student WHERE O_Student.Major >= (SELECT I_Student.Major FROM Student I_Student WHERE (I_Student.Fname = "Ian" OR I_Student.LName NOT LIKE "Prater%"))
SELECT COUNT(*) FROM Student O_Student WHERE (O_Student.Fname NOT IN (SELECT I_Student.Fname FROM Student I_Student WHERE (I_Student.Advisor = 1121 OR I_Student.Advisor > 2311)) AND (O_Student.city_code NOT IN "('NYC','NAR')" AND O_Student.LName NOT LIKE "%Lee"))
SELECT * FROM Student O_Student WHERE O_Student.StuID < (SELECT I_Student.StuID FROM Student I_Student WHERE (I_Student.Fname = "David" OR I_Student.Fname IN "('Dinesh','Eric')"))
SELECT O_Student.city_code, O_Student.Major FROM Student O_Student WHERE ((O_Student.Age >= 18 OR O_Student.Major > (SELECT I_Student.Major FROM Student I_Student WHERE (I_Student.Fname NOT IN "('Steven','Susan','Jun','Lisa')" OR I_Student.city_code != "ROC"))) OR O_Student.Major > 600)
SELECT COUNT(DISTINCT O_Student.LName), COUNT(DISTINCT O_Student.Advisor) FROM Student O_Student WHERE (O_Student.Advisor >= 8741 OR O_Student.Advisor > (SELECT I_Student.Advisor FROM Student I_Student WHERE (I_Student.LName NOT LIKE "%Wilson" OR I_Student.Age < 18)))
SELECT * FROM Student O_Student WHERE O_Student.LName LIKE (SELECT I_Student.LName FROM Student I_Student WHERE ((I_Student.Advisor > 7712 OR I_Student.Age = 17) OR I_Student.city_code = "BAL"))