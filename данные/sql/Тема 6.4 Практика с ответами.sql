-- --------------------------- ИЕРАРХИЧЕСКИЕ ЗАПРОСЫ ------------------------------------

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

-- ------------------------------- SQL EXISTS -----------------------

/* 

SELECT column_name(s)
FROM table_name
WHERE EXISTS
(SELECT column_name FROM table_name WHERE condition);

*/



-- ------------------------------- SQL with  общее табличное выражение Common Table Expressions (CTE)-----------------------
/*
CTE — важная функция MySQL, которая используется для генерации временного набора результатов

Его можно использовать как альтернативу VIEW.
*/

/*
WITH CTE-Name (column1,column2,… columnn) AS (Query)
SELECT * FROM CTE-Name;
*/


-- ВЫБРАТЬ КОДЫ ВСЕХ ГОРОДОВ, В КОТОРЫХ РАСПОЛОЖЕНЫ ОТДЕЛЫ ФИРМЫ.

SELECT DISTINCT
    location_id
FROM
    department;
    
-- ДЛЯ КАЖДОГО СОТРУДНИКА ОПРЕДЕЛИТЬ, КАКОЙ ПРОЦЕНТ ПО ОТНОШЕНИЮ К ЗАРПЛАТЕ СОСТАВЛЯЮТ ЕГО КОМИССИОННЫЕ.
 
SELECT 
    last_name, commission / salary * 100
FROM
    employee;
    
  -- ВЫВЕСТИ ДВА ИНИЦИАЛА (С ТОЧКАМИ) И ФАМИЛИИ ВСЕХ СОТРУДНИКОВ, НАПРИМЕР:
  -- W. J. SMITH  
  
SELECT 
    CONCAT(SUBSTRING(first_name, 1, 1),
            '. ',
            middle_initial,
            '. ',
            last_name) AS i
FROM
    employee;
    
-- ВЫБРАТЬ ФАМИЛИИ ВСЕХ СОТРУДНИКОВ, У КОТОРЫХ КОМИССИОННЫЕ БОЛЬШЕ ЗАРПЛАТЫ.

SELECT 
    last_name, salary, commission
FROM
    employee
WHERE
    salary < commission;
    
     
-- ПО КАЖДОЙ СДЕЛКЕ ВЫВЕСТИ ТОЧНУЮ СУММУ СДЕЛКИ, СУММУ СДЕЛКИ, ОКРУГЛЕННУЮ В БОЛЬШУЮ СТОРОНУ, 
-- ОКРУГЛЕННУЮ В МЕНЬШУЮ СТОРОНУ, ОКРУГЛЕННУЮ ПО ОБЩЕПРИНЯТЫМ ПРАВИЛАМИ ОКРУГЛЕНИЯ.    
 
 SELECT 
    total, ROUND(total, 0), CEILING(total), FLOOR(total)
FROM
    sales_order;
 
-- ВЫБРАТЬ ИМЕНА ВСЕХ СОТРУДНИКОВ, КОТОРЫЕ НЕ ЯВЛЯЮТСЯ МЕНЕДЖЕРАМИ 
-- (JOB_ID=671) И НЕ РАБОТАЮТ В ОТДЕЛЕ SALES В NEW YORK (DEPARTMENT_ID=13).   
    
SELECT 
    last_name
FROM
    employee
WHERE
    NOT (department_id = 13 OR job_id = 671);
  
 -- ВЫБРАТЬ ФАМИЛИИ ВСЕХ СОТРУДНИКОВ, У КОТОРЫХ КОД ДОЛЖНОСТИ 670 ИЛИ 677 (CLERK ИЛИ SALESPERSON). 

SELECT 
    last_name, job_id
FROM
    employee
WHERE
    job_id IN (670 , 667);
 
-- ВЫБРАТЬ ФАМИЛИИ ВСЕХ СОТРУДНИКОВ, КОТОРЫЕ ПОСТУПИЛИ НА РАБОТУ ПОСЛЕ 15 АПРЕЛЯ 2015 ГОДА.
 
 SELECT 
    last_name, hire_date
FROM
    employee
WHERE
    hire_date > '2015-04-15';
    
-- ВЫБРАТЬ ФАМИЛИИ ВСЕХ СОТРУДНИКОВ, КОТОРЫЕ ПОСТУПИЛИ НА РАБОТУ В 2015 ГОДУ.    
  
