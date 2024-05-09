use master 

create database UNIVER
drop database UNIVER
use UNIVER

drop table PROGRESS
drop table STUDENT
drop table GROUPS
drop table SUBJECT
drop table TEACHER
drop table  PULPIT
drop table PROFESSION
drop table FACULTY
drop table AUDITORIUM 
drop table AUDITORIUM_TYPE  

------------Создание и заполнение таблицы AUDITORIUM_TYPE 

create table AUDITORIUM_TYPE 
(    AUDITORIUM_TYPE  nchar(10) constraint AUDITORIUM_TYPE_PK  primary key,  
      AUDITORIUM_TYPENAME  nvarchar(30)       
 )
insert into AUDITORIUM_TYPE   (AUDITORIUM_TYPE,  AUDITORIUM_TYPENAME )        values (N'ЛК',            N'Лекционная');
insert into AUDITORIUM_TYPE   (AUDITORIUM_TYPE,  AUDITORIUM_TYPENAME )         values (N'ЛБ-К',          N'Компьютерный класс');
insert into AUDITORIUM_TYPE   (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )         values (N'ЛК-К',          N'Лекционная с уст. проектором');
insert into AUDITORIUM_TYPE   (AUDITORIUM_TYPE,  AUDITORIUM_TYPENAME )          values  (N'ЛБ-X',          N'Химическая лаборатория');
insert into AUDITORIUM_TYPE   (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )        values  (N'ЛБ-СК',   N'Спец. компьютерный класс');
                      
-------------Создание и заполнение таблицы AUDITORIUM  
  create table AUDITORIUM 
(   AUDITORIUM   nchar(20)  constraint AUDITORIUM_PK  primary key,              
    AUDITORIUM_TYPE     nchar(10) constraint  AUDITORIUM_AUDITORIUM_TYPE_FK foreign key         
                      references AUDITORIUM_TYPE(AUDITORIUM_TYPE), 
   AUDITORIUM_CAPACITY  integer constraint  AUDITORIUM_CAPACITY_CHECK default 1  check (AUDITORIUM_CAPACITY between 1 and 300),  -- вместимость 
   AUDITORIUM_NAME      nvarchar(50)                                     
)
insert into  AUDITORIUM   (AUDITORIUM, AUDITORIUM_NAME,  
 AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)   
values  (N'206-1', N'206-1' , N'ЛБ-К', 15);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, 
AUDITORIUM_TYPE, AUDITORIUM_CAPACITY) 
values  (N'301-1',   N'301-1', N'ЛБ-К', 15);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, 
AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )   
values  (N'236-1',   N'236-1', N'ЛК',   60);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, 
AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )  
values  (N'313-1',   N'313-1', N'ЛК-К',   60);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, 
AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )  
values  (N'324-1',   N'324-1', N'ЛК-К',   50);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, 
AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )   
 values  (N'413-1',   N'413-1', N'ЛБ-К', 15);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, 
