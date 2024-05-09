--1)Определить все индексы, которые имеются в БД UNIVER. 
--Создать временную локальную таблицу. Заполнить ее данными (не менее 1000 строк). 
--Разработать SELECT-запрос. Получить план запроса и определить его стоимость. 
--Создать кластеризованный индекс, уменьшающий стоимость SELECT-запроса
use UNIVER
use Ж_MyBase
exec sp_helpindex 'AUDITORIUM_TYPE'
exec sp_helpindex 'AUDITORIUM'
exec sp_helpindex 'FACULTY'
exec sp_helpindex 'PROFESSION'
exec sp_helpindex 'PULPIT'
exec sp_helpindex 'TEACHER'
exec sp_helpindex 'SUBJECT'
exec sp_helpindex 'GROUPS'
exec sp_helpindex 'STUDENT'
exec sp_helpindex 'PROGRESS'

create table #explre 
(	TIND int,
	TFIELD varchar(100)
);

go
SET nocount on;
DECLARE @i int = 0;
WHILE @i < 1000
	begin
INSERT #explre(TIND, TFIELD)
	values(floor(30000*rand()), replicate('строка', 10));
if(@i % 100 = 0)
	print @i;
SET @i = @i + 1;
end;
go
---0.011, стало 0.0033, код стал быстрее
select * from #explre where TIND between 1500 and 2500 order by TIND

checkpoint;  --фиксация БД
DBCC DROPCLEANBUFFERS;  --очистить буферный кэш

create clustered index #explre_cl on #explre(TIND asc);

drop index #explre_cl on #explre
drop table #explre
------------------------------------------------
use Ж_MyBase
DECLARE @i int = 0;
WHILE @i < 1000
	begin
INSERT dbo.Виды_кредитов(Код, Название_вида_кредита, Ставка)
	values(floor(300000*rand()), replicate('строка', 1), 50);
SET @i = @i + 1;
end;

create index #client on Виды_кредитов(Ставка);

select * from Виды_кредитов where Ставка between 1000 and 1500 order by Ставка

drop index #client on Виды_кредитов
--2)Создать временную локальную таблицу. Заполнить ее данными (10000 строк или больше). 
--Разработать SELECT-запрос. Получить план запроса и определить его стоимость. 
--Создать некластеризованный неуникальный составной индекс. 
--Оценить процедуры поиска информации.
create table #ex
( TKEY int,
  CC int identity(1,1),
  TF varchar(100)
);

go
SET nocount on;
DECLARE @i int = 0;
WHILE @i < 10000
	begin
INSERT #ex(TKEY, TF)
	values(floor(30000*rand()), replicate('строка', 10));
SET @i = @i + 1;
end;
go

--0.098, стало 0.04
--0.092, чет не изменилось
select count(*)[количество строк] from #ex;
select * from #ex;

--создаем некластеризованный неуникальный составной индекс
create index #ex_nonclu on #ex(TKEY, CC)

--этот индекс не применяется оптимизатором ни при фильтрации, 
--ни при сортировке строк таблицы #ex
--0.614 - сортировка, 0.092 - просмотр таблицы, ничего не изменилось
select * from #ex where TKEY > 1500 and CC < 4500;
select * from #ex order by TKEY, CC;

-- некласетризированный составной индекс подключается при фиксированном значении
-- 0,092, стало 0,0066 
select * from #ex where TKEY = 556 and CC > 3

drop index #ex_nonclu on #ex
drop table #ex
--------------------------------------------
use Ж_MyBase
DECLARE @i int = 0;
WHILE @i < 1000
	begin
INSERT dbo.Виды_кредитов(Код, Название_вида_кредита, Ставка)
	values(floor(300000*rand()), replicate('строка', 1), 50);
SET @i = @i + 1;
end;

select * from Виды_кредитов where Название_вида_кредита = N'Микро-Бизнес Овердрафт' and Ставка > 1200;

create index #credit_nonclu on Виды_кредитов(Код, Название_вида_кредита);

drop index #credit_nonclu on Виды_кредитов
--3)Создать временную локальную таблицу. Заполнить ее данными (не менее 10000 строк). 
--Разработать SELECT-запрос. Получить план запроса и определить его стоимость. 
--Создать некластеризованный индекс покрытия, уменьшающий стоимость SELECT-запроса.
create table #ex3
( TKEY int,
  CC int identity(1,1),
  TF varchar(100)
);

go
SET nocount on;
DECLARE @i int = 0;
WHILE @i < 10000
	begin
INSERT #ex3(TKEY, TF)
	values(floor(30000*rand()), replicate('строка', 10));
SET @i = @i + 1;
end;
go

create index #ex_tkey_x on #ex3(TKEY) include (CC)

--0.092, стало 0.019
select CC from #ex3 where TKEY > 15000;