SELECT 
    last_name, hire_date
FROM
    employee
WHERE
    YEAR(hire_date) = 2015;
 
 -- ДЛЯ КАЖДОГО СОТРУДНИКА ВЫБРАТЬ КОЛИЧЕСТВО ПОЛНЫХ ЛЕТ РАБОТЫ В ФИРМЕ.
 
SELECT 
    hire_date, FROM_DAYS(DATEDIFF(CURDATE(), hire_date))
FROM
    employee;
 
 
 -- ВЫБРАТЬ КОЛИЧЕСТВО СОТРУДНИКОВ, ПОЛУЧАЮЩИХ КОМИССИОННЫЕ.
 
 SELECT 
    COUNT(*)
FROM
    employee
WHERE
    commission IS NOT NULL;
 
-- ВЫБРАТЬ КОЛИЧЕСТВО И ОБЩУЮ СУММУ СДЕЛОК, СОВЕРШЕННЫХ С ПОКУПАТЕЛЕМ, КОД КОТОРОГО - 104. 
 
SELECT 
    COUNT(*), SUM(total)
FROM
    sales_order
WHERE
    customer_id = 104;
    
-- ВЫБРАТЬ СРЕДНЮЮ ЗАРПЛАТУ ПО КАЖДОЙ ДОЛЖНОСТИ.   

SELECT 
    job_id, AVG(salary)
FROM
    employee
GROUP BY job_id;
 
 -- ВЫБРАТЬ СРЕДНЮЮ ЗАРПЛАТА ПРОДАВЦОВ (КОД ДОЛЖНОСТИ - 670).
 
SELECT 
    AVG(salary)
FROM
    employee
WHERE
    job_id = 670;
    
-- ВЫБРАТЬ КОДЫ ТОВАРОВ, ПО КОТОРЫМ БЫЛО СОВЕРШЕНО МЕНЬШЕ 10 ПРОДАЖ.

SELECT 
    description, product.product_id
FROM
    item
        JOIN
    product ON item.product_id = product.product_id
GROUP BY product.description
HAVING COUNT(*) < 10;
      
-- ВЫБРАТЬ МАКСИМАЛЬНУЮ ЗАРПЛАТУ ПРОДАВЦОВ (КОД ДОЛЖНОСТИ - 670) ПО КАЖДОМУ ОТДЕЛУ.

SELECT 
    department_id, MAX(salary)
FROM
    employee
GROUP BY department_id , job_id
HAVING job_id = 670;
 
-- ВЫБРАТЬ СПИСОК ФАМИЛИЙ СОТРУДНИКОВ ПО ГОРОДАМ, ГДЕ ОНИ РАБОТАЮТ, С УКАЗАНИЕМ ДЛЯ КАЖДОГО ЕГО ДОЛЖНОСТИ.

SELECT DISTINCT
    regional_group, last_name, functn
FROM
    location,
    employee,
    job,
    department
WHERE
    job.job_id = employee.job_id
        AND employee.department_id = department.department_id
        AND department.location_id = location.location_id
ORDER BY regional_group , last_name;

-- ВЫБРАТЬ ВСЕХ ПОКУПАТЕЛЕЙ, С КОТОРЫМИ РАБОТАЕТ ПРОДАВЕЦ TURNER.
SELECT 
    name
FROM
    customer
        JOIN
    employee ON employee_id = salesperson_id
WHERE
    last_name = 'TURNER';

-- ВЫБРАТЬ СВОБОДНЫХ СОТРУДНИКОВ, КОТОРЫЕ НЕ ЗАКРЕПЛЕНЫ ЗА КОНКРЕТНЫМ ЗАКАЗЧИКОМ.
SELECT 
    last_name
FROM
    employee
WHERE
    employee_id NOT IN (SELECT DISTINCT
            salesperson_id
        FROM
            customer);

-- ВЫБРАТЬ СРЕДНЮЮ СУММУ ПРОДАЖ, КОТОРАЯ ПРИХОДИТСЯ НА ОДНОГО СОТРУДНИКА, РАБОТАЮЩЕГО В DALLAS.
SELECT 
    AVG(total) AS 'Средняя сумма продаж'
FROM
    employee e
        JOIN
    DEPARTMENT d ON d.department_id = e.department_id
        JOIN
    LOCATION l ON l.location_id = d.location_id
        JOIN
    CUSTOMER c ON c.salesperson_id = e.employee_id
        JOIN
    SALES_ORDER so ON so.customer_id = c.customer_id
