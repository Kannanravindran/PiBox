create database pibox;

use pibox;

create table users(id int(10) not null auto_increment,
	username varchar(50) not null,
	password varchar(100),
	email varchar(250),
	firstname varchar(100) not null,
	lastname varchar(100) not null,
	type varchar(20) not null,
	primary key(id),
	constraint unique_username unique (username, email)
	) engine=innodb charset=utf8;

