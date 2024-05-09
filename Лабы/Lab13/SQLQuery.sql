USE UNIVER
use Ж_MyBase

--1.Разработать хранимую процедуру без параметров с именем PSUBJECT.Процедура формирует результирующий набор
--на основе таблицы SUBJECT, аналогичный набору, представленному на рисунке.Процедура должна возвращать 
--количество строк, выведенных в результирующий набор.
GO
CREATE PROCEDURE PSUBJECT 
AS
BEGIN
	DECLARE @k INT = (SELECT COUNT(*) FROM SUBJECT);
	SELECT SUBJECT[код],SUBJECT_NAME[дисциплина], PULPIT[кафедра] FROM SUBJECT;
	RETURN @k;
END;

set nocount on
declare @res1 int = 0;
EXEC  @res1 = PSUBJECT;
print 'Количество предметов = ' + cast(@res1 as varchar(3));
-------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE PCredit1
AS
BEGIN
	DECLARE @k INT = (SELECT COUNT(*) FROM Виды_кредитов);
	SELECT Код AS [код], Название_вида_кредита AS [Название], Ставка AS [ставка] FROM Виды_кредитов;
	RETURN @k;
END;

SET NOCOUNT ON;
DECLARE @res1 INT = 0;
EXEC @res1 = PCredit1;
PRINT 'Количество видов кредитов = ' + CAST(@res1 AS VARCHAR(3));

drop procedure PCredit1
--2.Найти процедуру PSUBJECT с помощью обозревателя объектов (Object Explorer) SSMS и через контекстное
--меню создать сценарий на изменение процедуры оператором ALTER.Изменить процедуру PSUBJECT, созданную 
--в задании 1, чтобы она принимала два параметра с именами @p и @c. Параметр @p является входным, имеет
--тип VARCHAR(20) и значение по умолчанию NULL. Параметр @с является выходным, имеет тип INT.Процедура
--PSUBJECT должна формировать результирующий набор, аналогичный набору, представленному на рисунке выше,
--но при этом содержать строки, соответствующие коду кафедры, заданному параметром @p. Кроме того, 
--процедура должна формировать значение выходного параметра @с, равное количеству строк в результирующем
--наборе, а также возвращать значение к точке вызова,равное общему количеству дисциплин (количеству строк 
--в таблице SUBJECT). 

GO
ALTER PROCEDURE PSUBJECT @p varchar(20), @c int output
AS BEGIN
DECLARE @k INT = (SELECT COUNT(*) FROM SUBJECT);
PRINT 'Параметры: @p = ' + @p + ', @c = ' + cast(@c as varchar(3));
SELECT SUBJECT[код],SUBJECT_NAME[дисциплина], PULPIT[кафедра] FROM SUBJECT WHERE SUBJECT = @p;
SET @c = @@ROWCOUNT;
RETURN @k;
END;

DECLARE @res2 int = 0, @r int = 0, @p varchar(20);
EXEC @res2 = PSUBJECT @p = N'БД', @c = @r output;
PRINT 'Общее количество дисциплин = ' + cast(@res2 as varchar(3));
PRINT 'Количество дисциплин опеределенной кафедры ' + cast(@p as varchar(3)) + '=' + cast(@r as varchar(3));

drop procedure PSUBJECT
-------------------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE PCredit1 @p nvarchar(50), @c int OUTPUT
AS 
BEGIN
    DECLARE @k INT = (SELECT COUNT(*) FROM Виды_кредитов);
    PRINT 'Параметр: @p = ' + @p + ', @c = ' + CAST(@c AS VARCHAR(3));
    SELECT Код AS [Код_кредита], Название_вида_кредита AS [Название_кредита], Ставка AS [Ставка]
    FROM Виды_кредитов WHERE Название_вида_кредита = @p;
    SET @c = @@ROWCOUNT;
    RETURN @k;
END;
GO