WHERE
    l.regional_group = 'DALLAS';

-- ВЫБРАТЬ ИМЕНА ПРОДАВЦОВ, КОТОРЫЕ РАБОТАЮТ БОЛЕЕ ЧЕМ С ОДНИМ ПОКУПАТЕЛЕМ И НАЗВАНИЯ ПОКУПАТЕЛЕЙ, 
-- КОТОРЫХ ОНИ ОБСЛУЖИВАЮТ.
SELECT 
    last_name, name
FROM
    employee,
    customer
WHERE
    employee_id = salesperson_id
        AND salesperson_id IN (SELECT 
            salesperson_id
        FROM
            customer
        GROUP BY salesperson_id
        HAVING COUNT(*) > 1)
ORDER BY last_name;

-- ВЫБРАТЬ СУММУ ВСЕХ ПРОДАЖ, КОТОРЫЕ ОБЕСПЕЧИЛ ПРОДАВЕЦ TURNER.
SELECT 
    SUM(total)
FROM
    sales_order,
    customer,
    employee
WHERE
    sales_order.customer_id = customer.customer_id
        AND salesperson_id = employee_id
        AND last_name = 'TURNER';

 -- ВЫБРАТЬ СУММУ ВСЕХ ПРОДАЖ ТОВАРОВ, СВЯЗАННЫХ С 'ГАНТЕЛЬ', ЗА ЛЕТО 2020Г.
SELECT 
    SUM(total)
FROM
    item
WHERE
    product_id IN (SELECT 
            product_id
        FROM
            product
        WHERE
            description LIKE '%Гантель%')
        AND order_id IN (SELECT 
            order_id
        FROM
            sales_order
        WHERE
            order_date BETWEEN '2020-06-01' AND '2020-08-31');

SELECT 
    last_name, (salary - average) AS rsal
FROM
    employee,
    (SELECT 
        AVG(salary) AS average
    FROM
        employee
    WHERE
        job_id = 670) tmp
WHERE
    job_id = 670
ORDER BY rsal DESC;

-- ВЫБРАТЬ НАЗВАНИЕ ТОВАРА, ДАТУ ПРОДАЖИ, ЦЕНУ ПРОДАЖИ ДЛЯ ВСЕХ СЛУЧАЕВ, КОГДА ТОВАРЫ ПРОДАВАЛИСЬ НИЖЕ,
-- ЧЕМ ЗА 75% ИХ ОБЪЯВЛЕННОЙ ЦЕНЫ.
SELECT 
    description, order_date, actual_price, list_price
FROM
    product,
    sales_order,
    item,
    price
WHERE
    product.product_id = price.product_id
        AND product.product_id = item.product_id
        AND item.order_id = sales_order.order_id
        AND actual_price < list_price * 0.75
        AND order_date >= start_date
        AND (order_date < end_date
        OR end_date IS NULL);

-- ВЫБРАТЬ СПИСОК СОТРУДНИКОВ ФИРМЫ С УКАЗАНИЕМ ФАМИЛИИ НЕПОСРЕДСТВЕННОГО НАЧАЛЬНИКА КАЖДОГО.
SELECT 
    x.last_name, y.last_name
FROM
    employee x,
    employee y
WHERE
    x.manager_id = y.employee_id;

-- ДЛЯ КАЖДОГО СОТРУДНИКА ВЫВЕСТИ РАЗНОСТЬ МЕЖДУ ЕГО ЗАРПЛАТОЙ И СРЕДНЕЙ ЗАРПЛАТОЙ СОТРУДНИКОВ, ВЫПОЛНЯЮЩИХ ТЕ ЖЕ ФУНКЦИИ.
SELECT last_name, job_id, salary, salary - (AVG(salary) OVER (partition by job_id)) AS avsal 
from employee; 

SELECT 
    last_name, salary, salary - avsal
FROM
    employee,
    (SELECT 
        job_id AS jid, AVG(salary) AS avsal
    FROM
        employee
    GROUP BY job_id) tmp
WHERE
    job_id = jid;
 

-- ВЫВЕСТИ ТАБЛИЦУ РАСПРЕДЕЛЕНИЯ ОБЪЕМА ПРОДАЖ ТОВАРА МЯЧ БАСКЕТБОЛЬНЫЙ TORRES  ПО ГОДАМ.
SELECT 
    YEAR(order_date), SUM(item.total)
