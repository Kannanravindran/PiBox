create database pibox;

use pibox;

create table users(id int(10) not null auto_increment,
	username varchar(50) not null,
	password varchar(100),
	email varchar(250),
	firstname varchar(100),
	lastname varchar(100),
	type varchar(20),
	primary key(id),
	constraint unique_username unique (username, email)
	) engine=innodb charset=utf8;

CREATE TABLE `pibox`.`sessions` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `name` VARCHAR(45) NULL COMMENT '',
  `activity` VARCHAR(45) NULL COMMENT '',
  `status` VARCHAR(45) NULL COMMENT '',
  PRIMARY KEY (`id`)  COMMENT '');

CREATE TABLE `pibox`.`sessionuserassoc` (
  `sessionId` INT NULL COMMENT '',
  `userId` INT NULL COMMENT '',
  `userScore` INT NULL COMMENT '',
  INDEX `fk_Session_idx` (`sessionId` ASC)  COMMENT '',
  INDEX `fk_User_idx` (`userId` ASC)  COMMENT '',
  CONSTRAINT `fk_Session`
    FOREIGN KEY (`sessionId`)
    REFERENCES `pibox`.`sessions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_User`
    FOREIGN KEY (`userId`)
    REFERENCES `pibox`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
