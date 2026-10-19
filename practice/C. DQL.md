## DATA QUERY LANGUAGE

### OPERATORS IN POSTGRESQL

#### 1. Arithmetic
| Operator | Description | Example | Result |
|---|---|---|---|
| + | addition | `5 + 3` | 8 |
| - | subtraction | `5 - 3` | 2 |
| * | multiplication | `5 * 3` | 15 |
| / | division (**integer division truncates** for integer inputs) | `7 / 2` | 3 |
| % | modulo (remainder) | `7 % 2` | 1 |
| ^ | exponent | `2 ^ 3` | 8 |
| \|/ | square root | `\|/ 25` | 5 |
| \|\|/ | cube root | `\|\|/ 27` | 3 |
| @ | absolute value | `@ -5` | 5 |

📌 NOTE
- `7 / 2` gives `3`, not `3.5`, because both inputs are integers. Cast one side to get a decimal result: `7 / 2.0` or `7::NUMERIC / 2`.
- The sign of `%` follows the left operand: `-7 % 3` is `-1`.
- `^` is **left-associative** in PostgreSQL, so `2 ^ 3 ^ 2` is `(2^3)^2 = 64`, not `2^9 = 512`.
- Unary minus binds tighter than `^`, so `-2 ^ 2` is `4`.
- The postfix factorial operator `5 !` was removed in PostgreSQL 14. Use `factorial(5)`.

```sql
SELECT 7 / 2          AS int_division,     -- 3
       7 / 2.0        AS decimal_division, -- 3.5000000000000000
       7::NUMERIC / 2 AS cast_division,    -- 3.5000000000000000
       -7 % 3         AS modulo,           -- -1
       2 ^ 3 ^ 2      AS power,            -- 64
       |/ 144         AS sqrt,             -- 12
       @ -42          AS abs_value;        -- 42

-- Practical: average fare per passenger without integer truncation
SELECT 4350 / 3                    AS wrong,  -- 1450 (looks right only by luck)
       round(4351::NUMERIC / 3, 2) AS right;  -- 1450.33
```
#### 2. Comparison
| Operator | Description | Example | Result |
|---|---|---|---|
| = | equal | `5 = 5` | true |
| <> or != | not equal | `5 <> 3` | true |
| < | less than | `3 < 5` | true |
| > | greater than | `3 > 5` | false |
| <= | less than or equal | `5 <= 5` | true |
| >= | greater than or equal | `3 >= 5` | false |
| BETWEEN a AND b | within range, **both ends inclusive** | `5 BETWEEN 1 AND 5` | true |
| IS NULL / IS NOT NULL | checks for NULL | `NULL IS NULL` | true |
| IS DISTINCT FROM | not equal, treating NULL as a normal value | `NULL IS DISTINCT FROM NULL` | false |
| IS NOT DISTINCT FROM | equal, treating NULL as a normal value | `NULL IS NOT DISTINCT FROM NULL` | true |

📌 NOTE
- Any comparison with NULL using `=` or `<>` gives **NULL**, not true or false. `NULL = NULL` is NULL. Always use `IS NULL`.
- `BETWEEN` includes both ends. With timestamps that is a trap: `booked_at BETWEEN '2026-10-01' AND '2026-10-31'` misses everything after midnight on the 31st. Prefer `>= start AND < next_day`.
- `IS DISTINCT FROM` is the safe way to detect "value changed" in triggers and audits, because it handles NULLs correctly.

```sql
SELECT NULL = NULL                       AS eq,        -- NULL
       NULL IS NULL                      AS is_null,   -- true
       NULL IS DISTINCT FROM 5           AS distinct1, -- true
       NULL IS DISTINCT FROM NULL        AS distinct2, -- false
       'b' BETWEEN 'a' AND 'c'           AS str_between; -- true (works on text too)

-- Safe date-range filter (half-open interval)
SELECT * FROM bookings_b
WHERE booked_at >= '2026-10-01'
  AND booked_at <  '2026-11-01';

```

#### 3. Logical
| Operator | Description | Example | Result |
|---|---|---|---|
| AND | true if both are true | `true AND false` | false |
| OR | true if at least one is true | `true OR false` | true |
| NOT | reverses the value | `NOT true` | false |

📌 NOTE
- `AND` binds tighter than `OR`. `a OR b AND c` means `a OR (b AND c)`. Use parentheses to make intent clear.
- `WHERE` keeps a row only when the condition is **true**. Rows where it is NULL are dropped, just like false.
- `false AND NULL` is false, and `true OR NULL` is true, because the unknown value can't change the result.

