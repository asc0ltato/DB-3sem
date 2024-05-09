use UNIVER
use Ж_MyBase
---1
SELECT  FACULTY.FACULTY,
		GROUPS.PROFESSION, 
		PROGRESS.[SUBJECT],
		round(avg(cast(NOTE as float(1))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY = N'ТОВ'
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.[SUBJECT]
---
SELECT Клиенты.Вид_собственности AS [Вид собственности клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Виды_кредитов.Название_вида_кредита = N'Микро-Бизнес Инновации'
GROUP BY Клиенты.Вид_собственности, Виды_кредитов.Название_вида_кредита;
---
SELECT  FACULTY.FACULTY,
		GROUPS.PROFESSION, 
		PROGRESS.[SUBJECT],
		round(avg(cast(NOTE as float(1))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY = N'ИДиП'
GROUP BY ROLLUP(FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.[SUBJECT])
---
SELECT Клиенты.Вид_собственности AS [Вид собственности клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Виды_кредитов.Название_вида_кредита = N'Микро-Бизнес Инновации'
GROUP BY ROLLUP(Клиенты.Вид_собственности, Виды_кредитов.Название_вида_кредита)
---2
SELECT  FACULTY.FACULTY,
		GROUPS.PROFESSION, 
		PROGRESS.[SUBJECT],
		round(avg(cast(NOTE as float(1))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY = N'ИДиП'
GROUP BY CUBE(FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.[SUBJECT])
---
SELECT Клиенты.Вид_собственности AS [Вид собственности клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Виды_кредитов.Название_вида_кредита = N'Микро-Бизнес Инновации'
GROUP BY CUBE(Клиенты.Вид_собственности, Виды_кредитов.Название_вида_кредита)
---3
SELECT  GROUPS.PROFESSION, 
		PROGRESS.[SUBJECT],
		round(avg(cast(NOTE as float(1))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY = N'ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.[SUBJECT]
UNION
SELECT  GROUPS.PROFESSION, 
		PROGRESS.[SUBJECT],
		round(avg(cast(NOTE as float(1))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY = N'ХТиТ'
GROUP BY GROUPS.PROFESSION, PROGRESS.[SUBJECT]
---
SELECT Клиенты.Вид_собственности AS [Вид собственности клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Виды_кредитов.Название_вида_кредита = N'Микро-Бизнес Инновации'
GROUP BY Клиенты.Вид_собственности, Виды_кредитов.Название_вида_кредита
UNION
SELECT Клиенты.Вид_собственности AS [Вид собственности клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Виды_кредитов.Название_вида_кредита = N'Микро-Бизнес Старт'
GROUP BY Клиенты.Вид_собственности, Виды_кредитов.Название_вида_кредита
---
SELECT  GROUPS.PROFESSION, 
		PROGRESS.[SUBJECT],
		round(avg(cast(NOTE as float(1))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY = N'ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.[SUBJECT]
UNION ALL
SELECT  GROUPS.PROFESSION, 
		PROGRESS.[SUBJECT],
		round(avg(cast(NOTE as float(1))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY = N'ХТиТ'
GROUP BY GROUPS.PROFESSION, PROGRESS.[SUBJECT]
---
SELECT Клиенты.Вид_собственности AS [Вид собственности клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Виды_кредитов.Название_вида_кредита = N'Микро-Бизнес Инновации'
GROUP BY Клиенты.Вид_собственности, Виды_кредитов.Название_вида_кредита
UNION ALL
SELECT Клиенты.Вид_собственности AS [Вид собственности клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Виды_кредитов.Название_вида_кредита = N'Микро-Бизнес Старт'
GROUP BY Клиенты.Вид_собственности, Виды_кредитов.Название_вида_кредита
---4
SELECT  GROUPS.PROFESSION, 
		PROGRESS.[SUBJECT],
		round(avg(cast(NOTE as float(1))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY = N'ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.[SUBJECT]
INTERSECT
SELECT  GROUPS.PROFESSION, 
		PROGRESS.[SUBJECT],
		round(avg(cast(NOTE as float(1))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY = N'ХТиТ'
GROUP BY GROUPS.PROFESSION, PROGRESS.[SUBJECT]
---
SELECT Клиенты.Вид_собственности AS [Вид собственности клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Виды_кредитов.Название_вида_кредита = N'Микро-Бизнес Инновации'
GROUP BY Клиенты.Вид_собственности, Виды_кредитов.Название_вида_кредита
INTERSECT
SELECT Клиенты.Вид_собственности AS [Вид собственности клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Виды_кредитов.Название_вида_кредита = N'Микро-Бизнес Старт'
GROUP BY Клиенты.Вид_собственности, Виды_кредитов.Название_вида_кредита
---5
SELECT  GROUPS.PROFESSION, 
		PROGRESS.[SUBJECT],
		round(avg(cast(NOTE as float(1))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY = N'ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.[SUBJECT]
EXCEPT
SELECT  GROUPS.PROFESSION, 
		PROGRESS.[SUBJECT],
		round(avg(cast(NOTE as float(1))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY = N'ХТиТ'
GROUP BY GROUPS.PROFESSION, PROGRESS.[SUBJECT]
---
SELECT Клиенты.Вид_собственности AS [Вид собственности клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Виды_кредитов.Название_вида_кредита = N'Микро-Бизнес Инновации'
GROUP BY Клиенты.Вид_собственности, Виды_кредитов.Название_вида_кредита
EXCEPT
SELECT Клиенты.Вид_собственности AS [Вид собственности клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Виды_кредитов.Название_вида_кредита = N'Микро-Бизнес Старт'
GROUP BY Клиенты.Вид_собственности, Виды_кредитов.Название_вида_кредита
---7
SELECT  FACULTY.FACULTY, 
		GROUPS.IDGROUP ,
		COUNT(IDSTUDENT)[Кол-во студентов]
FROM FACULTY 
FULL JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
FULL JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
GROUP BY ROLLUP (FACULTY.FACULTY,GROUPS.IDGROUP)
---
SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPE,
	   COUNT(AUDITORIUM)[Кол-во аудиторий],
	   SUM(AUDITORIUM_CAPACITY)[Суммарная вместимость]
FROM AUDITORIUM_TYPE
FULL JOIN AUDITORIUM ON AUDITORIUM_TYPE.AUDITORIUM_TYPE = AUDITORIUM.AUDITORIUM_TYPE
GROUP BY ROLLUP (AUDITORIUM_TYPE.AUDITORIUM_TYPE)