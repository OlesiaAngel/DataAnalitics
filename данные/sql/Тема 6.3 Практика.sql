
-- ------------------------------------- БД BANK -----------------------------------------------

/* LIMIT, NULL, объединение значений из столбцов  */

/*SELECT column_name(s)
FROM table_name
WHERE condition
LIMIT number;*/


SELECT 
    first_name
FROM
    employee
WHERE
    (end_date IS NULL)
LIMIT 4;


SELECT 
    first_name
FROM
    employee
WHERE
    (end_date IS NULL)
LIMIT 4 OFFSET 2;

--  ------------------------------ UNION   ----------------------------------------------
-- Оператор UNION используется для объединения двух и более запросов оператора SELECT.
/* SELECT column_name(s) FROM table1
UNION
SELECT column_name(s) FROM table2;
*/
/* Каждый из операторов SQL SELECT должен иметь в своем запросе одинаковое количество столбцов 
и типы возвращаемых данных, иначе произойдет ошибка при формировании результирующей таблицы.
*/

SELECT 
    cust_id
FROM
    customer 
UNION SELECT 
    city
FROM
    customer;


 -- ----------------------------- JOIN -------------------------------------------------

/* SQL Join Работа с несколькими таблицами.  
INNER JOIN   (JOIN)
LEFT OUTER JOIN  (LEFT JOIN)
RIGHT OUTER JOIN (RIGHT JOIN)
FULL OUTER JOIN    (OUTER JOIN)
CROSS JOIN */ 

/*  INNER JOIN (Или JOIN)
SELECT column_name(s)
FROM table1, table2, table3
where table1.column_name=table2.column_name and table1.column_name=table3.column_name;

SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name=table2.column_name;
----------------------------------------------------------------
LEFT OUTER JOIN (Или LEFT JOIN)

SELECT column_name(s)
FROM table1
LEFT JOIN table2
ON table1.column_name=table2.column_name;

------------------------------------------------------------------
FULL OUTER JOIN (Или OUTER JOIN или FULL JOIN)

SELECT columns
FROM table1
FULL [OUTER] JOIN table2
ON table1.column = table2.column;*/

-- 1. Вывести сотрудника и название отдела, в котором он работает

SELECT 
    emp.EMP_ID,
    CONCAT(emp.first_name, ' ', emp.last_name) as 'ФИО',
    dep.NAME as 'Отдел'
FROM
    employee emp
        JOIN
    department dep ON emp.DEPT_ID = dep.DEPT_ID
ORDER BY emp.EMP_ID;

-- 2. Вывести список клиентов, дополнить информацией из таблицы OFFICER (должность занимает данный клиент)

SELECT 
    *
FROM
    customer c
        LEFT JOIN
    officer o ON c.CUST_ID = o.CUST_ID;
        

-- 3.  Вывести информацию по банковским счетам и фио сотрудника, который открыл этот счет.

SELECT 
    *
FROM
    account AS a
        JOIN
    employee e ON e.EMP_ID = a.OPEN_EMP_ID
        JOIN
    customer c ON c.CUST_ID = a.CUST_ID
WHERE
    a.AVAIL_BALANCE > 500
ORDER BY a.AVAIL_BALANCE DESC; 


/* Объединение таблиц с использование агрегатных функций 
Вывести ФИО сотрудника и общий баланс счетов, с которыми он работал
*/

SELECT 
    concat(e.first_name,' ',e.last_name) as fio,
    sum(a.AVAIL_BALANCE) as balans
FROM
    account AS a
        JOIN
    employee e ON e.EMP_ID = a.OPEN_EMP_ID
group by fio
order by balans;
 

/* Функции SQL  */
/* ROUND Округляет число до указанного количества знаков после запятой */

SELECT 
    concat(e.first_name,' ',e.last_name) as fio,
    round(sum(a.AVAIL_BALANCE),2) as balans
FROM
    account AS a
        JOIN
    employee e ON e.EMP_ID = a.OPEN_EMP_ID
group by fio
order by balans;


/* SUBSTRING() */

SELECT 
    concat(e.first_name,' ', substring(e.last_name,1,1), '.') as fio,
    round(sum(a.AVAIL_BALANCE),2) as balans
