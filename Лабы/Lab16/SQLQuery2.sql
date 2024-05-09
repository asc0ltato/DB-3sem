use UNIVER;
use Ж_MyBase
--1. Разработать сценарий создания XML-документа в режиме PATH из таблицы TEACHER для 
--преподавателей кафедры ИСиТ. 
select TEACHER [Код_преподавателя], TEACHER_NAME [Имя_преподавателя], GENDER [Пол],
PULPIT [Кафедра] from TEACHER where PULPIT = 'ИСиТ'
for xml path('Преподаватель'), root('Список_преподавателей_кафедры_ИСиТ'), elements;

----------------------------------------------------------------------------------------
SELECT Клиенты.ID [Код_клиента], Клиенты.Название_фирмы_клиента [Название_фирмы],
Клиенты.Адрес [Адрес_фирмы], Кредиты.Номер_кредита [Номер_кредита],
Виды_кредитов.Название_вида_кредита [Название_вида_кредита],
Виды_кредитов.Ставка [Ставка_кредита] FROM Клиенты
INNER JOIN Кредиты ON Клиенты.ID = Кредиты.ID_клиента
INNER JOIN Виды_кредитов ON Кредиты.Код_кредита = Виды_кредитов.Код
WHERE Клиенты.Вид_собственности = 'Кафе'
FOR XML PATH('Клиент'), ROOT('Список_клиентов_кафе'), ELEMENTS;

--2. Разработать сценарий создания XML-документа в режиме AUTO на основе SELECT-запроса к 
--таблицам AUDITORIUM и AUDITORIUM_TYPE, который содержит следующие столбцы: наименование 
--аудитории, наименование типа аудитории и вместимость. Найти только лекционные аудитории. 
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [Тип_аудитории],
		  AUDITORIUM.AUDITORIUM_TYPE [Наименование_типа_аудитории],
		  AUDITORIUM.AUDITORIUM_CAPACITY [Вместимость_аудитории]
		  from AUDITORIUM
		  inner join AUDITORIUM_TYPE on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM_TYPE.AUDITORIUM_TYPE like '%ЛК%'
order by [Тип_аудитории]
for xml auto, root('Список_Аудиторий'), elements;

----------------------------------------------------------------------------------------
SELECT Виды_кредитов.Название_вида_кредита [Тип_кредита], Виды_кредитов.Код [Код_кредита],
Виды_кредитов.Ставка [Ставка] FROM Виды_кредитов
WHERE Виды_кредитов.Название_вида_кредита LIKE '%Микро-Бизнес%'
ORDER BY [Тип_кредита]
FOR XML AUTO, ROOT('Список_Кредитов'), ELEMENTS;

--3. Разработать XML-документ, содержащий данные о трех новых учебных дисциплинах, которые
--следует добавить в таблицу SUBJECT. Разработать сценарий, извлекающий данные о дисциплинах
--из XML-документа и добавляющий их в таблицу SUBJECT. При этом применить системную функцию
--OPENXML и конструкцию INSERT… SELECT.
go
declare @i int = 0,
	@xml varchar(2000) = '<?xml version="1.0" encoding="windows-1251" ?>
       <SUBJECTS> 
		<SUBJECT SUBJECT="АнглЯз" SUBJECT_NAME="Английский язык" PULPIT="ИСиТ" /> 
		<SUBJECT SUBJECT="ПВС"	SUBJECT_NAME="Программирование встроенных систем" PULPIT="ИСиТ" /> 
		<SUBJECT SUBJECT="БелЯз" SUBJECT_NAME="Белорусский язык" PULPIT="ИСиТ" /> 
       </SUBJECTS>'
exec sp_xml_preparedocument @i output, @xml
select * from openxml(@i, '/SUBJECTS/SUBJECT', 0)
with ([SUBJECT] char(10), [SUBJECT_NAME] nvarchar(100), [PULPIT] char(20))


insert SUBJECT select [SUBJECT], [SUBJECT_NAME], [PULPIT]
from openxml(@i, '/SUBJECTS/SUBJECT', 0)
with ([SUBJECT] char(10), [SUBJECT_NAME] nvarchar(100), [PULPIT] char(20)) 
select * from SUBJECT
exec sp_xml_removedocument @i;

delete from SUBJECT where SUBJECT = 'АнглЯз'
delete from SUBJECT where SUBJECT = 'ПВС'
delete from SUBJECT where SUBJECT = 'БелЯз'

----------------------------------------------------------------------------------------
DECLARE @i int = 0,
    @xml varchar(2000) = '<?xml version="1.0" encoding="windows-1251" ?>
       <CREDITS> 
		<CREDIT CODE="123456" NAME="Новое название" RATE="2000" /> 
		<CREDIT CODE="654321" NAME="Другое название" RATE="3000" /> 
		<CREDIT CODE="987654" NAME="Еще одно название" RATE="4000" /> 
       </CREDITS>';
EXEC sp_xml_preparedocument @i OUTPUT, @xml;
INSERT Виды_кредитов SELECT [CODE], [NAME], [RATE]
FROM OPENXML(@i, '/CREDITS/CREDIT', 0) WITH ([CODE] nvarchar(20), [NAME] nvarchar(50), [RATE] real);
SELECT * FROM Виды_кредитов;
EXEC sp_xml_removedocument @i;

DELETE FROM Виды_кредитов WHERE Код = '275843';
DELETE FROM Виды_кредитов WHERE Код = '356345';
DELETE FROM Виды_кредитов WHERE Код = '324253';

