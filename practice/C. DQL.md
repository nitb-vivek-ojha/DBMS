## DATA QUERY LANGUAGE

### BASIC SYNTAX

```sql
-- 1. Coding Order: SELECT, DISTINCT, FROM, JOIN, WHERE, GROUP BY, HAVING, ORDER BY, LIMIT & OFFSET

-- 2. Execution Order: FROM, JOIN, WHERE, GROUP BY, HAVING, SELECT + DISTINCT, ORDER BY, LIMIT & OFFSET

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

```

### JOINS IN SQL

```sql
CREATE TABLE passenger (
  passenger_id int PRIMARY KEY,
  name         text NOT NULL,
  city         text NOT NULL
);
 
INSERT INTO passenger (passenger_id, name, city) VALUES
  (1, 'Aarav', 'Delhi'),
  (2, 'Diya',  'Mumbai'),
  (3, 'Kabir', 'Delhi'),
  (4, 'Meera', 'Jaipur'),  
  (5, 'Rohan', 'Pune');  


CREATE TABLE booking (
    pnr          text PRIMARY KEY,
    passenger_id int  NOT NULL,
    train_no     text NOT NULL,
    from_stn     text NOT NULL,
    to_stn       text NOT NULL,
    fare         numeric(8,2) NOT NULL
);
 
INSERT INTO booking (pnr, passenger_id, train_no, from_stn, to_stn, fare) VALUES
  ('PNR1001', 1, '12951', 'BCT',  'NDLS', 3200.00),
  ('PNR1002', 1, '12953', 'ST',   'NZM',  2900.00),  
  ('PNR1003', 2, '12909', 'BDTS', 'NZM',  1800.00),
  ('PNR1004', 3, '12951', 'BRC',  'NDLS', 2600.00),
  ('PNR1005', 9, '12953', 'BCT',  'KOTA', 2100.00); 

/*
 passenger_id | name  |  city  
--------------+-------+--------
            1 | Aarav | Delhi
            2 | Diya  | Mumbai
            3 | Kabir | Delhi
            4 | Meera | Jaipur
            5 | Rohan | Pune

   pnr   | passenger_id | train_no | from_stn | to_stn |  fare   
---------+--------------+----------+----------+--------+---------
 PNR1001 |            1 | 12951    | BCT      | NDLS   | 3200.00
 PNR1002 |            1 | 12953    | ST       | NZM    | 2900.00
 PNR1003 |            2 | 12909    | BDTS     | NZM    | 1800.00
 PNR1004 |            3 | 12951    | BRC      | NDLS   | 2600.00
 PNR1005 |            9 | 12953    | BCT      | KOTA   | 2100.00

*/
```

#### 1. INNER JOIN
```sql
SELECT *
FROM booking AS b
INNER JOIN passenger AS p
ON b.passenger_id = p.passenger_id

/*
   pnr   | passenger_id | train_no |  fare   | passenger_id | name  |  city  
---------+--------------+----------+---------+--------------+-------+--------
 PNR1001 |            1 | 12951    | 3200.00 |            1 | Aarav | Delhi
 PNR1002 |            1 | 12953    | 2900.00 |            1 | Aarav | Delhi
 PNR1003 |            2 | 12909    | 1800.00 |            2 | Diya  | Mumbai
 PNR1004 |            3 | 12951    | 2600.00 |            3 | Kabir | Delhi

*/
```