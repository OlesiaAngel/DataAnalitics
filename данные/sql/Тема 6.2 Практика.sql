/*База данных bank

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
PRODUCT_TYPE	Продукты услуг банка, например: Счет клиента Выдача кредитов лично и бизнесам Предоставление страхования*/
SQL Select;

select * from product_type;

	- Создать Alias для столбца;

Select Emp.Emp_Id
   ,Emp.First_Name
   ,Emp.Last_Name
   ,Emp.Dept_Id
   ,Concat('EMP'
          ,Emp.Emp_Id) As 'Номер'  -- New column
From   Employee Emp;


SQL Distinct;

select distinct name, PRODUCT_CD from product;

SQL Where;

select * from product where PRODUCT_TYPE_CD = 'LOAN';

SQL And Or (И, или);

select * from employee where FIRST_NAME like 'S%'
and DEPT_ID = 1;

SQL IN (В диапазоне..);

select * from employee where FIRST_NAME in ('Sarah', "Susan");

SQL Between (Между ...);

select emp.* From   Employee Emp
Where  (Emp.Emp_Id Between 5 And 10);

select * From   Employee E
Where  E.Emp_Id >= 5
And    E.Emp_Id <= 10;

select * from employee where 
START_DATE Between Str_To_Date('03-05-2002','%d-%m-%Y') And
 Str_To_Date('09-08-2002','%d-%m-%Y');
 
 select * from employee where 
START_DATE Between '2002-05-03' And '2002-08-09';

SQL Wildcard;

Select Cus.Cust_Id
     ,Cus.Fed_Id
     ,Cus.Address
From   Customer Cus
where cus.fed_id like '%-__-%';


SQL Like (Похоже на ...);



SQL Order By;

select * from employee order by FIRST_NAME desc;

SELECT 
    Emp.Emp_Id, Emp.First_Name, Emp.Last_Name, Emp.Start_Date
FROM
    Employee Emp
WHERE
    Emp.First_Name LIKE 'S%'
ORDER BY Emp.Start_Date DESC;


SQL Group By (Группировать по ...);

Select Acc.Product_Cd
     ,Count(Acc.Product_Cd) As Count_Acc
     ,Sum(Acc.Avail_Balance) As Sum_Avail_Balance
     ,Avg(Acc.Avail_Balance) As Avg_Avail_Balance
From   Account Acc
Group  By Acc.Product_Cd;


SQL Having;

Select Acc.Product_Cd
     ,Count(Acc.Product_Cd) As Count_Acc 
     ,Sum(Acc.Avail_Balance) As Sum_Avail_Balance -- Sum available balance
     ,Avg(Acc.Avail_Balance) As Avg_Avail_Balance -- The average available balance
From   Account Acc
Group  By Acc.Product_Cd
Having Count(Acc.Product_Cd) > 3;


Команды добавления данных (Insert);

Команда Insert Into;

Insert Into Acc_Transaction
  (Txn_Id
  ,Amount
  ,Funds_Avail_Date
  ,Txn_Date
  ,Txn_Type_Cd
  ,Account_Id
  ,Execution_Branch_Id
  ,Teller_Emp_Id)
Values
  (Null-- Txn_Id (automatically generated)
  ,100 -- Amount
  ,now() -- Funds_Avail_Date
  ,now() -- Txn_Date
  ,'CDT' -- Txn_Type_Cd
  ,2 -- Account_Id
  ,Null -- Execution_Branch_Id
  ,Null -- Teller_Emp_Id
   );

Команда Insert Into Select;

Insert Into Acc_Transaction
 (Txn_Id
 ,Txn_Date
 ,Account_Id
 ,Txn_Type_Cd
 ,Amount
 ,Funds_Avail_Date)
 Select Null -- Txn_Id (Tự sinh ra)
       ,Acc.Open_Date -- Txn_Date
       ,Acc.Account_Id -- Account_Id
       ,'CDT' -- Txn_Type_Cd
       ,200 -- Amount
       ,Acc.Open_Date -- Funds_Avail_Date
 From   Account Acc
 Where  Acc.Product_Cd = 'CD';

Команда обновления (Update);

Update Account Acc
Set    Acc.Avail_Balance   = Acc.Avail_Balance + 2 * Acc.Avail_Balance / 100
     ,Acc.Pending_Balance = Acc.Pending_Balance +
                            2 * Acc.Pending_Balance / 100
Where  Acc.Cust_Id = 1;


Команда удалить данные (Delete);

Delete From Acc_Transaction Txn
Where Txt.Txn_Id In (25  ,26);

SQL Functions;

SQL Count;

Select Count(Acc.Account_Id) From Account Acc;
Select Count(distinct txn.Account_id) From Acc_Transaction txn;

SQL Sum;

Select Sum(Acc.Avail_Balance) From Account Acc Where Acc.Cust_Id = 1;

SQL AVG;

Select round(Avg(Acc.Avail_Balance),2)
From   Account Acc
Where  Acc.Product_Cd = 'SAV';

SQL MIN;

Select round(Min(Acc.Avail_Balance),2)
From   Account Acc
Where  Acc.Product_Cd = 'SAV';

SQL MAX;

Select round(max(Acc.Avail_Balance),2)
From   Account Acc
Where  Acc.Product_Cd = 'SAV';


LIMIT,  NULL;

SElect FIRST_NAME 
from employee
where END_DATE is NULL
LIMIT 4;

SElect FIRST_NAME 
from employee
where END_DATE is NULL
LIMIT 4 offset 2;

select concat(FIRST_NAME,' ',LAST_NAME) as 'ФИО' from employee;

База данных ADULT.DATA;

-- 1. Сколько мужчин и женщин (признак *sex*) представлено в этом наборе данных?

select sex, count(*) from adult_data1 group by sex;

-- 2. Каков средний возраст (признак *age*) женщин?

select round(avg(age),1) from adult_data1 where sex='Female';

-- 4. Каковы средние значения возраста тех, кто получает более 50K в год (признак salary) и тех, кто получает менее 50K в год?

select salary, avg(age) from adult_data1 group by salary;