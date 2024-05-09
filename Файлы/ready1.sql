use exam

--1. Выбрать все заказы, выполненные после определенной даты.
select * from ORDERS where ORDER_DATE > N'2008-01-01';
--2. Выбрать все офисы из определенного региона и управляемые определенным сотрудником.
select * from OFFICES where REGION = N'Eastern' and MGR = 106;
--3. Выбрать заказы, сделанные в определенный период.
select * from ORDERS where ORDER_DATE between '2007-12-17' and '2008-02-05';
--4. Выбрать офисы из 12, 13 и 21 региона.
select * from OFFICES where OFFICE in ('12', '13', '21');
--5. Выбрать сотрудника, у которого нет менеджера (самого главного).
select * from SALESREPS where MANAGER is null;
--6.	Выбрать офисы из региона, который начинается на East.
select * from OFFICES where REGION like 'East%'
--7.	Выбрать фамилии и даты найма всех сотрудников и отсортировать по возрасту.
select NAME, HIRE_DATE from SALESREPS order by AGE;
--8.	Выбрать все заказы и отсортировать вначале по стоимости по убыванию, а затем по количеству заказанного по возрастанию.
select * from ORDERS order by AMOUNT desc, QTY asc;
--9.	Выбрать 5 самых дорогих товаров.
select top(5) * from PRODUCTS order by price desc; 
--10.	Выбрать 20% самых дорогих заказов.
select top 20 percent * from ORDERS order by amount desc;
--11.	Выбрать сотрудников с 4 по 7, отсортированных по дате найма.
select * from SALESREPS where EMPL_NUM between 104 and 107 order by HIRE_DATE;
--12.	Выбрать уникальные товары в заказах.
select distinct MFR, PRODUCT from ORDERS;
--13.	Подсчитать количество заказов для каждого покупателя.
select CUST [Покупатель], COUNT(*) [Количество заказов] from ORDERS group by CUST;
--14.	Подсчитать итоговую сумму заказа для каждого покупателя.
select CUST [Покупатель], SUM(AMOUNT) [Итоговая сумма] from ORDERS group by CUST;
--15.	Подсчитать среднюю цену заказа для каждого сотрудника.
select REP [Сотрудник], AVG(AMOUNT) [Средняя цена] from ORDERS group by REP;
--16.	Найти самый дорогой товар каждого производителя.
select MFR [Производитель], MAX(AMOUNT) from ORDERS group by MFR;
--17.Найти покупателей и их заказы (в результирующем наборе должны быть: наименование покупателя,
--наименование товара, производитель, количество и итоговая сумма).
select c.COMPANY [Наименование покупателя], p.DESCRIPTION [Наименование товара], 
p.MFR_ID [Производитель], o.QTY [Количество], o.AMOUNT [Итоговая сумма]
from ORDERS o
join CUSTOMERS c on o.CUST = c.CUST_NUM
join PRODUCTS p on o.PRODUCT = p.PRODUCT_ID and O.MFR = P.MFR_ID;

--18.Найти всех покупателей и их заказы. 
select  c.CUST_NUM [Номер покупателя], c.COMPANY [Покупатели], 
o.ORDER_NUM [Номер заказа], o.ORDER_DATE [Дата заказа] from CUSTOMERS c 
left join ORDERS o on c.CUST_NUM = o.CUST;

--19.Найти покупателей, у которых нет заказов.
select c.CUST_NUM [Номер покупателя], c.COMPANY [Покупатели], o.ORDER_NUM [Номер заказа] from CUSTOMERS c 
left join ORDERS o on c.CUST_NUM = o.CUST
WHERE o.ORDER_NUM is null;

--20.Найти покупателей, у которых есть заказы в определенный период.
select c.CUST_NUM [Номер покупателя], c.COMPANY [Покупатели], 
o.ORDER_NUM [Номер заказа], o.ORDER_DATE [Дата заказа] from CUSTOMERS c 
join ORDERS o on c.CUST_NUM = o.CUST 
WHERE o.ORDER_DATE between '2008-01-01' and '2008-01-15';

