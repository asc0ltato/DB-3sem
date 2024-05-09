use UNIVER;
use Ж_MyBase;
--1. С помощью сценария, представленного на рисунке, создать таблицу TR_AUDIT.Таблица 
--предназначена для добавления в нее строк триггерами. В столбец STMT триггер должен поместить
--событие, на которое он среагировал, а в столбец TRNAME - собственное имя. Разработать 
--AFTER-триггер с именем TR_TEACHER_INS для таблицы TEACHER, реагирующий на событие INSERT. 
--Триггер должен записывать строки вводимых данных в таблицу TR_AUDIT. В столбец СС помещаются
--значения столбцов вводимой строки.
create table TR_AUDIT
(
	ID int identity, -- Номер
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')), -- DML-оператор (событие, на которое среагировал)
	TRNAME varchar(50), -- Имя триггера
	CC varchar(300) -- Комментарий
)

go
create trigger TR_TEACHER_INS on TEACHER after insert as
declare @code nvarchar(10), @name nvarchar(100), @gender char(1), @pulpit nvarchar(10), @all nvarchar(300) = ''
print 'Операция INSERT'
set @code = rtrim((select TEACHER from inserted))
set @name = (select TEACHER_NAME from inserted)
set @gender = (select GENDER from inserted)
set @pulpit = (select PULPIT from inserted)
set  @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit;
insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS','TR_TEACHER_INS', @all)
return;

insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('ЖСС','Жук Светлана Сергеевна','ж','ИСиТ')
select * from TR_AUDIT;

drop table TR_AUDIT
drop trigger TR_TEACHER_INS;

---------------------------------------------------------------------------------------------------------------
CREATE TABLE TR_AUDIT_VIDY_KREDITOV (
    ID INT IDENTITY, 
    STMT VARCHAR(20) CHECK (STMT IN ('INS', 'DEL', 'UPD')),
    TRNAME VARCHAR(50),
    CC VARCHAR(300)
);

go
create trigger TR_AUDIT_VIDY_KREDITOV1 on Виды_кредитов after insert as
declare @code nvarchar(10), @name nvarchar(100), @rate real, @all nvarchar(300) = ''
print 'Операция INSERT'
set @code = rtrim((select Код from inserted))
set @name = (select Название_вида_кредита from inserted)
set @rate = (select Ставка from inserted)
set  @all = @code + ' ' + @name + ' ' + cast(@rate as nvarchar(20));
insert into TR_AUDIT_VIDY_KREDITOV (STMT, TRNAME, CC) values ('INS','TR_AUDIT_VIDY_KREDITOV1', @all)
return;

insert into Виды_кредитов (Код, Название_вида_кредита, Ставка) values (123450, 'Кредит 1', 10)
select * from TR_AUDIT_VIDY_KREDITOV;

drop table TR_AUDIT_VIDY_KREDITOV
drop trigger  TR_AUDIT_VIDY_KREDITOV1;

--2. Создать AFTER-триггер с именем TR_TEACHER_DEL для таблицы TEACHER, реагирующий на событие
--DELETE. Триггер должен записывать строку данных в таблицу TR_AUDIT для каждой удаляемой 
--строки. В столбец СС помещаются значения столбца TEACHER удаляемой строки. 
go
create trigger TR_TEACHER_DEL on TEACHER after delete as
declare @code nvarchar(10), @name nvarchar(100), @gender char(1), @pulpit nvarchar(10), @all nvarchar(300) = ''
print 'Операция удаления'
set @code = rtrim((select TEACHER from deleted))
set @name = (select TEACHER_NAME from deleted)
set @gender = (select GENDER from deleted)
set @pulpit = (select PULPIT from deleted)
set  @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit;
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL','TR_TEACHER_DEL',@all)
return

delete TEACHER where TEACHER_NAME = 'Жук Светлана Сергеевна'
select * from TR_AUDIT

drop trigger TR_TEACHER_DEL