AUDITORIUM_TYPE, AUDITORIUM_CAPACITY ) 
values  (N'423-1',   N'423-1', N'ЛБ-К', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, 
AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )     
values  (N'408-2',   N'408-2', N'ЛК',  90);

  ------Создание и заполнение таблицы FACULTY
  create table FACULTY
  (    FACULTY      nchar(10)   constraint  FACULTY_PK primary key,
       FACULTY_NAME  nvarchar(50) default N'???'
  );
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  (N'ИДиП',   N'Химическая технология и техника');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  (N'ХТиТ',   N'Химическая технология и техника');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  (N'ЛХФ',     N'Лесохозяйственный факультет');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  (N'ИЭФ',     N'Инженерно-экономический факультет');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  (N'ТТЛП',    N'Технология и техника лесной промышленности');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  (N'ТОВ',     N'Технология органических веществ');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  (N'ИТ',     N'Факультет информационных технологий');  
------Создание и заполнение таблицы PROFESSION
   create table PROFESSION
  (   PROFESSION   nchar(20) constraint PROFESSION_PK  primary key,
       FACULTY    nchar(10) constraint PROFESSION_FACULTY_FK foreign key 
                            references FACULTY(FACULTY),
       PROFESSION_NAME nvarchar(100),    QUALIFICATION   nvarchar(50)  
  );  
 insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION)    values    (N'ИТ',  N'1-40 01 02',   N'Информационные системы и технологии', N'инженер-программист-системотехник' );
 insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION)    values    (N'ИТ',  N'1-47 01 01', N'Издательское дело', N'редактор-технолог' );
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)    values    (N'ИТ',  N'1-36 06 01',  N'Полиграфическое оборудование и системы обработки информации', N'инженер-электромеханик' );                     
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)  values    (N'ХТиТ',  N'1-36 01 08',    N'Конструирование и производство изделий из композиционных материалов', N'инженер-механик' );
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)      values    (N'ХТиТ',  N'1-36 07 01',  N'Машины и аппараты химических производств и предприятий строительных материалов', N'инженер-механик' );
 insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION)  values    (N'ЛХФ',  N'1-75 01 01',      N'Лесное хозяйство', N'инженер лесного хозяйства' );
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)   values    (N'ЛХФ',  N'1-75 02 01',   N'Садово-парковое строительство', N'инженер садово-паркового строительства' );
 insert into PROFESSION(FACULTY, PROFESSION,     PROFESSION_NAME, QUALIFICATION)   values    (N'ЛХФ',  N'1-89 02 02',     N'Туризм и природопользование', N'специалист в сфере туризма' );
 insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION)  values    (N'ИЭФ',  N'1-25 01 07',  N'Экономика и управление на предприятии', N'экономист-менеджер' );
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)      values    (N'ИЭФ',  N'1-25 01 08',    N'Бухгалтерский учет, анализ и аудит', N'экономист' );                      
 insert into PROFESSION(FACULTY, PROFESSION,     PROFESSION_NAME, QUALIFICATION)  values    (N'ТТЛП',  N'1-36 05 01',   N'Машины и оборудование лесного комплекса', N'инженер-механик' );
 insert into PROFESSION(FACULTY, PROFESSION,   PROFESSION_NAME, QUALIFICATION)   values    (N'ТТЛП',  N'1-46 01 01',      N'Лесоинженерное дело', N'инженер-технолог' );
 insert into PROFESSION(FACULTY, PROFESSION,     PROFESSION_NAME, QUALIFICATION)      values    (N'ТОВ',  N'1-48 01 02',  N'Химическая технология органических веществ, материалов и изделий', N'инженер-химик-технолог' );                
 insert into PROFESSION(FACULTY, PROFESSION,   PROFESSION_NAME, QUALIFICATION)    values    (N'ТОВ',  N'1-48 01 05',    N'Химическая технология переработки древесины', N'инженер-химик-технолог' ); 
 insert into PROFESSION(FACULTY, PROFESSION,    PROFESSION_NAME, QUALIFICATION)  values    (N'ТОВ',  N'1-54 01 03',   N'Физико-химические методы и приборы контроля качества продукции', N'инженер по сертификации' ); 

------Создание и заполнение таблицы PULPIT
  create table  PULPIT 
(   PULPIT   nchar(20)  constraint PULPIT_PK  primary key,
    PULPIT_NAME  nvarchar(100), 
    FACULTY   nchar(10)   constraint PULPIT_FACULTY_FK foreign key 
                         references FACULTY(FACULTY) 
);  
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
  values  (N'ХТЭПиМЭЕ', N'Информационных систем и технологий' , N'ИТ'  )
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
  values  (N'ТНХСиППМ', N'Информационных систем и технологий' , N'ИТ'  )
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
  values  (N'ОВ', N'Информационных систем и технологий' , N'ИТ'  )
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
  values  (N'ПОиСОИ', N'Информационных систем и технологий' , N'ИТ'  )
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
  values  (N'ИСиТ', N'Информационных систем и технологий' , N'ИТ'  )
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
    values  (N'ЛВ', N'Лесоводства' , N'ЛХФ')          
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
   values  (N'ЛУ', N'Лесоустройства' , N'ЛХФ')           
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
  values  (N'ЛЗиДВ', N'Лесозащиты и древесиноведения' , N'ЛХФ')                
