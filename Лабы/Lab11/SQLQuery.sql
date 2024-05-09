use UNIVER
use Ж_MyBase
--1)Разработать сценарий, формирующий список дисциплин на кафедре ИСиТ. В отчет должны быть выведены
--краткие названия дисциплин из таблицы SUBJECT в одну строку через запятую. 
--Использовать встроенную функцию RTRIM.
DECLARE @sb char(45), @s char(500) = '';
DECLARE discipline cursor for select SUBJECT_NAME from SUBJECT where PULPIT = N'ИСиТ'
OPEN discipline;
FETCH discipline into @sb;
print 'Названия дисциплин кафедры ИСиТ';
while @@FETCH_STATUS = 0
	begin
		set @s = rtrim(@sb) + ',' + @s;
		FETCH discipline into @sb;
	end;
	print @s;
close discipline;
deallocate discipline;
-------------------------------------------------------------------------------------------------------
DECLARE @clientName nvarchar(50), @ss char(500) = '';
DECLARE clientCursor cursor for select Название_фирмы_клиента from Клиенты;
OPEN clientCursor;
FETCH next from clientCursor into @clientName;
print 'Названия фирм клиентов:';
while @@FETCH_STATUS = 0
	begin
		set @ss = rtrim(@clientName) + ', ' + @ss;
		FETCH next from clientCursor into @clientName;
	end;
	print @ss;
close clientCursor;
deallocate clientCursor;
--2)Разработать сценарий, демонстрирующий отличие глобального курсора от локального на примере базы данных UNIVER.
--LOCAL
DECLARE @stud int, @note int;
DECLARE marks cursor local for select IDSTUDENT, NOTE from PROGRESS;
	OPEN marks;
	FETCH marks into @stud, @note;
	print '1. ' + convert(nvarchar(5), @stud) + convert(nvarchar(5), @note);
	go
DECLARE @stud int, @note int;
	FETCH marks into @stud, @note;
	print '2. ' + convert(nvarchar(5), @stud) + convert(nvarchar(5), @note);
	go
--GLOBAL
DECLARE @stud int, @note int;
DECLARE marks cursor global for select IDSTUDENT, NOTE from PROGRESS;
	OPEN marks;
	FETCH marks into @stud, @note;
	print '1. ' + convert(nvarchar(5), @stud) + convert(nvarchar(5), @note);
	go
DECLARE @stud int, @note int;
	FETCH marks into @stud, @note;
	print '2. ' + convert(nvarchar(5), @stud) + convert(nvarchar(5), @note);
	close marks;
	deallocate marks;
	go
--LOCAL
DECLARE @clientId nvarchar(20), @clientName nvarchar(50);
DECLARE clientCursor CURSOR LOCAL FOR SELECT ID, Название_фирмы_клиента FROM Клиенты;
OPEN clientCursor;
FETCH NEXT FROM clientCursor INTO @clientId, @clientName;
PRINT 'Клиенты:';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'ID: ' + @clientId + ', Название: ' + @clientName;
    FETCH NEXT FROM clientCursor INTO @clientId, @clientName;
END;
CLOSE clientCursor;
DEALLOCATE clientCursor;
--GLOBAL
DECLARE @creditNumber nchar(5), @creditAmount real;
DECLARE creditDetailsCursor CURSOR GLOBAL FOR SELECT Номер_кредита, Сумма FROM Кредиты;
OPEN creditDetailsCursor;
FETCH NEXT FROM creditDetailsCursor INTO @creditNumber, @creditAmount;
PRINT 'Детали кредитов:';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Номер: ' + @creditNumber + ', Сумма: ' + CONVERT(nvarchar(20), @creditAmount);
    FETCH NEXT FROM creditDetailsCursor INTO @creditNumber, @creditAmount;