---------------------------------------------------------------------------------------------------------------
GO
CREATE TRIGGER TR_AUDIT_VIDY_KREDITOV_DEL ON Виды_кредитов AFTER DELETE AS
DECLARE @code NVARCHAR(10), @name NVARCHAR(100), @rate REAL, @all NVARCHAR(300) = '';
PRINT 'Операция DELETE';
SELECT @code = rtrim(Код), @name = Название_вида_кредита, @rate = Ставка FROM deleted;
SET @all = @code + ' ' + @name + ' ' + CAST(@rate AS NVARCHAR(20));
INSERT INTO TR_AUDIT_VIDY_KREDITOV (STMT, TRNAME, CC) VALUES ('DEL', 'TR_AUDIT_VIDY_KREDITOV_DEL', @all);
RETURN;

DELETE FROM Виды_кредитов WHERE Код = 123450;
SELECT * FROM TR_AUDIT_VIDY_KREDITOV;

DROP TABLE TR_AUDIT_VIDY_KREDITOV;
DROP TRIGGER TR_AUDIT_VIDY_KREDITOV_DEL;
--3. Создать AFTER-триггер с именем TR_TEACHER_UPD для таблицы TEACHER, реагирующий на событие 
--UPDATE. Триггер должен записывать строку данных в таблицу TR_AUDIT для каждой изменяемой 
--строки. В столбец СС помещаются значения столбцов изменяемой строки до и после изменения.
go
create trigger TR_TEACHER_UPD on TEACHER after update as
declare @code nvarchar(10), @name nvarchar(100), @gender char(1), @pulpit nvarchar(10), @all nvarchar(300) = ''
print 'Операция UPDATE'
set @code = rtrim((select TEACHER from inserted))
set @name = (select TEACHER_NAME from inserted)
set @gender = (select GENDER from inserted)
set @pulpit = (select PULPIT from inserted)
set @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit;
set @code = rtrim((select TEACHER from deleted))
set @name = (select TEACHER_NAME from deleted)
set @gender = (select GENDER from deleted)
set @pulpit = (select PULPIT from deleted)
set @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit;
insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD','TR_TEACHER_UPD',@all)
return

update TEACHER set TEACHER_NAME = 'Жук Света' where TEACHER_NAME = 'Жук Светлана Сергеевна'
select * from TR_AUDIT

drop trigger TR_TEACHER_UPD

---------------------------------------------------------------------------------------------------------------
GO
CREATE TRIGGER TR_AUDIT_VIDY_KREDITOV_UPD ON Виды_кредитов AFTER UPDATE AS
DECLARE @code NVARCHAR(10), @name NVARCHAR(50), @rate REAL, @all NVARCHAR(300) = '';
PRINT 'Операция UPDATE';
SELECT @code = rtrim(Код), @name = Название_вида_кредита, @rate = Ставка FROM inserted;
SELECT @code = rtrim(Код), @name = Название_вида_кредита, @rate = Ставка FROM deleted;
SET @all = @code + ' ' + @name + ' ' + CAST(@rate AS NVARCHAR(20));
INSERT INTO TR_AUDIT_VIDY_KREDITOV (STMT, TRNAME, CC) VALUES ('UPD', 'TR_AUDIT_VIDY_KREDITOV_UPD', @all);
RETURN;

UPDATE Виды_кредитов SET Название_вида_кредита = 'Новое название кредита' WHERE Код = 123450;
SELECT * FROM TR_AUDIT_VIDY_KREDITOV;

DROP TRIGGER TR_AUDIT_VIDY_KREDITOV_UPD;

