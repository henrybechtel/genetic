CREATE SCHEMA IF NOT EXISTS genetic;

SET search_path TO genetic;

DROP TABLE IF EXISTS public.exp_data;
CREATE TABLE public.exp_data AS
SELECT
    random() * 100 AS x, 
    random() * 100 AS y
FROM generate_series(1, 10);  



SELECT generate_series(
    '2024-01-01'::date,
    '2024-01-10'::date,
    '1 day'::interval
);


with vars as (
    select 
    3 as b0_true,
    5 as b1_true
)
SELECT x,
       b0_true + b1_true*x + normal_rand(0, 2) as y
FROM
    vars, 
    (Select normal_rand(6, 3) AS x FROM generate_series(1, 100)) AS T




DROP TABLE IF EXISTS normalscatter;
CREATE TABLE normalscatter AS
SELECT x,
       b0_true + b1_true*x + normal_rand(0, 2) as y
FROM
    (Select normal_rand(6, 3) AS x
     FROM generate_series(1, 100)) AS T


-- DROP TABLE IF EXISTS heteroscedastic;
-- CREATE TABLE heteroscedastic AS
-- SELECT x,
--        x * normal_rand(0, 0.5) as y
-- FROM
--     (Select normal_rand(6, 3) AS x
--      FROM generate_series(1, 100)) AS T