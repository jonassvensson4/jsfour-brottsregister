USE `essentialmode`;

CREATE TABLE `jsfour_brottsregister` (
	`pk` int(255) NOT NULL AUTO_INCREMENT,
	`firstname` varchar(255) NOT NULL,
	`lastname` varchar(255) NOT NULL,
	`dateofbirth` varchar(255) NOT NULL,
	`lastdigits` varchar(255) NOT NULL,
	`dateofcrime` varchar(255) NOT NULL,
	`crime` varchar(255) NOT NULL,
	`lastcrime` INT(2) NULL DEFAULT 0,
	PRIMARY KEY (`pk`)
);