--4. Создать AFTER-триггер с именем TR_TEACHER для таблицы TEACHER, реагирующий на события
--INSERT, DELETE, UPDATE. Триггер должен записывать строку данных в таблицу TR_AUDIT для каждой
--изменяемой строки. В коде триггера определить событие, активизировавшее триггер и поместить
--в столбец СС соответствующую событию информацию. Разработать сценарий, демонстрирующий 
--работоспособность триггера. 
go
create trigger TR_TEACHER on TEACHER after insert, update, delete
as
begin
	declare @code nvarchar(10), @name nvarchar(100), @gender char(1), @pulpit nvarchar(10), @all nvarchar(300) = ''
	declare @ins int = (select count(*) from inserted), @del int = (select count(*) from deleted)
	if @ins >0 and @del = 0
	begin
		print 'Событие Insert'
		set @code = rtrim((select TEACHER from inserted))
		set @name = (select TEACHER_NAME from inserted)
		set @gender = (select GENDER from inserted)
		set @pulpit = (select PULPIT from inserted)
		set @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit;
		insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS','TR_TEACHER',@all)
		return
	end
	else if @ins = 0 and @del>0
	begin
		print 'Событие Delete'
		set @code = rtrim((select TEACHER from deleted))
		set @name = (select TEACHER_NAME from deleted)
		set @gender = (select GENDER from deleted)
		set @pulpit = (select PULPIT from deleted)
		set @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit;
		insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL','TR_TEACHER',@all)
	return
	end
	else if @ins>0 and @del>0
	begin
		print 'Событие Update'
		set @code = rtrim((select TEACHER from inserted))
		set @name = (select TEACHER_NAME from inserted)
		set @gender = (select GENDER from inserted)
		set @pulpit = (select PULPIT from inserted)
		set @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit;
		set @code = rtrim((select TEACHER from deleted))
		set @name = (select TEACHER_NAME from deleted)
		set @gender = (select GENDER from deleted)
		set @pulpit = (select PULPIT from deleted)
		set @all = @code + ' ' + @name + ' ' + @gender + ' ' + @pulpit;
		insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD','TR_TEACHER',@all);
	return
	end
end

insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('ЖСС','Жук Светлана Сергеевна','ж','ИСиТ')
update TEACHER set TEACHER_NAME = 'Жук Света' where TEACHER_NAME = 'Жук Светлана Сергеевна'
delete TEACHER where TEACHER = 'ЖСС'

select * from TR_AUDIT

drop trigger TR_TEACHER

---------------------------------------------------------------------------------------------------------------
GO
CREATE TRIGGER TR_VIDY_KREDITOV ON Виды_кредитов AFTER INSERT, UPDATE, DELETE AS
BEGIN
	DECLARE @code NVARCHAR(10), @name NVARCHAR(50), @rate REAL, @all NVARCHAR(300) = '';
	DECLARE @ins INT = (SELECT COUNT(*) FROM inserted), @del INT = (SELECT COUNT(*) FROM deleted);
	IF @ins > 0 AND @del = 0
	BEGIN
		PRINT 'Событие Insert';
		SELECT @code = rtrim(Код), @name = Название_вида_кредита, @rate = Ставка FROM inserted;
		SET @all = @code + ' ' + @name + ' ' + CAST(@rate AS NVARCHAR(20));
		INSERT INTO TR_AUDIT_VIDY_KREDITOV (STMT, TRNAME, CC) VALUES ('INS', 'TR_VIDY_KREDITOV', @all);
		RETURN;
	END
	ELSE IF @ins = 0 AND @del > 0
	BEGIN
		PRINT 'Событие Delete';
		SELECT @code = rtrim(Код), @name = Название_вида_кредита, @rate = Ставка FROM deleted;
		SET @all = @code + ' ' + @name + ' ' + CAST(@rate AS NVARCHAR(20));
		INSERT INTO TR_AUDIT_VIDY_KREDITOV (STMT, TRNAME, CC) VALUES ('DEL', 'TR_VIDY_KREDITOV', @all);
		RETURN;
	END
	ELSE IF @ins > 0 AND @del > 0
	BEGIN
		PRINT 'Событие Update';
		SELECT @code = rtrim(Код), @name = Название_вида_кредита, @rate = Ставка FROM inserted;
		SET @all = @code + ' ' + @name + ' ' + CAST(@rate AS NVARCHAR(20));
		SELECT @code = rtrim(Код), @name = Название_вида_кредита, @rate = Ставка FROM deleted;
		SET @all = @code + ' ' + @name + ' ' + CAST(@rate AS NVARCHAR(20));
		INSERT INTO TR_AUDIT_VIDY_KREDITOV (STMT, TRNAME, CC) VALUES ('UPD', 'TR_VIDY_KREDITOV', @all);
		RETURN;
	END
