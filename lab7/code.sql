create view employee_details as
select e.emp_name, e.salary, d.dept_name, d.location
from employees e
join departments d on e.dept_id = d.dept_id;

create view dept_statistics as
select d.dept_name,
       count(e.emp_id) as employee_count,
       coalesce(avg(e.salary),0) as avg_salary,
       coalesce(max(e.salary),0) as max_salary,
       coalesce(min(e.salary),0) as min_salary
from departments d
left join employees e on d.dept_id = e.dept_id
group by d.dept_name;

create view project_overview as
select p.project_name, p.budget, d.dept_name, d.location, count(e.emp_id) as team_size
from projects p
join departments d on p.dept_id = d.dept_id
left join employees e on e.dept_id = d.dept_id
group by p.project_name, p.budget, d.dept_name, d.location;

create view high_earners as
select e.emp_name, e.salary, d.dept_name
from employees e
join departments d on e.dept_id = d.dept_id
where e.salary > 55000;

create or replace view employee_details as
select e.emp_name, e.salary, d.dept_name, d.location,
       case
         when e.salary > 60000 then 'high'
         when e.salary > 50000 then 'medium'
         else 'standard'
       end as salary_grade
from employees e
join departments d on e.dept_id = d.dept_id;

alter view high_earners rename to top_performers;

create view temp_view as
select * from employees where salary < 50000;
drop view temp_view;

create view employee_salaries as
select emp_id, emp_name, dept_id, salary from employees;

update employee_salaries set salary = 52000 where emp_name = 'john smith';

insert into employee_salaries (emp_id, emp_name, dept_id, salary)
values (6, 'alice johnson', 102, 58000);

create view it_employees as
select * from employees where dept_id = 101
with local check option;

create materialized view dept_summary_mv as
select d.dept_id, d.dept_name,
       count(e.emp_id) as total_employees,
       coalesce(sum(e.salary),0) as total_salaries,
       count(p.project_id) as total_projects,
       coalesce(sum(p.budget),0) as total_budget
from departments d
left join employees e on d.dept_id = e.dept_id
left join projects p on d.dept_id = p.dept_id
group by d.dept_id, d.dept_name
with data;

refresh materialized view dept_summary_mv;

create unique index dept_summary_mv_idx on dept_summary_mv(dept_id);
refresh materialized view concurrently dept_summary_mv;

create materialized view project_stats_mv as
select p.project_name, p.budget, d.dept_name, count(e.emp_id) as emp_count
from projects p
join departments d on p.dept_id = d.dept_id
left join employees e on e.dept_id = d.dept_id
group by p.project_name, p.budget, d.dept_name
with no data;

create role analyst;
create role data_viewer login password 'viewer123';
create user report_user password 'report456';

create role db_creator login createdb password 'creator789';
create role user_manager login createrole password 'manager101';
create role admin_user login superuser password 'admin999';

grant select on employees, departments, projects to analyst;
grant all privileges on employee_details to data_viewer;
grant select, insert on employees to report_user;

create role hr_team;
create role finance_team;
create role it_team;

create user hr_user1 password 'hr001';
create user hr_user2 password 'hr002';
create user finance_user1 password 'fin001';

grant hr_team to hr_user1, hr_user2;
grant finance_team to finance_user1;

grant select, update on employees to hr_team;
grant select on dept_statistics to finance_team;

revoke update on employees from hr_team;
revoke hr_team from hr_user2;
revoke all privileges on employee_details from data_viewer;

alter role analyst login password 'analyst123';
alter role user_manager superuser;
alter role analyst password null;
alter role data_viewer connection limit 5;

create role read_only;
grant select on all tables in schema public to read_only;

create role junior_analyst login password 'junior123';
create role senior_analyst login password 'senior123';
grant read_only to junior_analyst, senior_analyst;
grant insert, update on employees to senior_analyst;

create role project_manager login password 'pm123';
alter view dept_statistics owner to project_manager;
alter table projects owner to project_manager;

create role temp_owner login;
create table temp_table(id int);
alter table temp_table owner to temp_owner;
reassign owned by temp_owner to postgres;
drop owned by temp_owner;
drop role temp_owner;

create view hr_employee_view as
select * from employees where dept_id = 102;
grant select on hr_employee_view to hr_team;

create view finance_employee_view as
select emp_id, emp_name, salary from employees;
grant select on finance_employee_view to finance_team;

create view dept_dashboard as
select d.dept_name, d.location,
       count(e.emp_id) as employee_count,
       round(avg(e.salary),2) as avg_salary,
       count(distinct p.project_id) as active_projects,
       coalesce(sum(p.budget),0) as total_budget,
       round(coalesce(sum(p.budget),0)/nullif(count(e.emp_id),0),2) as budget_per_employee
from departments d
left join employees e on d.dept_id = e.dept_id
left join projects p on d.dept_id = p.dept_id
group by d.dept_name, d.location;

alter table projects add column created_date timestamp default current_timestamp;

create view high_budget_projects as
select p.project_name, p.budget, d.dept_name, p.created_date,
       case
         when p.budget > 150000 then 'critical review required'
         when p.budget > 100000 then 'management approval needed'
         else 'standard process'
       end as approval_status
from projects p
join departments d on p.dept_id = d.dept_id
where p.budget > 75000;

create role viewer_role;
grant select on all tables in schema public to viewer_role;

create role entry_role;
grant viewer_role to entry_role;
grant insert on employees, projects to entry_role;

create role analyst_role;
grant entry_role to analyst_role;
grant update on employees, projects to analyst_role;

create role manager_role;
grant analyst_role to manager_role;
grant delete on employees, projects to manager_role;

create user alice password 'alice123';
create user bob password 'bob123';
create user charlie password 'charlie123';
grant viewer_role to alice;
grant analyst_role to bob;
grant manager_role to charlie;
