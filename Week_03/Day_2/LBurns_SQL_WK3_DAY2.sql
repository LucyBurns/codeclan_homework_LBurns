--Question 1.
--(a). Find the first name, last name and team name of employees 
--who are members of teams.

select 
    e.first_name ,
    e.last_name ,
    t."name" 
from employees as e inner join teams as t
on e.team_id = t.id ;


--Hint
--We only want employees who are also in the teams table. So which 
--type of join should we use?


--(b). Find the first name, last name and team name of employees who 
--are members of teams and are enrolled in the pension scheme.

select 
    e.first_name ,
    e.last_name ,
    t."name" 
from employees as e inner join teams as t
on e.team_id = t.id 
where e.pension_enrol is true;



--(c). Find the first name, last name and team name of employees who 
--are members of teams, where their team has a charge cost greater than 80.

--Hint
--charge_cost may be the wrong type to compare with value 80. 
--Can you find a way to convert it without changing the database?


select 
    e.first_name ,
    e.last_name ,
    t."name" ,
    cast(t.charge_cost as int)
from employees as e inner join teams as t
on e.team_id = t.id 
where (cast(t.charge_cost as int)) > 80;


-- Alternative Answer
SELECT 
  e.first_name, 
  e.last_name, 
  t.name AS team_name
FROM employees AS e INNER JOIN teams AS t
ON e.team_id = t.id
WHERE t.charge_cost::INT > 80;



--Question 2.
--(a). Get a table of all employees details, together with their 
-- local_account_no and local_sort_code, if they have them.

--Hints
--local_account_no and local_sort_code are fields in pay_details, 
-- and employee details are held in employees, so this query requires a JOIN.

--What sort of JOIN is needed if we want details of all employees, 
--even if they don’t have stored local_account_no and local_sort_code?

select 
    e.* ,
    pd.local_account_no ,
    pd.local_sort_code 
from employees as e inner join pay_details as pd
on e.pay_detail_id = pd.id ;


-- to get all employees even without values - change to left join
select 
    e.* ,
    pd.local_account_no ,
    pd.local_sort_code 
from employees as e left join pay_details as pd
on e.pay_detail_id = pd.id ;


-- Suggested answer
SELECT 
  e.*,
  pd.local_account_no,
  pd.local_sort_code,
  t.name AS team_name
FROM employees AS e LEFT JOIN pay_details AS pd
ON e.pay_detail_id = pd.id
LEFT JOIN teams AS t
ON e.team_id = t.id



--(b). Amend your query above to also return the name of the team that 
--each employee belongs to.

--Hint
--The name of the team is in the teams table, so we will need to do another join.

select 
    e.* ,
    pd.local_account_no ,
    pd.local_sort_code,
    t."name" 
from 
    (employees as e inner join pay_details as pd
    on pay_detail_id = pd.id )
inner join teams as t
on e.team_id = t.id;

-- Note - answer has this as a left join, not inner join



--Question 3.
--(a). Make a table, which has each employee id along with the team 
--that employee belongs to.


select 
    e.id ,
    t.name 
from employees as e left join teams as t
on e.team_id = t.id ;




--(b). Breakdown the number of employees in each of the teams.


select 
    t.name ,
    count(e.id)
from employees as e left join teams as t
on e.team_id = t.id 
group by t.name;




--Hint
--You will need to add a group by to the table you created above.


--(c). Order the table above by so that the teams with the least 
--employees come first.


select 
    t.name ,
    count(e.id)
from employees as e left join teams as t
on e.team_id = t.id 
group by t.name
order by count(e.id) desc;


--Suggested answer - remember to name the computed columns
SELECT 
  t.name AS team_name, 
  COUNT(e.id) AS num_employees
FROM teams AS t LEFT JOIN employees AS e
ON e.team_id = t.id
GROUP BY t.name
ORDER BY num_employees ASC



--Question 4.
--(a). Create a table with the team id, team name and the count of the number of 
--employees in each team.


select 
    t.name ,
    t.id ,
    count(e.id) as num_employees
from employees as e left join teams as t
on e.team_id = t.id 
group by t.id ;




--(b). The total_day_charge of a team is defined as the charge_cost of the team 
--multiplied by the number of employees in the team. Calculate the 
--total_day_charge for each team.

--Hint
--If you GROUP BY teams.id, because it’s the primary key, you can SELECT 
--any other column of teams that you want (this is an exception to the rule 
-- that normally you can only SELECT a column that you GROUP BY).

select 
    t.name ,
    t.id ,
    count(e.id) as num_employees,
    (count(e.id) * (cast(t.charge_cost as int)) ) as charge_cost
from employees as e left join teams as t
on e.team_id = t.id 
group by t.id ;

-- Alternative Answer
SELECT 
  t.name,
  COUNT(e.id) * CAST(t.charge_cost AS INT) AS total_day_charge
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id



--(c). How would you amend your query from above to show only those teams 
--with a total_day_charge greater than 5000?


select 
    t.name ,
    t.id ,
    t.total_day_charge
from  
    (select
    t.id,
    t.name,
    count(e.id) as num_employees,
    t.charge_cost,
    cast(t.charge_cost as int)* count(e.id) 
            as total_day_charge
from teams as t left join employees as e
on t.id = e.team_id   
group by t.name, t.id   )t
where total_day_charge > 5000;
    
--Alternative answer
SELECT 
  t.name,
  COUNT(e.id) * CAST(t.charge_cost AS INT) AS total_day_charge
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id
HAVING COUNT(e.id) * CAST(t.charge_cost AS INT) > 5000




-- 2 Extension


--Question 5.
-- How many of the employees serve on one or more committees?


--Hints
--All of the details of membership of committees is held in a single table: 
--employees_committees, so this doesn’t require a join.

select
    count(distinct employee_id )
from employees_committees as ec 


--Some employees may serve in multiple committees. Can you find the 
--number of distinct employees who serve? [Extra hint - do some research on the DISTINCT() function].


--Question 6.
--How many of the employees do not serve on a committee?

select *
from employees as e left join employees_committees as ec 
on e.id = ec.employee_id 
where ec.id is null

--Hints
--This requires joining over only two tables

--Could you use a join and find rows without a match in the join?





