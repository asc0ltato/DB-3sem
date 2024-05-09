use UNIVER
---------------uncommitted----------------------
--1)
set transaction isolation level read uncommitted
begin tran
select count(*) from AUDITORIUM --8

--4.Разработать два сценария A и B на примере базы данных X_UNIVER. Сценарий A представляет собой явную
--транзакцию с уровнем изолированности READ UNCOMMITED, сценарий B – явную транзакцию с уровнем 
--изолированности READ COMMITED (по умолчанию).Сценарий A должен демонстрировать, что уровень READ 
--UNCOMMITED допускает неподтвержденное, неповторяющееся и фантомное чтение.
----------------A------------------
set transaction isolation level READ UNCOMMITTED
begin transaction
----------------t1-----------------
select count(*) from FACULTY
commit;
---------------t2----------------------





--------------------committed-------------------
--1) переход в B и потом сюда
set transaction isolation level read committed
begin tran
select count(*) from AUDITORIUM --8, неподтвержденного чтения нет, поэтому откат

--5.Разработать два сценария A и B на примере базы данных X_UNIVER. Сценарии A и В представляют собой явные
--транзакции с уровнем изолированности READ COMMITED. Сценарий A должен демонстрировать, что уровень READ 
--COMMITED не допускает неподтвержденного чтения, но при этом возможно неповторяющееся и фантомное чтение.
--А--
set transaction isolation level READ COMMITTED
begin transaction
select count(*) from FACULTY 
--------------t1---------------
--------------t2---------------
commit;



----------------repeatable read-----------------
--нет неповторяющегося чтения
--1)
set transaction isolation level repeatable read
begin tran
select count(*) from AUDITORIUM --8
--3)
commit tran
--4)
rollback tran -- для следующего задания

--6. Разработать два сценария A и B на примере базы данных X_UNIVER.Сценарий A представляет собой явную транзакцию
--с уровнем изолированности REPEATABLE READ. Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED.
--Сценарий A должен демонстрировать, что уровень REAPETABLE READ не допускает неподтвержденного чтения и 
--неповторяющегося чтения, но при этом возможно фантомное чтение.
--- A ---
set transaction isolation level REPEATABLE READ
begin transaction
select count(*) from PULPIT
-------------------------- t1 ------------------
-------------------------- t2 -----------------
commit;

rollback;





----------------serializable--------------------
--1)
set transaction isolation level serializable
begin tran
select count(*) from AUDITORIUM --8
--3)
commit tran

--7.Разработать два сценария A и B на примере базы данных UNIVER. Сценарий A представляет собой явную транзакцию 
--с уровнем изолированности SERIALIZABLE. Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED.
--Сценарий A должен демонстрировать отсутствие фантомного, неподтвержденного и неповторяющегося чтения.
-- A ---
set transaction isolation level SERIALIZABLE
begin transaction
select count(*) from PULPIT
-------------------------- t1 -----------------
-------------------------- t2 ------------------
commit;

rollback