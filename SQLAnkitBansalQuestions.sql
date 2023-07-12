/* Problem 1 Solution */
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
/* ========================================================================================================================================================================================================================*/
/* Problem 2 Find repeat customers and new customers */
Insert and create Statement
create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100),(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000);


Q1 : with cte as 
(select customer_id, min(order_date) as min_date from Customer_orders group by customer_id)

select o.order_date,
sum(case when min_date = order_date then 1 else 0 end) as new_customer,
sum(case when min_date < order_date then 1 else 0 end) as repeat_customer,
sum(case when min_date = order_date then order_amount else 0 end) as new_customer_order_amount,
sum(case when min_date < order_date then order_amount else 0 end) as repeate_customer_order_amount
from customer_orders o
inner join cte
on cte.customer_id = o.customer_id
group by order_date
/*====================================================================================================================================================================================================================*/
/* Problem 3 : resource used in office with total visited and most visited floors */
create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP'),('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR')

with floor_visits as
(
Select name, floor, count(1) as most_visited_floor,
rank() over(partition by name order by count(1) desc) as rn
from entries
group by name, floor),

total_visits as
(Select name,  count(1) as total_visits, string.agg(resources,', ') as resources_used from entries group by name )

Select fv.name, tv.total_visits, fv.floor as most_visited_floor, tv.resources_used from floor_visits as fv
inner join total_visits as tv
on fv.name = tv.name where fv.rn =1
/* ==================================================================================================================================================================================================================*/
/* Problem 4 : Leet code hard proble : calculate cancellation rate for unbanned users */
Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
Create table Users (users_id int, banned varchar(50), role varchar(50));

insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');

insert into Users (users_id, banned, role) values ('1', 'No', 'client');insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');insert into Users (users_id, banned, role) values ('10', 'No', 'driver');insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');insert into Users (users_id, banned, role) values ('13', 'No', 'driver');


with trip as
(
Select t.*
from Trips t
inner join users u
on t.client_id = u.users_id
inner join users d
on t.driver_id = d.users_id
where u.banned = 'No' AND d.banned ='No')

Select request_at,
(1.0*SUM(CASE WHEN status LIKE 'cancelled%' THEN 1 ELSE 0 END)/ count(*))*100 as cancelled_percent
from trip
group by request_at;
/*======================================================================================================================================================================================================================*/
/* Problem 5 : Leet code Hard problem : Tournament Winner*/
create table players
(player_id int,
group_id int);

insert into players values (15,1);insert into players values (25,1);insert into players values (30,1);insert into players values (45,1);insert into players values (10,2);insert into players values (35,2);insert into players values (50,2);
insert into players values (20,3);insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int);

insert into matches values (1,15,45,3,0);insert into matches values (2,30,25,1,2);insert into matches values (3,30,15,2,0);insert into matches values (4,40,20,5,2);insert into matches values (5,35,50,1,1);

with score as
(
select first_player as player_id, first_score as score from matches
union
select second_player as player_id, second_score as score from matches
),

total_score as
(
select s.player_id, p.group_id, sum(score) as total_score from score s 
inner join players p
on p.player_id = s.player_id
group by s.player_id, group_id),

ranking as
(select *, rank() over(partition by group_id order by total_score desc, player_id asc) as rn from total_score )

Select * from ranking 
where rn =1;
/*=====================================================================================================================================================================================================================*/
/*Problem 6 : Leetcode Hard Problem 3 | Market Analysis 2*/
create table users (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 create table orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );

 create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );


 insert into users values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2) ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);

/*Q1.*/ with ranking as
(
Select *,
rank() over(partition by seller_id order by order_date) as rn
from user_orders
),

fav_brand as
(
Select r.seller_id, r.item_id, i.item_brand
from ranking r
inner join items i
on i.item_id = r.item_id
where rn =2)

select  u.user_id, CASE WHEN item_brand = favorite_brand then 'yes' else 'no' end  as 'fav_brand' from users u left join fav_brand on u.user_id = seller_id

/*Q2.*/ with ranking as
(
Select *,
rank() over(partition by seller_id order by order_date) as rn
from user_orders
)
Select  u.user_id, 
CASE WHEN item_brand = favorite_brand then 'yes' else 'no' end  as 'fav_brand'
from users u
left join ranking r on u.user_id = seller_id AND rn =2
left join items i on i.item_id = r.item_id
/*=======================================================================================================================================================================================================================*/
/* tricky SQL Problem , fail/success */
create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail'),('2019-01-05','fail'),('2019-01-06','success')

/*Q1.*/ with seqn as
(
Select *,
row_number() over(order by date_value) as id,
row_number() over(partition by state order by date_value ) as seq, 
(row_number() over(order by date_value)  - row_number() over(partition by state order by date_value )) as diff
from tasks
order by date_value asc
)

