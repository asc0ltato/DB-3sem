use UNIVER;
---1)Объявить переменные типа...
---1.Первые две проинициализировать в операторе объявления
DECLARE @c char = 'a', 
		@vc varchar(5) = 'Sveta',
		@dt datetime,
		@t time,
		@i int,
		@si smallint,
		@ti tinyint,
		@num numeric(12,5)
---2.Присвоить произвольные значения переменным с помощью операторов SET и SELECT
SET @dt = getdate();
SET @t = '16:00:00';
SET @i = (select max(NOTE) from PROGRESS);

SELECT @si = min(NOTE), @num = avg(NOTE) from PROGRESS;
SET @ti = @i + @si; 
---3.Значения вывести с помощью SELECT и PRINT
select @i, @si, @ti, @num

print 'Переменная c: ' + @c;
print 'Переменная vc: ' + @vc;
print 'Переменная dt: ' + cast(@dt as varchar(15));
print 'Переменная t: ' + cast(@t as varchar(15));
---2)Определить общую вместимость аудиторий. Если о.в. > 200, то вывести кол-во аудиторий,
---среднюю вместимость, кол-во аудиторий, вместимость кот. < средней, и процент таких аудиторий
---Если о.в.а. < 200, то вывести сообщение о размере общей вместимости
DECLARE @capacity int = (select sum(AUDITORIUM_CAPACITY) from AUDITORIUM),	
		@kol int = (select count(AUDITORIUM) from AUDITORIUM),	
		@avg int = (select avg(AUDITORIUM_CAPACITY) from AUDITORIUM);
DECLARE	@lessavg int = (select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY < @avg);
DECLARE	@percent float = (@lessavg / @kol)* 100;

if @capacity > 200
begin
	SELECT @kol 'Кол-во аудиторий', 
	@avg 'Средняя вместимость',
	@lessavg 'Кол-во аудиторий, вместимость кот. < средней', 
	cast(@percent as varchar) + '%' 'Процент аудиторий, которые < средней'
end
else if @capacity < 200
begin
	print 'Общая вместимость равна: ' + @capacity;
end;
---3)Запрос с глобальными переменными.
print 'Число обработанных строк: ' + cast(@@ROWCOUNT as varchar(10));
print 'Версия SQL Server: ' + cast(@@VERSION as varchar(200));
print 'Системный идентификатор процесса, назначенный сервером текущему подключению: ' + cast(@@SPID as varchar(10));
print 'Код последней ошибки: ' + cast(@@ERROR as varchar(30));
print 'Имя сервера: ' + cast(@@SERVERNAME as varchar(30));
print 'Уровень вложенности транзакции: ' + cast(@@trancount as varchar(30));
print 'Проверка результата считывания строк результирующего набора: ' + cast(@@FETCH_STATUS as varchar(30));
print 'Уровень вложенности текущей процедуры: ' + cast(@@NESTLEVEL as varchar(30));
--- 4)
--- 1. Вычисление z для различных значений исходных данных
DECLARE @t2 int = 60, @z float(10), @x int = 50;

if (@t2 > @x) SET @z = power(sin(@t2), 2)
else if (@t2 < @x) SET @z = 4*(@t2 + @x)
else SET @z = 1 - exp(@x-2)
print 'z= ' + convert(nvarchar, @z);
--- 2.Преобразование полного ФИО в сокращенное
DECLARE @fullName varchar(30) = 'Макейчик Татьяна Леонидовна';

set @fullName = (select substring(@fullName, 1, charindex(' ', @fullName)) +
substring(@fullName, charindex(' ', @fullName) + 1, 1) + '.' +
substring(@fullName, charindex(' ', @fullName, charindex(' ', @fullName) + 1)+ 1, 1) + '.');

