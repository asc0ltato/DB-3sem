--1. Разработать сценарий, демонстрирующий работу в режиме неявной транзакции. Проанализировать пример,
--приведенный справа, в котором создается таблица Х, и создать сценарий для другой таблицы.
use master;

set nocount on
if exists (select * from  SYS.OBJECTS where OBJECT_ID = object_id (N'DBO.TAB') )--таблица TAB есть?
drop table TAB;
declare @c int, @flag char = 'c';	-- commit или rollback?
SET IMPLICIT_TRANSACTIONS  ON		-- включ. режим неявной транзакции
create table TAB (i int);				-- начало транзакции 
	insert TAB values (1),(2),(3),(4),(5);
	set @c = (select count(*) from TAB);
	print N'кол-во строк в TAB: ' + cast(@c as varchar(2));
	if @flag = 'c' commit -- фиксация
	else rollback; -- откат
SET IMPLICIT_TRANSACTIONS OFF -- выключ. режим неявной транзакции

if exists (select * from SYS.OBJECTS where OBJECT_ID= object_id(N'DBO.TAB')) 
print N'таблица TAB есть';
else print N'таблицы TAB нет'
--2.Разработать сценарий, демонстрирующий свойство атомарности явной транзакции на примере бд UNIVER. 
--В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
--Опробовать работу сценария при использовании различных операторов модификации таблиц.
use UNIVER;
begin try
	begin tran						
		insert FACULTY values (N'ЗН', N'Факультет замечательных наук');
		insert FACULTY values (N'ОН', N'Факультет очаровательных наук');
	commit tran;
end try
begin catch
	print N'ошибка:' + case
	when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0
	then N'дублирование факультета'
	else N'неизвестная ошибка' + cast(error_number() as varchar(5)) + error_message()
	end;
	if @@TRANCOUNT > 0 rollback tran;
end catch
select * from FACULTY

DELETE FACULTY WHERE FACULTY = 'ЗН';
DELETE FACULTY WHERE FACULTY = 'ОН';
-------------------------------------------------------------------------------------------------
use Ж_MyBase;
begin try
	begin tran	--начало явной транзакции					
		insert Клиенты values (6, 'Хауз', 'Дом', 'г.Минск, ул. Белорусская, д.1', '+1234567890', 'Анна Добрая', 'AP25345643');
		insert Клиенты values (7, 'Новая Компания', 'Коммерческая', 'г.Гродно, ул. Советская, д.10', '+9876543210', 'Иван Петров', 'BC1234567');
	commit tran; --фиксация транзакции
end try
begin catch
	print N'ошибка:' + case
	when error_number() = 2627 and patindex('%Клиенты_PK%', error_message()) > 0
	then N'дублирование ID клиента'
	else N'неизвестная ошибка' + cast(error_number() as varchar(5)) + error_message()
	end;
	if @@TRANCOUNT > 0 rollback tran;
end catch
select * from Клиенты
--3.Разработать сценарий, демонстрирующий применение оператора SAVE TRAN на примере базы данных UNIVER. 
--В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. Опробовать работу 
--сценария при использовании различных контрольных точек и различных операторов модификации таблиц.
use UNIVER;
declare @point nvarchar(32);
begin try
	begin tran
	set @point='p1'; save tran @point;
	insert FACULTY (FACULTY, FACULTY_NAME) values
						(N'ФО',N'Факультет Обычный'),
						(N'ФА',N'Факультет Атлетики'),
						(N'ЛФ',N'Факультет Лингвистики');
	set @point='p2' ; save tran @point;
	insert FACULTY values(N'МФ', N'Медицинский факультет');
	commit tran;
end try
begin catch
		print N'ошибка:' + case 
		when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0
		then N'дублирование факультета'
		else N'неизвестная ошибка:' + cast(error_number() as varchar(5)) + error_message()
	end;
	if @@trancount>0
	begin
		print N'контрольная точка: '+@point;
		rollback tran @point; --откат к контрольной точке
		commit tran; --фиксация изменений, выполненных до контрольной точки
	end;
end catch;

select * from FACULTY
DELETE FACULTY WHERE FACULTY = 'ФА';
DELETE FACULTY WHERE FACULTY = 'ФО';
DELETE FACULTY WHERE FACULTY = 'ЛФ';
-------------------------------------------------------------------------------------------------
use Ж_MyBase;
DECLARE @point1 NVARCHAR(32);
BEGIN TRY
    BEGIN TRAN
        INSERT Кредиты VALUES ('10015', '275843', '3', '18000', '2023-01-15', '2024-07-20');
        SET @point1 = 'p1'; SAVE TRAN @point1;
        INSERT Кредиты VALUES ('10016', '325325', '4', '30000', '2023-04-10', '2024-10-15');
        SET @point1 = 'p2'; SAVE TRAN @point1;
        INSERT Кредиты VALUES ('10017', '356345', '5', '25000', '2023-06-05', '2024-12-30');
        COMMIT TRAN;