END;
CLOSE creditDetailsCursor;
DEALLOCATE creditDetailsCursor;
--3)Разработать сценарий, демонстрирующий отличие статических курсоров от динамических на примере базы данных UNIVER.
DECLARE @facult nvarchar(50), @profession nvarchar(50), @year int;
DECLARE groups cursor local static for select FACULTY, PROFESSION, YEAR_FIRST from GROUPS where FACULTY = N'ХТиТ';
OPEN groups;
print 'Количество строк: ' + cast(@@CURSOR_ROWS as varchar(5));
UPDATE groups set  YEAR_FIRST = 2019 where PROFESSION = N'1-36 07 01';
DELETE groups where IDGROUP = 1;
FETCH groups into @facult, @profession, @year;
while @@FETCH_STATUS = 0
begin
print @facult + ''+  @profession + '' + convert(nvarchar(4),@year);
FETCH groups into @facult, @profession, @year;
end;
CLOSE groups;
-------------------------------------------------------------------------------------------------------------------
DECLARE @facult1 nvarchar(50), @profession1 nvarchar(50), @year1 int;
DECLARE groups cursor local dynamic for select FACULTY, PROFESSION, YEAR_FIRST from GROUPS where FACULTY = N'ХТиТ';
OPEN groups;
print 'Количество строк: ' + cast(@@CURSOR_ROWS as varchar(5));
UPDATE groups set  YEAR_FIRST = 2019 where PROFESSION = N'1-36 07 01';
DELETE groups where IDGROUP = 1;
FETCH groups into @facult1, @profession1, @year1;
while @@FETCH_STATUS = 0
begin
print @facult1 + ''+  @profession1 + '' + convert(nvarchar(4),@year1);
FETCH groups into @facult1, @profession1, @year1;
end;
CLOSE groups;
-------------------------------------------------------------------------------------------------------------------
go
DECLARE @clientID nvarchar(20), @clientName nvarchar(50), @ownershipType nvarchar(30), @address nvarchar(50), @phone nvarchar(20), @contactPerson nvarchar(20), @passport nvarchar(20);
DECLARE clientCursor CURSOR LOCAL STATIC FOR SELECT ID, Название_фирмы_клиента, Вид_собственности, Адрес, Телефон, Контактное_лицо, Паспорт FROM Клиенты;
OPEN clientCursor;
UPDATE Клиенты SET Название_фирмы_клиента = 'Новое название' WHERE ID = '1';
DELETE FROM Клиенты WHERE ID = '2';
FETCH NEXT FROM clientCursor INTO @clientID, @clientName, @ownershipType, @address, @phone, @contactPerson, @passport;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'ID: ' + @clientID + ', Название фирмы клиента: ' + @clientName + ', Вид собственности: ' + @ownershipType + ', Адрес: ' + @address + ', Телефон: ' + @phone + ', Контактное лицо: ' + @contactPerson + ', Паспорт: ' + @passport;
    FETCH NEXT FROM clientCursor INTO @clientID, @clientName, @ownershipType, @address, @phone, @contactPerson, @passport;
END;
CLOSE clientCursor;
DEALLOCATE clientCursor;
go
-------------------------------------------------------------------------------------------------------------------
go
DECLARE @clientID1 nvarchar(20), @clientName1 nvarchar(50), @ownershipType1 nvarchar(30), @address1 nvarchar(50), @phone1 nvarchar(20), @contactPerson1 nvarchar(20), @passport1 nvarchar(20);
DECLARE clientCursor CURSOR LOCAL DYNAMIC FOR SELECT ID, Название_фирмы_клиента, Вид_собственности, Адрес, Телефон, Контактное_лицо, Паспорт FROM Клиенты;
OPEN clientCursor;
UPDATE Клиенты SET Название_фирмы_клиента = 'Новое имя' WHERE ID = '1';
DELETE FROM Клиенты WHERE ID = '2';
FETCH NEXT FROM clientCursor INTO @clientID1, @clientName1, @ownershipType1, @address1, @phone1, @contactPerson1, @passport1;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'ID: ' + @clientID1 + ', Название фирмы клиента: ' + @clientName1 + ', Вид собственности: ' + @ownershipType1 + ', Адрес: ' + @address1 + ', Телефон: ' + @phone1 + ', Контактное лицо: ' + @contactPerson1 + ', Паспорт: ' + @passport1;
    FETCH NEXT FROM clientCursor INTO @clientID1, @clientName1, @ownershipType1, @address1, @phone1, @contactPerson1, @passport1;