FROM
    product,
    item,
    sales_order
WHERE
    product.product_id = item.product_id
        AND item.order_id = sales_order.order_id
        AND description = 'Мяч баскетбольный Torres'
GROUP BY YEAR(order_date)
ORDER BY 1;

 -- ОПРЕДЕЛИТЬ, КАКОЙ ПРОДУКТ ПРИНЕС НАИБОЛЬШУЮ ВЫРУЧКУ ЛЕТОМ 2020Г (ПО КОЛИЧЕСТВУ ОБЪЕМУ ПРОДАЖ).
SELECT 
    p.product_id, p.description, SUM(i.total)
FROM
    PRODUCT p
        JOIN
    ITEM i ON i.product_id = p.product_id
        JOIN
    SALES_ORDER so ON so.order_id = i.order_id
WHERE
    YEAR(so.order_date) = 2020
        AND MONTH(so.order_date) BETWEEN 6 AND 8
GROUP BY p.product_id
ORDER BY SUM(i.total) DESC
LIMIT 1;

 -- ВЫБРАТЬ ФАМИЛИИ ТЕХ СОТРУДНИКОВ, У КОТОРЫХ СУММАРНЫЙ ДОХОД (ЗАРПЛАТА + КОМИССИОННЫЕ) БОЛЬШЕ 2000.
SELECT 
    last_name, salary + commission
FROM
    employee
WHERE
    salary + commission > 2000;
-- ---------------------- ИЛИ --------------------------------
SELECT 
    last_name, income
FROM
    (SELECT 
        last_name, salary + commission AS income
    FROM
        employee
    WHERE
        commission IS NOT NULL UNION (SELECT 
        last_name, salary AS income
    FROM
        employee
    WHERE
        commission IS NULL)) AS tmp
WHERE
    income > 2000
ORDER BY 1;

-- ВЫБРАТЬ СРЕДНЮЮ СУММУ ПРОДАЖ, КОТОРАЯ ПРИХОДИТСЯ НА ОДНОГО СОТРУДНИКА В КАЖДОМ РЕГИОНЕ.
with temp as (SELECT 
    l.regional_group, SUM(total) AS sumtotal, e.employee_id
FROM
    employee e
        JOIN
    DEPARTMENT d ON d.department_id = e.department_id
        JOIN
    LOCATION l ON l.location_id = d.location_id
        JOIN
    CUSTOMER c ON c.salesperson_id = e.employee_id
        JOIN
    SALES_ORDER so ON so.customer_id = c.customer_id
GROUP BY e.employee_id , l.regional_group)
SELECT 
    regional_group, AVG(sumtotal) as 'Средняя сумма продаж'
FROM
    temp
GROUP BY regional_group;

--  ВЫБРАТЬ НАЗВАНИЯ ТОВАРОВ, ДЛЯ КОТОРЫХ НЫНЕШНЯЯ ЦЕНА УВЕЛИЧИЛАСЬ ПО СРАВНЕНИЮ С ЦЕНОЙ 
-- НА 15 ДЕКАБРЯ 2019Г. БОЛЕЕ, ЧЕМ НА 15%.
SELECT 
    description,
    x.list_price AS oldprice,
    y.list_price AS newprice
FROM
    product,
    price x,
    price y
WHERE
    product.product_id = x.product_id
        AND x.product_id = y.product_id
        AND x.start_date <= '2019-12-15'
        AND x.end_date > '2019-12-15'
        AND y.end_date IS NULL
        AND x.list_price * 1.15 < y.list_price;
	   
-- ------------------ С ИСПОЛЬЗОВАНЕМ ВЛОЖЕННЫХ ЗАПРОСОВ  ------------------------------
SELECT 
    description, old.list_price, new.list_price
FROM
    product,
    (SELECT 
        product_id, list_price
    FROM
        price
    WHERE
        start_date <= '2019-12-15'
            AND end_date > '2019-12-15') AS old,
    (SELECT 
        product_id, list_price
    FROM
        price
    WHERE
        end_date IS NULL) AS new
WHERE
    old.product_id = product.product_id
        AND new.product_id = product.product_id
        AND old.list_price * 1.15 < new.list_price;


-- ВЫБРАТЬ ИМЕНА И КОДЫ ОТДЕЛА ДЛЯ СОТРУДНИКОВ И СРЕДНУЮ ЗАРПЛАТУ ПО ОТДЕЛУ (БЕЗ УЧЕТА КОМИССИОННЫХ).