DECLARE @res2 INT = 0, @r INT = 0, @p NVARCHAR(50);
EXEC @res2 = PCredit1 @p = N'Микро-Бизнес Старт', @c = @r OUTPUT;
PRINT 'Общее количество видов кредитов = ' + CAST(@res2 AS VARCHAR(3));
PRINT 'Количество видов кредитов с названием ' + CAST(@p AS VARCHAR(50)) + ' = ' + CAST(@r AS VARCHAR(3));

drop procedure PCredit1
--3.Создать временную локальную таблицу с именем #SUBJECT. Наименование и тип столбцов таблицы должны
--соответствовать столбцам результирующего набора процедуры PSUBJECT, разработанной в задании 2.Изменить
--процедуру PSUBJECT таким образом, чтобы она не содержала выходного параметра.Применив конструкцию
--INSERT… EXECUTE с модифицированной процедурой PSUBJECT, добавить строки в таблицу #SUBJECT. 

GO
ALTER PROCEDURE PSUBJECT @p varchar(20)
AS BEGIN
DECLARE @k int = (SELECT COUNT(*) FROM SUBJECT);
SELECT SUBJECT[код],SUBJECT_NAME[дисциплина], PULPIT[кафедра] FROM SUBJECT WHERE SUBJECT = @p;
END;

CREATE TABLE #SUBJECT
(
	код nvarchar(20) primary key,
	дисциплина nvarchar(20),
	кафедра nvarchar(20)
);

INSERT #SUBJECT EXEC PSUBJECT @p = N'БД';
INSERT #SUBJECT EXEC PSUBJECT @p = N'ЛВ';

SELECT * FROM #SUBJECT;
-------------------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE PCredit1 @p nvarchar(50)
AS 
BEGIN
    DECLARE @k int = (SELECT COUNT(*) FROM Виды_кредитов);
    SELECT Код AS [Код_кредита], Название_вида_кредита AS [Название_кредита], Ставка AS [Ставка]
    FROM Виды_кредитов WHERE Название_вида_кредита = @p;
END;
GO

CREATE TABLE #VID_KREDIT
(
    Код_кредита nvarchar(20) primary key,
    Название_кредита nvarchar(50),
    Ставка real
);

INSERT INTO #VID_KREDIT EXEC PCredit1 @p = N'Микро-Бизнес Старт';
INSERT INTO #VID_KREDIT EXEC PCredit1 @p = N'Микро-Бизнес Инновации';

SELECT * FROM #VID_KREDIT;
--4. Разработать процедуру с именем PAUDITORIUM_INSERT. Процедура принимает четыре входных параметра: 
--@a, @n, @c и @t. Параметр @a имеет тип CHAR(20), параметр @n имеет тип VARCHAR(50), параметр @c имеет
--тип INT и значение по умолчанию 0, параметр @t имеет тип CHAR(10).Процедура добавляет строку в таблицу
--AUDITORIUM. Значения столбцов AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY и AUDITORIUM_TYPE
--добавляемой строки задаются соответственно параметрами @a, @n, @c и @t. Процедура PAUDITORIUM_INSERT 
--должна применять механизм TRY/CATCH для обработки ошибок. В случае возникновения ошибки, процедура должна 
--формировать сообщение, содержащее код ошибки, уровень серьезности и текст сообщения в стандартный
--выходной поток. Процедура должна возвращать к точке вызова значение -1 в том случае, если произошла 
--ошибка и 1, если выполнение успешно. Опробовать работу процедуры с различными значениями исходных данных, 
--которые вставляются в таблицу.
GO 
CREATE PROCEDURE PAUDITORIUM_INSERT @a char(20), @n varchar(50), @c int= 0, @t char(10)
AS DECLARE @rc int = 1;
BEGIN TRY
	INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
	VALUES (@a,@n,@c,@t)
	RETURN @rc;