END;
CLOSE clientCursor;
DEALLOCATE clientCursor;
go
-- 4. Разработать сценарий, демонстрирующий свойства навигации в результирующем наборе 
-- курсора с атрибутом SCROLL на примере базы данных UNIVER.
-- Использовать все известные ключевые слова в операторе FETCH.
DECLARE @tc nvarchar(50), @gender nvarchar(3), @pulp nvarchar(10);
DECLARE teacher cursor local static SCROLL for select TEACHER_NAME, GENDER, PULPIT from dbo.TEACHER where PULPIT = N'ИСиТ';
OPEN teacher;
FETCH FIRST from teacher into @tc, @gender, @pulp;
print 'Первая строка: ' + rtrim(@tc) + '; ' + rtrim(@gender) + '; ' + rtrim(@pulp);
FETCH teacher into @tc, @gender, @pulp;
print 'Следующая строка: ' + rtrim(@tc) + '; ' + rtrim(@gender) + '; ' + rtrim(@pulp);
FETCH NEXT from teacher into @tc, @gender, @pulp;
print 'Следующая строка за текущей: ' + rtrim(@tc) + '; ' + rtrim(@gender) + '; ' + rtrim(@pulp);
FETCH PRIOR from teacher into @tc, @gender, @pulp;
print 'Предыдущая строка от текущей: ' + rtrim(@tc) + '; ' + rtrim(@gender) + '; ' + rtrim(@pulp);
FETCH ABSOLUTE 3 from teacher into @tc, @gender, @pulp;
print 'Третья строка с начала: ' + rtrim(@tc) + '; ' + rtrim(@gender) + '; ' + rtrim(@pulp);
FETCH ABSOLUTE -3 from teacher into @tc, @gender, @pulp;
print 'Третья строка с конца: ' + rtrim(@tc) + '; ' + rtrim(@gender) + '; ' + rtrim(@pulp);
FETCH RELATIVE 5 from teacher into @tc, @gender, @pulp;
print 'Пятая строка вперёд от текущей: ' + rtrim(@tc) + '; ' + rtrim(@gender) + '; ' + rtrim(@pulp);
FETCH RELATIVE -5 from teacher into @tc, @gender, @pulp;
print 'Пятая строка назад от текущей: ' + rtrim(@tc) + '; ' + rtrim(@gender) + '; ' + rtrim(@pulp);
FETCH LAST from teacher into @tc, @gender, @pulp;
print 'Последняя строка: ' + rtrim(@tc) + '; ' + rtrim(@gender) + '; ' + rtrim(@pulp);
close teacher;
deallocate teacher;
-------------------------------------------------------------------------------------------------------------------
DECLARE @creditNumber nchar(15), @creditCode nvarchar(20), @clientID nvarchar(20);
DECLARE creditCursor CURSOR LOCAL STATIC SCROLL FOR SELECT Номер_кредита, Код_кредита, ID_клиента FROM Кредиты WHERE Сумма > 25000;
OPEN creditCursor;
FETCH FIRST FROM creditCursor INTO @creditNumber, @creditCode, @clientID;
PRINT 'Первая строка: ' + rtrim(ISNULL(@creditNumber, '')) + '; ' + rtrim(ISNULL(@creditCode, '')) + '; ' + rtrim(ISNULL(@clientID, ''));
FETCH NEXT FROM creditCursor INTO @creditNumber, @creditCode, @clientID;
PRINT 'Следующая строка: ' + rtrim(ISNULL(@creditNumber, '')) + '; ' + rtrim(ISNULL(@creditCode, '')) + '; ' + rtrim(ISNULL(@clientID, ''));
FETCH PRIOR FROM creditCursor INTO @creditNumber, @creditCode, @clientID;
PRINT 'Предыдущая строка от текущей: ' + rtrim(ISNULL(@creditNumber, '')) + '; ' + rtrim(ISNULL(@creditCode, '')) + '; ' + rtrim(ISNULL(@clientID, ''));
FETCH ABSOLUTE 3 FROM creditCursor INTO @creditNumber, @creditCode, @clientID;
PRINT 'Третья строка с начала: ' + rtrim(ISNULL(@creditNumber, '')) + '; ' + rtrim(ISNULL(@creditCode, '')) + '; ' + rtrim(ISNULL(@clientID, ''));
FETCH ABSOLUTE -3 FROM creditCursor INTO @creditNumber, @creditCode, @clientID;
PRINT 'Третья строка с конца: ' + rtrim(ISNULL(@creditNumber, '')) + '; ' + rtrim(ISNULL(@creditCode, '')) + '; ' + rtrim(ISNULL(@clientID, ''));
FETCH RELATIVE 5 FROM creditCursor INTO @creditNumber, @creditCode, @clientID;
PRINT 'Пятая строка вперёд от текущей: ' + rtrim(ISNULL(@creditNumber, '')) + '; ' + rtrim(ISNULL(@creditCode, '')) + '; ' + rtrim(ISNULL(@clientID, ''));
FETCH RELATIVE -5 FROM creditCursor INTO @creditNumber, @creditCode, @clientID;
PRINT 'Пятая строка назад от текущей: ' + rtrim(ISNULL(@creditNumber, '')) + '; ' + rtrim(ISNULL(@creditCode, '')) + '; ' + rtrim(ISNULL(@clientID, ''));
FETCH LAST FROM creditCursor INTO @creditNumber, @creditCode, @clientID;
PRINT 'Последняя строка: ' + rtrim(ISNULL(@creditNumber, '')) + '; ' + rtrim(ISNULL(@creditCode, '')) + '; ' + rtrim(ISNULL(@clientID, ''));
CLOSE creditCursor;
DEALLOCATE creditCursor;
--5. Создать курсор, демонстрирующий применение конструкции CURRENT OF в 
--секции WHERE с использованием операторов UPDATE и DELETE.
DECLARE @aud nvarchar(5), @aud_type nvarchar(5), @aud_cap int;
DECLARE auditorium cursor local dynamic for select AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY from AUDITORIUM for update;
open auditorium;
fetch auditorium into @aud, @aud_type, @aud_cap;
print 'Выбранная строка для обновления: ' + rtrim(@aud) + '; ' + rtrim(@aud_type) + '; ' + convert(nvarchar(5), @aud_cap) + '.';
UPDATE AUDITORIUM set AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY + 1 where CURRENT OF auditorium;
select AUDITORIUM_CAPACITY from AUDITORIUM;
fetch auditorium into @aud, @aud_type, @aud_cap;
print 'Выбранная строка для удаления: ' + rtrim(@aud) + '; ' + rtrim(@aud_type) + '; ' + convert(nvarchar(5), @aud_cap) + '.';
DELETE AUDITORIUM where CURRENT OF auditorium;
close auditorium;
deallocate auditorium;
-------------------------------------------------------------------------------------------------------------------
go
DECLARE @creditCode nvarchar(20), @creditName nvarchar(50), @creditRate real;
DECLARE creditCursor CURSOR LOCAL DYNAMIC FOR SELECT Код, Название_вида_кредита, Ставка FROM Виды_кредитов FOR UPDATE;
OPEN creditCursor;
FETCH NEXT FROM creditCursor INTO @creditCode, @creditName, @creditRate;
PRINT 'Выбранная строка для обновления: ' + rtrim(ISNULL(@creditCode, '')) + '; ' + rtrim(ISNULL(@creditName, '')) + '; ' + convert(nvarchar(5), @creditRate) + '.';
UPDATE Виды_кредитов SET Ставка = Ставка + 0.5 WHERE CURRENT OF creditCursor;
SELECT Название_вида_кредита, Ставка FROM Виды_кредитов;
FETCH NEXT FROM creditCursor INTO @creditCode, @creditName, @creditRate;
PRINT 'Выбранная строка для удаления: ' + rtrim(ISNULL(@creditCode, '')) + '; ' + rtrim(ISNULL(@creditName, '')) + '; ' + convert(nvarchar(5), @creditRate) + '.';
DELETE FROM Виды_кредитов WHERE CURRENT OF creditCursor;
CLOSE creditCursor;
DEALLOCATE creditCursor;
go
--6.1. Разработать SELECT-запрос, с помощью которого из таблицы PROGRESS удаляются строки, содержащие
--информацию о студентах, получивших оценки ниже 4 (использовать объединение таблиц PROGRESS, STUDENT, GROUPS). 
DECLARE @id nvarchar(5), @nme nvarchar(10), @nte int;
DECLARE Stud_cur cursor global dynamic for select p.IDSTUDENT, s.NAME, p.NOTE from PROGRESS p
							join STUDENT s on s.IDSTUDENT = p.IDSTUDENT where p.NOTE < 4 for update;