Select min(date_value) as start_date, max(date_value) as end_date, state
from seqn
group by state, diff
order by min(date_value)
/*=======================================================================================================================================================================================================================*/
/* PayPal SQL Interview problem. This is very advanced SQL problem.*/
create table emp(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into emp values (1, 'Ankit', 100,10000, 4, 39); insert into emp values (2, 'Mohit', 100, 15000, 5, 48); insert into emp values (3, 'Vikas', 100, 10000,4,37); insert into emp values (4, 'Rohit', 100, 5000, 2, 16); insert into emp values (5, 'Mudit', 200, 12000, 6,55);
insert into emp values (6, 'Agam', 200, 12000,2, 14);insert into emp values (7, 'Sanjay', 200, 9000, 2,13);insert into emp values (8, 'Ashish', 200,5000,2,12);insert into emp values (9, 'Mukesh',300,6000,6,51);insert into emp values (10, 'Rakesh',300,7000,6,50);

with dept_salary as
(
Select department_id, avg(salary) as dept_avg_salary, count(*) no_of_emp, sum(salary) as total_dept_salary
from Emp 
group by department_id
),

final as
(
Select ds1.department_id, max(ds1.dept_avg_salary) dep_salary, 
sum(ds2.total_dept_salary) / sum(ds2.no_of_emp) as comp_salary
from dept_salary ds1
inner join dept_salary ds2
where ds1.department_id != ds2.department_id
group by ds1.department_id )

Select * from final
where dep_salary < comp_salary
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Leetcode Hard Problem | User Purchase Platform */
create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100),(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);

with cte as
(Select spend_date, sum(amount) as amt ,user_id, CASE WHEN count(distinct platform) = 1 then platform ElSE 'both' END device from spending group by spend_date, user_id)
select * from 
(
select  spend_date,	device,	sum(amt) as spend, count(*) as cnt from cte group by spend_date, device
union all
select distinct (spend_date),	'both' as device,	0 as spend, 0 as cnt from spending
)
group by spend_date, device
order by spend_date, device desc
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
with cte as
(
Select spend_date, sum(amount) as amt ,user_id, CASE WHEN count(distinct platform) = 1 then platform ElSE 'both' END device from spending group by spend_date, user_id
union all
select distinct (spend_date), 0 as amt, null as user_id,'both' as device	from spending
)
select  spend_date,	device,	sum(amt) as spend, count(distinct user_id) as cnt from cte group by spend_date, device order by spend_date, device desc
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Customer Churn and Retention Ananlysis */
create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);
delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150),(2,1,'2020-02-10',150),(3,2,'2020-01-16',150),(4,2,'2020-02-25',150),(5,3,'2020-01-10',150),(6,3,'2020-02-20',150),(7,4,'2020-01-20',150),(8,5,'2020-02-20',150);

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Leetcode Hard SQL Problem - 6 | Second Most Recent Activity or First activity in case there is no second activity*/

create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values ('Alice','Travel','2020-02-12','2020-02-20'),('Alice','Dancing','2020-02-21','2020-02-23'),('Alice','Travel','2020-02-24','2020-02-28'),('Bob','Travel','2020-02-11','2020-02-18');

with cte as
(  select *, count(*) over(partition by username) as cnt, row_number() over(partition by username order by startDate) as rn from UserActivity )

Select * from cte where rn =2 or cnt =1
/***************************************************************************************************************************************************************************************************************************/
/* Sportify Case Study */
CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
insert into activity values (1,'app-installed','2022-01-01','India'),(1,'app-purchase','2022-01-02','India'),(2,'app-installed','2022-01-01','USA'),(3,'app-installed','2022-01-01','USA'),(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India'),(4,'app-purchase','2022-01-03','India'),(5,'app-installed','2022-01-03','SL'),(5,'app-purchase','2022-01-03','SL'),(6,'app-installed','2022-01-04','Pakistan'),(6,'app-purchase','2022-01-04','Pakistan');

/* Question 1 : Find total active users daily */
select event_date, count(distinct user_id) as active_user from activity group by event_date

 /* Question 2 : Total active users weekly */
Select datepart(week, event_date) as week, count(distinct user_id) as active_user from activity group by datepart(week, event_date)

 /*Question 3 : date-wise total number of users who purchased the app same day*/
with users as
(
select user_id, event_date, CASE WHEN count(distinct event_name) = 2 Then user_id else NULL END as user from activity group by user_id, event_date
)

select event_date, count(user) from users group by event_date
/*Question 4 : percentage of paid users in India, USA and Other countries */
with cte as
(
select 
CASE WHEN Country in('India','USA')Then country else 'Others' END as new_country, count(distinct user_id) as paid from activity
where event_name = 'app-purchase' group by CASE WHEN Country in('India','USA')Then country else 'Others' END
),
total as(Select  sum(paid) as total from cte)
Select new_country, (1.0*(paid)/total)*100 as paid_users from cte, total

/*Question 5 : find the number of users who made same day purchases */