END TRY
BEGIN CATCH
	PRINT 'Номер ошибки: ' + cast(error_number() as varchar(6));
	PRINT 'Сообщение: ' + error_message();
	PRINT 'Уровень: ' + cast(error_severity() as varchar(6));
	PRINT 'Метка: ' + cast(error_state() as varchar(8));
	PRINT 'Номер строки: ' + cast(error_line() as varchar(8));
	IF ERROR_PROCEDURE() is not null
	PRINT 'Имя процедуры: ' + error_procedure();
	RETURN -1;
END CATCH;

DECLARE @res4 int;
EXEC @res4 = PAUDITORIUM_INSERT @a = N'302-1', @n = N'302-1', @c = 130, @t = N'ЛК-К';
PRINT 'Код ошибки: ' + cast(@res4 as varchar(3));

DELETE FROM AUDITORIUM WHERE AUDITORIUM=N'302-1';
select * from AUDITORIUM;
-------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE PINSERT @k nvarchar(20), @n nvarchar(50), @s real = 0
AS 
BEGIN
    DECLARE @rc int = 1;
    BEGIN TRY
        INSERT INTO Виды_кредитов (Код, Название_вида_кредита, Ставка)
        VALUES (@k, @n, @s);
        RETURN @rc;
    END TRY
    BEGIN CATCH
        PRINT 'Номер ошибки: ' + CAST(ERROR_NUMBER() AS VARCHAR(6));
        PRINT 'Сообщение: ' + ERROR_MESSAGE();
        PRINT 'Уровень: ' + CAST(ERROR_SEVERITY() AS VARCHAR(6));
        PRINT 'Метка: ' + CAST(ERROR_STATE() AS VARCHAR(8));
        PRINT 'Номер строки: ' + CAST(ERROR_LINE() AS VARCHAR(8));
        IF ERROR_PROCEDURE() IS NOT NULL
            PRINT 'Имя процедуры: ' + ERROR_PROCEDURE();
        RETURN -1;
    END CATCH;
END;
GO

DECLARE @res4 int;
EXEC @res4 = PINSERT @k = N'123456', @n = N'Новый тип кредита', @s = 15003;
PRINT 'Код ошибки: ' + CAST(@res4 AS VARCHAR(3));

select * from Виды_кредитов
--5.Разработать процедуру с именем SUBJECT_REPORT, формирующую в стандартный выходной поток отчет со 
--списком дисциплин на конкретной кафедре. В отчет должны быть выведены краткие названия (поле SUBJECT)
--из таблицы SUBJECT в одну строку через запятую (использовать встроенную функцию RTRIM). Процедура имеет
--входной параметр с именем @p типа CHAR(10), который предназначен для указания кода кафедры.В том 
--случае, если по заданному значению @p невозможно определить код кафедры, процедура должна генерировать
--ошибку с сообщением ошибка в параметрах. Процедура SUBJECT_REPORT должна возвращать к точке вызова
--количество дисциплин, отображенных в отчете. 
GO
CREATE PROCEDURE SUBJECT_REPORT @p char(10)
AS DECLARE @rc int = 0;
BEGIN TRY
	DECLARE @tv char(20), @t char(300) = '';
	DECLARE SUB_REP CURSOR LOCAL STATIC FOR SELECT s.SUBJECT FROM SUBJECT s WHERE s.PULPIT = @p;
	IF NOT EXISTS (SELECT s.SUBJECT FROM SUBJECT s WHERE s.PULPIT = @p)
		RAISERROR('Ошибка', 11, 1);
	ELSE 
		OPEN SUB_REP;
		FETCH SUB_REP INTO @tv;
		PRINT 'Список дисциплин на кафедре: ';
		WHILE @@FETCH_STATUS = 0
		BEGIN
		SET @t = RTRIM(@tv) + ', ' + @t;
		SET @rc = @rc + 1;
		FETCH SUB_REP INTO @tv;
	END;
	PRINT @t;
	CLOSE SUB_REP;
	RETURN @rc;
END TRY
BEGIN CATCH 
	PRINT 'Ошибка в параметрах'
	IF ERROR_PROCEDURE() is not null
		PRINT 'Имя процедуры: ' + ERROR_PROCEDURE();
	RETURN @rc;