drop index #ex_tkey_x on #ex3
drop table #ex3
---------------------------------------------------
use Ж_MyBase
DECLARE @i int = 0;
WHILE @i < 1000
	begin
INSERT dbo.Виды_кредитов(Код, Название_вида_кредита, Ставка)
	values(floor(300000*rand()), replicate('строка', 1), 50);
SET @i = @i + 1;
end;

select Код from Виды_кредитов where Ставка > 1200;

create index #credit_they_x on Виды_кредитов(Ставка) include (Код);

drop index #credit_they_x on Виды_кредитов
--4)Создать и заполнить временную локальную таблицу. 
--Разработать SELECT-запрос, получить план запроса и определить его стоимость. 
--Создать некластеризованный фильтруемый индекс, уменьшающий стоимость SELECT-запроса.
create table #ex4
( TKEY int,
  CC int identity(1,1),
  TF varchar(100)
);

go
SET nocount on;
DECLARE @i int = 0;
WHILE @i < 10000
	begin
INSERT #ex4(TKEY, TF)
	values(floor(30000*rand()), replicate('строка', 10));
SET @i = @i + 1;
end;
go

--0.092, стало везде 0.003
select TKEY from #ex4 where TKEY between 100 and 200;
select TKEY from #ex4 where TKEY > 100 and TKEY < 200;
select TKEY from #ex4 where TKEY = 1335;

checkpoint;  --фиксация БД
DBCC DROPCLEANBUFFERS;  --очистить буферный кэш

create index #ex_where on #ex4(TKEY) where (TKEY >= 150 and TKEY < 200);

drop index #ex_where on #ex4
drop table #ex4
---------------------------------------------------
use Ж_MyBase
DECLARE @i int = 0;
WHILE @i < 1000
	begin
INSERT dbo.Виды_кредитов(Код, Название_вида_кредита, Ставка)
	values(floor(300000*rand()), replicate('строка', 1), 50);
SET @i = @i + 1;
end;

select Код from Виды_кредитов where Ставка = 1400;

create index #credit_where on Виды_кредитов(Ставка) where (Ставка > 1000 and Ставка < 1500);

drop index #credit_where on Виды_кредитов
--5)Заполнить временную локальную таблицу. 
--Создать некластеризованный индекс. Оценить уровень фрагментации индекса. 
--Разработать сценарий на T-SQL, выполнение которого приводит к уровню фрагментации индекса выше 90%. 
--Оценить уровень фрагментации индекса. 
--Выполнить процедуру реорганизации индекса, оценить уровень фрагментации. 
--Выполнить процедуру перестройки индекса и оценить уровень фрагментации индекса.
use tempdb;

create table #ex5
( TKEY int,
  CC int identity(1,1),
  TF varchar(100)
);

go
SET nocount on;
DECLARE @i int = 0;
WHILE @i < 10000
	begin
INSERT #ex5(TKEY, TF)
	values(floor(30000*rand()), replicate('строка', 10));
SET @i = @i + 1;
end;
go

create index #ex_tkey on #ex5(TKEY);

select name [Индекс], avg_fragmentation_in_percent [Фрагметанция (%)]
from sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
object_id(N'#ex5'), null, null, null) ss JOIN sys.indexes ii
on ss.object_id = ii.object_id and ss.index_id = ii.index_id where name is not null;

INSERT top(1000000) #ex5(TKEY, TF) select TKEY, TF from #ex5;
INSERT top(1000000) #ex5(TKEY, TF) select TKEY, TF from #ex5;
INSERT top(1000000) #ex5(TKEY, TF) select TKEY, TF from #ex5;

ALTER index #ex_tkey on #ex5 reorganize;
ALTER index #ex_tkey on #ex5 rebuild with (online=off);

drop index #ex_tkey on #ex5
drop table #ex5
--6)Разработать пример, демонстрирующий применение параметра FILL-FACTOR при создании некластеризованного индекса.
create table #ex6
( TKEY int,
  CC int identity(1,1),
  TF varchar(100)
);

go
SET nocount on;
DECLARE @i int = 0;
WHILE @i < 10000
	begin
INSERT #ex6(TKEY, TF)
	values(floor(30000*rand()), replicate('строка', 10));
SET @i = @i + 1;
end;
go

create index #ex_tkey on #ex6(TKEY) with (fillfactor = 65);

INSERT top(50) percent into #ex6(TKEY, TF) select TKEY, TF from #ex6;

select name [Индекс], avg_fragmentation_in_percent [Фрагметанция (%)]
from sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
object_id(N'#ex6'), null, null, null) ss JOIN sys.indexes ii
on ss.object_id = ii.object_id and ss.index_id = ii.index_id where name is not null;

drop index #ex_tkey on #ex6
drop table #ex6