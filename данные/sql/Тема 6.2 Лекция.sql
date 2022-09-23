Команды добавления данных (Insert);

INSERT INTO <table_name> ("column1", "column2", ...)
VALUES ("value1", "value2", ...);

Команда Insert Into Select

INSERT INTO "table1" ("column1", "column2", ...)
SELECT "column3", "column4", ...
FROM "table2";

Команда обновления (Update)

UPDATE "table_name"
SET "column_1" = "new value 1", "column_2"= "new value 2"
WHERE "condition";

Команда удаления данных (Delete)

DELETE FROM "table_name"
WHERE "condition";




Структура sql-запросов

/* Комментарий 

многострочный*/

-- Комментарий в одну строку

Общая структура запроса выглядит следующим образом:
WITH 'имя_производной_таблицы' ('список_столбцов') AS ('подзапрос') -- необязательно
SELECT [DISTINCT] ('столбцы или * для выбора всех столбцов') AS 'псевдоним' -- обязательно
FROM ('таблица A/ таблица1 (LEFT, RIGHT) JOIN таблица2 ON условие_соединения') -- обязательно
WHERE ('условие/фильтрация, например, city = 'Moscow'') /* необязательно, операции сравнения: =  <  >  <=  >=  <> !=
условие поиска: AND OR NOT */
GROUP BY ('столбец, по которому хотим сгруппировать данные') -- необязательно
HAVING ('условие/фильтрация на уровне сгруппированных данных') -- необязательно
ORDER BY ('столбец, по которому хотим отсортировать вывод') -- необязательно
LIMIT 'количество'; -- Срез строк

База данных bank

НАЗВАНИЕ ТАБЛИЦЫ	ЗНАЧЕНИЕ
ACCOUNT	Таблица хранящая банковский счет. Каждый клиет может зарегистрировать несколько счетов, 
каждый счет соответствует услуге предоставленной банком.
ACC_TRANSACTION	Таблица хранящая информацию транзакции с банком определенного счета.
BRANCH	Филиал банка
BUSSINESS	 
CUSTOMER	Таблица клиентов
DEPARTMENT	Таблица департаментов банка.
EMPLOYEE	Таблица работников банка.
OFFICER	 
PRODUCT	Продукты услуг банка, например: Депозитные вклады Выдача кредитов Выдача кредитов малым бизнесам
PRODUCT_TYPE	Продукты услуг банка, например: Счет клиента Выдача кредитов лично и бизнесам Предоставление страхования




SELECT, FROM

SELECT, FROM — обязательные элементы запроса, 
которые определяют выбранные столбцы, их порядок и источник данных.

Выбрать все (обозначается как *) из таблицы Customers;

SELECT * FROM Customer;

Выбрать столбцы CUST_ID, ADDRESS из таблицы Customer;

SELECT CUST_ID, ADDRESS FROM Customer;




WHERE

WHERE — необязательный элемент запроса, который используется, 
когда нужно отфильтровать данные по нужному условию. 
Очень часто внутри элемента where используются IN / NOT IN для фильтрации столбца по нескольким значениям, 
AND / OR для фильтрации таблицы по нескольким столбцам.

Фильтрация по одному условию и одному значению;

select * from Customer
WHERE City = 'Newton';

Фильтрация по одному условию и нескольким значениям с применением IN (включение) 
или NOT IN (исключение);

select * from Customer
where City IN ('Newton', 'Salem');

select * from Customer
where City NOT IN ('Newton', 'Salem','Woburn');

Фильтрация по нескольким условиям с применением AND (выполняются все условия) 
или OR (выполняется хотя бы одно условие) и нескольким значениям;

select * from Customer
where (STATE = 'MA') AND (City not in ('Newton', 'Salem','Woburn')) AND (CUST_ID > 5);

select * from Customer
where City in ('Newton', 'Salem') OR CUST_ID > 10;

Есть 2 специальных знака в SQL:
Знак %
Знак _
Значение:
% описывает 0, 1 или разные знаки.
_ описывает точно один знак.
Эти два знака обычно используются в условии LIKE;

Select Cus.Cust_Id
     ,Cus.Fed_Id
     ,Cus.Address
From   Customer Cus
where cus.fed_id like '%-__-%';





GROUP BY

GROUP BY — необязательный элемент запроса, с помощью которого можно задать 
агрегацию по нужному столбцу (например, если нужно узнать какое количество клиентов живет в каждом из городов).

При использовании GROUP BY обязательно:

перечень столбцов, по которым делается разрез, был одинаковым внутри SELECT и внутри GROUP BY,
агрегатные функции (SUM, AVG, COUNT, MAX, MIN) должны быть также указаны 
внутри SELECT с указанием столбца, к которому такая функция применяется.

Группировка количества клиентов по городу;