--21.Найти товары, которые купили покупатели с кредитным лимитом больше 40000.
select distinct p.PRODUCT_ID [Название товара], p.DESCRIPTION [Описание товара] from CUSTOMERS c 
join ORDERS o on c.CUST_NUM = o.CUST
join PRODUCTS p on p.PRODUCT_ID = o.PRODUCT and o.MFR = p.MFR_ID
WHERE c.CREDIT_LIMIT > 40000

--22.Найти сотрудников одного возраста.
select s.NAME, s.AGE from SALESREPS s inner join SALESREPS s1 on s.NAME != s1.NAME and s.AGE = s1.AGE 

--23.Выбрать всех покупателей в порядке уменьшения обшей стоимости заказов.
select c.CUST_NUM [Номер покупателя], c.COMPANY [Покупатель], SUM(o.AMOUNT) [Общая стоимость заказов]
from CUSTOMERS c join ORDERS o on c.CUST_NUM = o.CUST
group by c.CUST_NUM, C.COMPANY
order by SUM(o.AMOUNT) desc;

--24.Выбрать заказы, сумма которых больше среднего значения.
select * from ORDERS 
WHERE AMOUNT > (select avg(AMOUNT) from ORDERS)

--25.Подсчитать, на какую сумму каждый офис выполнил заказы, и отсортировать их в порядке убывания.
select ofi.OFFICE [Код офиса], SUM(ofi.SALES) [Общая сумма заказов] from OFFICES ofi
group by ofi.OFFICE
order by SUM(ofi.SALES) desc;

--26.Выбрать сотрудников, которые являются начальниками (у которых есть подчиненные).
select * from SALESREPS s1 where exists (select * from SALESREPS s2 where s2.MANAGER = s1.EMPL_NUM)

--27.Выбрать сотрудников, которые не являются начальниками (у которых нет подчиненных).
select * from SALESREPS s1 where not exists (select * from SALESREPS s2 where s2.MANAGER = s1.EMPL_NUM)

--28.Выбрать всех продукты, продаваемые менеджерами из восточного региона.
select distinct p.* from PRODUCTS p
join ORDERS o on p.MFR_ID = o.MFR and p.PRODUCT_ID = o.PRODUCT
join SALESREPS s on s.EMPL_NUM = o.REP
join OFFICES oo on oo.OFFICE = s.REP_OFFICE
where oo.REGION = N'Eastern'

--29.Выбрать товары, которые по стоимости ниже среднего значения стоимости заказа по покупателю.
select p.* from PRODUCTS p 
join ORDERS o on p.MFR_ID = o.MFR and p.PRODUCT_ID = o.PRODUCT
WHERE p.PRICE < (select avg(AMOUNT) from ORDERS WHERE CUST = o.CUST)

--30.Найти организации, которые не делали заказы в 2008, но делали в 2007 (как минимум 2-мя разными способами).
select c.COMPANY from CUSTOMERS c
where c.CUST_NUM not in (select o.CUST from ORDERS o where year(o.ORDER_DATE) = 2008)
and C.CUST_NUM in (select o.CUST from ORDERS o where year(o.ORDER_DATE) = 2007);
---
select c.COMPANY from CUSTOMERS c 
left join (select CUST from ORDERS where year(ORDER_DATE) = 2008) n1 on c.CUST_NUM = n1.CUST
join (select CUST from ORDERS where year(ORDER_DATE) = 2007) n2 on c.CUST_NUM = n2.CUST
where n1.CUST is null;
---
select c.COMPANY from CUSTOMERS c 
where not exists (select * from ORDERS o where o.CUST = c.CUST_NUM and year(o.ORDER_DATE) = 2008)
and exists (select * from ORDERS o where o.CUST = c.CUST_NUM and year(o.ORDER_DATE) = 2007)