insert into PULPIT   (PULPIT,  PULPIT_NAME, FACULTY)
   values  (N'ЛКиП', N'Лесных культур и почвоведения' , N'ЛХФ') 
insert into PULPIT   (PULPIT,  PULPIT_NAME, FACULTY)
   values  (N'ТиП', N'Туризма и природопользования' , N'ЛХФ')              
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
   values  (N'ЛПиСПС' , N'Ландшафтного проектирования и садово-паркового строительства' , N'ЛХФ')          
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
   values  (N'ТЛ', N'Транспорта леса', N'ТТЛП')                          
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
   values  (N'ЛМиЛЗ' , N'Лесных машин и технологии лесозаготовок' , N'ТТЛП')  
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
   values  (N'ТДП' , N'Технологий деревообрабатывающих производств', N'ТТЛП')   
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
values  (N'ТиДИД' , N'Технологии и дизайна изделий из древесины' , N'ТТЛП')    
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
values  (N'ОХ', N'Органической химии' , N'ТОВ') 
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
 values  (N'ХПД' , N'Химической переработки древесины' , N'ТОВ')             
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
 values  (N'ТНВиОХТ' , N'Технологии неорганических веществ и общей химической технологии' , N'ХТиТ') 
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
    values  (N'ПиАХП' , N'Процессов и аппаратов химических производств' , N'ХТиТ')                                               
insert into PULPIT   (PULPIT,    PULPIT_NAME, FACULTY)
values  (N'ЭТиМ',    N'Экономической теории и маркетинга' , N'ИЭФ')   
insert into PULPIT   (PULPIT,    PULPIT_NAME, FACULTY)
  values  (N'МиЭП',   N'Менеджмента и экономики природопользования' , N'ИЭФ')   
insert into PULPIT   (PULPIT,    PULPIT_NAME, FACULTY)
   values  (N'СБУАиА', N'Статистики, бухгалтерского учета, анализа и аудита', N'ИЭФ')     
             
------Создание и заполнение таблицы TEACHER
 create table TEACHER
 (   TEACHER    nchar(10)  constraint TEACHER_PK  primary key,
     TEACHER_NAME  nvarchar(100), 
     GENDER     nchar(1) CHECK (GENDER in (N'м', N'ж')),
     PULPIT   nchar(20) constraint TEACHER_PULPIT_FK foreign key 
                         references PULPIT(PULPIT) 
 );
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
                       values  (N'СМЛВ',    N'Смелов Владимир Владиславович', N'м',  N'ИСиТ');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'АКНВЧ',    N'Акунович Станислав Иванович', N'м', N'ИСиТ');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'КЛСНВ',    N'Колесников Виталий Леонидович', N'м', N'ИСиТ');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'БРКВЧ',    N'Бракович Андрей Игоревич', N'м', N'ИСиТ');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'ДТК',     N'Дятко Александр Аркадьевич', N'м', N'ИСиТ');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'УРБ',     N'Урбанович Павел Павлович', N'м', N'ИСиТ');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                      values  (N'ГРН',     N'Гурин Николай Иванович', N'м', N'ИСиТ');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'ЖЛК',     N'Жиляк Надежда Александровна',  N'ж', N'ИСиТ');                     
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'МРЗ',     N'Мороз Елена Станиславовна',  N'ж',   N'ИСиТ');                                                                                           
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
             values  (N'БРТШВЧ',   N'Барташевич Святослав Александрович', N'м' , N'ПОиСОИ');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'АРС',     N'Арсентьев Виталий Арсентьевич', N'м', N'ПОиСОИ');                       
