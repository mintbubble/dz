
--Вывести распределение (количество) клиентов по сферам деятельности, отсортировав результат по убыванию количества. — (1 балл)
select job_industry_category, count(*) from module2.customer
where job_industry_category is not null
group by job_industry_category order by count(*) desc;
--Найти сумму транзакций за каждый месяц по сферам деятельности, отсортировав по месяцам и по сфере деятельности. — (1 балл)
select c.job_industry_category, extract(month from transaction_date) as month, sum(t.list_price) from module2.transaction t
inner join  module2.customer c on t.customer_id = c.customer_id and c.job_industry_category is not null
group by c.job_industry_category, extract(month from transaction_date)
order by extract(month from transaction_date), c.job_industry_category;
--Вывести количество онлайн-заказов для всех брендов в рамках подтвержденных заказов клиентов из сферы IT. — (1 балл)
select t.brand, count(*) from module2.transaction t
inner join  module2.customer c on t.customer_id = c.customer_id and c.job_industry_category='IT'
where t.order_status='Approved' and t.online_order='true' and t.brand is not null
group by t.brand;
--Найти по всем клиентам сумму всех транзакций (list_price), максимум, минимум и количество транзакций, отсортировав результат по убыванию
--суммы транзакций и количества клиентов. Выполните двумя способами: используя только group by и используя только оконные функции.
--Сравните результат. — (2 балла)
select distinct t.customer_id, c.first_name, c.last_name, sum(t.list_price), min(t.list_price), max(t.list_price), count(t.transaction_id)
from module2.transaction t
inner join  module2.customer c on t.customer_id = c.customer_id
group by t.customer_id, c.first_name, c.last_name
order by sum(t.list_price) desc,count(t.transaction_id) desc;

select distinct t.customer_id, c.first_name, c.last_name,
sum(t.list_price) over(partition by t.customer_id, c.first_name, c.last_name ) as sum,
min(t.list_price) over(partition by t.customer_id, c.first_name, c.last_name ) as min,
max(t.list_price) over(partition by t.customer_id, c.first_name, c.last_name ) as max,
count(t.transaction_id) over(partition by t.customer_id, c.first_name, c.last_name)  as count
from module2.transaction t
inner join  module2.customer c on t.customer_id = c.customer_id
order by sum desc, count desc;

--Найти имена и фамилии клиентов с минимальной/максимальной суммой транзакций за весь период (сумма транзакций не может быть null).
--Напишите отдельные запросы для минимальной и максимальной суммы. — (2 балла)
with v1 as (select distinct t.customer_id, c.first_name, c.last_name, sum(t.list_price) as sum
from module2.transaction t
inner join  module2.customer c on t.customer_id = c.customer_id
group by t.customer_id, c.first_name, c.last_name
order by sum(t.list_price) )
select first_name, last_name from v1
where sum = (select min(sum) from v1);

with v1 as (select distinct t.customer_id, c.first_name, c.last_name, sum(t.list_price) as sum
from module2.transaction t
inner join  module2.customer c on t.customer_id = c.customer_id
group by t.customer_id, c.first_name, c.last_name
order by sum(t.list_price) desc)
select first_name, last_name from v1
where sum = (select max(sum) from v1);


--Вывести только самые первые транзакции клиентов. Решить с помощью оконных функций. — (1 балл)
select * from (
select t.*, row_number() over(partition by customer_id order by transaction_date) as num from module2.transaction t) v
where num=1;

--Вывести имена, фамилии и профессии клиентов, между транзакциями которых был максимальный интервал (интервал вычисляется в днях) — (2 балла).
with v as (select  t.customer_id,  t.transaction_date,
lag(t.transaction_date)  over(partition by customer_id order by transaction_date) as prev_date,
--max(t.transaction_date) over(partition by customer_id order by transaction_date) as max_d,
--min(t.transaction_date) over(partition by customer_id order by transaction_date) as min_d,
(t.transaction_date - lag(t.transaction_date)  over(partition by customer_id order by transaction_date) ) as diff
from module2.transaction t
order by diff  )
select v.customer_id, c.first_name, c.last_name, c.job_title from v 
inner join  module2.customer c on v.customer_id = c.customer_id 
where v.diff=(select max(diff) from v);
