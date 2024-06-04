use AWS3;

create table DIM_COUNTRY(
	country_id int IDENTITY(1,1),
	country varchar(50)
);

create table DIM_DIRECTOR(
	director_id int IDENTITY(1,1),
	director varchar(50)
);

create table DIM_TYPE(
	type_id int IDENTITY(1,1),
	type varchar(50)
);

create table DIM_DATE(
	date_id int IDENTITY(1,1),
	date_added date,
	release_year int
);

create table DIM_RATING(
	rating_id int IDENTITY(1,1),
	rating varchar(50)
);

create table DIM_DURATION(
	duration_id int IDENTITY(1,1),
	duration varchar(50)
);

create table DIM_INFO(
	info_id int IDENTITY(1,1),
	title varchar(50),
	listed_in varchar(50),
	description varchar(MAX),
	cast varchar(MAX)
);

create table FACT_NETFLIX_SHOWS(
	show_id int,
	info_id int,
	type_id int,
	director_id int ,
	country_id int,
	date_id int,
	rating_id int ,
	duration_id int);