insert into  TEACHER    (TEACHER,  TEACHER_NAME,GENDER, PULPIT )
                       values  (N'БРНВСК',   N'Барановский Станислав Иванович', N'м', N'ЭТиМ');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'НВРВ',   N'Неверов Александр Васильевич', N'м', N'МиЭП');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'РВКЧ',   N'Ровкач Андрей Иванович', N'м', N'ЛВ');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'ДМДК', N'Демидко Марина Николаевна',  N'ж',  N'ЛПиСПС');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'БРГ',     N'Бурганская Татьяна Минаевна', N'ж', N'ЛПиСПС');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'РЖК',   N'Рожков Леонид Николаевич', N'м', N'ЛВ');                      
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'ЗВГЦВ',   N'Звягинцев Вячеслав Борисович', N'м', N'ЛЗиДВ'); 
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'БЗБРДВ',   N'Безбородов Владимир Степанович', N'м', N'ОХ'); 
insert into  TEACHER    (TEACHER,  TEACHER_NAME, GENDER, PULPIT )
                       values  (N'НСКВЦ',   N'Насковец Михаил Трофимович', N'м', N'ТЛ'); 
	------Создание и заполнение таблицы SUBJECT
create table SUBJECT
    (     SUBJECT  nchar(10) constraint SUBJECT_PK  primary key, 
           SUBJECT_NAME nvarchar(100) unique,
           PULPIT  nchar(20) constraint SUBJECT_PULPIT_FK foreign key 
                         references PULPIT(PULPIT)   
     )
 insert into SUBJECT   (SUBJECT,   SUBJECT_NAME, PULPIT )
                       values (N'СУБД',   N'Системы управления базами данных', N'ИСиТ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,  PULPIT)
                       values (N'БД',     N'Базы данных' , N'ИСиТ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,  PULPIT )
                       values (N'ИНФ',    N'Информационные технологии' , N'ИСиТ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,  PULPIT )
                       values (N'ОАиП',  N'Основы алгоритмизации и программирования', N'ИСиТ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,  PULPIT )
                       values (N'ПЗ',     N'Представление знаний в компьютерных системах', N'ИСиТ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,  PULPIT )
                       values (N'ПСП',    N'Программирование сетевых приложений', N'ИСиТ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,  PULPIT )
                       values (N'МСОИ',  N'Моделирование систем обработки информации', N'ИСиТ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,  PULPIT )
                       values (N'ПИС',     N'Проектирование информационных систем', N'ИСиТ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,  PULPIT )
                       values (N'КГ',      N'Компьютерная геометрия N' , N'ИСиТ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,  PULPIT )
           values (N'ПМАПЛ',   N'Полиграф. машины, автоматы и поточные линии', N'ПОиСОИ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,  PULPIT )
                       values (N'КМС',     N'Компьютерные мультимедийные системы', N'ИСиТ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME, PULPIT )
                       values (N'ОПП',     N'Организация полиграф. производства', N'ПОиСОИ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME, PULPIT)
                       values (N'ДМ',   N'Дискретная математика', N'ИСиТ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,PULPIT )
                      values (N'МП',   N'Математическое программирование' , N'ИСиТ');  
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME, PULPIT )
               values (N'ЛЭВМ', N'Логические основы ЭВМ',  N'ИСиТ');                   
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,PULPIT )
               values (N'ООП',  N'Объектно-ориентированное программирование', N'ИСиТ');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME, PULPIT )
                       values (N'ЭП', N'Экономика природопользования' , N'МиЭП')
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME, PULPIT )
                       values (N'ЭТ', N'Экономическая теория' , N'ЭТиМ')
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME, PULPIT )
                       values (N'БЛЗиПсOO' , N'Биология лесных зверей и птиц с осн. охотов.' , N'ОВ')
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME, PULPIT )
                       values (N'ОСПиЛПХ' , N'Основы садово-паркового и лесопаркового хозяйства',  N'ЛПиСПС')
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,PULPIT )
                       values (N'ИГ', N'Инженерная геодезия N' , N'ЛУ')
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,PULPIT )
                       values (N'ЛВ',    N'Лесоводство', N'ЛЗиДВ') 
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME, PULPIT )
                       values (N'ОХ',    N'Органическая химия', N'ОХ')   
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,PULPIT )
                       values (N'ТРИ',    N'Технология резиновых изделий' , N'ТНХСиППМ') 
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME, PULPIT )
                       values (N'ВТЛ',    N'Водный транспорт леса' , N'ТЛ')
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,PULPIT )
                       values (N'ТиОЛ',   N'Технология и оборудование лесозаготовок', N'ЛМиЛЗ') 
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,PULPIT )
                       values (N'ТОПИ',   N'Технология обогащения полезных ископаемых N' , N'ТНВиОХТ')
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME, PULPIT )
                       values (N'ПЭХ',    N'Прикладная электрохимия' , N'ХТЭПиМЭЕ')                                                                                                                                                           
  
