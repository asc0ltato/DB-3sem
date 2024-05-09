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

--SELECT AUDITORIUM as 'Свободные аудитории во вт 4 парой'
--FROM TIMETABLE
--WHERE DAY_NAME = 'пн' and AUDITORIUM not in (
--SELECT AUDITORIUM FROM TIMETABLE WHERE DAY_NAME = 'вт' and LESSON = 4);
--
--SELECT AUDITORIUM as 'Свободные аудитории во вт'
--FROM TIMETABLE
--WHERE DAY_NAME = 'пн' and AUDITORIUM not in (
--SELECT AUDITORIUM FROM TIMETABLE WHERE DAY_NAME = 'вт');



-- Выбираем идентификатор группы (IDGROUP), день недели (DAY_NAME)
-- и вычисляем количество "окон" для каждой группы по дням недели.
select T.IDGROUP, TT.DAY_NAME,
    SUM(case
		-- Если номер текущей пары (LESSON) больше, чем минимальный номер пары для этой группы и дня недели,
        -- то считаем это "окном" (ставим 1), в противном случае, это не "окно" (ставим 0).
        when TT.LESSON > MIN_LESSON then 1
        else 0
    end) as [Количество окон]
from GROUPS T
-- Объединяем таблицу GROUPS с таблицей TIMETABLE по идентификатору группы (IDGROUP).
inner join TIMETABLE TT ON T.IDGROUP = TT.IDGROUP
-- Создаем подзапрос, который вычисляет минимальный номер пары (MIN_LESSON) для каждой группы и дня недели.
inner join (
    select IDGROUP, DAY_NAME, MIN(LESSON) as MIN_LESSON
    from TIMETABLE
	 -- Группируем данные по идентификатору группы (IDGROUP) и дню недели (DAY_NAME).
    group by IDGROUP, DAY_NAME
) as MinLessons on T.IDGROUP = MinLessons.IDGROUP AND TT.DAY_NAME = MinLessons.DAY_NAME
-- Группируем результаты по идентификатору группы и дню недели.
group by T.IDGROUP, TT.DAY_NAME
-- Сортируем результаты по идентификатору группы и дню недели.
order by T.IDGROUP, TT.DAY_NAME;


-- Выбираем имя преподавателя (TEACHER), день недели (DAY_NAME) и вычисляем количество "окон".
select T.TEACHER, TT.DAY_NAME,
    SUM(case
		-- Если предыдущая пара (PREVIOUS_LESSON) существует (не NULL) и разница между текущей парой и предыдущей больше 1,
        -- то считаем это "окном" (ставим 1), в противном случае, это не "окно" (ставим 0).
        when TT.PREVIOUS_LESSON IS NOT NULL AND TT.LESSON - TT.PREVIOUS_LESSON > 1 then 1
        else 0
    end) as [Количество окон]
from TEACHER T
-- Объединяем таблицу TEACHER с подзапросом TT, который включает информацию о текущей паре и предыдущей паре (если она есть).
inner join (
    select
        TEACHER,
        DAY_NAME,
        LESSON,
		-- Используем функцию LAG для вычисления номера предыдущей пары (LESSON) 
        -- с разбивкой по преподавателю (TEACHER) и дню недели (DAY_NAME), упорядоченной по номеру пары.
        LAG(LESSON) over (partition by TEACHER, DAY_NAME order by LESSON) as PREVIOUS_LESSON
    from TIMETABLE
) TT on T.TEACHER = TT.TEACHER
-- Группируем результаты по имени преподавателя и дню недели.
group by T.TEACHER, TT.DAY_NAME
-- Сортируем результаты по имени преподавателя и дню недели.
order by T.TEACHER, TT.DAY_NAME;