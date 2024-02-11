CREATE SCHEMA module2;

CREATE table module2.transaction(
transaction_id integer PRIMARY KEY,
product_id integer NOT NULL,
brand varchar(40) NULL,
product_line varchar(40) NULL,
product_class varchar(40) NULL,
product_size varchar(40) null,
customer_id integer NULL,
transaction_date timestamp NOT NULL,
online_order varchar(40) NULL,
order_status varchar(40) NOT NULL,
list_price numeric NOT NULL,
standard_cost numeric NULL,
FOREIGN KEY(customer_id) REFERENCES module1.customer(customer_id)
);


CREATE table module2.customer(
customer_id integer PRIMARY KEY,
first_name varchar(40) NULL,
last_name varchar(40) NULL,
gender varchar(40) NULL,
DOB timestamp NULL,
job_title varchar(40) NULL,
job_industry_category varchar(40) NULL,
wealth_segment varchar(40) NULL,
deceased_indicator varchar(40) NULL,
owns_car varchar(40) NULL,
address varchar(40) NULL,
postcode integer NULL,
state varchar(40) NULL,
country varchar(40) NULL,
property_valuation integer NULL
);


--(1 балл) Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов.
select distinct brand from module2.transaction where standard_cost>1500 and brand is not null;
--(1 балл) Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно.
select transaction_id  from module2.transaction where order_status='Approved' and transaction_date between '2017-04-01' and '2017-04-09';
--(1 балл) Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'.
select distinct job_title from module2.customer where job_industry_category in ('IT', 'Financial Services') and job_title like 'Senior%';
--(1 балл) Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services
select distinct t.brand from module2.transaction t 
inner join  module2.customer c on t.customer_id = c.customer_id 
where c.job_industry_category='Financial Services' and t.brand is not null;
--(1 балл) Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.
select distinct t.customer_id, c.first_name, c.last_name  from module2.transaction t
left join module2.customer c on t.customer_id = c.customer_id 
where t.brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles') and t.online_order='true' limit 10 ;
--(1 балл) Вывести всех клиентов, у которых нет транзакций.
select customer_id, first_name, last_name  from module2.customer where customer_id not in (select customer_id from module2.transaction );
--(2 балла) Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.
select distinct t.customer_id, c.first_name, c.last_name  from module2.transaction t 
inner join  module2.customer c on t.customer_id = c.customer_id 
where c.job_industry_category='IT' and t.standard_cost =(select max(standard_cost) from module2.transaction);
--(2 балла) Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.
select distinct t.customer_id, c.first_name, c.last_name from module2.transaction t 
inner join  module2.customer c on t.customer_id = c.customer_id 
where c.job_industry_category in ('IT','Health') and t.order_status='Approved' and t.transaction_date > '2017-07-07' and t.transaction_date < '2017-07-17';
