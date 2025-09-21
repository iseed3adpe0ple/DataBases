/*
CREATE DATABASE university_main
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
CREATE TABLE if not exists students(
	student_id Serial PRIMARY KEY,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	email varchar(100),
	phone char(15),
	date_of_birth date,
	enrollment_date date,
	gpa numeric(3,2),
	is_active bool,
	graduation_year smallint
);

CREATE TABLE IF NOT EXISTS professors(
	professor_id Serial PRIMARY KEY,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	email varchar(100),
	office_number varchar(20),
	hire_date date,
	salary numeric(12,2),
	is_tenured bool,
	years_experience int
);

CREATE TABLE IF NOT EXISTS courses(
	course_id Serial PRIMARY KEY,
	course_code char(8) NOT NULL,
	course_title varchar(100) NOT NULL,
	description TEXT,
	credits smallint,
	max_enrollment int,
	course_fee numeric(10,2),
	is_online bool,
	created_at timestamp without time zone
);

CREATE TABLE IF NOT EXISTS class_schedule(
	schedule_id Serial PRIMARY KEY,
	course_id int,
	professor_id int,
	classroom varchar(20),
	class_date date,
	start_time time without time zone,
	end_time time without time zone,
	duration interval
);

CREATE TABLE IF NOT EXISTS student_records(
	record_id Serial PRIMARY KEY,
	student_id int,
	course_id int,
	semester varchar(20),
	year int,
	grade char(2),
	attendance_percentage numeric(4,1),
	submission_timestamp timestamp with time zone,
	last_updated timestamp with time zone
);

Alter Table students
	Add middle_name varchar(30),
	add student_status varchar(20),
	alter column phone type varchar(20),
	alter column student_status set default 'active',
	alter column gpa set default 0.00;


alter table professors
	add department_code char(5),
	add research_area text,
	alter column years_experience type smallint,
	alter column is_tenured set default false,
	add last_promotion_date date;


alter table courses
	add prerequisite_course_id int,
	add difficulty_level smallint,
	alter column course_code type varchar(10),
	alter column credits set default 3,
	add column lab_required bool default False;


alter table class_schedule
	add room_capacity int,
	drop column duration,
	add session_type varchar(15),
	alter column classroom type varchar(30),
	add equipment_needed text;

alter table student_records
	add extra_credit_points numeric(3,1),
	alter column grade type varchar(5),
	alter column extra_credit_points set default 0.0,
	add final_exam_date date,
	drop column last_updated;

create table if not exists departments(
	department_id serial primary key,
	department_name varchar(100),
	department_code char(5),
	building varchar(50),
	phone varchar(15),
	budget numeric(12,2),
	established_year int
);

create table if not exists library_books(
	book_id serial primary key,
	isbn char(13),
	title varchar(200),
	author varchar(100),
	publisher varchar(100),
	publication_date date,
	price numeric(10,2),
	is_available bool,
	acquisition_timestamp timestamp without time zone
);

create table student_book_loans(
	loan_id serial primary key,
	student_id int,
	book_id int,
	loan_date date,
	due_date date,
	return_date date,
	fine_amount numeric(10,2),
	loan_status varchar(20)
);

alter table professors
	add department_id int;


alter table students
	add advisor_id int;

alter table courses
	add department_id int;

create table if not exists grade_scale(
	grade_id serial primary key,
	letter_grade char(2),
	min_percentage numeric(4,1),
	max_percentage numeric(4,1),
	gpa_points numeric(3,2)
);

create table if not exists semester_calendar(
	semester_id serial primary key,
	semester_name varchar(20),
	academic_year int,
	start_date date,
	end_date date,
	registration_deadline timestamp with time zone,
	is_current bool
);

drop table if exists student_book_loans;
drop table if exists library_books;
drop table if exists grade_scale;

create table if not exists grade_scale(
	grade_id serial primary key,
	letter_grade char(2),
	min_percentage numeric(4,1),
	max_percentage numeric(4,1),
	gpa_points numeric(3,2),
	description text
);