FROM
    account AS a
        JOIN
    employee e ON e.EMP_ID = a.OPEN_EMP_ID
group by fio
order by balans;



-- ------------------------------------ Оконные функции SQL  ---------------------------
/*
Оконные функции не уменьшают количество строк, 
а возвращают столько же значений, сколько получили на вход. 

Оконные функции не изменяют выборку, а только добавляют некоторую дополнительную информацию о ней.
 Для простоты понимания можно считать, что SQL сначала выполняет весь запрос 
 (кроме сортировки и limit), а уже потом считает значения окна.
*/

SELECT 
    SUM(AVAIL_BALANCE)
FROM
    account;

SELECT 
    PRODUCT_CD, round(SUM(AVAIL_BALANCE),2) as summa
FROM
    account
GROUP BY PRODUCT_CD;    

SELECT ACCOUNT_ID, AVAIL_BALANCE, PRODUCT_CD, round(SUM(AVAIL_BALANCE) OVER (partition by PRODUCT_CD),1) total_summa
FROM
    account; 

/* CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END; */

select ACCOUNT_ID, AVAIL_BALANCE, 
case  
	when AVAIL_BALANCE > 500 then 'Баланс больше 500'
    when AVAIL_BALANCE = 500 then 'Баланс = 500'
    else 'Баланс меньше 500'
end as balance
from account;



-- ----------------------------------- БД ADULT.DATA ----------------------------------------
/*
Уникальные значения признаков набора Adult по доходу населения:

age: возраст
workclass: вид работы: Частный, без оплаты, никогда не работал и т.д.
fnlwgt: вес кейса
education: уровень образования: Бакалавриат, Некоторые колледжи, 11-й, Высшая степень, Профессиональная школа, Доцент-acdm, Assoc-voc, 9-й, 7-8-й, 12-й, Магистр, 1-4-й, 10-й, Докторантура, 5-й-6-й, Дошкольное.
education (образование): детский сад, начальная школа (1-4 класс), начальная школа (5-6 класс), средняя школа (7-8 класс), старшая школа (9 класс), старшая школа (10 класс), старшая школа (11 класс), старшая школа (12 класс), абитуриент, техникум, колледж, среднее специальное образование технического профиля, среднее специальное образование академического профиля, бакалавр, магистр, доктор наук
education-num: код уровня образования.
marital-status: статус гражданина: Женат-гражданская супруга, Разведен, Никогда не состоял в браке, Раздельно, Вдова, Женат-супруга-отсутствует, Женат-AF-супруга.
occupation: род занятий
relationship: Жена, Собственный ребенок, Муж, Не член семьи, Другой родственник, Неженатый.
race: расса
sex: пол: Женщина мужчина.
hours-per-week: количество часов в неделю.
native-country: страна
salary: уровень дохода: > 50 тыс., <= 50 тыс.
*/

-- 1. Сколько мужчин и женщин (признак *sex*) представлено в этом наборе данных?
select sex, count(*) from adult_data1 group by sex;

-- 2. Каков средний возраст (признак *age*) женщин?
select round(avg(age),1) from adult_data1 where sex = 'Female';

-- 3. Какова доля граждан Германии (признак *native_country*)?

select count(*)/(select count(*) from adult_data1) as 'Доля' from adult_data1 where native_country = 'Germany';

-- 4. Каковы средние значения возраста тех, кто получает более 50K в год (признак salary) и тех, кто получает менее 50K в год?
select salary, avg(age) from adult_data1 group by salary;

-- 5. Правда ли, что люди, которые получают больше 50k, имеют как минимум высшее образование? 
-- (признак education – Bachelors, Prof-school, Assoc-acdm, Assoc-voc, Masters или Doctorate)

SELECT 
    education, COUNT(*) AS kol
FROM
    adult_data1
WHERE
    salary = '>50K'
GROUP BY education
ORDER BY kol DESC;

-- 6. Найдите максимальный возраст мужчин расы (признак race) Amer-Indian-Eskimo.

SELECT 
    MAX(age)
FROM
    adult_data1