print @fullName;
---3.Поиск студентов, у кот. день рождения в следующем месяце, и определение их возраста
DECLARE @month int = month(getdate());
if @month = 12 set @month = 0;
SELECT NAME[Имя студента], 2023-YEAR(BDAY)[Возраст], month(BDAY)[Месяц рождения]
FROM STUDENT WHERE month(BDAY) = @month + 1
---4.Поиск дня недели, в кот. студенты некоторой группы сдавали экзамен по БД
select CASE
	when DATEPART(weekday, PDATE) = 1 then 'Понедельник'
	when DATEPART(weekday, PDATE) = 2 then 'Вторник'
	when DATEPART(weekday, PDATE) = 3 then 'Среда'
	when DATEPART(weekday, PDATE) = 4 then 'Четверг'
	when DATEPART(weekday, PDATE) = 5 then 'Пятница'
	when DATEPART(weekday, PDATE) = 6 then 'Суббота'
	when DATEPART(weekday, PDATE) = 7 then 'Воскресенье'
end
from PROGRESS 
where SUBJECT = 'СУБД'

select * from PROGRESS
---5)Продемонстрировать if...else
DECLARE @avgMark float(3), @count int;
set @avgMark = (select avg(NOTE) from PROGRESS);
set @count = (select count(NOTE) from PROGRESS);

if @avgMark < 6
begin
	print 'Средние оценки меньше 6'
end
else if @avgMark > 6
begin
	print 'Средние оценки больше 6'
end
else
begin
	print 'Средняя оценка: ' + cast(@avgMark as varchar);
end

print 'Количество оценок: '+ cast(@count as varchar);

select * from PROGRESS
---6)Сценарий, в кот. с помощью CASE анализируются оценки, полученные студентами некоторого факультета при сдаче экзов
SELECT CASE
WHEN NOTE between 9 and 10 then 'Отлично(9-10)'
WHEN NOTE between 7 and 8 then 'Хорошо(7-8)'
WHEN NOTE between 5 and 6 then 'Удовлетворительно(5-6)'
ELSE 'Ужасно(Ниже 4)'
END NOTE, count(*) [Количество]
FROM PROGRESS p
JOIN STUDENT s on p.IDSTUDENT = s.IDSTUDENT
JOIN GROUPS g on s.IDGROUP = g.IDGROUP
WHERE FACULTY = N'ИДиП'
GROUP BY CASE
WHEN NOTE between 9 and 10 then 'Отлично(9-10)'
WHEN NOTE between 7 and 8 then 'Хорошо(7-8)'
WHEN NOTE between 5 and 6 then 'Удовлетворительно(5-6)'
ELSE 'Ужасно(Ниже 4)'
end;
---7)Создать временную локальную таблицу из 3ех столбцов и 10 строк, заполнить и вывести содержимое. Использовать WHILE
CREATE TABLE #example
(
	ID int,
	number_1 int,
	number_2 int,
);

DECLARE  @iter int = 0;
WHILE @iter < 10
	begin
	INSERT #example(ID, number_1, number_2)
			values(rand() * 10, rand() * 20, rand() * 30);
	if (@iter = 9)
		print 'Таблица заполнена десятью числами'
	SET @iter = @iter + 1;
	end

SELECT * from #example;
---8)Использование оператора RETURN
DECLARE @xx int = 5
print @xx + 1
print @xx + 2
RETURN
print @xx + 3
---9)Разработать сценарий с ошибками, в котором используются для обработки ошибок блоки TRY и CATCH.
--Применить функции ERROR_NUMBER (код последней ошибки),
--ERROR_MESSAGE (сообщение об ошибке), ERROR_LINE (код последней ошибки),
--ERROR_PROCEDURE (имя процедуры или NULL), ERROR_SEVERITY (уровень серьезности ошибки), ERROR_STATE (метка ошибки).
BEGIN TRY
 UPDATE GROUPS set YEAR_FIRST = 'year' WHERE YEAR_FIRST = 2013
END TRY
BEGIN CATCH
print ERROR_NUMBER() 
print ERROR_MESSAGE()
print ERROR_LINE() 
print ERROR_PROCEDURE() 
print ERROR_SEVERITY()
print ERROR_STATE() 
END CATCH