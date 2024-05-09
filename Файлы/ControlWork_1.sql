use exam

select top(3) ORDERS.PRODUCT, sum(ORDERS.QTY) as [Количество заказанных товаров] from ORDERS   
group by ORDERS.PRODUCT 
order by [Количество заказанных товаров] desc

select  OFFICES.OFFICE, OFFICES.CITY,  sum(ORDERS.QTY) [Количество проданных товаров] from ORDERS
join SALESREPS on SALESREPS.EMPL_NUM = ORDERS.REP
join OFFICES ON  OFFICES.OFFICE = SALESREPS.REP_OFFICE
group by OFFICES.OFFICE, OFFICES.CITY
order by OFFICES.CITY