SELECT 
    last_name, department_id, salary, AVG(salary) OVER (partition by department_id) AS avs
FROM
    employee; 

-- ВЫБРАТЬ ИМЕНА И КОДЫ ОТДЕЛА ДЛЯ СОТРУДНИКОВ, У КОТОРЫХ ЗАРПЛАТА ВЫШЕ СРЕДНЕЙ ПО ОТДЕЛУ (БЕЗ УЧЕТА КОМИССИОННЫХ).

SELECT 
    last_name, department_id, salary
FROM
    employee temp
WHERE
    salary > (SELECT 
            AVG(salary)
        FROM
            employee
        WHERE
            temp.department_id = employee.department_id)
ORDER BY 1;
-- ----------------------------  -- ИЛИ---------------
SELECT 
    last_name, employee.department_id, salary
FROM
    employee,
    (SELECT 
        AVG(salary) AS avs, department_id
    FROM
        employee
    GROUP BY department_id) temp
WHERE
    temp.department_id = employee.department_id
        AND salary > avs
ORDER BY 1;
     
 -- 4. ВЫБРАТЬ СПИСОК ТОВАРОВ И КОЛИЧЕСТВО ПРОДАННЫХ ЭКЗЕМПЛЯРОВ В КАЖДОМ ГОРОДЕ.
SELECT 
    description, regional_group, st
FROM
    product,
    location,
    (SELECT 
        SUM(item.quantity) AS st,
            location_id AS loc,
            product_id AS prod
    FROM
        department, employee, customer, sales_order, item
    WHERE
        department.department_id = employee.department_id
            AND employee_id = salesperson_id
            AND customer.customer_id = sales_order.customer_id
            AND sales_order.order_id = item.order_id
    GROUP BY location_id , prod) x,
    (SELECT 
        MAX(st) AS mst, prod
    FROM
        (SELECT 
        SUM(item.quantity) AS st,
            location_id AS loc,
            product_id AS prod
    FROM
        department, employee, customer, sales_order, item
    WHERE
        department.department_id = employee.department_id
            AND employee_id = salesperson_id
            AND customer.customer_id = sales_order.customer_id
            AND sales_order.order_id = item.order_id
    GROUP BY location_id , prod) t1
    GROUP BY loc , prod) y
WHERE
    st = mst AND x.prod = y.prod
        AND x.prod = product_id
        AND loc = location_id;
    
 

-- ВЫБРАТЬ ИМЕНА И ЗАРПЛАТЫ 10 САМЫХ ВЫСОКООПЛАЧИВАЕМЫХ СОТРУДНИКОВ ФИРМЫ (БЕЗ УЧЕТА КОМИССИОННЫХ).
SELECT 
    last_name, salary
FROM
    employee temp
ORDER BY salary DESC
LIMIT 10; 

-- Выбрать данные для построения графика зависимости средней зарплаты рядового служащего от срока работы в фирме 
-- (с точностью до месяца).

SELECT (YEAR(CURDATE())-YEAR(hire_date))*12 + 
         MONTH(CURDATE())-MONTH(hire_date) AS term, AVG(salary)
       FROM employee
       WHERE job_id NOT IN
          (SELECT job_id 
             FROM job
             WHERE functn IN ('MANAGER', 'PRESIDENT') )
       GROUP BY (YEAR(CURDATE())-YEAR(hire_date))*12 + 
            MONTH(CURDATE())-MONTH(hire_date);
            
-- ВЫБРАТЬ ДАННЫЕ ДЛЯ ПОСТРОЕНИЯ ГРАФИКА ОБЩАЯ СУММА ПРОДАЖИ, ЦЕНА ПРОДАЖИ, ЦЕНА ТОВАРА.
SELECT 
    i.product_id, i.total, i.actual_price, p.list_price
FROM
    item i
        JOIN
    price p ON p.product_id = i.product_id
        JOIN
    sales_order so ON i.order_id = so.order_id
WHERE
    so.order_date BETWEEN p.start_date AND p.end_date;

