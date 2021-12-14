/* MVP */
/* Q1 */
-- Question 1.
-- Find all the employees who work in the ‘Human Resources’ department.

select *
from employees e 
where department = 'Human Resources';


/* Q2 */
-- Question 2.
-- Get the first_name, last_name, and country of the employees
-- who work in the ‘Legal’ department.

select 
        first_name,
        last_name,
        country
    from employees 
    where department = 'Legal';
    
    
/* Q3 */
-- Question 3.
-- Count the number of employees based in Portugal
    
select
    count(id)
from employees e 
where country = 'Portugal' ;
    


/* Q4 */
-- Question 4.
-- Count the number of employees based in either Portugal or Spain.

select
    count(id)
from employees e 
where country in  ('Portugal', 'Spain');


/* Q5 */
-- Question 5.
-- Count the number of pay_details records lacking a local_account_no.

select
    count(id)
from pay_details pd 
where local_account_no is null

/* Q6 */
-- Question 6.
-- Are there any pay_details records lacking both a local_account_no and iban number?

select *
from pay_details pd 
where (local_account_no is null and iban is null)

-- There are none 


/* Q7 */
-- Question 7.
-- Get a table with employees first_name and last_name ordered 
-- alphabetically by last_name (put any NULLs last).

select 
       first_name,
        last_name
from employees e 
order by 
    last_name asc nulls last ;

/* Q8 */
-- Question 8
-- Get a table of employees first_name, last_name and country, 
-- ordered alphabetically first by country and then by last_name 
-- (put any NULLs last).

select 
        first_name,
        last_name,
        country 
from employees e 
order by 
    country asc nulls last,
    last_name asc nulls last ;

/* Q9 */
-- Question 9
-- Find the details of the top ten highest paid employees in the corporation.

select *
from employees e 
order by salary desc nulls last
limit 10;


/* Q10 */
-- Question 10
-- Find the first_name, last_name and salary of the lowest paid employee in Hungary.

select 
        first_name ,
        last_name ,
        salary 
from employees e 
where country ='Hungary'
order by salary asc nulls last
limit 1;



/* Q11 */
-- Question 11
-- How many employees have a first_name beginning with ‘F’?

select 
    count(id)
from employees e 
where first_name like 'F%';


/* Q12 */
-- Question 12
-- Find all the details of any employees with a ‘yahoo’ email address?

select 
    count(id)
from employees e 
where email ilike '%yahoo%';


/* Q13 */
-- Question 13
-- Count the number of pension enrolled employees not based in either France or Germany.

select 
    count(id)
from employees e 
where 
    country not in ('France', 'Germany')
    and pension_enrol = true ;

/* Q14 */
-- Question 14
-- What is the maximum salary among those employees in the ‘Engineering’ department who work
-- 1.0 full-time equivalent hours (fte_hours)?
select 
    max(salary)
from employees e 
where department ='Engineering'
    and fte_hours = 1;
    

/* Q15 */
-- Question 15
-- Return a table containing each employees first_name, last_name, full-time equivalent hours 
-- (fte_hours), salary, and a new column effective_yearly_salary which should contain fte_hours 
-- multiplied by salary.
select 
        first_name ,
        last_name ,
        fte_hours ,
        salary ,
        (salary * fte_hours) as effective_yearly_salary 
from employees e ;

    
/* Q16 */
-- Question 16.
-- The corporation wants to make name badges for a forthcoming conference. Return a column 
-- badge_label showing employees’ first_name and last_name joined together with their department 
-- in the following style: ‘Bob Smith - Legal’. Restrict output to only those employees with stored 
-- first_name, last_name and department.

select 
    concat(first_name, ' ', last_name, ' - ', department) as badge_label
    from employees e 
    where (first_name, last_name , department) is not null  ;

    
/* Q17 */
-- Question 17.
-- One of the conference organisers thinks it would be nice to add the year of the employees’ 
-- start_date to the badge_label to celebrate long-standing colleagues, in the following style
-- ‘Bob Smith - Legal (joined 1998)’. Further restrict output to only those employees with a 
-- stored start_date.

-- [If you’re really keen - try adding the month as a string: ‘Bob Smith - Legal
-- (joined July 1998)’]
    
 select 
    concat(first_name, ' ', last_name, ' - ', department, ' (joined ',
        extract(year from start_date), ')') as badge_label
    from employees e 
where (first_name, last_name , department, start_date) is not null  ;

    
 -- Attempting to add in the month - but can't get the code working just now 
    
SELECT
  concat(
    first_name, ' ', last_name, ' - ', department, ' (joined ', 
    to_char(start_date, 'FMMonth'), ' ', to_char(start_date, 'YYYY'), ')'
  ) AS badge_label
from employees
where 
  first_name is not null and 
  last_name is not null and 
  department is not null and
  start_date is not null;



/* Q18 */
-- Question 18
--Return the first_name, last_name and salary of all employees together with 
-- a new column called salary_class with a value 'low' where salary is less 
--than 40,000 and value 'high' where salary is greater than or equal to 40,000.

                
select first_name,
       last_name,
       salary,
       case  when salary <   40000 then  'Low'
             when salary  >= 40000 then  'High'
       end as salary_class
from employees e ;