END TRY
BEGIN CATCH
    PRINT N'ошибка: ' + CASE 
        WHEN ERROR_NUMBER() = 2627 AND PATINDEX('%Кредиты_PK%', ERROR_MESSAGE()) > 0 
		THEN N'дублирование номера кредита'
        ELSE N'неизвестная ошибка: ' + CAST(ERROR_NUMBER() AS VARCHAR(5)) + ERROR_MESSAGE()
    END;
    IF @@TRANCOUNT > 0
    BEGIN
        PRINT N'контрольная точка: ' + @point1;
        ROLLBACK TRAN @point1;
        COMMIT TRAN; 
    END;
END CATCH;
SELECT * FROM Кредиты
--4.Разработать два сценария A и B на примере базы данных X_UNIVER. Сценарий A представляет собой явную
--транзакцию с уровнем изолированности READ UNCOMMITED, сценарий B – явную транзакцию с уровнем 
--изолированности READ COMMITED (по умолчанию).Сценарий A должен демонстрировать, что уровень READ 
--UNCOMMITED допускает неподтвержденное, неповторяющееся и фантомное чтение.
use UNIVER;
----------------A------------------
set transaction isolation level READ UNCOMMITTED
begin transaction
----------------t1-----------------
select count(*) from FACULTY
commit;
---------------t2----------------------
----------B--------
begin transaction
select @@SPID
delete FACULTY WHERE FACULTY like 'ФФК1';
insert FACULTY values(N'ФФК',N'Факультет Физической Культуры');
insert FACULTY values(N'ФФК1',N'Факультет Физической Культуры1');
insert FACULTY values(N'ФФК2',N'Факультет Физической Культуры2');
update FACULTY set FACULTY_NAME = 'Факультет Физической Культуры5' where FACULTY = 'ФФК1';
-------------t1---------------------
-------------t2---------------------
rollback;
delete FACULTY where FACULTY like 'ФФК%'
-------------------------------------------------------------------------------------------------
use Ж_MyBase
----------------A------------------
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
----------------t1-----------------
SELECT @@SPID, 'insert Виды_кредитов' N'результат', * FROM Виды_кредитов WHERE Название_вида_кредита = 'Микро-Бизнес Старт';
SELECT @@SPID, 'update Кредиты' AS 'результат', Название_вида_кредита, Ставка FROM Виды_кредитов WHERE Название_вида_кредита = 'Микро-Бизнес Старт';
COMMIT;
---------------t2----------------------
----------B--------
BEGIN TRANSACTION;
SELECT @@SPID; 
INSERT Виды_кредитов VALUES ('123456', 'Ипотека', 5.5);
UPDATE Виды_кредитов SET Название_вида_кредита = 'Ипотека' WHERE Название_вида_кредита = 'Микро-Бизнес Инвест';
-------------t1---------------------
-------------t2---------------------
ROLLBACK; 
--5.Разработать два сценария A и B на примере базы данных X_UNIVER. Сценарии A и В представляют собой явные
--транзакции с уровнем изолированности READ COMMITED. Сценарий A должен демонстрировать, что уровень READ 
--COMMITED не допускает неподтвержденного чтения, но при этом возможно неповторяющееся и фантомное чтение.
use UNIVER;
--А--
set transaction isolation level READ COMMITTED
begin transaction
select count(*) from FACULTY where FACULTY=N'ИТ'
--------------t1---------------
--------------t2---------------
select 'update FACULTY' N'результат', count(*) from FACULTY where FACULTY=N'ИТ'
commit;

--B--
begin transaction
------------t1--------------
update FACULTY set FACULTY=N'ИТ' where FACULTY=N'ИТ'
commit;
------------t2--------------
-------------------------------------------------------------------------------------------------
use Ж_MyBase
--А--
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
SELECT count(*) from Кредиты where Номер_кредита = '10010';
--------------t1---------------
--------------t2---------------
SELECT 'update Кредиты' N'результат', count(*) from Кредиты where Номер_кредита = '10010';
COMMIT;

--B--
BEGIN TRANSACTION;
------------t1--------------
SELECT @@SPID; 
UPDATE Кредиты SET Номер_кредита = '10235' WHERE Номер_кредита = '10010';
commit
-------------t2---------------------
--6. Разработать два сценария A и B на примере базы данных X_UNIVER.Сценарий A представляет собой явную транзакцию
--с уровнем изолированности REPEATABLE READ. Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED.
--Сценарий A должен демонстрировать, что уровень REAPETABLE READ не допускает неподтвержденного чтения и 
--неповторяющегося чтения, но при этом возможно фантомное чтение.
--- A ---
set transaction isolation level REPEATABLE READ
begin transaction
select PULPIT from PULPIT where FACULTY = N'ИТ';
-------------------------- t1 ------------------
-------------------------- t2 -----------------
select case
when PULPIT = N'ЛВ' then 'insert PULPIT' else ' '
end N'результат', PULPIT from PULPIT where FACULTY = N'ИТ';
commit;