-- ВЫБРАТЬ ПРОДУКТЫ В ПОРЯДКЕ УВЕЛИЧЕНИЯ ИХ ПРИБЫЛЬНОСТИ. 
-- ПРИБЫЛЬ ОПРЕДЕЛЯЕТСЯ КАК ОТНОСИТЕЛЬНАЯ РАЗНОСТЬ МЕЖДУ РЕАЛЬНОЙ ЦЕНОЙ ПРОДАЖЕ И МИНИМАЛЬНОЙ ЦЕНОЙ.

SELECT 
    description, profit
FROM
    product,
    (SELECT 
        product.product_id AS pid,
            SUM(((actual_price - min_price) / min_price) * quantity) / SUM(quantity) AS profit
    FROM
        price, product, item, sales_order
    WHERE
        item.order_id = sales_order.order_id
            AND product.product_id = price.product_id
            AND product.product_id = item.product_id
            AND order_date <= start_date
            AND (order_date < end_date
            OR end_date IS NULL)
    GROUP BY product.product_id) tmp
WHERE
    product_id = pid
ORDER BY profit;


-- ДЛЯ КАЖДОГО ПРОДУКТА ВЫБРАТЬ РЕГИОН, В КОТОРОМ ОН ЛУЧШЕ ВСЕГО ПРОДАЕТСЯ (ПО ОБЪЕМУ ПРОДАЖ)-
-- НАЗВАНИЕ ПРОДУКТА, НАЗВАНИЕ РЕГИОНА (LOCATION.REGIONAL_GROUP).
SELECT 
    description, regional_group
FROM
    product,
    location,
    (SELECT 
        SUM(item.total) AS st,
            location_id AS loc,
            product_id AS prod
    FROM
        department, employee, customer, sales_order, item
    WHERE
        department.department_id = employee.department_id
            AND employee_id = salesperson_id
            AND customer.customer_id = sales_order.customer_id
            AND sales_order.order_id = item.order_id
    GROUP BY location_id , product_id) x,
    (SELECT 
        MAX(st) AS mst, prod
    FROM
        (SELECT 
        SUM(item.total) AS st,
            location_id AS loc,
            product_id AS prod
    FROM
        department, employee, customer, sales_order, item
    WHERE
        department.department_id = employee.department_id
            AND employee_id = salesperson_id
            AND customer.customer_id = sales_order.customer_id
            AND sales_order.order_id = item.order_id
    GROUP BY location_id , product_id) t1
    GROUP BY prod) y
WHERE
    st = mst AND x.prod = y.prod
        AND x.prod = product_id
        AND loc = location_id;


-- ВЫВЕСТИ СТРУКТУРУ ПОДЧИНЕННОСТИ В ФИРМЕ.
WITH RECURSIVE  temp (level, name, id, mid) AS
       (SELECT 1 AS level, last_name, employee_id, manager_id
          FROM employee
          WHERE last_name=
             (SELECT last_name
                FROM employee, job
                WHERE employee.job_id=job.job_id
                AND functn ='PRESIDENT' )
       UNION ALL
      SELECT level+1 AS level, last_name, employee_id, manager_id
        FROM employee, temp
        WHERE manager_id=id )
   SELECT DISTINCT level, name, id, mid
      FROM temp
      ORDER BY level;

-- ВЫБРАТЬ СРЕДНЮЮ ЗАРПЛАТУ ВСЕХ ПОДЧИНЕННЫХ JONES.
WITH RECURSIVE temp (id, sal) AS 
       (SELECT employee_id, salary
          FROM employee
          WHERE manager_id IN
            (SELECT employee_id
                FROM employee
                WHERE last_name= 'JONES') 
       UNION ALL
      SELECT employee_id, salary
         FROM employee,temp
         WHERE manager_id=id )
   SELECT AVG(sal)
      FROM temp;
     
-- 1. ДЛЯ КАЖДОГО ПРОДАВЦА (JOB_ID=670) ВЫВЕСТИ РАЗНОСТЬ МЕЖДУ ЕГО ЗАРПЛАТОЙ И СРЕДНЕЙ ЗАРПЛАТОЙ ПРОДАВЦОВ В ОТДЕЛЕ C КОДОМ 23. 
SELECT 
	last_name, job_id, salary, salary - (AVG(salary) OVER (partition by job_id)) AS avsal 
from 
	employee 
WHERE 
	job_id=670 and department_id = 23; 


