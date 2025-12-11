-- 1. process_transfer
create or replace procedure process_transfer(p_from int, p_to int, p_amount numeric, p_cur text)
language plpgsql as $$
declare rate numeric; bal numeric;
begin
select balance into bal from accounts where id=p_from for update;
if bal < p_amount then raise exception 'not enough funds'; end if;
select fx_rate into rate from currency_rates where from_cur=p_cur and to_cur='kzt';
update accounts set balance = balance - p_amount where id=p_from;
update accounts set balance = balance + p_amount*rate where id=p_to;
insert into audit_log(from_acc,to_acc,amount,currency) values(p_from,p_to,p_amount,p_cur);
end $$;


-- 2. views
create view customer_balance_summary as
select c.id, c.name, a.balance, a.currency
from customers c join accounts a on a.customer_id=c.id;


create view daily_transaction_report as
select date_trunc('day', ts) as day, count(*), sum(amount)
from transactions group by 1;


create view suspicious_activity_view as
select t.* from transactions t where amount > 1000000;


-- 3. indexes
create index idx_acc_cust on accounts(customer_id);
create index idx_trans_ts on transactions(ts);
create index idx_email_lower on customers(lower(email));


-- 4. batch salary
create or replace procedure process_salary_batch(p_dept int)
language plpgsql as $$
declare r record;
begin
for r in select emp_id, amount from salary_batches where dept_id=p_dept loop
update accounts set balance = balance + r.amount where id=r.emp_id;
end loop;
end $$;
