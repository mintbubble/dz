CREATE SCHEMA module1;


CREATE table module1.transaction(
transaction_id integer PRIMARY KEY,
product_uid varchar(40) NULL,
customer_id integer NULL,
transaction_date timestamp NOT NULL,
online_order varchar(40) NULL,
order_status varchar(40) NOT NULL,
list_price numeric NOT NULL,
standard_cost numeric NULL,
FOREIGN KEY(product_uid) REFERENCES module1.product(product_uid),
FOREIGN KEY(customer_id) REFERENCES module1.customer(customer_id)
);

CREATE table module1.product(
product_uid varchar(40) PRIMARY KEY,
product_id integer NOT NULL,
brand varchar(40) NULL,
product_line varchar(40) NULL,
product_class varchar(40) NULL,
product_size varchar(40) NULL
);

CREATE table module1.customer(
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
address_code varchar(40) NULL,
address_name varchar(40) NULL,
postcode integer NULL,
state varchar(40) NULL,
country varchar(40) NULL,
property_valuation integer NULL
);

--DROP table module1.customer CASCADE;
--DROP table module1.product CASCADE;
--DROP table module1.transaction CASCADE;
--truncate table module1.customer CASCADE;