select City, count(CUST_ID) from Customer
GROUP BY City;

Группировка количества клиентов поштату и городу;

select STATE, CITY, count(CUST_ID) from Customer
GROUP BY STATE, CITY;

Группировка счетов по ID продукта с разными агрегатными функциями: 
количество счетов по банковскому продукту и сумма баланса на этих счетах;


select PRODUCT_CD as 'Продукт', COUNT(ACCOUNT_ID) as 'Количество', SUM(AVAIL_BALANCE) from account
GROUP BY PRODUCT_CD;

Группировка с фильтрацией исходной таблицы. 
В данном случае на выходе будет таблица с количеством клиентов по городам одного штата;


select City, count(CUST_ID) from Customer
WHERE STATE = 'MA'
GROUP BY City;

Переименование столбца с агрегацией с помощью оператора AS. 
По умолчанию название столбца с агрегацией равно примененной агрегатной функции, что далее может быть не очень удобно для восприятия;

select City, count(CUST_ID) 
AS 'Количество' 
from Customer
group by City;





HAVING

HAVING — необязательный элемент запроса, который отвечает за фильтрацию 
на уровне сгруппированных данных (по сути, WHERE, но только на уровень выше).

Фильтрация агрегированной таблицы с количеством клиентов по городам, 
в данном случае оставляем в выгрузке только те города, в которых не менее 5 клиентов;


select City, count(CUST_ID) from Customer
group by City
HAVING count(CUST_ID) >= 2; 


В случае с переименованным столбцом внутри HAVING можно указать как 
и саму агрегирующую конструкцию count(CUST_ID), так и новое название столбца number_of_clients;


select City, count(CUST_ID) as number_of_clients from Customer
group by City
HAVING number_of_clients >= 2;

Пример запроса, содержащего WHERE и HAVING. 
В данном запросе сначала фильтруется исходная таблица по пользователям,
 рассчитывается количество клиентов по городам и остаются только те города, 
 где количество клиентов не менее 5;

select City, count(CUST_ID) as number_of_clients from Customer
WHERE CUST_TYPE_CD not in ('B')
group by City
HAVING city like 'S%';

select City, count(CUST_ID) as number_of_clients from Customer
WHERE CUST_TYPE_CD not in ('B')
group by City
HAVING number_of_clients >= 2;


Различие Where & Having

Вам нужно различать между Where и Having в одной команде.
Where это команда, которая фильтрует данные перед группировкой (Group)
Having это команда, которая фильтрует данные после группировки (Group)
Если вы хотите иметь общую информацию филиала банка (Таблица BRANCH). 
Вы можете использовать where, чтобы отфильтровать данные перед группировкой (group);

Select Acc.Product_Cd
     ,Count(Acc.Product_Cd) As Count_Acc
     ,Sum(Acc.Avail_Balance) As Sum_Avail_Balance
     ,Avg(Acc.Avail_Balance) As Avg_Avail_Balance
From   Account Acc
Where  Acc.Open_Branch_Id = 1
Group  By Acc.Product_Cd
Having Count(Acc.Product_Cd) > 1;




ORDER BY

ORDER BY — необязательный элемент запроса, который отвечает за сортировку таблицы.

Простой пример сортировки по одному столбцу. 
В данном запросе осуществляется сортировка по городу, который указал клиент;

select * from Customer
ORDER BY City;

Осуществлять сортировку можно и по нескольким столбцам, 
в этом случае сортировка происходит по порядку указанных столбцов;

select * from Customer
ORDER BY STATE, City;

По умолчанию сортировка происходит по возрастанию для чисел 
и в алфавитном порядке для текстовых значений. 
Если нужна обратная сортировка, то в конструкции ORDER BY после названия столбца надо добавить DESC;

select * from Customer
order by CUST_ID DESC;

Обратная сортировка по одному столбцу и сортировка по умолчанию по второму;

select * from Customer
order by STATE DESC, City;




JOIN

JOIN — необязательный элемент, используется для объединения таблиц по ключу, 
который присутствует в обеих таблицах. Перед ключом ставится оператор ON.

Запрос, в котором соединяем таблицы account и Customer по ключу CUST_ID, 
при этом перед названиям столбца ключа добавляется название таблицы через точку;

select * from account
JOIN Customer ON account.CUST_ID = Customer.CUST_ID;

Нередко может возникать ситуация, 
когда надо промэппить одну таблицу значениями из другой. 
В зависимости от задачи, могут использоваться разные типы присоединений. 
INNER JOIN — пересечение, RIGHT/LEFT JOIN для мэппинга одной таблицы знаениями из другой,

Внутри всего запроса JOIN встраивается после элемента from до элемента where, пример запроса;

select * from account
join Customer on account.CUST_ID = Customer.CUST_ID
where Customer.CUST_ID >10;



