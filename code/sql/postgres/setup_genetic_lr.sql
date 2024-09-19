-- Setting up initial tables for genentic linear regression

CREATE SCHEMA IF NOT EXISTS genetic;

SET search_path TO genetic;

CREATE OR REPLACE FUNCTION normal_rand(mean DOUBLE PRECISION, stddev DOUBLE PRECISION)
RETURNS DOUBLE PRECISION AS $$
DECLARE
    u1 DOUBLE PRECISION;
    u2 DOUBLE PRECISION;
    z0 DOUBLE PRECISION;
    z1 DOUBLE PRECISION;
BEGIN
    -- Generate two independent uniform random variables between 0 and 1
    u1 := random();
    u2 := random();
    
    -- Apply the Box-Muller transform
    z0 := sqrt(-2 * ln(u1)) * cos(2 * pi() * u2);
    -- z1 := sqrt(-2 * ln(u1)) * sin(2 * pi() * u2); -- Optional second normal variable
    /* Even though you only need one normal random variable, 
    the method still requires two uniform random variables because the transformation 
    mathematically depends on this pair. However, it efficiently produces two normals at once, 
    so if you need another normal number shortly after, you could reuse the discarded z1 to save on computation. */

    -- Scale and shift the result to match the desired mean and standard deviation
    RETURN mean + z0 * stddev;
END;
$$ LANGUAGE plpgsql;




drop table observations
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
    (Select normal_rand(6, 3) AS x FROM generate_series(1, 20)) AS T
)

select * 
from observations
order by x;

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