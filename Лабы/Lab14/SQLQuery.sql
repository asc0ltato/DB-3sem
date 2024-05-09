use UNIVER;
use Ж_MyBase
--1.Разработать скалярную функцию с именем COUNT_STUDENTS, которая вычисляет количество студентов на
--факультете, код которого задается параметром типа varchar(20) с именем @faculty. Использовать 
--внутреннее соединение таблиц FACULTY, GROUPS, STUDENT. Опробовать работу функции.
GO
CREATE FUNCTION COUNT_STUDENTS(@faculty varchar(20)) RETURNS INT
AS BEGIN DECLARE @rc int = 0;
	SET @rc = (SELECT COUNT(*) FROM STUDENT s join GROUPS g on s.IDGROUP = g.IDGROUP WHERE g.FACULTY = @faculty);
return @rc;
end;

DECLARE @f int = dbo.COUNT_STUDENTS(N'ХТиТ');
PRINT N'Количество студентов на выбранном факультете: ' + cast(@f as nvarchar(4));

select FACULTY, dbo.COUNT_STUDENTS(FACULTY) from FACULTY;

drop function COUNT_STUDENTS;
-------------------------------------------------------------------------------------------------
CREATE FUNCTION COUNT_CREDITS_BY_CODE(@creditCode nvarchar(20)) RETURNS INT
AS BEGIN DECLARE @creditCount int;
    SELECT @creditCount = COUNT(*) FROM Кредиты WHERE Код_кредита = @creditCode;
    RETURN @creditCount;
END;

DECLARE @creditCount INT = dbo.COUNT_CREDITS_BY_CODE('275843');
PRINT 'Количество кредитов заданным кодом: ' + CAST(@creditCount AS nvarchar(10));
--Внести измененияв текст функции с помощью оператора ALTER с тем, чтобы функция принимала второй
--параметр @prof типа varchar(20), обозначающий специальность студентов. Для параметров определить
--значения по умолчанию NULL. Опробовать работу функции с помощью SELECT-запросов.
GO
ALTER FUNCTION COUNT_STUDENTS(@faculty varchar(20), @prof varchar(20) = NULL) RETURNS INT
AS BEGIN 
	DECLARE @rc int = 0;
	SET @rc = (SELECT COUNT(*) FROM STUDENT s join GROUPS g ON s.IDGROUP = g.IDGROUP join PULPIT p ON g.FACULTY = @faculty and p.PULPIT = @prof);
return @rc;
end;

DECLARE @f int = dbo.COUNT_STUDENTS(N'ТОВ',N'ОХ');
PRINT N'Количество студентов на выбранном факультете: ' + cast(@f as nvarchar(4));

select FACULTY, dbo.COUNT_STUDENTS(FACULTY, PULPIT) from PULPIT;
drop function COUNT_STUDENTS;
-------------------------------------------------------------------------------------------------
ALTER FUNCTION COUNT_CREDITS_BY_CODE (@creditCode nvarchar(20), @clientId nvarchar(20)) RETURNS INT
AS  BEGIN DECLARE @creditCount int;
    SELECT @creditCount = COUNT(*) FROM Кредиты cr
    INNER JOIN Виды_кредитов vk ON cr.Код_кредита = vk.Код
    WHERE vk.Код = @creditCode AND cr.ID_клиента = @clientId;
	RETURN @creditCount;
END;

DECLARE @creditCount INT = dbo.COUNT_CREDITS_BY_CODE('275843', '1');
PRINT 'Количество кредитов заданным кодом и ID клиента: ' + CAST(@creditCount AS nvarchar(10));
--2.Разработать скалярную функцию с именем FSUBJECTS, принимающую параметр @p типа varchar(20), значение
--которого задает код кафедры (столбец SUBJECT.PULPIT).Функция должна возвращать строку типа varchar(300)
--с перечнем дисциплин в отчете.Создать и выполнить сценарий, который создает отчет, аналогичный 
--представленному ниже.Использовать локальный статический курсор на основе SELECT-запроса к таблице SUBJECT.
GO 
CREATE FUNCTION FSUBJECTS(@p varchar(20)) RETURNS char(300)
AS BEGIN
	DECLARE @tv char(20);
	DECLARE @t varchar(300) = 'Дисциплины:';
	DECLARE FS CURSOR LOCAL STATIC FOR SELECT s.SUBJECT FROM SUBJECT s WHERE s.PULPIT = @p;
	OPEN FS;
	FETCH FS INTO @tv;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @t = @t + ', ' + rtrim(@tv);
		FETCH FS INTO @tv;
	END;
	RETURN @t;