------Создание и заполнение таблицы GROUPS
create table GROUPS 
(   IDGROUP  integer  identity(1,1) constraint GROUP_PK  primary key,              
    FACULTY   nchar(10) constraint  GROUPS_FACULTY_FK foreign key         
                                                         references FACULTY(FACULTY), 
     PROFESSION  nchar(20) constraint  GROUPS_PROFESSION_FK foreign key         
                                                         references PROFESSION(PROFESSION),
    YEAR_FIRST  smallint  check (YEAR_FIRST<=YEAR(GETDATE())),                  
  )
insert into GROUPS   (FACULTY,  PROFESSION, YEAR_FIRST )
         values (N'ИДиП', N'1-40 01 02', 2013), --1
                (N'ИДиП', N'1-40 01 02', 2012),
                (N'ИДиП', N'1-40 01 02', 2011),
                (N'ИДиП', N'1-40 01 02', 2010),
                (N'ИДиП', N'1-47 01 01', 2013),---5 гр
                (N'ИДиП', N'1-47 01 01', 2012),
                (N'ИДиП', N'1-47 01 01', 2011),
                (N'ИДиП', N'1-36 06 01', 2010),-----8 гр
                (N'ИДиП', N'1-36 06 01', 2013),
                (N'ИДиП', N'1-36 06 01', 2012),
                (N'ИДиП', N'1-36 06 01', 2011),
                (N'ХТиТ', N'1-36 01 08', 2013),---12 гр                                                  
                (N'ХТиТ', N'1-36 01 08', 2012),
                (N'ХТиТ', N'1-36 07 01', 2011),
                (N'ХТиТ', N'1-36 07 01', 2010),
                (N'ТОВ', N'1-48 01 02', 2012), ---16 гр 
                (N'ТОВ' , N'1-48 01 02', 2011),
                (N'ТОВ' , N'1-48 01 05', 2013),
                (N'ТОВ' , N'1-54 01 03', 2012),
                (N'ЛХФ' , N'1-75 01 01', 2013),--20 гр      
                (N'ЛХФ' , N'1-75 02 01', 2012),
                (N'ЛХФ' , N'1-75 02 01', 2011),
                (N'ЛХФ' , N'1-89 02 02', 2012),
                (N'ЛХФ' , N'1-89 02 02', 2011),  
                (N'ТТЛП' , N'1-36 05 01', 2013),
                (N'ТТЛП' , N'1-36 05 01', 2012),
                (N'ТТЛП' , N'1-46 01 01', 2012),--27 гр
                (N'ИЭФ' , N'1-25 01 07', 2013), 
                (N'ИЭФ' , N'1-25 01 07', 2012),     
                (N'ИЭФ' , N'1-25 01 07', 2010),
                (N'ИЭФ' , N'1-25 01 08', 2013),
                (N'ИЭФ' , N'1-25 01 08', 2012) ---32 гр       
                          
------Создание и заполнение таблицы STUDENT
create table STUDENT 
(    IDSTUDENT   integer  identity(1000,1) constraint STUDENT_PK  primary key,
      IDGROUP   integer  constraint STUDENT_GROUP_FK foreign key         
                      references GROUPS(IDGROUP),        
      NAME   nvarchar(100), 
      BDAY   date,
      STAMP  timestamp,
      INFO     xml,
      FOTO     varbinary
 ) 
