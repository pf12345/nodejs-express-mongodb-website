--create database mockup
create database mockup;

use mockup;

CREATE TABLE serialNumbers (
	id INT NOT NULL auto_increment PRIMARY KEY,
	number VARCHAR (36) NOT NULL DEFAULT '',
	remainActiveCount INT NOT NULL DEFAULT 1,
	addTime Datetime NOT NULL,
	state TINYINT NOT NULL DEFAULT 0
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE activeRecord (
	id INT NOT NULL auto_increment PRIMARY KEY,
	number VARCHAR (36) NOT NULL DEFAULT '',
	mac VARCHAR (50) NOT NULL DEFAULT '',
	addTime Datetime NOT NULL,
	state TINYINT NOT NULL DEFAULT 0
)ENGINE=INNODB DEFAULT CHARSET=utf8;

INSERT INTO serialNumbers(number,remainActiveCount,addTime,state) VALUES(?,?,now(),0)