END CATCH;
 
DECLARE @rc int;
EXEC @rc = SUBJECT_REPORT @p = N'ИСиТ';
PRINT 'Количество дисциплин на кафедре = ' + cast(@rc as varchar(3));

select * from SUBJECT;
-------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE PReport @p nvarchar(50)
AS 
BEGIN
    DECLARE @rc int = 0;
    BEGIN TRY
        DECLARE @tv nvarchar(50), @t nvarchar(300) = '';
        DECLARE CREDIT_REPORT CURSOR LOCAL STATIC FOR SELECT vk.Название_вида_кредита FROM Виды_кредитов vk WHERE vk.Ставка = @p;
        IF NOT EXISTS (SELECT vk.Название_вида_кредита FROM Виды_кредитов vk WHERE vk.Ставка = @p)
            RAISERROR('Ошибка', 11, 1);
        ELSE 
            OPEN CREDIT_REPORT;
            FETCH CREDIT_REPORT INTO @tv;
            PRINT 'Список видов кредитов с заданной ставкой: ';
            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @t = RTRIM(@tv) + ', ' + @t;
                SET @rc = @rc + 1;
                FETCH CREDIT_REPORT INTO @tv;
            END;
            PRINT @t;
            CLOSE CREDIT_REPORT;
            RETURN @rc;
    END TRY
    BEGIN CATCH 
        PRINT 'Ошибка в параметрах';
        IF ERROR_PROCEDURE() IS NOT NULL
            PRINT 'Имя процедуры: ' + ERROR_PROCEDURE();
        RETURN @rc;
    END CATCH;
END;
GO

DECLARE @rc int;
EXEC @rc = PReport @p = N'1500';
PRINT 'Количество видов кредитов с заданной ставкой = ' + CAST(@rc AS VARCHAR(3));
--6.Разработать процедуру с именем PAUDITORIUM_INSERTX. Процедура принимает пять входных параметров: @a,
--@n, @c, @t и @tn. Параметры @a, @n, @c, @t аналогичны параметрам процедуры PAUDITORIUM_INSERT. 
--Параметр @tn является входным, имеет тип VARCHAR(50), предназначен для ввода значения в столбец 
--AUDITORIUM_TYPE.AUDITORIUM_TYPENAME.Процедура добавляет две строки. Первая строка добавляется в 
--таблицу AUDITORIUM_TYPE. Значения столбцов AUDITORIUM_TYPE и AUDITORIUM_ TYPENAME задаются
--соответственно параметрами @t и @tn. Вторая строка добавляется путем вызова процедуры 
--PAUDITORIUM_INSERT.Добавление строки в таблицу AUDITORIUM_ TYPE и вызов процедуры PAUDITORIUM_INSERT 
--должны выполняться в рамках одной транзакции с уровнем изолированности SERIALIZABLE. В процедуре 
--должна быть предусмотрена обработка ошибок с помощью механизма TRY/CATCH. Все ошибки должны быть 
--обработаны с выдачей соответствующего сообщения в стандартный выходной поток. Процедура 
--PAUDITORIUM_INSERTX должна возвращать к точке вызова значение -1 в том случае, если произошла ошибка
--и 1, если выполнения процедуры завершилось успешно. 
GO
CREATE PROCEDURE PAUDITORIUM_INSERTX @a char(20), @n varchar(50), @c int= 0, @t char(10), @tn varchar(50)
AS DECLARE @rc int =1;
BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRAN
	INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) VALUES(@t, @tn)
	EXEC @rc = PAUDITORIUM_INSERT @a, @n, @c, @t;
	COMMIT TRAN;
	RETURN @rc;
