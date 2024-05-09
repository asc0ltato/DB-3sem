use EXAM
/*1.	Создайте процедуру, которая выводит список заказов и их итоговую стоимость для БЯКА
определенного покупателя. Параметр – наименование покупателя. Обработайте возможные ошибки.*/ 
go
create procedure FIRST_TASK @bn varchar(20) as
begin try
select ORDERS.ORDER_NUM , ORDERS.AMOUNT from ORDERS 
inner join CUSTOMERS on CUSTOMERS.CUST_NUM = ORDERS.CUST where CUSTOMERS.COMPANY = @bn
return 1
end try
begin catch
print 'err num: ' + cast(error_number() as varchar(6));
print 'err msg: ' + error_message();
print 'err level: ' + cast(error_severity() as varchar(6));
if ERROR_PROCEDURE() is not null 
print 'ERROR: ' + error_procedure();
return -1
end catch

go
exec FIRST_TASK @bn= 'JCP Inc.'

drop procedure FIRST_TASK
/*2.	Создайте функцию, которая подсчитывает количество 
заказов покупателя за определенный период. 
Параметры – покупатель, дата начала периода, дата окончания периода.*/
go
create function SECOND_TASK (@cname varchar(15),@per1 date ,@per2 date) returns int as
begin
declare @rc int = 0 
set @rc = (select count(ORDERS.ORDER_NUM) from ORDERS 
inner join CUSTOMERS on CUSTOMERS.CUST_NUM = ORDERS.CUST
where ORDER_DATE between @per1 and @per2 and CUSTOMERS.COMPANY = @cname )
return @rc
end;

go
declare @s int = dbo.SECOND_TASK('JCP Inc.','2007-01-01','2008-01-01');
print 'Count: ' + cast(@s as varchar(10))

drop function dbo.SECOND_TASK
/*3.	Создайте процедуру, которая выводит список всех товаров, 
приобретенных покупателем, по возрастанию цены товара. 
Параметр – наименование покупателя. Обработайте возможные ошибки.*/
go
create procedure THIRD_TASK @ci varchar(20) as
begin try
select * from PRODUCTS 
inner join ORDERS on ORDERS.MFR = PRODUCTS.MFR_ID and ORDERS.PRODUCT = PRODUCTS.PRODUCT_ID
inner join CUSTOMERS on CUSTOMERS.CUST_NUM = ORDERS.CUST and CUSTOMERS.COMPANY = @ci
order by PRODUCTS.PRICE asc
return 1
end try
begin catch
print 'err num: ' + cast(error_number() as varchar(6));
print 'err msg: ' + error_message();
print 'err level: ' + cast(error_severity() as varchar(6));
if ERROR_PROCEDURE() is not null 
print 'ERROR: ' + error_procedure();
return -1
end catch

go
exec THIRD_TASK @ci = 'JCP Inc.';

drop procedure THIRD_TASK
/*4 Создайте функцию, которая добавляет покупателя в таблицу Customers, 
и возвращает код добавленного покупателя или -1 в случае ошибки.
Параметры соответствуют столбцам таблицы, кроме кода покупателя, 
который задается при помощи последовательности.*/
-- НЕЛЬЗЯ INSERT в фунции!
go
create procedure FOUR_TASK @com varchar(20), @cr int , @cl decimal(9,2) as 
begin try
declare @cn int = (select max(CUSTOMERS.CUST_NUM) + 1 from CUSTOMERS )
insert into CUSTOMERS(CUST_NUM,COMPANY,CUST_REP,CREDIT_LIMIT) values(@cn ,@com ,@cr ,@cl)
return @cn
end try
begin catch
return -1
end catch

go
declare @num int
exec @num = FOUR_TASK 'JCP Inc.',103,11111.00
print '@num: ' + cast(@num as varchar(20)) 
select * from CUSTOMERS