-- 2. ВЫБРАТЬ СРЕДНЮЮ СУММУ ПРОДАЖ, КОТОРАЯ ПРИХОДИТСЯ НА ОДНОГО СОТРУДНИКА В ГОРОДЕ NEW YORK.
with temp as (SELECT 
    l.regional_group, SUM(total) AS sumtotal, e.employee_id
FROM
    employee e
        JOIN
    DEPARTMENT d ON d.department_id = e.department_id
        JOIN
    LOCATION l ON l.location_id = d.location_id
        JOIN
    CUSTOMER c ON c.salesperson_id = e.employee_id
        JOIN
    SALES_ORDER so ON so.customer_id = c.customer_id
GROUP BY e.employee_id , l.regional_group)
SELECT 
    regional_group, AVG(sumtotal) AS 'Средняя сумма продаж'
FROM
    temp
WHERE
    regional_group LIKE 'New%'
GROUP BY regional_group;


-- 3. ОПРЕДЕЛИТЬ, КАКОЙ ПРОДУКТ БЫЛ НАИБОЛЕЕ ПОПУЛЯРЕН ВЕСНОЙ 2019Г (ПО КОЛИЧЕСТВУ ПРОДАННЫХ ЭКЗЕМПЛЯРОВ).
SELECT 
    p.product_id, p.description, SUM(quantity)
FROM
    PRODUCT p
        JOIN
    ITEM i ON i.product_id = p.product_id
        JOIN
    SALES_ORDER so ON so.order_id = i.order_id
WHERE
    YEAR(so.order_date) = 2019
        AND MONTH(so.order_date) BETWEEN 3 AND 5
GROUP BY p.product_id
ORDER BY SUM(quantity) DESC
LIMIT 1;

-- 4. ВЫБРАТЬ ТОВАРЫ, НАИБОЛЕЕ ПОПУЛЯРНЫЕ В КАЖДОМ ГОРОДЕ (ПО КОЛИЧЕСТВУ ПРОДАННЫХ ЭКЗЕМПЛЯРОВ).
with temp AS
(SELECT description, regional_group, st
        FROM product, location,
          (SELECT SUM(item.quantity) AS st, location_id AS loc, 
                  product_id AS prod
             FROM department, employee, customer, sales_order, item
             WHERE department.department_id=employee.department_id
             AND employee_id=salesperson_id
             AND customer.customer_id= sales_order.customer_id
             AND sales_order.order_id=item.order_id
             GROUP BY location_id, prod ) x,
         (SELECT MAX(st) AS mst, prod 
            FROM
               (SELECT SUM(item.quantity) AS st, location_id AS loc, 
                     product_id AS prod
                  FROM department, employee, customer, sales_order, item
                  WHERE department.department_id= employee.department_id
                  AND employee_id=salesperson_id
                  AND customer.customer_id= sales_order.customer_id
                  AND sales_order.order_id=item.order_id
                  GROUP BY location_id, prod) t1 
            GROUP BY loc, prod ) y
      WHERE st=mst AND x.prod=y.prod
     AND x.prod=product_id AND loc=location_id)
    
     SELECT t1.description, t1.regional_group, t1.st
      FROM temp t1
       WHERE st =
           (SELECT max(t2.st)
              FROM temp t2
             WHERE t2.regional_group= t1.regional_group)
       ORDER BY 2;

     
--  5. ВЫБРАТЬ ДАННЫЕ ДЛЯ ПОСТРОЕНИЯ ГРАФИКА ЗАВИСИМОСТИ СУММЫ ПРОДАЖИ ОТ ПРОЦЕНТА ПРЕДСТАВЛЕННОЙ ПОКУПАТЕЛЮ СКИДКИ.
SELECT 
    i.total,
    ROUND(100 - (i.actual_price / p.list_price * 100)) discount
FROM
    item i
        JOIN
    price p ON p.product_id = i.product_id
        JOIN
    sales_order so ON i.order_id = so.order_id
WHERE
    so.order_date BETWEEN p.start_date AND p.end_date
ORDER BY total;



-- (*). ОПРЕДЕЛИТЬ, НЕ ХРАНЯТСЯ ЛИ В БАЗЕ ДАННЫХ СВЕДЕНИЯ О ПОКУПАТЕЛЯХ, КОТОРЫЕ НЕ СОВЕРШИЛИ НИ ОДНОЙ ПОКУПКИ.

SELECT 
    COUNT(*) 'Количество покупателей, которые не совершили ни одной покупки'
FROM
    customer
        LEFT JOIN
    sales_order so USING (customer_id)
WHERE
    so.customer_id IS NULL;
