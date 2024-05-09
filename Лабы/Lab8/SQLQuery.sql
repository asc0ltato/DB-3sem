use UNIVER
use Ж_MyBase
---1) Представление преподаватель. К Teacher и содержать столбцы...
CREATE VIEW [Преподаватель]
as select TEACHER [Код],
		  TEACHER_NAME [Имя преподавателя],
		  GENDER [Пол],
		  PULPIT [Код кафедры]
FROM TEACHER;

select * from [Преподаватель]

DROP VIEW [Преподаватель]
-----------------------------------------------------------------------------------------
CREATE VIEW [Клиентики]
AS SELECT ID [ID],
		  Название_фирмы_клиента [Фирма клиента],
		  Вид_собственности [Вид собственности],
		  Адрес [Адрес фирмы]
FROM Клиенты;

SELECT * FROM [Клиентики];

ALTER VIEW [Клиентики]
AS SELECT ID [ID],
		  Название_фирмы_клиента [Фирма клиента],
		  Вид_собственности [Вид собственности],
		  Адрес [Адрес фирмы],
		  Контактное_лицо [Лицо фирмы]
FROM Клиенты;

DROP VIEW [Клиентики];
---2)Кол-во кафедр. К FACULTY и PULPIT и содержать столбцы факул., 
---кол-во кафедр(вычисляет на основе строк таблицы PULPIT)
CREATE VIEW [Количество кафедр]
as select FACULTY.FACULTY_NAME [Факультет],
          COUNT(*) [Количество кафедр]
FROM PULPIT join FACULTY
on PULPIT.FACULTY = FACULTY.FACULTY
group by FACULTY.FACULTY_NAME

select * from [Количество кафедр]
drop view [Количество кафедр]
-----------------------------------------------------------------------------------------
CREATE VIEW [Количество кредитов]
AS SELECT ID [ID],
          COUNT(*) [Количество кредитов]
FROM Клиенты JOIN Кредиты
ON Клиенты.ID = Кредиты.ID_клиента
GROUP BY ID;

SELECT * FROM [Количество кредитов];
DROP VIEW [Количество кредитов];
---3)Аудитории. К AUDITORIUM и содержать столбцы...Представление должно отображать только лекционные аудитории 
---(в столбце AUDITORIUM_ TYPE строка, начинающаяся с симво-ла ЛК) и допускать выполнение оператора INSERT, UPDATE и DELETE.
CREATE VIEW [Аудитории]
as select AUDITORIUM [Код],
          AUDITORIUM_NAME [Наименование аудитории],
		  AUDITORIUM_TYPE [Тип аудитории]
FROM AUDITORIUM
WHERE AUDITORIUM_TYPE like 'ЛК%'

select * from [Аудитории]
-----------------------------------------------------------------------------------------
CREATE VIEW [Виды_кредита]
AS SELECT Код [Код],
          Название_вида_кредита [Название вида кредита],
		  Ставка [Ставка]
FROM Виды_кредитов
WHERE Название_вида_кредита like 'Микро-Бизнес%'

SELECT * FROM [Виды_кредита];
---4)Лекц. аудитории. К AUDITORIUM и содержать столбцы...Представление должно отображать только лекционные аудитории 
---(в столбце AUDITORIUM_ TYPE строка, начинающаяся с симво-ла ЛК)
CREATE VIEW [Лекционные аудитории]
as select AUDITORIUM [Код],
          AUDITORIUM_NAME [Наименование аудитории],
		  AUDITORIUM_TYPE [Тип аудитории]
FROM AUDITORIUM
WHERE AUDITORIUM_TYPE like 'ЛК%' WITH CHECK OPTION

select * from [Лекционные аудитории]
-----------------------------------------------------------------------------------------
CREATE VIEW [Микро-Бизнес]
AS SELECT Код [Код],
          Название_вида_кредита [Название вида кредита],
		  Ставка [Ставка]
