SET search_path TO genetic;

drop table if exists betas;
create table betas as
select
normal_rand(0, 3) AS b0,
normal_rand(0, 3) AS b1,
1 AS generation
FROM generate_series(1, 10);
 

select * from betas;


WITH 
max_gen as 
     (SELECT MAX(generation) AS generation FROM betas),
last_betas as (
    select * from betas
    where generation = (SELECT generation FROM max_gen)
 ),
 cp AS
    (SELECT o.*,
            b.b0,
            b.b1,
            b.generation,
            ((b.b0 + b.b1 * o.x) - o.y) ^ 2 AS sq_error
     FROM observations as o
     CROSS JOIN last_betas as b),
      rmse_calc AS
    (SELECT b0, b1, generation, |/AVG(sq_error) AS rmse
     FROM cp
     GROUP BY b0, b1, generation),
      ranked as
    (SELECT *,
            rank() over(
                        partition by generation
                        order by rmse) as rank
     FROM rmse_calc )
select *, (SELECT generation FROM max_gen) as mgen
from ranked;


INSERT INTO betas (b0, b1, generation)
SELECT
    b0 + (random() * 0.1),
    b1 + (random() * 0.1),
    max(generation) + 1
FROM
    ranked
-- where rank < 4
GROUP BY b0, b1, generation;


select *
from betas
order by generation desc;