END;

select PULPIT, dbo.FSUBJECTS(PULPIT) from PULPIT;
drop function FSUBJECTS;
-------------------------------------------------------------------------------------------------
CREATE FUNCTION FCREDITS(@creditCode nvarchar(20)) RETURNS nvarchar(300)
AS  BEGIN
    DECLARE @creditType nvarchar(50);
    DECLARE @creditList nvarchar(300) = 'Типы кредитов:';
    DECLARE creditCursor CURSOR LOCAL STATIC FOR 
    SELECT Название_вида_кредита FROM Виды_кредитов WHERE Код = @creditCode;
    OPEN creditCursor;
    FETCH NEXT FROM creditCursor INTO @creditType;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @creditList = @creditList + ', ' + rtrim(@creditType);
        FETCH NEXT FROM creditCursor INTO @creditType;
    END;
    RETURN @creditList;
END;

SELECT Код, dbo.FCREDITS(Код) AS Типы_кредитов FROM Виды_кредитов;
--3.Разработать табличную функцию FFACPUL, результаты работы которой продемонстрированы на рисунке ниже. Функция 
--принимает два параметра, задающих код факультета (столбец FACULTY.FACULTY) и код кафедры (столбец PULPIT.PULPIT). 
--Использует SELECT-запрос c левым внешним соединением между таблицами FACULTY и PULPIT. 
--Если оба параметра функции равны NULL, то она воз-вращает список всех кафедр на всех факультетах. 
--Если задан первый параметр (второй равен NULL), функция возвращает список всех кафедр заданного факультета. 
--Если задан второй параметр (первый равен NULL), функция возвращает результирующий набор, содержащий строку, 
--соответствующую заданной кафедре.Если заданы два параметра, функция возвращает результирующий набор, содержащий 
--строку, соответствующую заданной кафедре на заданном факультете. Если по заданным значениям параметров невозможно
--сформировать строки, функция возвращает пустой результирующий набор. 
GO
CREATE FUNCTION FFACPUL (@f varchar(10), @p varchar(20)) RETURNS TABLE
AS RETURN
SELECT f.FACULTY, p.PULPIT from FACULTY f left join PULPIT p ON f.FACULTY = p.FACULTY
WHERE f.FACULTY = isnull(@f, f.FACULTY) and p.PULPIT = isnull(@p, p.PULPIT);

select * from dbo.FFACPUL(NULL,NULL);
select * from dbo.FFACPUL('ИТ',NULL);
select * from dbo.FFACPUL(NULL,'ИСиТ');
select * from dbo.FFACPUL('ИТ','ИСиТ');

drop function FFACPUL;
-------------------------------------------------------------------------------------------------
GO
CREATE FUNCTION FFCREDITS_INFO(@creditCode nvarchar(20), @clientID nvarchar(20)) RETURNS TABLE 
AS RETURN
SELECT vk.Название_вида_кредита [Название вида кредита], vk.Ставка[Ставка],
cr.Сумма [Сумма], cr.Дата_выдачи[Дата_выдачи], cr.Дата_возврата [Дата_возврата]
FROM Кредиты cr LEFT JOIN Виды_кредитов vk ON cr.Код_кредита = vk.Код
WHERE vk.Код = ISNULL(@creditCode, vk.Код) AND cr.ID_клиента = ISNULL(@clientID, cr.ID_клиента);

SELECT * FROM dbo.FFCREDITS_INFO(NULL, NULL); 
SELECT * FROM dbo.FFCREDITS_INFO('275843', NULL); 
SELECT * FROM dbo.FFCREDITS_INFO(NULL, '1'); 
SELECT * FROM dbo.FFCREDITS_INFO('275843', '1'); 

--4. На рисунке ниже показан сценарий, демонстрирующий работу скалярной функции FCTEACHER. Функция принимает один 
--параметр, задающий код кафедры. Функция возвращает количество преподавателей на заданной параметром кафедре.
--Если параметр равен NULL, то возвращается общее количество преподавателей. Разработать функцию FCTEACHER. 
GO
CREATE FUNCTION FCTEACHER (@p varchar(50)) RETURNS INT
AS BEGIN
	DECLARE @rc int = (SELECT COUNT(*) FROM TEACHER WHERE PULPIT = ISNULL(@p, PULPIT));
	RETURN @rc;
END;

SELECT PULPIT, dbo.FCTEACHER(PULPIT)[Количество преподавателей] from PULPIT;
select dbo.FCTEACHER(NULL)[Всего преподавателей];

