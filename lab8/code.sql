--2.1
create index emp_salary_idx on employees(salary);
--2.2
create index emp_dept_idx on employees(dept_id);
--3.1
create index emp_dept_salary_idx on employees(dept_id,salary);
--4.1
create unique index emp_email_unique_idx on employees(email);
--5.1
create index emp_salary_desc_idx on employees(salary desc);
--5.2
create index emp_salary_nulls_idx on employees(salary desc nulls first);
--6.1
select * from employees where lower(name)='john';
--6.2
create index emp_hire_year_idx on employees((extract(year from hire_date)));
--7.1
alter index emp_salary_idx rename to employees_salary_index;
--7.2
drop index emp_dept_salary_idx;
--7.3
reindex index employees_salary_index;
--8.1
select e.*,d.dept_name from employees e join departments d on e.dept_id=d.dept_id where e.salary>52000 order by e.salary desc;
--8.2
create index emp_high_salary_idx on employees(salary) where salary>52000;
--8.3
explain select * from employees where salary>52000;
--9.1
create index dept_name_hash_idx on departments using hash(dept_name);
--9.2
explain select * from departments where dept_name='it';
--10.1
select indexrelid::regclass as index_name,pg_size_pretty(pg_relation_size(indexrelid)) as size from pg_index;
--10.2
drop index dept_name_hash_idx;
