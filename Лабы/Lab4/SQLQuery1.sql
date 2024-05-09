--1
SELECT AUDITORIUM.AUDITORIUM[Код аудитории], AUDITORIUM_TYPE.AUDITORIUM_TYPENAME[Наименование типа аудитории]
	FROM AUDITORIUM Inner Join AUDITORIUM_TYPE 
		On AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

use Ж_MyBase
use UNIVER
---
SELECT Виды_кредитов.Название_вида_кредита, Кредиты.Сумма
	FROM Виды_кредитов Inner Join Кредиты
		On Код = Код_кредита
--2
SELECT AUDITORIUM.AUDITORIUM[Код аудитории], AUDITORIUM_TYPE.AUDITORIUM_TYPENAME[Наименование типа аудитории] 
	FROM AUDITORIUM Inner Join AUDITORIUM_TYPE 
		On AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE AND
														AUDITORIUM_TYPE.AUDITORIUM_TYPENAME Like '%компьютер%'
---
SELECT Виды_кредитов.Название_вида_кредита, Кредиты.Сумма
	FROM Виды_кредитов Inner Join Кредиты
		On Код = Код_кредита AND Виды_кредитов.Название_вида_кредита Like '%Микро-Бизнес Инвест%'
--3
SELECT FACULTY.FACULTY_Name[Факультет], PULPIT.PULPIT_Name[Кафедра], PROFESSION.QUALIFICATION[Специальность], SUBJECT.SUBJECT_NAME[Дисциплина], STUDENT.NAME[Имя студента],
Case
when (PROGRESS.NOTE = 6) then 'шесть'
when (PROGRESS.NOTE = 7) then 'семь'
when (PROGRESS.NOTE = 8) then 'восемь'
else 'не между 6 и 8'
end [Оценка]
FROM PROGRESS
inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join SUBJECT on PROGRESS.SUBJECT = SUBJECT.SUBJECT
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
inner join PULPIT on SUBJECT.PULPIT = PULPIT.PULPIT
inner join FACULTY on PULPIT.FACULTY = FACULTY.FACULTY
inner join PROFESSION on PROFESSION.FACULTY = FACULTY.FACULTY
where PROGRESS.NOTE between 6 and 8
order by PROGRESS.NOTE desc;
---
SELECT Клиенты.Название_фирмы_клиента, Кредиты.Сумма,
Case
when (Виды_кредитов.Ставка = 1000) then 'мало'
when (Виды_кредитов.Ставка = 1300) then 'мало'
when (Виды_кредитов.Ставка = 1400) then 'мало'
when (Виды_кредитов.Ставка = 1500) then 'мало'
when (Виды_кредитов.Ставка = 2000) then 'много'
else 'нет значений'
end [Ставочка]
FROM Виды_кредитов
inner join Кредиты on Кредиты.Код_кредита = Виды_кредитов.Код
inner join Клиенты on Клиенты.ID = Кредиты.ID_клиента
order by Виды_кредитов.Ставка desc
--4
SELECT isnull (TEACHER.TEACHER_NAME, '***') [Преподаватель],
	PULPIT.PULPIT
	FROM PULPIT left outer join TEACHER
		ON PULPIT.PULPIT = TEACHER.PULPIT
---
SELECT isnull ( Клиенты.Контактное_лицо, '***')[Лицо], Кредиты.ID_клиента
	from Кредиты left outer join Клиенты
		on Кредиты.ID_клиента = Клиенты.ID
--5
SELECT *
FROM AUDITORIUM_TYPE FULL OUTER JOIN AUDITORIUM
ON AUDITORIUM_TYPE.AUDITORIUM_TYPE = AUDITORIUM.AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_TYPE is NULL

SELECT *
FROM AUDITORIUM FULL OUTER JOIN AUDITORIUM_TYPE
ON AUDITORIUM_TYPE.AUDITORIUM_TYPE = AUDITORIUM.AUDITORIUM_TYPE
WHERE AUDITORIUM is NULL

SELECT *
FROM AUDITORIUM FULL OUTER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_TYPE is not NULL and AUDITORIUM_TYPE.AUDITORIUM_TYPE is not null
---
SELECT *
FROM Виды_кредитов FULL OUTER JOIN Кредиты
ON Виды_кредитов.Код = Кредиты.Код_кредита
WHERE Виды_кредитов.Большая_вставка is NULL

SELECT *
FROM Кредиты FULL OUTER JOIN Виды_кредитов
ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Кредиты.Код_кредита is not Null