END TRY
BEGIN CATCH
	PRINT 'Номер ошибки: ' + cast(error_number() as varchar(6));
	PRINT 'Сообщение: ' + error_message();
	PRINT 'Уровень: ' + cast(error_severity() as varchar(6));
	PRINT 'Метка: ' + cast(error_state() as varchar(8));
	PRINT 'Номер строки: ' + cast(error_line() as varchar(8));
	IF ERROR_PROCEDURE() is not null
		PRINT 'Имя процедуры: ' + error_procedure();
	IF @@TRANCOUNT > 0 ROLLBACK TRAN;
	RETURN -1;
END CATCH;

DECLARE @res6 int;
EXEC @res6 = PAUDITORIUM_INSERTX @a = '203-1', @n = '203-1', @c = N'20', @t = N'ЛД-К', @tn = N'Лабораторная';
PRINT 'Код ошибки: ' + cast(@res6 as varchar(3));

DELETE FROM AUDITORIUM WHERE AUDITORIUM = N'203-1'
DELETE FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPENAME= N'Лабораторная'
select * from AUDITORIUM
select * from AUDITORIUM_TYPE
-------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE PINSERTX @nk nchar(15), @kc nvarchar(20), @cid nvarchar(20),
@am real, @d1 date, @d2 date, @k nvarchar(20), @n nvarchar(50), @s real = 0
AS 
BEGIN
    DECLARE @rc int = 1;
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        BEGIN TRAN
        EXEC @rc = PINSERT @k, @n, @s;
        INSERT INTO Кредиты (Номер_кредита, Код_кредита, ID_клиента, Сумма, Дата_выдачи, Дата_возврата)
        VALUES (@nk, @kc, @cid, @am, @d1, @d2);
        COMMIT TRAN;
        RETURN @rc;
    END TRY
    BEGIN CATCH
        PRINT 'Номер ошибки: ' + CAST(ERROR_NUMBER() AS VARCHAR(6));
        PRINT 'Сообщение: ' + ERROR_MESSAGE();
        PRINT 'Уровень: ' + CAST(ERROR_SEVERITY() AS VARCHAR(6));
        PRINT 'Метка: ' + CAST(ERROR_STATE() AS VARCHAR(8));
        PRINT 'Номер строки: ' + CAST(ERROR_LINE() AS VARCHAR(8));
        IF ERROR_PROCEDURE() IS NOT NULL
            PRINT 'Имя процедуры: ' + ERROR_PROCEDURE();
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        RETURN -1;
    END CATCH;
END;
GO

DECLARE @res6 int;
EXEC @res6 = PINSERTX @k = 275893, @n = 'New Credit Type', @s = 1500.0,
@nk = 10015, @kc = 275893, @cid = 10, @am = 23000, @d1= '2021-11-25', @d2 = '2022-11-23';
PRINT 'Код ошибки: ' + CAST(@res6 AS VARCHAR(3));
--8.Разработать процедуру с именем PRINT_REPORT, формирующую в стандартный выходной поток отчет, аналогичный отчету,
--представленному на рисунке в задании 8 лабораторной работы № 12. Процедура имеет два входных параметра с именами:
--@f и @p. Параметр @f является входным, имеет тип CHAR(10) и значение по умолчанию NULL. Параметр предназначен для
--указания кода факультета (столбец FACULTY.FACULTY). Параметр @p является входным, имеет тип CHAR(10)и значение по
--умолчанию NULL. Параметр предназначен для указания кода кафедры (столбец PULPIT.PULPIT).Если значение параметра 
--@f не равно NULL, а значение @p равно NULL, то отчет формируется только для заданного параметром @f факультета. 
--Если значение параметра @f не равно NULL и значение @p тоже не равно NULL, то отчет формируется для заданной 
--кафедры (параметр @p) заданного факультета (параметр @f). Если значение параметра @f равно NULL, а значение @p
--не равно NULL, то факультет должен быть определен по значению столбца PULPIT.FACULY в строке соответствующей 
--значению @p. В том случае, если по заданному значению @p невозможно определить код факультета, процедура должна
--генерировать ошибку с сообщением ошибка в параметрах. Процедура PRINT_REPORT должна возвращать к точке вызова,
--количество кафедр отображенных в отчете. Разработать сценарий, вызывающий процедуру PRINT_REPORT и 
--предусматривающий обработку ошибок, возникших в процедуре. Примечание: при разработке процедуры использовать сценарий пункта 1 и применить механизм TRY/CATCH.