open Stud_cur;
	fetch Stud_cur into @id, @nme, @nte;
	print 'Выбранная строка: ' + @id + ', ' + rtrim(@nme) + ', ' + convert(nvarchar(5), @nte) + '.';
	delete PROGRESS where CURRENT OF Stud_cur;
close Stud_cur;
deallocate Stud_cur;
-------------------------------------------------------------------------------------------------------------------
DECLARE @creditID nvarchar(15), @creditCode nvarchar(20), @clientID nvarchar(20), @amount real, @issueDate date, @returnDate date;
DECLARE CreditCursor CURSOR GLOBAL DYNAMIC FOR SELECT Номер_кредита, Код_кредита, ID_клиента, Сумма, Дата_выдачи, Дата_возврата FROM Кредиты WHERE Сумма > 25000 FOR UPDATE;
OPEN CreditCursor;
FETCH NEXT FROM CreditCursor INTO @creditID, @creditCode, @clientID, @amount, @issueDate, @returnDate;
PRINT 'Выбранная строка для удаления: ' + rtrim(ISNULL(@creditID, '')) + ', ' + rtrim(ISNULL(@creditCode, '')) + ', ' + rtrim(ISNULL(@clientID, '')) + ', ' + convert(nvarchar(20), @amount) + ', ' + convert(nvarchar(20), @issueDate) + ', ' + convert(nvarchar(20), @returnDate) + '.';
DELETE FROM Кредиты WHERE CURRENT OF CreditCursor;
CLOSE CreditCursor;
DEALLOCATE CreditCursor;
-- 6.2. Разработать SELECT-запрос, с помощью которого в таблице PROGRESS для студента с конкретным номером IDSTUDENT корректируется оценка (увеличивается на единицу).
DECLARE @i nvarchar(5), @nm nvarchar(30), @nt int;
DECLARE Stud_cur cursor global dynamic for select p.IDSTUDENT, s.NAME, p.NOTE from PROGRESS p
							join STUDENT s ON s.IDSTUDENT = p.IDSTUDENT where p.IDSTUDENT = 1003 for update;
