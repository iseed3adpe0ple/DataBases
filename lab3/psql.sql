-- Database: advanced_lab

-- DROP DATABASE IF EXISTS advanced_lab;
/*
CREATE DATABASE advanced_lab
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Russian_Russia.1251'
    LC_CTYPE = 'Russian_Russia.1251'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
*/

create table employees(
	emp_id serial primary key,
	first_name text,
	last_name text,
	department text,
	salary int,
	hire_date date,
	status text default 'Active'
);

create table departments(
	dept_id serial primary key,
	dept_name text,
	budget int,
	manager_id int
);

create table projects(
	project_id serial primary key,
	project_name text,
	dept_id int,
	start_date date,
	end_date date,
	budget int
);

insert into employees(first_name, last_name, department)
values ('John', 'Doe', 'IT');

insert into employees(first_name, last_name, department, hire_date)
values ('Alice', 'Smith', 'HR', CURRENT_DATE);

insert into departments (dept_name, budget, manager_id)
values
	('IT', 100000, 1),
	('HR', 50000, 2),
	('Finance', 75000, 3);

insert into employees (first_name, last_name, department, hire_date, salary)
values ('Charlie', 'Miller', 'IT', Current_date, 50000*1.1);

create temp table temp_employees as
select * from employees
where department = 'IT';

update employees set salary = salary * 1.10;
update employees set status = 'Senior' where salary > 60000 and hire_date < '2020-01-01';
update employees set department = case
	when salary > 80000 then 'Management'
	when salary between 50000 and 80000 then 'Senior'
	else 'junior'
end;

update employees set department = default where status = 'Inactive';
update departments d set budget = (
	select avg(e.salary) * 1.2
	from employees e
	where e.department = d.dept_name
);

update employees set
	salary = salary * 1.15,
	status = 'Promoted'
where department = 'Sales';

delete from employees where status = 'Terminated';
delete from employees where salary < 40000
	and hire_date > '2023-01-01'
	and department is null;

delete from departments
where dept_name not in(
	Select distinct department
	from employees
	where department is not null
);

delete from projects 
where end_date < '2023-01-01'
returning *;

insert into employees (first_name, last_name, salary, department, hire_date, status)
values ('David', 'White', NULL, NULL, current_date, 'Active');

Update employees set department = 'Unassigned' where department is null;

delete from employees where salary is null or department is null;

insert into employees (first_name, last_name, department, salary, hire_date)
values ('Emma', 'Johnson', 'IT', 60000, current_date)
returning emp_id, (first_name || ' ' || last_name) as full_name;

update employees set salary = salary + 5000
where department = 'IT'
returning emp_id,
	salary - 5000 as old_salary,
	salary as new_salary;

delete from employees where hire_date < '2020-01-01' returning *;

insert into employees (first_name, last_name, department, salary, hire_date)
select 'George', 'Taylor', 'HR', 45000, current_date
where not exists(
	Select 1 from employees where first_name = 'George' and last_name = 'Taylor'
);

Update employees e
set salary = salary * case
	when (select d.budget from departments d
	where d.dept_name = e.department) > 100000 then 1.10
	else 1.05
end;

insert into employees (first_name, last_name, department, salary, hire_date)
values
	('Alex', 'Green', 'IT', 50000, '2020-01-01'),
	('Sophie', 'Brown', 'Finance', 52000, '2019-01-01'),
	('Liam', 'Wilson', 'HR', 48000, '2022-01-01'),
	('Olivia', 'Davis', 'Sales', 51000, '2020-01-01'),
	('Noah', 'Evans', 'IT', 53000, '2015-01-01');

update employees set salary = salary * 1.10 
where last_name in ('Green', 'Brown', 'Wilson', 'Davis', 'Evans');

create table employee_archive as select * from employees where status = 'Inactive';
delete from employees where status = 'Inactive';

update projects set end_date = end_date + interval '30 days'
where budget > 50000 and end_date is not null
