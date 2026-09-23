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
-- ========================== DATA MANIPULATION LANGUAGE =============================
-- EXAMPLE 1
INSERT INTO PERSON (id, name, dob, age)
SELECT id, name, NULL, 'Unknown' -- static values 
FROM customers -- all the customer entries will be inserted into table person


-- ========================== DATA QUERY LANGUAGE ====================================
-- a. Coding Order: SELECT, DISTINCT, FROM, WHERE, GROUP BY, HAVING, ORDER BY, LIMIT & OFFSET

-- b. Execution Order: FROM, WHERE, GROUP BY, HAVING, SELECT + DISTINCT, ORDER BY, LIMIT & OFFSET
-- ===================================================================================

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
--      1. Be included exactly as-is in the GROUP BY clause
--      2. Be wrapped inside an aggregate function (like COUNT(), SUM(), etc.)
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