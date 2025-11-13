-- AUTO-GENERATED FILE.

-- This file is an auto-generated file by Ballerina persistence layer for model.
-- Please verify the generated scripts and execute them against the target DB server.

DROP TABLE IF EXISTS `MoesifData`;

CREATE TABLE `MoesifData` (
	`id` INT AUTO_INCREMENT,
	`data` LONGBLOB NOT NULL,
	`published` BOOLEAN NOT NULL,
	PRIMARY KEY(`id`)
);