```sql
-- Bug: intended "confirmed or RAC bookings on train 12723"
SELECT * FROM bookings_b
WHERE status = 'CONFIRMED' OR status = 'RAC' AND train_id = 12723;
-- Actually means: CONFIRMED on ANY train, OR RAC on 12723

-- Fix
SELECT * FROM bookings_b
WHERE (status = 'CONFIRMED' OR status = 'RAC') AND train_id = 12723;
```
#### 4. String
| Operator | Description | Example | Result |
|---|---|---|---|
| \|\| | concatenation | `'HYB' \|\| '-' \|\| 'SC'` | HYB-SC |
| LIKE | pattern match, case-sensitive (`%` = any characters, `_` = exactly one) | `'Hyderabad' LIKE 'Hyd%'` | true |
| ILIKE | pattern match, case-insensitive (PostgreSQL-specific) | `'Hyderabad' ILIKE 'hyd%'` | true |
| NOT LIKE / NOT ILIKE | negated pattern match | `'Pune' NOT LIKE 'H%'` | true |
| ~ | regex match, case-sensitive | `'HYB' ~ '^[A-Z]{3}$'` | true |
| ~* | regex match, case-insensitive | `'hyb' ~* '^[A-Z]{3}$'` | true |
| !~ | regex does not match, case-sensitive | `'hyb' !~ '^[A-Z]+$'` | true |
| !~* | regex does not match, case-insensitive | `'123' !~* '^[a-z]+$'` | true |
| ^@ | starts with | `'Hyderabad' ^@ 'Hyd'` | true |

📌 NOTE
- `||` with NULL gives NULL: `'Train ' || NULL` is NULL. Use `concat()` or `concat_ws()`, which skip NULLs.
- `LIKE 'Hyd%'` (prefix) can use a B-tree index. `LIKE '%bad'` (leading wildcard) cannot, so it scans the whole table. For "contains" searches on large tables, look at the `pg_trgm` extension with a GIN index.
- In `LIKE`, `_` matches one character. To match a literal `_` or `%`, escape it: `LIKE 'A\_%'`.
- `~` is unanchored: `'XHYBX' ~ 'HYB'` is true. Use `^` and `$` to match the whole string.

```sql
SELECT 'Train ' || 12723          AS concat_num,   -- Train 12723 (number converted automatically)
       'Train ' || NULL           AS concat_null,  -- NULL
       concat('Train ', NULL)     AS concat_fn,    -- Train
       concat_ws(' - ', 'HYB', NULL, 'SC') AS ws; -- HYB - SC

-- Stations whose name starts with 'Sec' (case-insensitive)
SELECT * FROM stations WHERE name ILIKE 'sec%';

-- Station codes that are exactly 3 letters
SELECT * FROM stations WHERE station_code ~ '^[A-Z]{3}$';

-- Names with exactly 4 characters
SELECT * FROM stations WHERE name LIKE '____';
```

#### 5. Set membership & subquery operators
| Operator | Description | Example | Result |
|---|---|---|---|
| IN (list) | value matches any in the list | `3 IN (1, 2, 3)` | true |
| NOT IN (list) | value matches none in the list | `4 NOT IN (1, 2, 3)` | true |
| = ANY (array / subquery) | true if the comparison is true for at least one element | `3 = ANY(ARRAY[1,2,3])` | true |
| > ALL (array / subquery) | true if the comparison is true for every element | `5 > ALL(ARRAY[1,2,3])` | true |
| EXISTS (subquery) | true if the subquery returns at least one row | `EXISTS (SELECT 1)` | true |
| NOT EXISTS (subquery) | true if the subquery returns no rows | | |

📌 NOTE
- **The NOT IN trap:** if the list or subquery contains even one NULL, `NOT IN` returns NULL for every row, so the query returns **nothing**. `5 NOT IN (1, NULL)` is NULL.
- Prefer `NOT EXISTS` for "rows with no match in another table." It handles NULLs correctly and usually plans at least as well.
- `ANY` works with any comparison operator (`<`, `>=`, `LIKE`, ...), not just `=`.
- `x > ALL(empty set)` is **true**, because there is nothing to fail the condition.

```sql
SELECT 5 NOT IN (1, 2)     AS normal,     -- true
       5 NOT IN (1, NULL)  AS null_trap;  -- NULL

-- Passengers who have never made a booking
-- Risky if bookings_b.passenger_id can be NULL:
SELECT * FROM passengers
WHERE passenger_id NOT IN (SELECT passenger_id FROM bookings_b);

-- Safe:
SELECT * FROM passengers p
WHERE NOT EXISTS (SELECT 1 FROM bookings_b b WHERE b.passenger_id = p.passenger_id);

-- Station name matches any of several patterns
SELECT * FROM stations WHERE name ILIKE ANY (ARRAY['%junction', '%central', '%terminus']);
```