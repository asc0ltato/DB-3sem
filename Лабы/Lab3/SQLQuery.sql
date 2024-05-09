use master
go
create database Ж_MyBase on primary 
( name = N'Ж_MyBase_mdf', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Ж_MyBase_mdf.mdf', size = 10240Kb, maxsize = unlimited, filegrowth = 1024Kb),
( name = N'Ж_MyBase_ndf', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Ж_MyBase_ndf.ndf', size = 10240KB, maxsize=1Gb, filegrowth=25%),
filegroup FG1
( name = N'Ж_MyBase_fg1_1', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Ж_MyBase_frq-1.ndf', size = 10240Kb, maxsize=1Gb, filegrowth=25%),
( name = N'Ж_MyBase_fg1_2', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Ж_MyBase_frg-2.ndf', size = 10240Kb, maxsize=1Gb, filegrowth=25%),
filegroup FG2
( name = N'Ж_MyBase_fg1_3', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Ж_MyBase_frq-3.ndf', size = 10240Kb, maxsize=1Gb, filegrowth=25%),
( name = N'Ж_MyBase_fg1_4', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Ж_MyBase_frg-4.ndf', size = 10240Kb, maxsize=1Gb, filegrowth=25%),
filegroup FG3
( name = N'Ж_MyBase_fg1_5', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Ж_MyBase_frq-5.ndf', size = 10240Kb, maxsize=1Gb, filegrowth=25%),
( name = N'Ж_MyBase_fg1_6', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Ж_MyBase_frg-6.ndf', size = 10240Kb, maxsize=1Gb, filegrowth=25%)
log on 
( name = N'Ж_MyBase_log', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Ж_MyBase_log.ldf', size = 10240Kb, maxsize = 2048Gb, filegrowth = 10%)
go 

use Ж_MyBase;
drop database Ж_MyBase

CREATE table Клиенты 
(   ID nvarchar(20) primary key,
	Название_фирмы_клиента nvarchar(50),
	Вид_собственности nvarchar(30),
	Адрес nvarchar(50),
	Телефон nvarchar(20),
	Контактное_лицо nvarchar(20)
) on FG1;

CREATE table Виды_кредитов
(   Код nvarchar(20) primary key,
	Название_вида_кредита nvarchar(50),
	Ставка real not null
) on FG2;

CREATE table Кредиты
(   Номер_кредита nchar(15) primary key,
	Код_кредита nvarchar(20) foreign key references Виды_кредитов(Код),
	ID_клиента nvarchar(20) foreign key references Клиенты(ID),
	Сумма real not null,
	Дата_выдачи date,
	Дата_возврата date
) on FG3;

ALTER table Клиенты ADD Паспорт nvarchar(20);

INSERT into Клиенты (ID, Название_фирмы_клиента, Вид_собственности, Адрес, Телефон, Контактное_лицо, Паспорт)
	 values (1, 'News Cafe', 'Кафе', 'г.Брест, ул. Армейская, д.5', +375335632195, 'Рыбачёнок К.Д.', 'MC6683679'),
			(2, 'Атлантик Авто', 'Автосалон', 'г. Могилев, ул. Киселева, д.15', +375334526830, 'Давыдко А.Н.', 'MC7375968'),
			(3, 'БГТУ', 'УО', 'г.Минск, ул.Свердлова, д.13A', +375334526830, 'Шиман Д.В.', 'MC2719437'),
			(4, 'Мила', 'Магазин', 'г.Борисов, ул.Перспективная, д.1', +375254956073, 'Петров П.П.', 'MC7102460'), 
			(5, 'Остров чистоты', 'Магазин', 'г.Слоним, ул.Доморада, д.10', +375295645065, 'Иванов И.В.', 'МС3673840');

INSERT into Виды_кредитов (Код, Название_вида_кредита, Ставка)
	 values (275843, 'Микро-Бизнес Старт', 1000),
			(356345, 'Микро-Бизнес Овердрафт', 1400),
			(324253, 'Микро-Бизнес Инновации', 1500),
			(235253, 'Микро-Бизнес Инвест Плюс', 1300),
			(325325, 'Микро-Бизнес Инвест', 2000);

INSERT into Кредиты (Номер_кредита, Код_кредита, ID_клиента, Сумма, Дата_выдачи, Дата_возврата)
	  values (10010, 275843, 1, 20000, '2017-3-23', '2021-11-26'),
			 (10011, 356345, 2, 30000, '2017-4-21', '2023-9-1'),
			 (10012, 324253, 3, 22000, '2018-5-3', '2021-3-6'),
			 (10013, 235253, 4, 25000, '2018-7-4', '2022-1-1'),
			 (10014, 325325, 5, 27000, '2019-2-24', '2023-6-21');

SELECT * from Клиенты;
SELECT ID, Название_фирмы_клиента from Клиенты;
SELECT count(*) from Кредиты;

UPDATE Клиенты set Контактное_лицо = 'Гайдук С.С.' where Контактное_лицо = 'Шиман Д.В.';

delete from Клиенты where ID = 1;
drop table Виды_кредитов;