END;

INSERT INTO Виды_кредитов (Код, Название_вида_кредита, Ставка) VALUES (123456, 'Кредит 1', 10);
UPDATE Виды_кредитов SET Название_вида_кредита = 'Новое название' WHERE Код = 123456;
DELETE FROM Виды_кредитов WHERE Код = 123456;

SELECT * FROM TR_AUDIT_VIDY_KREDITOV;

DROP TRIGGER TR_VIDY_KREDITOV;
--5. Разработать сценарий, который демонстрирует на примере базы данных UNIVER, что проверка
--ограничения целостности выполняется до срабатывания AFTER-триггера.
alter table TEACHER add constraint GENDER check(GENDER = 'м' or GENDER = 'ж')
go
UPDATE TEACHER SET GENDER = N'й' WHERE TEACHER=N'СМЛВ'

select * from TR_AUDIT

---------------------------------------------------------------------------------------------------------------
UPDATE Виды_кредитов SET Ставка = -10 WHERE Код = 123456;

SELECT * FROM TR_AUDIT_VIDY_KREDITOV;
--6. Создать для таблицы TEACHER три AFTER-триггера с именами: TR_TEACHER_ DEL1, 
--TR_TEACHER_DEL2 и TR_TEACHER_ DEL3. Триггеры должны реагировать на событие DELETE и 
--формировать соответствующие строки в таблицу TR_AUDIT.  Получить список триггеров таблицы
--TEACHER. Упорядочить выполнение триггеров для таблицы TEACHER, реагирующих на событие DELETE
--следующим образом: первым должен выполняться триггер с именем TR_TEACHER_DEL3, последним –
--триггер TR_TEACHER_DEL2. Использовать системные представления SYS.TRIGGERS и 
--SYS.TRIGGERS_ EVENTS, а также системную процедуру SP_SETTRIGGERORDERS. 
go
create trigger TR_TEACHER_DEL1 on TEACHER after delete as
begin
	print 'Триггер 1' 
	declare @a nvarchar(50) = (select TEACHER from deleted)
	insert into TR_AUDIT values ('DEL','TR_TEACHER_DEL1',@a)
end
go
go
create trigger TR_TEACHER_DEL2 on TEACHER after delete as
begin
	print 'Триггер 2' 
	declare @a nvarchar(50) = (select TEACHER from deleted)
	insert into TR_AUDIT values ('DEL','TR_TEACHER_DEL2',@a)
end
go

go
create trigger TR_TEACHER_DEL3 on TEACHER after delete as
begin
	print 'Триггер 3' 
	declare @a nvarchar(50) = (select TEACHER from deleted)
	insert into TR_AUDIT values ('DEL','TR_TEACHER_DEL3',@a)
end
go

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL1', @order = 'None', @stmttype = 'DELETE';
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', @order = 'Last', @stmttype = 'DELETE';
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', @order = 'First', @stmttype = 'DELETE';

insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('ЖСС','Жук Светлана Сергеевна','ж','ИСиТ')
delete TEACHER where TEACHER = 'ЖСС'

select * from TR_AUDIT

select t.name, e.type_desc from sys.triggers  t join  sys.trigger_events e  
on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE' ; 

drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3

---------------------------------------------------------------------------------------------------------------
GO
CREATE TRIGGER TR_VIDY_KREDITOV_DEL1 ON Виды_кредитов AFTER DELETE AS
BEGIN
	PRINT 'Триггер 1';
	DECLARE @a NVARCHAR(50) = (SELECT Код FROM deleted);
	INSERT INTO TR_AUDIT_VIDY_KREDITOV VALUES ('DEL', 'TR_VIDY_KREDITOV_DEL1', @a);
END;
GO

