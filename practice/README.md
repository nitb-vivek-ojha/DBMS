## SQL PRACTICE

### SET UP THE DATABASE
1. Make sure you have docker installed in your system.
2. Edit the .env file.
3. Run the following command
```
cd practice/
docker-compose up
```
4. At this point your database should be up and running. Verify it by running the following command
```
# open another shell and run
docker ps -a
```
![container-startup](/assets/container-startup.png)

5. Migrate.sh will create tables and seed your database.
```
cd /practice
chmod +x migrate.sh
./migrate.sh
```
6. Open shell and connect to your database via psql
```
docker exec -it postgres psql -U <user> -d <database-name>
```
![connect-with-psql](/assets/psql.png)

7. Run the follwoing commands
![schema-description](/assets/schema.png)

8. Handy commands
```
\l              list all databases
\c railway      connect to a different database
\dt             list tables in the current schema
\d <table>     describe a table (columns, indexes, constraints, FKs)
\dn             list schemas
\di             list indexes
\df             list functions
\x              toggle expanded output (essential for wide rows)
\e              open the last query in $EDITOR
\q              quit 
ctrl + L        clearing screen (for windows)
```

### BASIC SQL COMMANDS
#### DATA MANIPULATION LANGUAGE
```sql
-- ====================== EXAMPLE 1  ==========================================
INSERT INTO PERSON (id, name, dob, age)
VALUES 
    (1, "Vivek", NULL, 24),
    (2, "Vinay", NULL, 23)

-- ====================== EXAMPLE 2  ==========================================
INSERT INTO PERSON (id, name, dob, age)
SELECT id, name, NULL, 'Unknown' -- static values 
FROM customers -- all the customer entries will be inserted into table person

-- ====================== EXAMPLE 3  ==========================================
UPDATE person
SET
    name = "X",
    age = 25

WHERE id = 10; -- use WHERE clause to avoid updating all rows unintentionally

```

#### DATA QUERY LANGUAGE
```sql
-- 1. Coding Order: SELECT, DISTINCT, FROM, WHERE, GROUP BY, HAVING, ORDER BY, LIMIT & OFFSET

-- 2. Execution Order: FROM, WHERE, GROUP BY, HAVING, SELECT + DISTINCT, ORDER BY, LIMIT & OFFSET

-- 3. Operators 
--    a. Comparison: =, != or <>, <, <=, >, >=
--    b. Logical: AND, OR, NOT
--    c. Pattern Matching: LIKE, ILIKE, POSIX (~)
--    d. Set/Range: IN, BETWEEN (inclusive), EXISTS 
--    e. Null Checks: IS NULL, IS NOT NULL

-- ====================== EXAMPLE 1  ============================
-- a. DISTINCT applies to complete row for uniqueness
-- b. Aggregate functions are not used with WHERE clause 
-- c. AS (ALIAS)
-- d. LIMIT 2 OFFSET 1 (skip 1 record and give next 2 records)
-- ==============================================================
SELECT DISTINCT train_id AS id, number 
FROM trains
WHERE train_id < 5
ORDER BY number ASC
LIMIT 2 OFFSET 1;

SELECT 123 AS temp_values; -- static values

-- ====================== EXAMPLE 2 (GROUP BY) =================================
-- THE COLUMNS IN SELECT COMMAND MUST OBEY ANY OF THE TWO CONDITIONS
--      a. Be included exactly as-is in the GROUP BY clause
--      b. Be wrapped inside an aggregate function (like COUNT(), SUM(), etc.)
-- =============================================================================
SELECT travel_class, COUNT(travel_class) as passenger_count
FROM bookings
GROUP BY travel_class
ORDER BY passenger_count ASC;

SELECT travel_class
FROM bookings
GROUP BY travel_class
HAVING COUNT(travel_class) < 10
ORDER BY COUNT(travel_class) DESC
LIMIT 1;

-- ====================== EXAMPLE 3 (JOINS) =================================
-- INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN
-- LEFT ANTI JOIN, RIGHT ANTI JOIN, FULL ANTI JOIN
-- =============================================================================

SELECT c.id, c.name, o.orderid
FROM customer AS c
INNER JOIN order as o -- order of table does not matter in INNER JOIN
ON c.id = o.id

SELECT c.id, c.name, o.orderid
FROM customer as c
LEFT JOIN order as o -- order of table matters here (left table)A-B(right table)
ON c.id = o.id

SELECT c.id, c.name, o.orderid
FROM customer as c
RIGHT JOIN order as o -- order of table matters here (left table)A-B(right table)
ON c.id = o.id -- same result can be achieved by flipping the order of table and join type

SELECT c.id, c.name, o.orderid
FROM customer as c -- order does not matter here
FULL JOIN order as o -- db will take every row from left table and try to match id in the right table. If id matches data from right will be added otherwise null will be added. The same is performed from right side.
ON c.id = o.id

-- ============================== ANTI JOINS ==================================

SELECT *
FROM customer AS c
LEFT JOIN order AS o
ON c.id = o.id
WHERE o.customerid = NULL -- LEFT ANTI JOIN (right key is null)

SELECT *
FROM customer AS c
RIGHT JOIN order AS o
ON o.id = c.id
WHERE c.id = NULL -- RIGHT ANTI JOIN (left key is null)

SELECT *
FROM customer AS c
LEFT JOIN order AS o
ON c.id = o.id
WHERE o.customerid = NULL OR c.id = NULL -- FULL ANTI JOIN

-- ============================ CROSS JOIN ==================================
SELECT *
FROM customer
CROSS JOIN order
-- ==========================================================================

-- QUESTION: Condition to apply a JOIN ?
-- 1. Normally to extract meaningful data from join the two tables must share a relation. A typical join condition pairs a foreign key from one table with its corresponding primary key in another table.

-- 2. You can still apply a JOIN even if the tables are unrelated. The resulting output will be a cartesian product (every single row of the first table with every single row of the second table)

SELECT * 
FROM Users 
JOIN Products ON 1=1;

-- QUESTION: does a join yield more than one matching column ?
-- Yes
/*
Users
    UserID: 1 | Name: Alice

Orders
    OrderID: 101 | UserID: 1 | Item: Laptop
    OrderID: 102 | UserID: 1 | Item: Mouse
*/

SELECT *
FROM Users as u
LEFT JOIN Orders as o
ON u.UserID = 0.UserID
```