GO
CREATE PROCEDURE PRINT_REPORT  @f CHAR(10) = NULL, @p CHAR(10) = NULL
AS 
BEGIN
  BEGIN TRY
    DECLARE @FacultyCode CHAR(10);
    IF @f IS NOT NULL AND @p IS NULL
    BEGIN
      SELECT 'Факультет: ' + F.FACULTY AS 'Факультет', 
             'Кафедра: ' + P.PULPIT AS 'Кафедра',
             'Количество преподавателей: ' + CAST(COUNT(T.TEACHER_NAME) AS NVARCHAR) AS 'Количество преподавателей',
             'Дисциплины: ' + COALESCE(STUFF((SELECT ', ' + RTRIM(S.SUBJECT) 
                                               FROM SUBJECT S 
                                               WHERE S.PULPIT = P.PULPIT 
                                               FOR XML PATH('')), 1, 2, ''), N'нет') + '.' AS 'Дисциплины'
      FROM FACULTY F 
      JOIN PULPIT P ON F.FACULTY = P.FACULTY
      LEFT JOIN TEACHER T ON T.PULPIT = P.PULPIT WHERE F.FACULTY = @f
      GROUP BY F.FACULTY, P.PULPIT;
    END
    ELSE IF @f IS NOT NULL AND @p IS NOT NULL
    BEGIN
      SELECT 'Факультет: ' + F.FACULTY AS 'Факультет', 
             'Кафедра: ' + P.PULPIT AS 'Кафедра',
             'Количество преподавателей: ' + CAST(COUNT(T.TEACHER_NAME) AS NVARCHAR) AS 'Количество преподавателей',
             'Дисциплины: ' + COALESCE(STUFF((SELECT ', ' + RTRIM(S.SUBJECT) 
                                               FROM SUBJECT S 
                                               WHERE S.PULPIT = P.PULPIT 
                                               FOR XML PATH('')), 1, 2, ''), N'нет') + '.' AS 'Дисциплины'
      FROM FACULTY F 
      JOIN PULPIT P ON F.FACULTY = P.FACULTY
      LEFT JOIN TEACHER T ON T.PULPIT = P.PULPIT WHERE F.FACULTY = @f AND P.PULPIT = @p
      GROUP BY F.FACULTY, P.PULPIT;
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
        SELECT 'Факультет: ' + F.FACULTY AS 'Факультет', 
               'Кафедра: ' + P.PULPIT AS 'Кафедра',
               'Количество преподавателей: ' + CAST(COUNT(T.TEACHER_NAME) AS NVARCHAR) AS 'Количество преподавателей',
               'Дисциплины: ' + COALESCE(STUFF((SELECT ', ' + RTRIM(S.SUBJECT) 
                                                 FROM SUBJECT S 
                                                 WHERE S.PULPIT = P.PULPIT 
                                                 FOR XML PATH('')), 1, 2, ''), N'нет') + '.' AS 'Дисциплины'
        FROM FACULTY F 
        JOIN PULPIT P ON F.FACULTY = P.FACULTY
        LEFT JOIN TEACHER T ON T.PULPIT = P.PULPIT WHERE F.FACULTY = @FacultyCode AND P.PULPIT = @p
        GROUP BY F.FACULTY, P.PULPIT;
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

drop procedure PRINT_REPORT;

BEGIN TRY
	DECLARE @nya int;
	EXEC @nya = PRINT_REPORT @f = null, @p = 'ИСиТ';
END TRY
BEGIN CATCH
	 PRINT 'Ошибка при вызове процедуры PRINT_REPORT: ' + ERROR_MESSAGE();
END CATCH

select * from FACULTY