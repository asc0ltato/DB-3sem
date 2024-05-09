use UNIVER
------------------uncommitted------------------
--2)
BEGIN TRAN
DELETE FROM AUDITORIUM WHERE AUDITORIUM='423-1'
select count(*) from AUDITORIUM --7, неподтвержденное чтение
rollback tran
--3)
BEGIN TRAN
select count(*) from AUDITORIUM --8 после отката
commit tran

--4.Разработать два сценария A и B на примере базы данных X_UNIVER. Сценарий A представляет собой явную
--транзакцию с уровнем изолированности READ UNCOMMITED, сценарий B – явную транзакцию с уровнем 
--изолированности READ COMMITED (по умолчанию).Сценарий A должен демонстрировать, что уровень READ 
--UNCOMMITED допускает неподтвержденное, неповторяющееся и фантомное чтение.
----------B--------
begin transaction
delete FACULTY WHERE FACULTY like 'ФФК1';
insert FACULTY values(N'ФФК',N'Факультет Физической Культуры');
insert FACULTY values(N'ФФК1',N'Факультет Физической Культуры1');
insert FACULTY values(N'ФФК2',N'Факультет Физической Культуры2');
select count(*) from FACULTY
-------------t1---------------------
-------------t2---------------------
rollback;

BEGIN TRAN
select count(*) from FACULTY 
commit tran





--------------------committed-------------------
BEGIN TRAN
DELETE FROM AUDITORIUM WHERE AUDITORIUM='423-1'
select count(*) from AUDITORIUM --7

Rollback tran

BEGIN TRAN
select count(*) from AUDITORIUM --8
commit tran

--5.Разработать два сценария A и B на примере базы данных X_UNIVER. Сценарии A и В представляют собой явные
--транзакции с уровнем изолированности READ COMMITED. Сценарий A должен демонстрировать, что уровень READ 
--COMMITED не допускает неподтвержденного чтения, но при этом возможно неповторяющееся и фантомное чтение.
--B--
------------t1--------------
begin transaction
delete FACULTY WHERE FACULTY = N'ФА';
select count(*) from FACULTY 

Rollback tran

begin transaction
select count(*) from FACULTY 
commit;
------------t2--------------





------------------repeatable read--------------
--2)
BEGIN TRAN
DELETE FROM AUDITORIUM WHERE AUDITORIUM='423-1'
--4)
commit tran

--6. Разработать два сценария A и B на примере базы данных X_UNIVER.Сценарий A представляет собой явную транзакцию
--с уровнем изолированности REPEATABLE READ. Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED.
--Сценарий A должен демонстрировать, что уровень REAPETABLE READ не допускает неподтвержденного чтения и 
--неповторяющегося чтения, но при этом возможно фантомное чтение.
--- B ---
begin transaction
insert PULPIT values (N'мя', N'Полиграфических производств', N'ИДИП');
select count(*) from PULPIT

rollback
commit;

select * from PULPIT
-------------------------- t2 --------------------
DELETE PULPIT FROM PULPIT WHERE PULPIT = 'мя' 




----------------serializable--------------------
--2)
BEGIN TRAN
insert into AUDITORIUM Values('202', N'ЛК',60,'202-1');
--4)
commit tran

--7.Разработать два сценария A и B на примере базы данных UNIVER. Сценарий A представляет собой явную транзакцию 
--с уровнем изолированности SERIALIZABLE. Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED.
--Сценарий A должен демонстрировать отсутствие фантомного, неподтвержденного и неповторяющегося чтения.
--- B ---
begin transaction
insert PULPIT values (N'КБk', N'компьютерная безопасность', N'ИТ');

-------------------------- t1 --------------------
commit;

select * from PULPIT
-------------------------- t2 --------------------
rollback