CREATE TRIGGER TR_VIDY_KREDITOV_DEL2 ON Виды_кредитов AFTER DELETE AS
BEGIN
	PRINT 'Триггер 2';
	DECLARE @a NVARCHAR(50) = (SELECT Код FROM deleted);
	INSERT INTO TR_AUDIT_VIDY_KREDITOV VALUES ('DEL', 'TR_VIDY_KREDITOV_DEL2', @a);
END;
GO

CREATE TRIGGER TR_VIDY_KREDITOV_DEL3 ON Виды_кредитов AFTER DELETE AS
BEGIN
	PRINT 'Триггер 3';
	DECLARE @a NVARCHAR(50) = (SELECT Код FROM deleted);
	INSERT INTO TR_AUDIT_VIDY_KREDITOV VALUES ('DEL', 'TR_VIDY_KREDITOV_DEL3', @a);
END;
GO

EXEC SP_SETTRIGGERORDER @triggername = 'TR_VIDY_KREDITOV_DEL1', @order = 'None', @stmttype = 'DELETE';
EXEC SP_SETTRIGGERORDER @triggername = 'TR_VIDY_KREDITOV_DEL2', @order = 'Last', @stmttype = 'DELETE';
EXEC SP_SETTRIGGERORDER @triggername = 'TR_VIDY_KREDITOV_DEL3', @order = 'First', @stmttype = 'DELETE';

INSERT INTO Виды_кредитов (Код, Название_вида_кредита, Ставка) VALUES (123456, 'Кредит 1', 10);
DELETE FROM Виды_кредитов WHERE Код = 123456;

SELECT * FROM TR_AUDIT_VIDY_KREDITOV;

SELECT t.name, e.type_desc
FROM sys.triggers t
JOIN sys.trigger_events e ON t.object_id = e.object_id
WHERE OBJECT_NAME(t.parent_id) = 'Виды_кредитов' AND e.type_desc = 'DELETE';

DROP TRIGGER TR_VIDY_KREDITOV_DEL1;
DROP TRIGGER TR_VIDY_KREDITOV_DEL2;
DROP TRIGGER TR_VIDY_KREDITOV_DEL3;

--7. Разработать сценарий, демонстрирующий на примере базы данных UNIVER утверждение: AFTER-
--триггер является частью транзакции, в рамках которого выполняется оператор, активизировавший
--триггер.
go
create trigger Task7 on TEACHER after insert, delete, update as
declare @count int = (select count(*) from TEACHER)
if (@count>10)
begin
	raiserror('Преподавателей слишком много для создания триггера',10,1)
	rollback
end
return

insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('ЖСС','Жук Светлана Сергеевна','ж','ИСиТ')

drop trigger Task7

---------------------------------------------------------------------------------------------------------------
GO
CREATE TRIGGER Task7_VIDY_KREDITOV ON Виды_кредитов AFTER INSERT, DELETE, UPDATE AS
BEGIN
	DECLARE @count INT = (SELECT COUNT(*) FROM Виды_кредитов);
	IF (@count > 3)
	BEGIN
		RAISERROR('Количество записей превышает допустимый предел для триггера', 10, 1);
		ROLLBACK;
	END;
	RETURN;
END;

INSERT INTO Виды_кредитов (Код, Название_вида_кредита, Ставка) VALUES (123456, 'Кредит 1', 10);

DROP TRIGGER Task7_VIDY_KREDITOV;

--8.  Для таблицы FACULTY создать INSTEAD OF-триггер, запрещающий удаление строк в таблице. 
--Разработать сценарий, который демонстрирует на примере базы данных UNIVER, что проверка
--ограничения целостности выполнена, если есть INSTEAD OF-триггер.С помощью оператора DROP
--удалить все DML-триггеры, созданные в этой лабораторной работе.
go
create trigger insteadOf on TEACHER instead of delete as
raiserror(N'Удаление запрещено!',10,1)
return
go

delete TEACHER
select * from TEACHER

delete TEACHER where TEACHER = 'ЖСС'

drop trigger InsteadOf