insert into STUDENT (IDGROUP,NAME, BDAY)
    values (2, N'Силюк Валерия Ивановна',         N'12.07.1994'),
           (2, N'Сергель Виолетта Николаевна',    N'06.03.1994'),
           (2, N'Добродей Ольга Анатольевна',     N'09.11.1994'),
           (2, N'Подоляк Мария Сергеевна',        N'04.10.1994'),
           (2, N'Никитенко Екатерина Дмитриевна', N'08.01.1994'),
           (3, N'Яцкевич Галина Иосифовна',       N'02.08.1993'),
           (3, N'Осадчая Эла Васильевна',         N'07.12.1993'),
           (3, N'Акулова Елена Геннадьевна',      N'02.12.1993'),
           (4, N'Плешкун Милана Анатольевна',     N'08.03.1992'),
           (4, N'Буянова Мария Александровна',    N'02.06.1992'),
           (4, N'Харченко Елена Геннадьевна',     N'11.12.1992'),
           (4, N'Крученок Евгений Александрович', N'11.05.1992'),
           (4, N'Бороховский Виталий Петрович',   N'09.11.1992'),
           (4, N'Мацкевич Надежда Валерьевна',    N'01.11.1992'),
           (5, N'Логинова Мария Вячеславовна',    N'08.07.1995'),
           (5, N'Белько Наталья Николаевна',      N'02.11.1995'),
           (5, N'Селило Екатерина Геннадьевна',   N'07.05.1995'),
           (5, N'Дрозд Анастасия Андреевна',      N'04.08.1995'),
           (6, N'Козловская Елена Евгеньевна',    N'08.11.1994'),
           (6, N'Потапнин Кирилл Олегович',       N'02.03.1994'),
           (6, N'Равковская Ольга Николаевна',    N'04.06.1994'),
           (6, N'Ходоронок Александра Вадимовна', N'09.11.1994'),
           (6, N'Рамук Владислав Юрьевич',        N'04.07.1994'),
           (7, N'Неруганенок Мария Владимировна', N'03.01.1993'),
           (7, N'Цыганок Анна Петровна',          N'12.09.1993'),
           (7, N'Масилевич Оксана Игоревна',      N'12.06.1993'),
           (7, N'Алексиевич Елизавета Викторовна' , N'09.02.1993'),
           (7, N'Ватолин Максим Андреевич',       N'04.07.1993'),
           (8, N'Синица Валерия Андреевна',       N'08.01.1992'),
           (8, N'Кудряшова Алина Николаевна',     N'12.05.1992'),
           (8, N'Мигулина Елена Леонидовна',      N'08.11.1992'),
           (8, N'Шпиленя Алексей Сергеевич',      N'12.03.1992'),
           (9, N'Астафьев Игорь Александрович',   N'10.08.1995'),
           (9, N'Гайтюкевич Андрей Игоревич',     N'02.05.1995'),
           (9, N'Рученя Наталья Александровна',   N'08.01.1995'),
           (9, N'Тарасевич Анастасия Ивановна',   N'11.09.1995'),
           (10, N'Жоглин Николай Владимирович',   N'08.01.1994'),
           (10, N'Санько Андрей Дмитриевич',      N'11.09.1994'),
           (10, N'Пещур Анна Александровна',      N'06.04.1994'),
           (10, N'Бучалис Никита Леонидович',     N'12.08.1994')
