Q1 : Select team,sum(no_of_wins) + sum(no_of_losses) as total_match,  sum(no_of_wins) as won, sum(no_of_losses) as lost
from
(
select team_1 as team,
case when team_1 =winner then 1 else 0 end  as 'no_of_wins', case when team_1 !=winner then 1 else 0 end  as 'no_of_losses' from icc_world_cup
union all
select team_2 as team, case when team_2 =winner then 1 else 0 end  as 'no_of_wins', case when team_2 !=winner then 1 else 0 end  as 'no_of_losses' from icc_world_cup
)
group by team
order by won desc

Q2 : Select team, count(*) as total_match,  sum(no_of_wins) as won, count(*) - sum(no_of_wins) as lost
from
(
select team_1 as team, case when team_1 =winner then 1 else 0 end  as 'no_of_wins' from icc_world_cup
union all
select team_2 as team, case when team_2 =winner then 1 else 0 end  as 'no_of_wins' from icc_world_cup
)
group by team
order by won desc

--- Problem 2 Find repeat customers and new customers
Insert and create Statement
create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);