WHERE
    race LIKE 'Amer-Indian-Eskimo'
        AND sex = 'Male';

-- 7. Среди кого больше зарабатывающих много (>50K): среди женатых или холостых мужчин (признак marital_status)? 
-- Женатыми считаем тех, у кого marital_status начинается с Married (Married-civ-spouse, Married-spouse-absent или Married-AF-spouse), 
-- остальных считаем холостыми.

SELECT DISTINCT
    marital_status
FROM
    adult_data1;

SELECT 
    'Женатые' as status1, COUNT(*) as kol
FROM
    adult_data1
WHERE
    salary = '>50K'
        AND marital_status LIKE 'Married%' 
UNION SELECT 
    'Холостые' as status1, COUNT(*) as kol
FROM
    adult_data1
WHERE
    salary = '>50K'
        AND marital_status NOT LIKE 'Married%';

-- 8. Какое максимальное число часов человек работает в неделю (признак hours_per_week)? 

SELECT 
    MAX(hours_per_week)
FROM
    adult_data1;
    
-- Сколько людей работают такое количество часов и сколько среди них зарабатывающих много?

SELECT 
    COUNT(*)
FROM
    adult_data1
WHERE
    hours_per_week = (SELECT 
            MAX(hours_per_week)
        FROM
            adult_data1)
        AND salary = '>50K';

-- Вычислим долю зарабатывающих много, среди тех кто работает максимальное количество часов

SELECT 
    COUNT(*) / (SELECT 
            COUNT(*)
        FROM
            adult_data1
        WHERE
            hours_per_week = (SELECT 
                    MAX(hours_per_week)
                FROM
                    adult_data1)) AS 'Доля'
FROM
    adult_data1
WHERE
    hours_per_week = (SELECT 
            MAX(hours_per_week)
        FROM
            adult_data1)
        AND salary = '>50K';


-- 9. Посчитайте среднее время работы (hours-per-week) 
-- зарабатывающих мало и много (salary) для каждой страны (native-country).

SELECT 
    native_country, salary, AVG(hours_per_week) AS mean
FROM
    adult_data1
GROUP BY native_country , salary
ORDER BY native_country;






-- ---------------------------------------- БД CORP  (Корпорация)  -------------------------------------------------
/* Таблица EMPLOYEE - сотрудники фирмы
1	employee_id	Код сотрудника
2	last_name	Фамилия
3	first_name	Имя
4	middle_initial	Средний инициал
5	manager_id	Код начальника
6	job_id	Код должности
7	hire_date	Дата поступления в фирму
8	salary	Зарплата
9	commission	Комиссионные
10	department_id	Код отдела

Таблица DEPARTMENT - отделы фирмы
1	department_id	Код отдела
2	name	Название отдела
3	location_id	Код места размещения

Таблица LOCATION - места размещения отделов
1	location_id	Код места размещения
2	regional_group	Город

Таблица JOB - должности в фирме
1	job_id	Код должности
2	functn	Название должности

Таблица CUSTOMER - фирмы-покупатели
1	customer_id	Код покупателя
2	name	Название покупателя
3	address	Адрес
4	city	Город
5	state	Штат
6	zip_code	Почтовый код
7	area_code	Код региона
8	phone_number	Телефон
9	salesperson_id	Код сотрудника-продавца, обслуживаю-щего данного покупателя
10	credit_limit	Кредит для покупателя
11	comments	Примечания

Таблица SALES_ORDER - договоры о продаже
1	order_id	Код договора
2	order_date	Дата договора
3	customer_id	Код покупателя
4	ship_date	Дата поставки
5	total	Общая сумма договора

Таблица ITEM - акты продаж
1	order_id	Код договора, в состав которого входит акт
2	item_id	Код акта
3	product_id	Код продукта
4	actual_price	Цена продажи
5	quantity	Количество
6	total	Общая сумма

Таблица PRODUCT – товары
1	product_id	Код продукта
2	description	Название продукта

Таблица PRICE – цены
1	product_id	Код продукта
2	list_price	Объявленная цена
3	min_price	Минимально возможная цена
4	start_date	Дата установления цены
5	end_date	Дата отмены цены

*/