open Stud_cur;
	fetch Stud_cur into @i, @nm, @nt;
	print 'Выбранная строка: ' + @i + ', ' + rtrim(@nm) + N', текущая оценка: ' +convert(nvarchar(5), @nt) + '.';
	UPDATE PROGRESS set NOTE = NOTE + 1 where CURRENT OF Stud_cur;
close Stud_cur;
deallocate Stud_cur;
-------------------------------------------------------------------------------------------------------------------
go
DECLARE @creditID nvarchar(5), @creditCode nvarchar(20), @clientID nvarchar(20), @amount real, @issueDate date, @returnDate date;
DECLARE CreditCursor CURSOR GLOBAL DYNAMIC FOR SELECT Номер_кредита, Код_кредита, ID_клиента, Сумма, Дата_выдачи, Дата_возврата FROM Кредиты WHERE ID_клиента = '3' FOR UPDATE;
OPEN CreditCursor;
FETCH NEXT FROM CreditCursor INTO @creditID, @creditCode, @clientID, @amount, @issueDate, @returnDate;
PRINT 'Выбранная строка для обновления: ' + ISNULL(@creditID, '') + ', ' + ISNULL(@creditCode, '') + ', ' + ISNULL(@clientID, '') + ', ' + CONVERT(nvarchar(20), @amount) + ', ' + CONVERT(nvarchar(20), @issueDate) + ', ' + CONVERT(nvarchar(20), @returnDate) + '.';
UPDATE Кредиты SET Сумма = Сумма + 1 WHERE CURRENT OF CreditCursor;
CLOSE CreditCursor;
DEALLOCATE CreditCursor;
go
--Отчет на рисунке справа содержит информацию о факультетах (таблица FACULTY), кафедрах (таблица PULPIT), 
--количестве преподавателей на кафедрах (таблица TEACHER), а также перечень закрепленных за кафедрой дисциплин (таблица SUBJECT). 
--Разработать сценарий, формирующий подобный отчет. При этом, если нет дисциплин, закрепленных за кафедрой, 
--в отчет выводится слово нет; коды дисциплин перечисляются в одной строке через запятую, список заканчивается точкой. 
declare cur cursor local static for
	select f.FACULTY, f.FACULTY_NAME, p.PULPIT, COUNT(t.TEACHER_NAME) as TEACHER_COUNT, 
		STUFF((SELECT ', ' + RTRIM(s.SUBJECT) 
				from SUBJECT s 
				where s.PULPIT = p.PULPIT
				for XML PATH('')), 1, 2, ' ') as SUBJECT_LIST
	from FACULTY f 
	join PULPIT p on p.FACULTY = f.FACULTY
	left join TEACHER t on t.PULPIT = p.PULPIT
	group by f.FACULTY, f.FACULTY_NAME, p.PULPIT
    order by f.FACULTY, p.PULPIT; 
declare @fc nchar(10), @fc_name nvarchar(50), @pl nchar(20), @cn int, @sb nvarchar(MAX), @prev_faculty nchar(10) = '';
open cur;
fetch next from cur into @fc, @fc_name, @pl, @cn, @sb;
while @@FETCH_STATUS = 0
begin
	if @fc != @prev_faculty
	begin
        print 'Факультет: ' + CAST(@fc AS nvarchar);
        set @prev_faculty = @fc;
    end
	print CHAR(9) + 'Кафедра: ' + CAST(@pl AS nvarchar);
    print CHAR(9) + CHAR(9) + 'Количество преподавателей: ' + CAST(@cn AS nvarchar);
    print CHAR(9) + CHAR(9) + 'Дисциплины: ' + COALESCE(@sb, N'нет') + '.' ; 
	fetch next from cur into @fc, @fc_name, @pl, @cn, @sb;
end;
close cur;
deallocate cur;