FROM Виды_кредитов
WHERE Название_вида_кредита like 'Микро-Бизнес%' WITH CHECK OPTION

SELECT * FROM [Микро-Бизнес];
DROP VIEW [Микро-Бизнес]
---5)Дисциплины. К SUBJECT, отображать все дисциплины в алфавитном порядке и содержать столбцы... Использовать TOP и ORDER BY.
CREATE VIEW [Дисциплины] (Код, Наименование_дисциплины, Код_кафедры) 
as select top 10 SUBJECT, SUBJECT_NAME, PULPIT.PULPIT
FROM SUBJECT join PULPIT 
ON SUBJECT.PULPIT = PULPIT.PULPIT
ORDER BY SUBJECT_NAME asc

select * from [Дисциплины]
-----------------------------------------------------------------------------------------
CREATE VIEW [Название_вида_кредитов_asc] (Код, Название_вида_кредита, ID) 
AS SELECT TOP 3 Номер_кредита, Название_вида_кредита, ID_клиента
FROM Кредиты JOIN Виды_кредитов 
ON Кредиты.Код_кредита = Виды_кредитов.Код
ORDER BY Название_вида_кредита ASC

SELECT * FROM [Название_вида_кредитов_asc]
---6)Изменить Кол-во кафедр, чтобы оно было привязано к базовым таблицам.
---Продемонстрировать свойство привязанно-сти представления к базовым таблицам. Использовать опцию SCHEMABINDING.
ALTER VIEW [Количество кафедр] WITH SCHEMABINDING
as select FACULTY.FACULTY_NAME [Факультет],
          COUNT(PULPIT.PULPIT) [Количество кафедр]
FROM dbo.PULPIT join dbo.FACULTY
on PULPIT.FACULTY = FACULTY.FACULTY
group by FACULTY.FACULTY_NAME

select * from [Количество кафедр]
-----------------------------------------------------------------------------------------
ALTER VIEW [Количество кредитов] WITH SCHEMABINDING
AS SELECT ID [ID],
          COUNT(Кредиты.Код_кредита) [Количество кредитов]
FROM dbo.Клиенты JOIN dbo.Кредиты
ON Клиенты.ID = Кредиты.ID_клиента
GROUP BY Клиенты.ID;

SELECT * FROM [Количество кредитов]
---8) Разработать представление для таблицы TIMETABLE в виде расписания. 
-- изучить оператор PIVOT и использовать его.

select * from TIMETABLE;
drop view TIMETABLE_GROUP_SCHEDULE;
drop view TIMETABLE_TEACHER_SCHEDULE;

create view TIMETABLE_GROUP_SCHEDULE
as select DAY_NAME,
       IDGROUP as GroupID,
       ISNULL([1], '') as Lesson1,
       ISNULL([2], '') as Lesson2,
       ISNULL([3], '') as Lesson3,
       ISNULL([4], '') as Lesson4
from (
    select DAY_NAME, LESSON, IDGROUP, SUBJECT
    FROM TIMETABLE
) as Source
PIVOT (
    MAX(SUBJECT)
    for LESSON IN ([1], [2], [3], [4])
) as PivotTable;

create view  TIMETABLE_TEACHER_SCHEDULE
as select DAY_NAME,
       TEACHER,
       ISNULL([1], '') as Lesson1,
       ISNULL([2], '') as Lesson2,
       ISNULL([3], '') as Lesson3,
       ISNULL([4], '') as Lesson4
from (
    select DAY_NAME, LESSON, TEACHER, SUBJECT
    FROM TIMETABLE
) as Source
PIVOT (
    MAX(SUBJECT)
    for LESSON IN ([1], [2], [3], [4])
) as PivotTable;

select * from TIMETABLE_GROUP_SCHEDULE where GroupID = 2;
select * from TIMETABLE_TEACHER_SCHEDULE where TEACHER = 'СМЛВ';