drop function FCTEACHER
-------------------------------------------------------------------------------------------------
GO
CREATE FUNCTION FCREDITSS(@creditCode nvarchar(20)) RETURNS INT
AS BEGIN
	DECLARE @rc int = (SELECT COUNT(*) FROM Кредиты WHERE Код_кредита = ISNULL(@creditCode, Код_кредита));
	RETURN @rc;
END;

SELECT Название_вида_кредита, dbo.FCREDITSS(Код)[Количество_кредитов] FROM Виды_кредитов;
SELECT dbo.FCREDITSS(NULL)[Всего_кредитов];
--6.Проанализировать многооператорную табличную функцию FACULTY_REPORT, представленную ниже:
--Изменить эту функцию так, чтобы количество кафедр, количество групп, количество студентов и количество специальностей 
--вычислялось отдельными скалярными функциями.
go
create function COUNT_PULPIT(@faculty nvarchar(20)) returns int 
as begin declare @count int;
	SET @count = (SELECT COUNT(pl.PULPIT) FROM PULPIT pl WHERE pl.FACULTY = isnull(@faculty, pl.FACULTY));
return @count;
end;

go
create function COUNT_GROUPS(@faculty nvarchar(20)) returns int 
as begin declare @count int;
	set @count = (SELECT COUNT(g.IDGROUP) FROM GROUPS g WHERE g.FACULTY = isnull(@faculty, g.FACULTY));
return @count;
end;

go
create function COUNT_PROFESSION(@faculty nvarchar(20)) returns int 
as begin declare @count int;
	set @count = (SELECT COUNT(p.PROFESSION) FROM PROFESSION p WHERE p.FACULTY = isnull(@faculty, p.FACULTY));
	return @count;
end;
go

GO
create function FACULTY_REPORT(@c int) returns @fr table
([Факультет] nvarchar(50), [Кол-во кафедр] int, [Кол-во групп] int, [Кол-во судентов] int, [Кол-во специальностей] int)
as begin
	declare @f nvarchar(30);
	declare cc cursor local static for
	select f.FACULTY from FACULTY f where dbo.COUNT_STUDENTS(f.FACULTY) > @c;
	open cc;
	fetch cc into @f;
	while @@FETCH_STATUS = 0
	begin
		insert @fr values (@f, dbo.COUNT_PULPIT(@f),dbo.COUNT_GROUPS(@f), dbo.COUNT_STUDENTS(@f), dbo.COUNT_PROFESSION(@f));
		fetch cc into @f;
	end;
	return;
end;
GO

SELECT * FROM dbo.FACULTY_REPORT(3);

drop function COUNT_PULPIT
drop function COUNT_GROUPS
drop function COUNT_STUDENTS
drop function COUNT_PROFESSION
drop function FACULTY_REPORT

create function FACULTY_REPORT(@c int) returns @fr table
						( [Факультет] varchar(50), [Количество кафедр] int, [Количество групп]  int, 
																	[Количество студентов] int, [Количество специальностей] int )
as begin 
		declare cc CURSOR local static for 
		select FACULTY from FACULTY where dbo.COUNT_STUDENTS(FACULTY.FACULTY, default) > @c; 
		declare @f varchar(30);
		open cc;  
				fetch cc into @f;
		while @@fetch_status = 0
		begin
			insert @fr values( @f,  (select count(PULPIT) from PULPIT where FACULTY = @f),
			(select count(IDGROUP) from GROUPS where FACULTY = @f),   dbo.COUNT_STUDENTS(@f, default),
			(select count(PROFESSION) from PROFESSION where FACULTY = @f)   ); 
			fetch cc into @f;  
		end;   
		return; 
end;
--7. Рассмотреть хранимую процедуру с именем PRINT_REPORT из пункта 8 лабораторной работы № 14. Создать новую версию этой 
--процедуры с именем PRINT_REPORTX. Процедура PRINT_REPORTX должна работать аналогично процедуре PRINT_REPORT и иметь тот же 
--набор параметров, но SELECT-запрос курсора в новой процедуре должен использовать функции FSUBJECTS, FFACPUL и FCTEACHER.
--Сравнить результаты, полученные процедурами PRINT_REPORT и PRINT_REPORTX и убедиться в работоспособности новой функции. 
-- Функция FSUBJECTS
go
create function FSUBJECTS (@PULPIT varchar(20)) returns varchar(300)
as 
begin
	declare @OUT varchar(300) = 'Дисциплины: '
	declare @SUBJ varchar(100) = ''
	declare cur cursor local static for
		(select s.SUBJECT 
		 from   SUBJECT s 
		 where  s.PULPIT = @PULPIT)
	open cur
	fetch cur into @SUBJ
	while @@FETCH_STATUS = 0
	begin
		set @OUT += rtrim(ltrim(@SUBJ)) + ', '
		fetch cur into @SUBJ
	end
	return @OUT
