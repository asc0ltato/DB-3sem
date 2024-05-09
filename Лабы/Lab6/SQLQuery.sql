use Ж_MyBase
use UNIVER
---1
SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPENAME, 
	MAX(AUDITORIUM_CAPACITY)[Макси. вместимость], 
	MIN(AUDITORIUM_CAPACITY)[Мин. вместимость],
	AVG(AUDITORIUM_CAPACITY)[Средн. вместимость],
	SUM(AUDITORIUM_CAPACITY)[Сумм. вместимость],
	COUNT(AUDITORIUM_CAPACITY)[Кол-во аудиторий] 
FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
GROUP BY AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
---
SELECT Клиенты.Название_фирмы_клиента AS [Название фирмы клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       MAX(Кредиты.Сумма) AS [Максимальная сумма],
       MIN(Кредиты.Сумма) AS [Минимальная сумма],
       AVG(Кредиты.Сумма) AS [Средняя сумма],
       SUM(Кредиты.Сумма) AS [Суммарная сумма],
       COUNT(*) AS [Количество кредитов]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
GROUP BY Клиенты.Название_фирмы_клиента, Виды_кредитов.Название_вида_кредита;
---3
SELECT *
FROM (SELECT CASE WHEN NOTE between 4 and 5 then '4-5'
				  WHEN NOTE between 6 and 7 then '6-7'
				  WHEN NOTE between 8 and 9 then '8-9'
				  else '10'
				  end [Оценка], COUNT (*) [Кол-во]
FROM PROGRESS GROUP BY CASE
				  WHEN NOTE between 4 and 5 then '4-5'
				  WHEN NOTE between 6 and 7 then '6-7'
				  WHEN NOTE between 8 and 9 then '8-9'
				  else '10'
				  end) as T
ORDER BY CASE[Оценка]
	WHEN '4-5' then 3
	WHEN '6-7' then 2
	WHEN '8-9' then 1
else 0
end
---
SELECT *
FROM ( SELECT CASE WHEN Сумма BETWEEN 20000 AND 23000 THEN '20000-23000'
				   WHEN Сумма BETWEEN 24000 AND 26000 THEN '24000-26000'
                   WHEN Сумма BETWEEN 27000 AND 29000 THEN '27000-29000'
                   ELSE '30000'
                   END AS [Сумма кредита],
                   COUNT(*) AS [Кол-во кредитов]
FROM Кредиты GROUP BY CASE
                   WHEN Сумма BETWEEN 20000 AND 23000 THEN '20000-23000'
				   WHEN Сумма BETWEEN 24000 AND 26000 THEN '24000-26000'
                   WHEN Сумма BETWEEN 27000 AND 29000 THEN '27000-29000'
                   ELSE '30000'
                   END) AS T
ORDER BY CASE [Сумма кредита]
         WHEN '20000-23000' THEN 3
		 WHEN '24000-26000' THEN 2
         WHEN '27000-29000' THEN 1
         ELSE 0
		 END
---4
SELECT GROUPS.FACULTY,
	   GROUPS.PROFESSION,
	   GROUPS.IDGROUP,
	   (2014 - GROUPS.YEAR_FIRST)[Курс],
	   round(avg(cast(NOTE as float(4))), 2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
GROUP BY GROUPS.FACULTY, GROUPS.PROFESSION, GROUPS.IDGROUP, GROUPS.YEAR_FIRST
ORDER BY [Средняя оценка] desc
---
SELECT Клиенты.Название_фирмы_клиента AS [Название фирмы клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       round(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
GROUP BY Клиенты.Название_фирмы_клиента, Виды_кредитов.Название_вида_кредита;
---5
SELECT  GROUPS.FACULTY,
		GROUPS.PROFESSION, 
		GROUPS.IDGROUP,
		(2014 - GROUPS.YEAR_FIRST)[Курс],
		round(avg(cast(NOTE as float(4))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE PROGRESS.SUBJECT = N'БД' or PROGRESS.SUBJECT = N'ОАиП'
GROUP BY GROUPS.FACULTY, GROUPS.PROFESSION, GROUPS.IDGROUP, GROUPS.YEAR_FIRST
ORDER BY [Средняя оценка] desc
---
SELECT Клиенты.Название_фирмы_клиента AS [Название фирмы клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
INNER JOIN Кредиты AS C2 ON Клиенты.ID = C2.ID_клиента
INNER JOIN Виды_кредитов AS V2 ON C2.Код_кредита = V2.Код
WHERE (V2.Название_вида_кредита = 'Микро-Бизнес Старт' OR V2.Название_вида_кредита = 'Микро-Бизнес Инновации')
GROUP BY Клиенты.Название_фирмы_клиента, Виды_кредитов.Название_вида_кредита
ORDER BY [Средняя сумма кредита] desc
---6
SELECT  GROUPS.PROFESSION, 
		PROGRESS.[SUBJECT],
		round(avg(cast(NOTE as float(1))),2) as [Средняя оценка]
FROM FACULTY
		INNER JOIN GROUPS ON GROUPS.FACULTY = FACULTY.FACULTY
		INNER JOIN STUDENT ON STUDENT.IDGROUP = GROUPS.IDGROUP
		INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY = N'ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.[SUBJECT]
---
SELECT Клиенты.Название_фирмы_клиента AS [Название фирмы клиента],
       Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       ROUND(AVG(Кредиты.Сумма), 2) AS [Средняя сумма кредита]
FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
INNER JOIN Кредиты AS C2 ON Клиенты.ID = C2.ID_клиента
INNER JOIN Виды_кредитов AS V2 ON C2.Код_кредита = V2.Код
WHERE (V2.Название_вида_кредита = 'Микро-Бизнес')
GROUP BY Клиенты.Название_фирмы_клиента, Виды_кредитов.Название_вида_кредита;
---7
SELECT PROGRESS.[SUBJECT], 
	   COUNT(PROGRESS.NOTE)[Кол-во 8, 9]
FROM PROGRESS
GROUP BY PROGRESS.[SUBJECT], PROGRESS.NOTE 
HAVING PROGRESS.NOTE >= 8
ORDER BY NOTE desc
---
SELECT Виды_кредитов.Название_вида_кредита AS [Название вида кредита],
       COUNT(CASE WHEN Кредиты.Сумма >= 25000 THEN 1 ELSE NULL END) AS [Кол-во кредитов с суммой >= 25000]
FROM Кредиты
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Кредиты.Сумма >= 25000
GROUP BY Виды_кредитов.Название_вида_кредита
ORDER BY [Кол-во кредитов с суммой >= 25000] DESC;