insert into STUDENT (IDGROUP,NAME, BDAY)
    values (11, N'Лавренчук Владислав Николаевич' , N'07.11.1993'),
           (11, N'Власик Евгения Викторовна',     N'04.06.1993'),
           (11, N'Абрамов Денис Дмитриевич',      N'10.12.1993'),
           (11, N'Оленчик Сергей Николаевич',     N'04.07.1993'),
           (11, N'Савинко Павел Андреевич',       N'08.01.1993'),
           (11, N'Бакун Алексей Викторович',      N'02.09.1993'),
           (12, N'Бань Сергей Анатольевич',       N'11.12.1995'),
           (12, N'Сечейко Илья Александрович',    N'10.06.1995'),
           (12, N'Кузмичева Анна Андреевна',      N'09.08.1995'),
           (12, N'Бурко Диана Францевна',         N'04.07.1995'),
           (12, N'Даниленко Максим Васильевич',   N'08.03.1995'),
           (12, N'Зизюк Ольга Олеговна',          N'12.09.1995'),
           (13, N'Шарапо Мария Владимировна',     N'08.10.1994'),
           (13, N'Касперович Вадим Викторович',   N'10.02.1994'),
           (13, N'Чупрыгин Арсений Александрович' , N'11.11.1994'),
           (13, N'Воеводская Ольга Леонидовна',   N'10.02.1994'),
           (13, N'Метушевский Денис Игоревич',    N'12.01.1994'),
           (14, N'Ловецкая Валерия Александровна' , N'11.09.1993'),
           (14, N'Дворак Антонина Николаевна',    N'01.12.1993'),
           (14, N'Щука Татьяна Николаевна',       N'09.06.1993'),
           (14, N'Коблинец Александра Евгеньевна' , N'05.01.1993'),
           (14, N'Фомичевская Елена Эрнестовна',  N'01.07.1993'),
           (15, N'Бесараб Маргарита Вадимовна',   N'07.04.1992'),
           (15, N'Бадуро Виктория Сергеевна',     N'10.12.1992'),
           (15, N'Тарасенко Ольга Викторовна',    N'05.05.1992'),
           (15, N'Афанасенко Ольга Владимировна', N'11.01.1992'),
           (15, N'Чуйкевич Ирина Дмитриевна',     N'04.06.1992'),
           (16, N'Брель Алеся Алексеевна',        N'08.01.1994'),
           (16, N'Кузнецова Анастасия Андреевна', N'07.02.1994'),
           (16, N'Томина Карина Геннадьевна',     N'12.06.1994'),
           (16, N'Дуброва Павел Игоревич',        N'03.07.1994'),
           (16, N'Шпаков Виктор Андреевич',       N'04.07.1994'),
           (17, N'Шнейдер Анастасия Дмитриевна',  N'08.11.1993'),
           (17, N'Шыгина Елена Викторовна',       N'02.04.1993'),
           (17, N'Клюева Анна Ивановна',          N'03.06.1993'),
           (17, N'Доморад Марина Андреевна',      N'05.11.1993'),
           (17, N'Линчук Михаил Александрович',   N'03.07.1993'),
           (18, N'Васильева Дарья Олеговна',      N'08.01.1995'),
           (18, N'Щигельская Екатерина Андреевна' , N'06.09.1995'),
           (18, N'Сазонова Екатерина Дмитриевна', N'08.03.1995'),
           (18, N'Бакунович Алина Олеговна',      N'07.08.1995')

------Создание и заполнение таблицы PROGRESS
create table PROGRESS
 (  SUBJECT   nchar(10) constraint PROGRESS_SUBJECT_FK foreign key
                      references SUBJECT(SUBJECT),                
     IDSTUDENT integer  constraint PROGRESS_IDSTUDENT_FK foreign key         
                      references STUDENT(IDSTUDENT),        
     PDATE    date, 
     NOTE     integer check (NOTE between 1 and 10)
  )
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values  (N'ОАиП', 1001,  N'01.10.2013',8),
           (N'ОАиП', 1002,  N'01.10.2013',7),
           (N'ОАиП', 1003,  N'01.10.2013',5),
           (N'ОАиП', 1005,  N'01.10.2013',4)
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values   (N'СУБД', 1014,  N'01.12.2013',5),
           (N'СУБД', 1015,  N'01.12.2013',9),
           (N'СУБД', 1016,  N'01.12.2013',5),
           (N'СУБД', 1017,  N'01.12.2013',4)
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values (N'КГ',   1018,  N'06.5.2013',4),
           (N'КГ',   1019,  N'06.05.2013',7),
           (N'КГ',   1020,  N'06.05.2013',7),
           (N'КГ',   1021,  N'06.05.2013',9),
           (N'КГ',   1022,  N'06.05.2013',5),
           (N'КГ',   1023,  N'06.05.2013',6)

