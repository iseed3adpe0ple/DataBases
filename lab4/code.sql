-- Database: lab4

-- DROP DATABASE IF EXISTS lab4;
/*
CREATE DATABASE lab4
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Russian_Russia.1251'
    LC_CTYPE = 'Russian_Russia.1251'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


CREATE TABLE employees (
 employee_id SERIAL PRIMARY KEY,
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 department VARCHAR(50),
 salary NUMERIC(10,2),
 hire_date DATE,
 manager_id INTEGER,
 email VARCHAR(100)
);

CREATE TABLE projects (
 project_id SERIAL PRIMARY KEY,
 project_name VARCHAR(100),
 budget NUMERIC(12,2),
 start_date DATE,
 end_date DATE,
 status VARCHAR(20)
);

CREATE TABLE assignments (
 assignment_id SERIAL PRIMARY KEY,
 employee_id INTEGER REFERENCES employees(employee_id),
 project_id INTEGER REFERENCES projects(project_id),
 hours_worked NUMERIC(5,1),
 assignment_date DATE
);

INSERT INTO employees (first_name, last_name, department,
salary, hire_date, manager_id, email) VALUES
('John', 'Smith', 'IT', 75000, '2020-01-15', NULL,
'john.smith@company.com'),
('Sarah', 'Johnson', 'IT', 65000, '2020-03-20', 1,
'sarah.j@company.com'),
('Michael', 'Brown', 'Sales', 55000, '2019-06-10', NULL,
'mbrown@company.com'),
('Emily', 'Davis', 'HR', 60000, '2021-02-01', NULL,
'emily.davis@company.com'),
('Robert', 'Wilson', 'IT', 70000, '2020-08-15', 1, NULL),
('Lisa', 'Anderson', 'Sales', 58000, '2021-05-20', 3,
'lisa.a@company.com');

INSERT INTO projects (project_name, budget, start_date,
end_date, status) VALUES
('Website Redesign', 150000, '2024-01-01', '2024-06-30',
'Active'),
('CRM Implementation', 200000, '2024-02-15', '2024-12-31',
'Active'),
('Marketing Campaign', 80000, '2024-03-01', '2024-05-31',
'Completed'),
('Database Migration', 120000, '2024-01-10', NULL, 'Active');

INSERT INTO assignments (employee_id, project_id,
hours_worked, assignment_date) VALUES
(1, 1, 120.5, '2024-01-15'),
(2, 1, 95.0, '2024-01-20'),
(1, 4, 80.0, '2024-02-01'),
(3, 3, 60.0, '2024-03-05'),
(5, 2, 110.0, '2024-02-20'),
(6, 3, 75.5, '2024-03-10');
*/

select first_name, last_name, department, salary from employees;

select distinct department from  employees;



-- alter table projects add column budget_category varchar(6);

update projects set budget_category = case
 when budget > 150000 then 'large'
 when budget between 100000 and 150000 then 'medium'
 else 'small'
end;

select project_name, budget from projects;

select
 first_name, last_name, coalesce(email, 'No email provided') as email_fixed 
from employees;

select first_name, last_name from employees where hire_date > '2020-01-01';

select first_name, last_name from employees where salary between 60000 and 70000;

select first_name, last_name from employees where first_name like 'L%' or first_name like 'J%';

select first_name, last_name from employees where manager_id is not null and department = 'IT';

select 
 upper(first_name) as name_upper,
 length(last_name) as last_len,
 substring(email from 1 for 3) as email_prefix
from employees;

select 
 salary*12 as annual_salary,
 round(salary, 2) as month_salary,
 salary*0.10 as raise_amount
from employees;

select format('Project: %s - Budget: $%s - Status: %s', project_name, budget, status) from projects;

select first_name, last_name, extract(year from age(current_date, hire_date)) as years_of_working from employees;

select department, round(avg(salary), 2) as avg_salary
from employees group by department;

select project_name, end_date - start_date as hours_worked
from projects;

select department, count(*) as employee_count
from employees
group by department
having count(*) > 1;

select min(salary) as min_salary, max(salary) as max_salary, sum(salary) as total_payroll
from employees;

select employee_id, first_name, last_name from employees where salary > 65000
union
select employee_id, first_name, last_name from employees where hire_date > '2020-01-01';

select first_name, last_name from employees where department = 'IT'
intersect
select first_name, last_name from employees where salary > 65000;

select employee_id from employees 
except
select employee_id from assignments;

select first_name, last_name from employees e where
exists (
	select 1 from assignments p
	where e.employee_id = p.employee_id
);

select first_name, last_name from employees
where employee_id in (
	select employee_id
	from assignments a
	join projects p on a.project_id = p.project_id
	where p.status = 'Active'
);

select first_name, last_name from employees
where salary > any(
	select salary from employees where department = 'Sales'
);

select
	e.employee_id,
	e.first_name, e.last_name,
	e.department,
	avg(pa.hours_worked) as avg_hours_worked,
	(
		select count(*)
		from employees e2
		where e2.department = e.department and e2.salary > e.salary
	) + 1 as salary_rank
from employees e
left join assignments pa on e.employee_id = pa.employee_id
group by e.employee_id, e.first_name, e.last_name, e.department, e.salary;

SELECT 
    p.project_name,
    SUM(pa.hours_worked) AS total_hours,
    COUNT(DISTINCT pa.employee_id) AS employees_assigned
FROM 
    projects p
JOIN 
    assignments pa ON p.project_id = pa.project_id
GROUP BY 
    p.project_name
HAVING 
    SUM(pa.hours_worked) > 150;

SELECT 
    department,
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary,
    MAX(CONCAT(first_name, ' ', last_name)) AS highest_paid_employee,  -- временно, уточним ниже
    GREATEST(MIN(salary), 30000) AS min_salary_or_30000,
    LEAST(MAX(salary), 200000) AS max_salary_or_200000
FROM 
    employees e
GROUP BY 
    department;
