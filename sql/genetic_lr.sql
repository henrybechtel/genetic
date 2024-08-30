-- SET search_path TO genetic;

WITH cp AS (
    SELECT
        o.*,
        b.b0,
        b.b1,
        ((b.b0 + b.b1 * o.x) - o.y) ^ 2 AS sq_error
    FROM 
        observations as o
    CROSS JOIN 
        betas as b
),
rmse_calc AS (
    SELECT 
        b0,
        b1,
        |/AVG(sq_error) AS RMSE
    FROM 
        cp
    GROUP BY b0, b1
),
ranked as (
SELECT *,
rank() over(order by rmse) as rank
FROM rmse_calc
)
select *
from ranked
WHERE rank < 5;