--- B ---
begin transaction
-------------------------- t1 --------------------
insert PULPIT values (N'мя', N'Полиграфических производств', N'ИДИП');
commit;
select * from PULPIT
-------------------------- t2 --------------------
-------------------------------------------------------------------------------------------------
use Ж_MyBase
--- A ---
set transaction isolation level REPEATABLE READ
begin transaction
select Название_вида_кредита from Виды_кредитов where Название_вида_кредита = N'Ипотека';
-------------------------- t1 ------------------
-------------------------- t2 -----------------
select case
when Название_вида_кредита = N'Микро-Бизнес Инновации' then 'insert Виды_кредитов' else ' '
end N'результат', Название_вида_кредита from Виды_кредитов where Название_вида_кредита = N'Ипотека';
commit;

--- B ---
begin transaction
-------------------------- t1 --------------------
insert Виды_кредитов values (N'234512', N'Микро-Бизнес Банк', N'1200');
commit;
-------------------------- t2 --------------------
--7.Разработать два сценария A и B на примере базы данных UNIVER. Сценарий A представляет собой явную транзакцию 
--с уровнем изолированности SERIALIZABLE. Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED.
--Сценарий A должен демонстрировать отсутствие фантомного, неподтвержденного и неповторяющегося чтения.
use UNIVER;
-- A ---
set transaction isolation level SERIALIZABLE
begin transaction
insert PULPIT values (N'КГ', N'Компьютерная графика', N'ИТ');
commit;
update PULPIT set PULPIT = N'КГ' where FACULTY = N'ИТ';
select PULPIT from PULPIT where FACULTY = N'ИТ';
-------------------------- t1 -----------------
select PULPIT from PULPIT where FACULTY = N'ИТ';
-------------------------- t2 ------------------
commit;

--- B ---
begin transaction
insert PULPIT values (N'КБ', N'компьютерная безопсность', N'ИТ');
update PULPIT set PULPIT = N'КБ' where FACULTY = N'ИТ';
select PULPIT from PULPIT where FACULTY = N'ИТ';
-------------------------- t1 --------------------
commit;
select PULPIT from PULPIT where FACULTY = N'ИТ';
-------------------------- t2 --------------------
select * from PULPIT
-------------------------------------------------------------------------------------------------
use Ж_MyBase
-- A ---
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
INSERT Виды_кредитов VALUES ('789012', 'Кредит наличными', 1500);
COMMIT;
UPDATE Виды_кредитов SET Название_вида_кредита = 'Кредит наличными' WHERE Ставка = 1500;
SELECT Название_вида_кредита FROM Виды_кредитов WHERE Ставка = 1500;
-------------------------- t1 -----------------
SELECT Название_вида_кредита FROM Виды_кредитов WHERE Ставка = 1500;
-------------------------- t2 ------------------
COMMIT;

--- B ---
BEGIN TRANSACTION;
INSERT Виды_кредитов VALUES ('789012', 'Кредит наличными', 1500);
UPDATE Виды_кредитов SET Название_вида_кредита = 'Автокредит' WHERE Ставка = 1500;
SELECT Название_вида_кредита FROM Виды_кредитов WHERE Ставка = 1500;
-------------------------- t1 --------------------
COMMIT;
SELECT Название_вида_кредита FROM Виды_кредитов WHERE Ставка = 1500;
-------------------------- t2 --------------------
SELECT * FROM Виды_кредитов;
--8.Разработать сценарий, демонстрирующий свойства вложенных транзакций, на примере базы данных UNIVER. 
use UNIVER;

begin tran
	update FACULTY set FACULTY_NAME=N'Кафедра ИЭЭЭФ' where FACULTY.FACULTY = N'ИЭФ';
	begin tran
	update PULPIT set PULPIT_NAME=N'Кафедра ИЭЭЭФ' where PULPIT.FACULTY = N'ИЭФ';
	commit;
	if @@TRANCOUNT > 0 rollback;
select 
	(select count(*) from dbo.PULPIT where FACULTY = N'ИЭФ') N'PULPIT',
	(select count(*) from dbo.FACULTY where FACULTY.FACULTY = N'ИЭФ') N'FACULTY';

select * from PULPIT
select * from FACULTY
-------------------------------------------------------------------------------------------------
use Ж_MyBase

begin tran
	update Кредиты set ID_клиента =N'6' where Кредиты.ID_клиента = N'5';
	begin tran
	update Клиенты set ID =N'6' where Клиенты.ID = N'5';
	commit;
	if @@TRANCOUNT > 0 rollback;
select 
	(select count(*) from dbo.Клиенты where Клиенты.ID = N'5') N'Клиенты',
	(select count(*) from dbo.Кредиты where Кредиты.ID_клиента = N'5') N'Кредиты';

select * from Клиенты
select * from Кредиты