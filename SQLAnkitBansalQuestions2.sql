/* Find 3 or more consucutive empty seats. */
create table bms (seat_no int ,is_empty varchar(10));
insert into bms values (1,'N'),(2,'Y'),(3,'N'),(4,'Y'),(5,'Y'),(6,'Y'),(7,'N'),(8,'Y'),(9,'Y'),(10,'Y'),(11,'Y'),(12,'N'),(13,'Y'),(14,'Y');
-- Solution 1 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
with cte as ( Select *,
lag(is_empty,1) over(ORDER BY seat_no ROWS BETWEEN 1 PRECEDING AND current row) as prev_1, lag(is_empty,2) over(ORDER BY seat_no ROWS BETWEEN 1 PRECEDING AND current row) as prev_2,
lead(is_empty,1) over(ORDER BY seat_no ROWS BETWEEN current row And 1 following) as next_1, lead(is_empty,2) over(ORDER BY seat_no ROWS BETWEEN current row And 1 following) as next_2 from bms)

select seat_no from cte
where is_empty = 'Y' AND prev_1 ='Y' AND prev_2 = 'Y' OR (is_empty = 'Y' AND next_1 ='Y' AND next_2 = 'Y') OR (is_empty = 'Y' AND prev_1 ='Y' AND next_1 = 'Y');
--Solution 2 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
with cte as (  Select *,
SUM (CASE WHEN is_empty ='Y' Then 1 ELSE 0 END) over(ORDER BY seat_no ROWS BETWEEN 1 PRECEDING AND 1 Following) as curr, 
SUM (CASE WHEN is_empty ='Y' Then 1 ELSE 0 END) over(ORDER BY seat_no ROWS BETWEEN 2 PRECEDING AND current row) as prev,
SUM (CASE WHEN is_empty ='Y' Then 1 ELSE 0 END) over(ORDER BY seat_no ROWS BETWEEN current row AND 2 Following) as next from bms)

select seat_no from cte where curr= 3 OR prev= 3 OR next=3
--Solution 3 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*============================================================================================================================================================================================================================*/
/*Solving an SQL Puzzle */
create table input (
id int, formula varchar(10),value int)
insert into input values (1,'1+4',10),(2,'2+1',5),(3,'3-2',40),(4,'4-1',20);

with cte as ( select id, value,formula,substring (formula, 2,1) as operation, substring (formula, 3,1) as id2 from input)

Select c1.id, c1.formula,c1.value, CASE WHEN c1.operation = "+" THEN c1.value + c2. value ELSE c1.value -c2.value END as new_value
from cte c1 inner join cte c2 on c1.id2 = c2.id
/*============================================================================================================================================================================================================================*/
/*Top 10 SQL interview Questions and Answers | Frequently asked SQL interview questions.*/
Create table emp (emp_id int, emp_name varchar(20), dep_id varchar(10), salary int, manager_id varcar(10));

insert into Emp values (1,'Ankit',100,10000,4),(2,'Mohit',100,15000,5),(3,'Vikas',100,10000,4),(4,'Rohit',100,5000,2),(5,'Mudit',200,12000,6),(6,'Angam',200,12000,2),(7,'Sanjay',200,9000,2),(8,'Ashish',200,5000,2),(1,'Saubrabh',900,12000,2)
/* Find duplicates in a given table */
Select emp_id, count(emp_id) from Emp group by emp_id having count(emp_id) >1 ;
/* How to delete duplicates*/
with cte as (Select *, row_number() over(partition by emp_id order by emp_id) as rn from Emp )
delete from cte where rn >1
/*Union and Union all */
