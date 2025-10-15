-- Database: lab5

-- DROP DATABASE IF EXISTS lab5;

/*
CREATE DATABASE lab5
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

create table employees (
	employee_id serial primary key,
	first_name text,
	last_name text,
	age smallint check (age between 18 and 65),
	salary numeric(12,2) check (salary > 0) 
);

create table products_catalog(
	product_id serial primary key,
	product_name text,
	regular_price numeric(10,2),
	discount_price numeric (10,2)
);

alter table products_catalog
add constraint valid_discount
check (
	regular_price > 0
	and discount_price > 0
	and discount_price < regular_price
);

create table bookings(
	booking_id serial primary key,
	check_in_date date,
	check_out_date date,
	num_guests int
);

alter table bookings
add constraint multiple_column_check(
	num_guests between 1 and 10,
	check_out_date > check_in_date
);

insert into employees (first_name, last_name, age, salary)
values ('John', 'Smith', 30, 50000.00),
       ('Alice', 'Brown', 45, 75000.00);

insert into employees (first_name, last_name, age, salary)
values ('Bob', 'Young', 16, 30000.00),
       ('Eve', 'Zero', 25, -5000.00);

insert into products_catalog (product_name, regular_price, discount_price)
values ('Laptop', 1000.00, 850.00),
       ('Phone', 700.00, 600.00);

insert into products_catalog (product_name, regular_price, discount_price)
values ('Tablet', 500.00, 600.00),
       ('Mouse', 50.00, 0.00);

insert into bookings (check_in_date, check_out_date, num_guests)
values ('2025-10-15', '2025-10-20', 2),
       ('2025-11-01', '2025-11-05', 4);

insert into bookings (check_in_date, check_out_date, num_guests)
values ('2025-12-10', '2025-12-05', 2),
       ('2025-12-01', '2025-12-10', 15);

create table customers (
    customer_id integer not null,
    email text not null,
    phone text,
    registration_date date not null
);

create table inventory (
    item_id integer not null,
    item_name text not null,
    quantity integer not null check (quantity >= 0),
    unit_price numeric not null check (unit_price > 0),
    last_updated timestamp not null
);

insert into inventory values (1, 'Laptop', 10, 1500.00, now());
insert into inventory values (2, 'Mouse', 50, 25.50, now());

insert into inventory values (3, null, 5, 100.00, now());
insert into inventory values (4, 'Keyboard', null, 75.00, now());
insert into inventory values (5, 'Monitor', 10, null, now());
insert into inventory values (6, 'Tablet', 8, 200.00, null);

insert into inventory values (7, 'Phone', 15, 800.00, now());

create table users (
    user_id integer,
    username text unique,
    email text unique,
    created_at timestamp
);

create table course_enrollments (
    enrollment_id integer,
    student_id integer,
    course_code text,
    semester text,
    unique (student_id, course_code, semester)
);

alter table users
add constraint unique_username unique (username),
add constraint unique_email unique (email);

insert into users values (1, 'alice', 'alice@mail.com', now());
insert into users values (2, 'bob', 'bob@mail.com', now());
insert into users values (3, 'alice', 'alice2@mail.com', now());
insert into users values (4, 'john', 'bob@mail.com', now());

create table departments (
    dept_id integer primary key,
    dept_name text not null,
    location text
);

insert into departments values (1, 'HR', 'Almaty');
insert into departments values (2, 'IT', 'Astana');
insert into departments values (3, 'Finance', 'Shymkent');
insert into departments values (1, 'Marketing', 'Atyrau');
insert into departments values (null, 'Sales', 'Kokshetau');

create table student_courses (
    student_id integer,
    course_id integer,
    enrollment_date date,
    grade text,
    primary key (student_id, course_id)
);

create table employees_dept (
    emp_id integer primary key,
    emp_name text not null,
    dept_id integer references departments(dept_id),
    hire_date date
);

insert into employees_dept values (1, 'Alice', 1, '2023-01-10');
insert into employees_dept values (2, 'Bob', 2, '2023-03-15');
insert into employees_dept values (3, 'Charlie', 99, '2023-05-20');

create table authors (
    author_id integer primary key,
    author_name text not null,
    country text
);

create table publishers (
    publisher_id integer primary key,
    publisher_name text not null,
    city text
);

create table books (
    book_id integer primary key,
    title text not null,
    author_id integer references authors(author_id),
    publisher_id integer references publishers(publisher_id),
    publication_year integer,
    isbn text unique
);

insert into authors values
(1, 'George Orwell', 'UK'),
(2, 'Fyodor Dostoevsky', 'Russia'),
(3, 'Ernest Hemingway', 'USA');

insert into publishers values
(1, 'Penguin Books', 'London'),
(2, 'Vintage Classics', 'New York'),
(3, 'AST', 'Moscow');

insert into books values
(1, '1984', 1, 1, 1949, '9780451524935'),
(2, 'Crime and Punishment', 2, 3, 1866, '9780143058144'),
(3, 'The Old Man and the Sea', 3, 2, 1952, '9780684801223');

create table categories (
    category_id integer primary key,
    category_name text not null
);

create table products_fk (
    product_id integer primary key,
    product_name text not null,
    category_id integer references categories(category_id) on delete restrict
);

create table orders (
    order_id integer primary key,
    order_date date not null
);

create table order_items (
    item_id integer primary key,
    order_id integer references orders(order_id) on delete cascade,
    product_id integer references products_fk(product_id),
    quantity integer check (quantity > 0)
);

-- Insert sample data
insert into categories values
(1, 'Electronics'),
(2, 'Clothing');

insert into products_fk values
(1, 'Laptop', 1),
(2, 'Smartphone', 1),
(3, 'T-Shirt', 2);

insert into orders values
(1, '2025-10-15'),
(2, '2025-10-16');

insert into order_items values
(1, 1, 1, 2),
(2, 1, 2, 1),
(3, 2, 3, 5);

-- Test scenarios
-- 1. Try to delete a category with products (will fail due to RESTRICT)
delete from categories where category_id = 1;

-- 2. Delete an order (order_items are automatically deleted due to CASCADE)
delete from orders where order_id = 1;
