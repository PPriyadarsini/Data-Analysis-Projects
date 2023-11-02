/*  

 @Steel Data & @Matthew Steel

 SQL Challenge 1 - Steve's Car Showroom

 Link: https://www.steeldata.org.uk/sql1.html

 Intro:
	Steve runs a top-end car showroom but his data analyst has just quit and left him without his crucial insights.
	Can you analyse the following data to provide him with all the answers he requires?

 Concepts used: 
	- SELECT
	- AGGREGATE FUNCTIONS (SUM, COUNT)
	- JOINS
	- WHERE
	- AND
	- GROUP BY
	- HAVING CLAUSE
	- ORDER BY
	- TOP 

 */

CREATE TABLE cars (
car_id INT PRIMARY KEY,
make VARCHAR(50),
type VARCHAR(50),
style VARCHAR(50),
cost_$ INT
);

---------------

INSERT INTO cars (car_id, make, type, style, cost_$)
VALUES (1, 'Honda', 'Civic', 'Sedan', 30000),
(2, 'Toyota', 'Corolla', 'Hatchback', 25000),
(3, 'Ford', 'Explorer', 'SUV', 40000),
(4, 'Chevrolet', 'Camaro', 'Coupe', 36000),
(5, 'BMW', 'X5', 'SUV', 55000),
(6, 'Audi', 'A4', 'Sedan', 48000),
(7, 'Mercedes', 'C-Class', 'Coupe', 60000),
(8, 'Nissan', 'Altima', 'Sedan', 26000);

---------------

CREATE TABLE salespersons (
salesman_id INT PRIMARY KEY,
name VARCHAR(50),
age INT,
city VARCHAR(50)
);

---------------

INSERT INTO salespersons (salesman_id, name, age, city)
VALUES (1, 'John Smith', 28, 'New York'),
(2, 'Emily Wong', 35, 'San Fran'),
(3, 'Tom Lee', 42, 'Seattle'),
(4, 'Lucy Chen', 31, 'LA');

---------------

CREATE TABLE sales (
sale_id INT PRIMARY KEY,
car_id INT,
salesman_id INT,
purchase_date DATE,
FOREIGN KEY (car_id) REFERENCES cars(car_id),
FOREIGN KEY (salesman_id) REFERENCES salespersons(salesman_id)
);

---------------

INSERT INTO sales (sale_id, car_id, salesman_id, purchase_date)
VALUES (1, 1, 1, '2021-01-01'),
(2, 3, 3, '2021-02-03'),
(3, 2, 2, '2021-02-10'),
(4, 5, 4, '2021-03-01'),
(5, 8, 1, '2021-04-02'),
(6, 2, 1, '2021-05-05'),
(7, 4, 2, '2021-06-07'),
(8, 5, 3, '2021-07-09'),
(9, 2, 4, '2022-01-01'),
(10, 1, 3, '2022-02-03'),
(11, 8, 2, '2022-02-10'),
(12, 7, 2, '2022-03-01'),
(13, 5, 3, '2022-04-02'),
(14, 3, 1, '2022-05-05'),
(15, 5, 4, '2022-06-07'),
(16, 1, 2, '2022-07-09'),
(17, 2, 3, '2023-01-01'),
(18, 6, 3, '2023-02-03'),
(19, 7, 1, '2023-02-10'),
(20, 4, 4, '2023-03-01');

---------------

SELECT * 
FROM cars

SELECT *
FROM sales

SELECT *
FROM salespersons

-- Questions:

-- 1. Details of all cars purchased in the year 2022. 

SELECT c.car_id, c.make, c.type, c.style, c.cost_$, s.purchase_date
FROM cars c
INNER JOIN sales s on c.car_id = s.car_id
WHERE YEAR(s.purchase_date) = '2022'

-- 2. The total number of cars sold by each salesperson.

SELECT sp.salesman_id, sp.name, COUNT(*) AS total_no_of_cars_sold
FROM salespersons sp
INNER JOIN sales s on s.salesman_id = sp.salesman_id
GROUP BY sp.salesman_id, sp.name

-- 3. The total revenue generated by each salesperson.

SELECT s.salesman_id, sp.name, SUM(c.cost_$) as total_revenue
FROM sales s
INNER JOIN salespersons sp on sp.salesman_id = s.salesman_id
INNER JOIN cars c on c.car_id = s.car_id
GROUP BY s.salesman_id, sp.name

-- 4. The details of the cars sold by each salesperson.

SELECT sp.salesman_id, sp.name, c.car_id, c.make, c.type, c.style, c.cost_$
FROM salespersons sp
INNER JOIN sales s on s.salesman_id= sp.salesman_id
INNER JOIN cars c on c.car_id = s.car_id
ORDER BY sp.salesman_id

-- 5. The total revenue generated by each car type.

SELECT c.type, SUM(c.cost_$) as total_revenue
FROM cars c
INNER JOIN sales s on s.car_id = c.car_id
GROUP BY c.type
ORDER BY c.type

-- 6. The details of the cars sold in the year 2021 by salesperson 'Emily Wong'.

SELECT sp.name, c.car_id, c.make, c.type, c.style, c.cost_$, s.purchase_date
FROM cars c
INNER JOIN sales s on s.car_id = c.car_id
INNER JOIN salespersons sp on sp.salesman_id = s.salesman_id
WHERE YEAR(s.purchase_date) = '2021' AND sp.name = 'Emily Wong'

-- 7. The total revenue generated by the sales of hatchback cars.

SELECT c.style, SUM(c.cost_$) as total_revenue
FROM cars c
INNER JOIN sales s on s.car_id = c.car_id
GROUP BY c.style
HAVING c.style = 'Hatchback'

-- 8. The total revenue generated by the sales of SUV cars in the year 2022.

SELECT c.style, SUM(c.cost_$) as total_revenue
FROM cars c
INNER JOIN sales s on s.car_id = c.car_id
WHERE c.style = 'SUV' AND YEAR(s.purchase_date) = '2022'
GROUP BY c.style

-- 9. The name and city of the salesperson who sold the most number of cars in the year 2023.

SELECT TOP 1 sp.name, sp.city, COUNT(*) as most_cars_sold
FROM salespersons sp
INNER JOIN sales s on s.salesman_id = sp.salesman_id
WHERE YEAR(s.purchase_date) = '2023'
GROUP BY sp.name, sp.city
ORDER BY COUNT(*) DESC

-- 10. The name and age of the salesperson who generated the highest revenue in the year 2022.

SELECT TOP 1 sp.name, sp.age, SUM(c.cost_$) as highest_revenue
FROM salespersons sp
INNER JOIN sales s on s.salesman_id = sp.salesman_id
INNER JOIN cars c on c.car_id = s.car_id
WHERE YEAR(s.purchase_date) = '2022'
GROUP BY sp.name, sp.age
ORDER BY SUM(c.cost_$) DESC