drop procedure FOUR_TASK
delete CUSTOMERS where CUSTOMERS.CREDIT_LIMIT = 11111.0
/*5.Создайте процедуру, которая выводит список покупателей, бяка
в порядке убывания общей стоимости заказов.
Параметры – дата начала периода, дата окончания периода. 
Обработайте возможные ошибки.*/
go
create procedure FIVE_TASK @per1 date , @per2 date as
begin try
select * from CUSTOMERS 
inner join ORDERS on ORDERS.CUST = CUSTOMERS.CUST_NUM and ORDER_DATE between @per1 and @per2
order by ORDERS.AMOUNT desc
return 1
end try
begin catch
if ERROR_PROCEDURE() is not null
print 'ERR' + ERROR_PROCEDURE()
return -1
end catch

go
exec FIVE_TASK '2007-01-01' , '2008-01-01'

drop procedure FIVE_TASK
/*6.	Создайте функцию, которая подсчитывает БЯКА
количество заказанных товаров за определенный период. 
Параметры – дата начала периода, дата окончания периода.*/
go
create function SIX_TASK(@per1 date,@per2 date) returns int as
begin
declare @rc int = 0;
set @rc = ( select count(distinct ORDERS.PRODUCT) from ORDERS
Where ORDERS.ORDER_DATE between @per1 and @per2)
return @rc
end;

go
declare @s2 int = dbo.SIX_TASK('2007-01-01','2007-12-01');
print 'Count: ' + cast(@s2 as varchar(10))

drop function dbo.SIX_TASK
/*7.	Создайте процедуру, которая выводит список покупателей, БЯКА
у которых нет заказов в этом временном периоде. 
Параметры – дата начала периода, дата окончания периода.
Обработайте возможные ошибки*/
go
create procedure SEVEN_TASK @per1 date , @per2 date as
begin try
select * from CUSTOMERS 
inner join ORDERS on ORDERS.CUST = CUST_NUM 
where ORDER_DATE not between @per1 and @per2 
end try
begin catch
if ERROR_PROCEDURE() is not null
print 'ERR: ' + ERROR_PROCEDURE();
end catch

go
exec SEVEN_TASK '2007-12-27','2008-03-02'

drop procedure SEVEN_TASK
-- ??????
/*8.	Создайте функцию, которая подсчитывает количество БЯКА
покупателей определенного товара. 
Параметры – наименование товара.*/
go
create function EIGHT_TASK (@pn varchar(20)) returns int 
as begin
declare @rc int = 0
set @rc = (select count(distinct CUSTOMERS.CUST_NUM) from CUSTOMERS
inner join ORDERS on ORDERS.CUST = CUSTOMERS.CUST_NUM
inner join PRODUCTS on ORDERS.MFR = PRODUCTS.MFR_ID and ORDERS.PRODUCT = PRODUCTS.PRODUCT_ID
and PRODUCTS.MFR_ID = @pn)
return @rc
end;

go
declare @si3 int = dbo.EIGHT_TASK('REI')
print 'количество покупателей определенного товара: ' + cast(@si3 as varchar(10))

drop function dbo.EIGHT_TASK
/*9.	Создайте процедуру, которая увеличивает 
на 10% стоимость определенного товара.
Параметр – наименование товара. Обработайте возможные ошибки*/
go
create procedure NINE_TASK @pn varchar(20) as
begin try
update PRODUCTS set PRICE = PRICE + 0.1 * PRICE where PRODUCTS.PRODUCT_ID = @pn
end try
begin catch
if ERROR_PROCEDURE() is not null
print 'ERR: ' + ERROR_PROCEDURE();
end catch

go
exec NINE_TASK '41001'

select * from PRODUCTS
update PRODUCTS set PRICE = 55.00 where PRODUCT_ID = '41001'

drop procedure NINE_TASK
/*10.	Создайте функцию, которая вычисляет количество заказов, БЯКА
выполненных в определенном году для определенного покупателя. 
Параметры – покупатель, год. товара.*/
go
create function TEN_TASK(@cn int , @y int) returns int as 
begin
declare @rc int = 0;
set @rc = (select count(ORDERS.ORDER_NUM) from ORDERS 
inner join CUSTOMERS on CUSTOMERS.CUST_NUM = ORDERS.CUST
where YEAR(ORDERS.ORDER_DATE) = @y and CUSTOMERS.CUST_NUM = @cn);
return @rc;
end;

go
declare @si4 int = dbo.TEN_TASK(2111,2007)
print 'количество заказов ' + cast(@si4 as varchar(10))

drop function dbo.TEN_TASK