end;

-- Функция FFACPUL
go
create function FFACPUL (@FACULTY varchar(20), @PULPIT varchar(20)) returns table
as return
	select f.FACULTY Факультет, p.PULPIT Кафедра
	from   FACULTY f left join PULPIT p 
	on	   p.FACULTY = f.FACULTY
	where  f.FACULTY = isnull(@FACULTY, f.FACULTY)
	and	   p.PULPIT = isnull (@PULPIT, p.PULPIT)

-- Функция FCTEACHER
go
create function FCTEACHER (@PULPIT varchar(20)) returns int
as begin
	declare @COUNT int = (select count(*)
						  from   TEACHER t
						  where  t.PULPIT = isnull(@PULPIT, t.PULPIT))
	return @COUNT
end

--drop function FSUBJECTS
--drop function FFACPUL
--drop function FCTEACHER

go
CREATE PROCEDURE PRINT_REPORTX @f CHAR(10) = NULL, @p CHAR(10) = NULL
AS
BEGIN
    BEGIN TRY
        DECLARE @FacultyCode CHAR(10);
        IF @f IS NOT NULL AND @p IS NULL
        BEGIN
            SELECT 
                'Факультет: ' + F.FACULTY AS 'Факультет',
                'Кафедра: ' + P.PULPIT AS 'Кафедра',
                'Количество преподавателей: ' + CAST(dbo.FCTEACHER(P.PULPIT) AS NVARCHAR) AS 'Количество преподавателей',
                dbo.FSUBJECTS(P.PULPIT) AS 'Дисциплины'
            FROM dbo.FFACPUL(@f, NULL) FP
            JOIN FACULTY F ON FP.Факультет = F.FACULTY
            JOIN PULPIT P ON FP.Кафедра = P.PULPIT;
        END
        ELSE IF @f IS NOT NULL AND @p IS NOT NULL
        BEGIN
            SELECT 
                'Факультет: ' + F.FACULTY AS 'Факультет',
                'Кафедра: ' + P.PULPIT AS 'Кафедра',
                'Количество преподавателей: ' + CAST(dbo.FCTEACHER(P.PULPIT) AS NVARCHAR) AS 'Количество преподавателей',
                dbo.FSUBJECTS(P.PULPIT) AS 'Дисциплины'
            FROM dbo.FFACPUL(@f, @p) FP
            JOIN FACULTY F ON FP.Факультет = F.FACULTY
            JOIN PULPIT P ON FP.Кафедра = P.PULPIT;
        END
        ELSE IF @f IS NULL AND @p IS NOT NULL
        BEGIN
            SELECT @FacultyCode = FACULTY FROM PULPIT WHERE PULPIT = @p;
            IF @FacultyCode IS NULL
            BEGIN
                PRINT 'Ошибка в параметрах';
            END
            ELSE
            BEGIN
                SELECT 
                    'Факультет: ' + F.FACULTY AS 'Факультет',
                    'Кафедра: ' + P.PULPIT AS 'Кафедра',
                    'Количество преподавателей: ' + CAST(dbo.FCTEACHER(P.PULPIT) AS NVARCHAR) AS 'Количество преподавателей',
                    dbo.FSUBJECTS(P.PULPIT) AS 'Дисциплины'
                FROM dbo.FFACPUL(@FacultyCode, @p) FP
                JOIN FACULTY F ON FP.Факультет = F.FACULTY
                JOIN PULPIT P ON FP.Кафедра = P.PULPIT;
            END
        END
        DECLARE @mya INT;
        SELECT @mya = COUNT(*) FROM FACULTY;
        SELECT @mya AS [Количество кафедр];
    END TRY
    BEGIN CATCH
        PRINT 'Ошибка: ' + ERROR_MESSAGE();
    END CATCH
END;

BEGIN TRY
 DECLARE @nya int;
 EXEC @nya = PRINT_REPORTX @f = 'ИТ' , @p = null;
END TRY
BEGIN CATCH
  PRINT 'Ошибка при вызове процедуры PRINT_REPORTX: ' + ERROR_MESSAGE();
END CATCH