---------------------------------------------------------------------------------------------------------------
GO
CREATE TRIGGER InsteadOf_VIDY_KREDITOV ON Виды_кредитов INSTEAD OF DELETE AS
BEGIN
	RAISERROR(N'Удаление запрещено!', 10, 1);
	RETURN;
END;

DELETE FROM Виды_кредитов;
SELECT * FROM Виды_кредитов;

DELETE FROM Виды_кредитов WHERE Код = 123456;

DROP TRIGGER InsteadOf_VIDY_KREDITOV;

--9. Создать DDL-триггер, реагирующий на все DDL-события в БД UNIVER. Триггер должен запрещать
--создавать новые таблицы и удалять существующие. Свое выполнение триггер должен сопровождать
--сообщением, которое содержит: тип события, имя и тип объекта, а также пояснительный текст,
--в случае запрещения выполнения оператора. Разработать сценарий, демонстрирующий работу триггера. 
go
create trigger DDL_UNIVERSITY on database for DDL_DATABASE_LEVEL_EVENTS as
	declare @t1 varchar(50), @t2 varchar(50), @t3 varchar(50)
	set @t1 = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','varchar(50)')
	set @t2 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','varchar(50)')
	set @t3 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]','varchar(50)')
	if @t2 = 'TEACHER' 
		print 'Тип события: ' + @t1;
		print 'Имя объекта: ' + @t2;
		print 'Тип объекта: ' + @t3;
		raiserror ('Операции с таблице TEACHER запрещены!',10,1)
		rollback
go

go
alter table TEACHER drop column TEACHER_NAME

drop trigger DDL_UNIVERSITY on database

---------------------------------------------------------------------------------------------------------------
GO
CREATE TRIGGER DDL_VIDY_KREDITOV ON DATABASE FOR DDL_DATABASE_LEVEL_EVENTS AS
BEGIN
	DECLARE @eventType VARCHAR(50), @objectName VARCHAR(50), @objectType VARCHAR(50);
	SET @eventType = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','VARCHAR(50)');
	SET @objectName = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','VARCHAR(50)');
	SET @objectType = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]','VARCHAR(50)');

	IF @objectName = 'Виды_кредитов' 
	BEGIN
		PRINT 'Тип события: ' + @eventType;
		PRINT 'Имя объекта: ' + @objectName;
		PRINT 'Тип объекта: ' + @objectType;
		RAISERROR('Операции с таблицей Виды_кредитов запрещены!', 10, 1);
		ROLLBACK;
	END;
END;

alter table Виды_кредитов drop column Ставка

DROP TRIGGER DDL_VIDY_KREDITOV ON DATABASE;
--11. Создать таблицу WEATHER (город, начальная дата, конечная дата, температура). Создать 
--триггер, проверяющий корректность ввода и изменения данных. Например, если в таблице есть
--строка (Минск, 01.01.2022 00:00, 01.01.2022 23:59, -6), то в нее не может быть вставлена 
--строка (Минск, 01.01.2022 00:00, 01.01.2022 23:59, -2). Временные периоды могут быть различными.
CREATE TABLE WEATHER (
    city VARCHAR(100),
    start_date DATETIME,
    end_date DATETIME,
    temperature INT,
);

GO
CREATE TRIGGER check_weather ON WEATHER AFTER INSERT, UPDATE AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM WEATHER W INNER JOIN inserted I ON 
		W.city = I.city AND 
		W.start_date = I.start_date AND 
		W.end_date = I.end_date AND 
		W.temperature != I.temperature
    )
    BEGIN
		raiserror( N'Данные для города, начальной даты и конечной даты уже существуют с другой температурой', 16, 1);
    END
END;

select * from WEATHER;

INSERT INTO WEATHER (city, start_date, end_date, temperature)
VALUES ('Минск', '2022-01-01T00:00:00', '2022-01-01T23:59:59', -6);

INSERT INTO WEATHER (city, start_date, end_date, temperature)
VALUES ('Минск', '2022-01-01T00:00:00', '2022-01-01T23:59:59', -2);

drop table WEATHER;
drop trigger check_weather;