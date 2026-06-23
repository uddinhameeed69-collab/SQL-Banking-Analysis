CREATE DATABASE banking_project;
USE banking_project;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    account_type VARCHAR(20)
);

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    balance DECIMAL(12,2),
    open_date DATE
);

CREATE TABLE bank_transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_date DATE,
    transaction_type VARCHAR(20),
    amount DECIMAL(12,2)
);
INSERT INTO bank_transactions
(transaction_id, account_id, transaction_date, transaction_type, amount)
VALUES
(1,1001,'2024-01-05','Deposit',5000),
(2,1002,'2024-01-08','Withdrawal',2000),
(3,1003,'2024-01-10','Transfer',7500),
(4,1004,'2024-01-12','Deposit',12000),
(5,1005,'2024-01-15','Withdrawal',3500),
(6,1006,'2024-01-18','Deposit',8000),
(7,1007,'2024-01-20','Transfer',4500),
(8,1008,'2024-01-22','Withdrawal',1500),
(9,1009,'2024-01-25','Deposit',9500),
(10,1010,'2024-01-28','Transfer',6000),
(11,1011,'2024-02-02','Deposit',7000),
(12,1012,'2024-02-05','Withdrawal',2500),
(13,1013,'2024-02-08','Transfer',8200),
(14,1014,'2024-02-10','Deposit',11000),
(15,1015,'2024-02-12','Withdrawal',4000),
(16,1016,'2024-02-15','Deposit',9000),
(17,1017,'2024-02-18','Transfer',5000),
(18,1018,'2024-02-20','Withdrawal',1800),
(19,1019,'2024-02-22','Deposit',13000),
(20,1020,'2024-02-25','Transfer',7200);

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_amount DECIMAL(12,2),
    loan_status VARCHAR(20),
    interest_rate DECIMAL(5,2)
);
select * from customers;
select *from  Accounts;
select * from Loans;
select * from bank_transactions;


# retrieve the names of all customers along with their city.

select customer_name , 
city from customers;

# display the following details for all accounts:

select * from Accounts;

# retrieve all accounts having a balance greater than 100,000.

select account_id,
customer_id,
balance from Accounts
where balance > 100000;

# find the total number of customers in the bank.

select count(*)
from customers;

# calculate the total amount deposited by customers.

select SUM(amount) AS total_deposit_amount
from  bank_transactions
where  transaction_type = 'Deposit';

# find the average account balance of all customers.


select avg(balance) as average_balance
from Accounts;

# display the Top 5 customers having the highest account balance.

select c.customer_name,
       a.balance
from Customers c
join Accounts a
on c.customer_id = a.customer_id
order by a.balance desc
limit 5;

# count the number of transactions for each transaction type.

select transaction_type,count(transaction_type) as total_transaction 
from bank_transactions
group by transaction_type;

# calculate the total transaction amount for each transaction type.

select transaction_type,sum(amount) as total_amount
from bank_transactions
group by transaction_type;

# find the highest transaction amount in the bank.

select  max(amount) as high_transaction
from bank_transactions;

# display the Top 3 highest transactions.

select transaction_id , account_id,
amount from bank_transactions
order by amount desc
limit 3;

# display all customers who have a Savings account.

select customer_id,customer_name,
city,account_type
from customers
where account_type= "Savings";

# count the number of customers in each city.

select city , count(city) as total_customer 
from customers
group by city;

# find the city with the highest number of customers.

select city , count(city) as total_customer 
from customers
group by city
order by total_customer desc
limit 1;

# Find Customers Who Have Taken a Loan.

select c.customer_id , c.customer_name , l.loan_amount, l.loan_status 
from Customers c 
inner join Loans l
on c.customer_id = l.customer_id;

# Find Customers with Approved Loans

select  c.customer_name , l.loan_amount, l.loan_status 
from Customers c 
inner join Loans l
on c.customer_id = l.customer_id
where l.loan_status ="Approved";

# Find Total Loan Amount by Loan Status

select  c.customer_name , l.loan_amount
from Customers c 
inner join Loans l
on c.customer_id = l.customer_id
order by l.loan_amount desc
limit 1;

# Find customers whose total loan amount is greater than 10,00,000.

select  c.customer_id,c.customer_name , sum(l.loan_amount) as total_amount
from Customers c 
inner join Loans l
on c.customer_id = l.customer_id
group by c.customer_id, c.customer_name
having total_amount > 1000000;

# Find customers whose loan amount is greater than the average loan amount of all customers.
 
SELECT c.customer_name,
       l.loan_amount
FROM Customers c
INNER JOIN Loans l
ON c.customer_id = l.customer_id
WHERE l.loan_amount >
(
    SELECT AVG(loan_amount)
    FROM Loans
);

# find the Top 5 customers with the highest loan amounts.

with highest_loan_amounts as (
select c.customer_name , l.loan_amount
from customers c
inner join Loans l
on c.customer_id = l.customer_id)
select customer_name , loan_amount 
from highest_loan_amounts
order by loan_amount desc
limit 5;

# Rank Customers by Loan Amount

SELECT c.customer_name,
       l.loan_amount,
       RANK() OVER(ORDER BY l.loan_amount DESC) AS customer_rank
FROM Customers c
INNER JOIN Loans l
ON c.customer_id = l.customer_id;

# Dense Rank Customers by Loan Amount

SELECT c.customer_name,
       l.loan_amount,
       DENSE_RANK() OVER(ORDER BY l.loan_amount DESC) AS customer_dense_rank
FROM Customers c
INNER JOIN Loans l
ON c.customer_id = l.customer_id;

# Assign Row Number to Customers

SELECT c.customer_name,
       l.loan_amount,
       ROW_NUMBER() OVER(ORDER BY l.loan_amount DESC) AS row_num
FROM Customers c
INNER JOIN Loans l
ON c.customer_id = l.customer_id;

# Customer Segmentation High Value → Loan Amount > 1500000 Medium Value → Loan Amount Between 800000 and 1500000 Low Value → Loan Amount < 800000 #

SELECT c.customer_name,
       l.loan_amount,
       CASE
           WHEN l.loan_amount > 1500000 THEN 'High Value'
           WHEN l.loan_amount BETWEEN 800000 AND 1500000 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS customer_segment
FROM Customers c
INNER JOIN Loans l
ON c.customer_id = l.customer_id;

# Banking KPI Query Total Customers , Total Loans ,Average Loan Amount ,Maximum Loan Amount

SELECT
COUNT(DISTINCT customer_id) AS total_customers,
COUNT(*) AS total_loans,
AVG(loan_amount) AS avg_loan_amount,
MAX(loan_amount) AS max_loan_amount
FROM Loans;

/*
Project: Banking Customer & Loan Analytics

Tools Used:
- MySQL
- MySQL Workbench

Concepts Covered:
- Joins
- Group By
- Having
- Subqueries
- CTEs
- Window Functions
- Case Statements
- KPI Analysis

Author: Hameed Uddin
*/





