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



/*===============================================================================================================================================================================================================================*/
