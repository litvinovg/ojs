#1
UPDATE user_settings SET setting_name = 'familyName' WHERE setting_name = 'lastName';
UPDATE author_settings SET setting_name = 'familyName' WHERE setting_name = 'lastName';

UPDATE user_settings SET setting_name = 'givenName' WHERE setting_name = 'firstName';
UPDATE author_settings SET setting_name = 'givenName' WHERE setting_name = 'firstName';

#2
UPDATE user_settings us1
INNER JOIN user_settings us2 ON us1.user_id = us2.user_id AND us1.locale = us2.locale
SET us1.setting_value = concat(us1.setting_value," ",us2.setting_value ) WHERE us1.setting_name = 'givenName' AND us2.setting_name = 'middleName';

UPDATE author_settings us1
INNER JOIN author_settings us2 ON us1.author_id = us2.author_id AND us1.locale = us2.locale
SET us1.setting_value = concat(us1.setting_value," ",us2.setting_value ) WHERE us1.setting_name = 'givenName' AND us2.setting_name = 'middleName';

#3
#INSERT INTO author_settings (author_id, locale, setting_name, setting_value, setting_type) VALUES (?, ?, 'preferredPublicName', ?, 'string')

#INSERT INTO author_settings (author_id, locale, setting_name, setting_value, setting_type)

#SELECT author_id, locale, 'preferredPublicName', setting_value, 'string'
#FROM   courses
#WHERE  cid = 2



#4
ALTER TABLE authors DROP COLUMN suffix;
ALTER TABLE users DROP COLUMN salutation;
ALTER TABLE users DROP COLUMN suffix;

#5 
 CREATE TABLE `categories` (
  `category_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `parent_id` bigint(20) NOT NULL,
  `seq` bigint(20) DEFAULT NULL,
  `path` varchar(255) NOT NULL,
  `image` text,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_path` (`context_id`,`path`),
  KEY `category_context_id` (`context_id`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `submission_categories` (
  `submission_id` bigint(20) NOT NULL,
  `category_id` bigint(20) NOT NULL,
  UNIQUE KEY `submission_categories_id` (`submission_id`,`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `category_settings` (
  `category_id` bigint(20) NOT NULL,
  `locale` varchar(14) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `category_settings_pkey` (`category_id`,`locale`,`setting_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
