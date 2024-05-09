create procedure FirstTask @n nvarchar(20) as 
begin
select s2.NAME from SALESREPS s1
inner join SALESREPS s2 on s1.REP_OFFICE = s2.REP_OFFICE
inner join OFFICES on s1.REP_OFFICE = OFFICES.OFFICE
and s1.NAME = @n;
return 1;
end;

go 
exec FirstTask @n = 'Paul Cruz';

drop procedure FirstTask

go
create function SecondTask (@name varchar(10)) returns int as 
begin
declare @res int = 0;
set @res = (select s2.NAME from SALESREPS s1 
inner join SALESREPS s2 on s1.REP_OFFICE = s2.REP_OFFICE
inner join OFFICES on s1.MANAGER = OFFICES.MGR
and s1.NAME = @name);
return @res;
end;

go
declare @s2 int = dbo.SecondTask('Larry Fitch'); 
print 'Фамилия начальника сотрудника' + cast(@s2 as nvarchar(10));

drop function SecondTask;