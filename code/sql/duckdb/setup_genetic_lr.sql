-- Setting up initial tables for genentic linear regression

CREATE SCHEMA IF NOT EXISTS linreg;

USE linreg;


WITH parameters AS (
    SELECT 0 AS mean, 2.0 AS stddev  
)
SELECT 
    (sqrt(-2 * ln(random())) * cos(2 * pi() * random()) * stddev + mean) AS b0,
    (sqrt(-2 * ln(random())) * cos(2 * pi() * random()) * stddev + mean) AS b1
FROM range(10), parameters; 




drop table observations;

create table observations as(
with vars as (
    select 
    3 as b0_true,
    5 as b1_true
)
SELECT x,
       b0_true + b1_true*x + normal_rand(0, 4) as y
FROM
    vars, 
    (Select normal_rand(6, 3) AS x FROM generate_series(1, 20)) AS T);



-- SELECT generate_series(
--     '2024-01-01'::date,
--     '2024-01-10'::date,
--     '1 day'::interval
-- );

-- DROP TABLE IF EXISTS heteroscedastic;
-- CREATE TABLE heteroscedastic AS
-- SELECT x,
--        x * normal_rand(0, 0.5) as y
-- FROM
--     (Select normal_rand(6, 3) AS x
--      FROM generate_series(1, 100)) AS T