SELECT *
FROM Виды_кредитов FULL OUTER JOIN Кредиты
ON Виды_кредитов.Код = Кредиты.Код_кредита
WHERE Виды_кредитов.Код is not NULL and Кредиты.Код_кредита is not Null

--6
SELECT AUDITORIUM.AUDITORIUM[Код аудитории], AUDITORIUM_TYPE.AUDITORIUM_TYPENAME[Наименование типа аудитории]
	FROM AUDITORIUM Cross Join AUDITORIUM_TYPE 
		Where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
---
SELECT Виды_кредитов.Название_вида_кредита, Кредиты.Сумма
	FROM Виды_кредитов Cross Join Кредиты
		Where Код = Код_кредита
--8
use UNIVER
create table TIMETABLE
(
    DAY_NAME   nvarchar(2) check (DAY_NAME in ('пн', 'вт', 'ср', 'чт', 'пт', 'сб')),
    LESSON     int check (LESSON between 1 and 4),
    TEACHER    nchar(10) foreign key references TEACHER (TEACHER),
    AUDITORIUM nchar(20) foreign key references AUDITORIUM (AUDITORIUM),
    SUBJECT    nchar(10) foreign key references SUBJECT (SUBJECT),
    IDGROUP    int foreign key references GROUPS (IDGROUP),
)
insert into TIMETABLE
values ('пн', 1, 'СМЛВ', '313-1', 'СУБД', 2),
       ('пн', 2, 'СМЛВ', '313-1', 'ОАиП', 4),
	   ('пн', 3, 'СМЛВ', '313-1', 'ОАиП', 3),
       ('пн', 1, 'МРЗ', '324-1', 'СУБД', 6),
       ('пн', 3, 'УРБ', '324-1', 'ПИС', 4),
       ('пн', 1, 'УРБ', '206-1', 'ПИС', 10),
       ('пн', 4, 'СМЛВ', '206-1', 'ОАиП', 3),
       ('пн', 1, 'БРКВЧ', '301-1', 'СУБД', 7),
       ('пн', 4, 'БРКВЧ', '301-1', 'ОАиП', 7),
       ('пн', 2, 'БРКВЧ', '413-1', 'СУБД', 8),
       ('пн', 2, 'ДТК', '423-1', 'СУБД', 7),
       ('пн', 4, 'ДТК', '423-1', 'ОАиП', 2),
       ('вт', 1, 'СМЛВ', '313-1', 'СУБД', 2),
       ('вт', 2, 'СМЛВ', '313-1', 'ОАиП', 4),
       ('вт', 3, 'УРБ', '324-1', 'ПИС', 4),
       ('вт', 4, 'СМЛВ', '206-1', 'ОАиП', 3);

SELECT AUDITORIUM as 'Свободные аудитории во вт 4 парой'
FROM TIMETABLE
WHERE DAY_NAME = 'пн' and AUDITORIUM not in (
SELECT AUDITORIUM FROM TIMETABLE WHERE DAY_NAME = 'вт' and LESSON = 4);

SELECT AUDITORIUM as 'Свободные аудитории во вт'
FROM TIMETABLE
WHERE DAY_NAME = 'пн' and AUDITORIUM not in (
SELECT AUDITORIUM FROM TIMETABLE WHERE DAY_NAME = 'вт');

select T.IDGROUP, TT.DAY_NAME,
    SUM(case
        when TT.LESSON > MIN_LESSON then 1
        else 0
    end) as [Количество окон]
from GROUPS T
inner join TIMETABLE TT ON T.IDGROUP = TT.IDGROUP
inner join (
    select IDGROUP, DAY_NAME, MIN(LESSON) as MIN_LESSON
    from TIMETABLE
    group by IDGROUP, DAY_NAME
) as MinLessons on T.IDGROUP = MinLessons.IDGROUP AND TT.DAY_NAME = MinLessons.DAY_NAME
group by T.IDGROUP, TT.DAY_NAME
order by T.IDGROUP, TT.DAY_NAME;

select T.TEACHER, TT.DAY_NAME,
    SUM(case
        when TT.PREVIOUS_LESSON IS NOT NULL AND TT.LESSON - TT.PREVIOUS_LESSON > 1 then 1
        else 0
    end) as [Количество окон]
from TEACHER T
inner join (
    select TEACHER, DAY_NAME, LESSON, LAG(LESSON) over (partition by TEACHER, DAY_NAME order by LESSON) as PREVIOUS_LESSON
    from TIMETABLE
) TT on T.TEACHER = TT.TEACHER
group by T.TEACHER, TT.DAY_NAME
order by T.TEACHER, TT.DAY_NAME;