--4. Используя таблицу STUDENT разработать XML-структуру, содержащую паспортные данные 
--студента: серию и номер паспорта, личный номер, дата выдачи и адрес прописки. Разработать
--сценарий, в который включен оператор INSERT, добавляющий строку с XML-столбцом.Включить в этот
--же сценарий оператор UPDATE, изменяющий столбец INFO у одной строки таблицы STUDENT и 
--оператор SELECT, формирующий результирующий набор, аналогичный представленному на рисунке. 
--В SELECT-запросе использовать методы QUERY и VALUEXML-типа.
insert into STUDENT (IDGROUP,NAME,BDAY,INFO)
values ( 1,'Жук Светлана Сергеевна', '2004-10-20',
'<студент>
	<паспорт серия="MC" номер="1111111" дата="14.10.2019"/>
	<телефон>+37525711651</телефон>
	<адрес>
		   <страна>Беларусь</страна>
		   <город>Крупки</город>
		   <улица>Советская</улица>
		   <дом>10</дом>
		   <квартира>11</квартира>
	</адрес>
</студент>')

update STUDENT set INFO= '
<студент>
	<паспорт серия="MP" номер="1234567" дата="13.03.2022"/>
	<телефон>+375331415499</телефон>
	<адрес>
		   <страна>Беларусь</страна>
		   <город>Минск</город>
		   <улица>Белорусская</улица>
		   <дом>21</дом>
		   <квартира>702</квартира>
	</адрес>
</студент>' where INFO.value('(студент/адрес/город)[1]','varchar(10)')='Крупки';

select NAME, 
INFO.value('(/студент/паспорт/@серия)[1]','varchar(10)') [Серия],
INFO.value('(/студент/паспорт/@номер)[1]', 'varchar(10)') [Номер паспорта],
INFO.query('/студент/адрес')[Адрес]
from  STUDENT;

delete from STUDENT where NAME = 'Жук Светлана Сергеевна'

---------------------------------------------------------------------------------------------
INSERT INTO Виды_кредитов (Код, Название_вида_кредита, Ставка)
VALUES (
    '123456', 
    'Кредит XYZ',
    2500 
);

UPDATE Виды_кредитов
SET Название_вида_кредита = 'Обновленное название'
WHERE Название_вида_кредита = 'Старое название';

SELECT * FROM Виды_кредитов;

DELETE FROM Виды_кредитов WHERE Название_вида_кредита = 'Удаляемый кредит';

--5. Изменить (ALTER TABLE) таблицу STUDENT в базе данных UNIVER таким образом, чтобы значения
--типизированного столбца с именем INFO контролировались коллекцией XML-схем 
--(XML SCHEMACOLLECTION), представленной в правой части. Разработать сценарии, демонстрирующие
--ввод и корректировку данных (операторы INSERT и UPDATE) в столбец INFO таблицы STUDENT, как
--содержащие ошибки, так и правильные.Разработать другую XML-схему и добавить ее в коллекцию 
--XML-схем в БД UNIVER.
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
       <xs:element name="студент">  
       <xs:complexType><xs:sequence>
       <xs:element name="паспорт" maxOccurs="1" minOccurs="1">
       <xs:complexType>
       <xs:attribute name="серия" type="xs:string" use="required" />
       <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
       <xs:attribute name="дата"  use="required" >  
       <xs:simpleType>  <xs:restriction base ="xs:string">
   <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
   </xs:restriction> 	</xs:simpleType>
   </xs:attribute> </xs:complexType> 
   </xs:element>
   <xs:element maxOccurs="3" name="телефон" type="xs:string"/>
   <xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
   </xs:sequence></xs:complexType>  </xs:element>
   </xs:sequence></xs:complexType>
   </xs:element>
</xs:schema>';

alter table STUDENT alter column INFO xml(Student)

drop XML SCHEMA COLLECTION Student;

---------------------------------------------------------------------------------------------
CREATE XML SCHEMA COLLECTION CreditSchema AS 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
       <xs:element name="кредит">  
       <xs:complexType><xs:sequence>
       <xs:element name="Код" type="xs:string" />
       <xs:element name="Название_вида_кредита" type="xs:string" />
       <xs:element name="Ставка" type="xs:decimal" />
       </xs:sequence></xs:complexType>
       </xs:element>
</xs:schema>';

ALTER TABLE Виды_кредитов ALTER COLUMN INFO xml(CreditSchema);

DROP XML SCHEMA COLLECTION CreditSchema;

--7*. Разработать SELECT-запрос, формирующий XML-фрагмент такой же структуры, как фрагмент 
--на рисунке ниже, содержащий описание структуры вуза, включающей перечень факультетов, 
--кафедр и преподавателей. Разработать сценарий, демонстрирующий работу SELECT-запроса. 
--Примечание: использовать подзапросы, режим PATH и ключевое слово TYPE (TYPE указывает на то,
--что формируемый XML-фрагмент следует рассматривать как вложенный).
select rtrim(FACULTY.FACULTY) as '@код',
(select count(*) from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY) as 'количество_кафедр',
(select rtrim(PULPIT.PULPIT) as '@код',
(select rtrim(TEACHER.TEACHER) as 'преподаватель/@код', TEACHER.TEACHER_NAME as 'преподаватель'

from TEACHER where TEACHER.PULPIT = PULPIT.PULPIT for xml path(''),type, root('преподаватели'))
from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY for xml path('кафедра'), type, root('кафедры'))
from FACULTY for xml path('факультет'), type, root('университет')