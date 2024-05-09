use UNIVER
use Ж_MyBase
---1.1
SELECT distinct FACULTY.FACULTY, PULPIT.PULPIT_NAME
FROM FACULTY, PULPIT
WHERE FACULTY.FACULTY = PULPIT.FACULTY and FACULTY.FACULTY In (SELECT FACULTY FROM PROFESSION
WHERE (PROFESSION_NAME Like N'%технология%' or PROFESSION_NAME Like N'%технологии%'))
--1.2
SELECT distinct Клиенты.Название_фирмы_клиента, Кредиты.Номер_кредита
FROM Клиенты, Кредиты
WHERE Клиенты.ID = Кредиты.ID_клиента and Кредиты.ID_клиента In (SELECT ID FROM Клиенты
WHERE Вид_собственности Like N'%Магазин%' or Вид_собственности Like N'%Автосалон%')
---2.1
SELECT distinct FACULTY.FACULTY, PULPIT.PULPIT_NAME
FROM FACULTY Inner JOIN PULPIT 
On FACULTY.FACULTY = PULPIT.FACULTY 
WHERE FACULTY.FACULTY In (SELECT FACULTY FROM PROFESSION
WHERE (PROFESSION_NAME Like N'%технология%' or PROFESSION_NAME Like N'%технологии%'))
--2.2
SELECT distinct Клиенты.Название_фирмы_клиента, Кредиты.Номер_кредита
FROM Клиенты Inner JOIN Кредиты
On Клиенты.ID = Кредиты.ID_клиента
WHERE Кредиты.ID_клиента In (SELECT ID FROM Клиенты
WHERE Вид_собственности Like N'%Магазин%' or Вид_собственности Like N'%Автосалон%')
---3.1
SELECT distinct FACULTY.FACULTY, PULPIT.PULPIT_NAME
FROM FACULTY Inner JOIN PULPIT 
On FACULTY.FACULTY = PULPIT.FACULTY 
Inner JOIN PROFESSION On PROFESSION.FACULTY = FACULTY.FACULTY
WHERE (PROFESSION_NAME Like N'%технология%' or PROFESSION_NAME Like N'%технологии%')
--3.2
SELECT distinct Клиенты.Название_фирмы_клиента, Кредиты.Номер_кредита
FROM Клиенты Inner JOIN Кредиты
On Клиенты.ID = Кредиты.ID_клиента
Inner JOIN Виды_кредитов On Виды_кредитов.Код = Кредиты.Код_кредита
WHERE Вид_собственности Like N'%Магазин%' or Вид_собственности Like N'%Автосалон%'
---4.1
SELECT AUDITORIUM_TYPE, AUDITORIUM_CAPACITY
FROM AUDITORIUM a
WHERE  AUDITORIUM_TYPE = (select top(1) AUDITORIUM_TYPE FROM AUDITORIUM aa
WHERE aa.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE) 
order by AUDITORIUM_CAPACITY desc
--4.2
SELECT Название_вида_кредита, Ставка
FROM Виды_кредитов vk
WHERE Ставка = (select top(1) Ставка FROM Виды_кредитов v
WHERE v.Код = vk.Код)
order by Ставка desc
---5.1
SELECT FACULTY_NAME FROM FACULTY
WHERE not exists (select * from PULPIT
WHERE PULPIT.FACULTY = FACULTY.FACULTY)
--5.2
SELECT Название_фирмы_клиента FROM Клиенты
WHERE not exists (select * from Кредиты
WHERE Кредиты.ID_клиента = Клиенты.ID)
---6.1
SELECT top 1
	(select avg(pr.NOTE) from PROGRESS pr 
		where pr.SUBJECT = N'ОАиП')[ОАиП],
	(select avg(pr.NOTE) from PROGRESS pr
		where pr.SUBJECT = N'БД')[БД],
	(select avg(pr.NOTE) from PROGRESS pr
		where pr.SUBJECT = N'СУБД')[СУБД]
FROM PROGRESS
--6.2
SELECT top 1
    (select avg(kr.Сумма) from Кредиты kr 
     where kr.Код_кредита = N'275843')[Микро-Бизнес Старт],
    (select avg(kr.Сумма) from Кредиты kr
     where kr.Код_кредита = N'356345')[Микро-Бизнес Овердрафт],
    (select avg(kr.Сумма) from Кредиты kr
     where kr.Код_кредита = N'324253')[Микро-Бизнес Инновации]
FROM Кредиты
---7
SELECT NOTE, SUBJECT FROM PROGRESS
WHERE NOTE >=all (select NOTE from PROGRESS WHERE SUBJECT like 'ОАиП%')
--
SELECT Сумма, Код_кредита FROM Кредиты
WHERE Сумма >=all (select Сумма from Кредиты WHERE Код_кредита like N'325325%')
---8
SELECT NOTE, SUBJECT FROM PROGRESS
WHERE NOTE > any (select NOTE from PROGRESS WHERE NOTE > 4)
order by NOTE desc
--
SELECT Сумма, Код_кредита FROM Кредиты
WHERE Сумма > any (select Сумма from Кредиты WHERE Сумма > 22000)
order by Сумма desc
---10
SELECT NAME, BDAY FROM STUDENT
WHERE BDAY in (select BDAY from STUDENT group by BDAY having count(*) > 1)
order by BDAY