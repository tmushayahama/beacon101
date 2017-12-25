DROP USER 'mt102'@'localhost';
CREATE USER 'mt102'@'localhost' IDENTIFIED BY 'motivator101++';
DROP DATABASE IF EXISTS mt102;
CREATE DATABASE mt102 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON mt102.* to 'mt102'@'localhost' WITH GRANT OPTION;
USE mt102;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `migration` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES ('2014_10_12_000000_create_users_table',1),('2014_10_12_100000_create_password_resets_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  KEY `password_resets_email_index` (`email`),
  KEY `password_resets_token_index` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `mt_card`
--
DROP TABLE IF EXISTS `mt_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `mt_card` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_card_id` int(11),
  `type_id` int(11) NOT NULL,
  `level_id` int(11),
  `title` varchar(1000) NOT NULL DEFAULT "",
  `description` varchar(1000),
	 `template_type_id` int(11),
  `creator_id` int(11) NOT NULL,
  `card_picture_url` varchar(1000) NOT NULL DEFAULT "",
  `background_color` varchar(50) DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `privacy_id` int(11),
  `order` int(11) NOT NULL DEFAULT '1',
  `status` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `card_parent_card_id` (`parent_card_id`),
  KEY `card_creator_id` (`creator_id`),
  KEY `card_type_id` (`type_id`),
  KEY `card_template_type_id` (`template_type_id`),
  KEY `card_level_id` (`level_id`),
  KEY `card_privacy_id` (`privacy_id`),
  CONSTRAINT `card_parent_card_id` FOREIGN KEY (`parent_card_id`) REFERENCES `mt_card` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_creator_id` FOREIGN KEY (`creator_id`) REFERENCES `mt_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_type_id` FOREIGN KEY (`type_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_template_type_id` FOREIGN KEY (`template_type_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_level_id` FOREIGN KEY (`level_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_privacy_id` FOREIGN KEY (`privacy_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `mt_card_bookmark`
--
DROP TABLE IF EXISTS `mt_card_bookmark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mt_card_bookmark` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `card_id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `description` varchar(1000),
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `privacy_id` int(11) NOT NULL,
  `status_id` int(11),
  PRIMARY KEY (`id`),
  KEY `card_bookmark_card_id` (`card_id`),
  KEY `card_bookmark_creator_id` (`creator_id`),
  KEY `card_bookmark_level_id` (`level_id`),
  KEY `card_bookmark_status_id` (`status_id`),
  CONSTRAINT `card_bookmark_card_id` FOREIGN KEY (`card_id`) REFERENCES `mt_card` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_bookmark_creator_id` FOREIGN KEY (`creator_id`) REFERENCES `mt_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_bookmark_level_id` FOREIGN KEY (`level_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_bookmark_status_id` FOREIGN KEY (`status_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `mt_card_contribution`
--
DROP TABLE IF EXISTS `mt_card_contribution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mt_card_contribution` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `card_id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `contributor_id` int(11) NOT NULL,
  `description` varchar(1000),
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status_id` int(11) NOT NULL DEFAULT '70000',
  `privacy_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contribution_card_id` (`card_id`),
  KEY `contribution_creator_id` (`creator_id`),
  KEY `contribution_level_id` (`level_id`),
  KEY `contribution_status_id` (`status_id`),
  KEY `contribution_contributor_id` (`contributor_id`),
  KEY `contribution_privacy_id` (`privacy_id`),
  CONSTRAINT `contribution_card_id` FOREIGN KEY (`card_id`) REFERENCES `mt_card` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contribution_creator_id` FOREIGN KEY (`creator_id`) REFERENCES `mt_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contribution_level_id` FOREIGN KEY (`level_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contribution_status_id` FOREIGN KEY (`status_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contribution_contributor_id` FOREIGN KEY (`contributor_id`) REFERENCES `mt_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contribution_privacy_id` FOREIGN KEY (`status_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
--
-- Table structure for table `mt_card_recommendation`
--
DROP TABLE IF EXISTS `mt_card_recommendation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mt_card_recommendation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `card_id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `description` varchar(1000),
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `importance` int (11),
  `status_id` int(11),
  PRIMARY KEY (`id`),
  KEY `card_recommendation_card_id` (`card_id`),
  KEY `card_recommendation_creator_id` (`creator_id`),
  KEY `card_recommendation_level_id` (`level_id`),
  KEY `card_recommendation_status_id` (`status_id`),
  CONSTRAINT `card_recommendation_card_id` FOREIGN KEY (`card_id`) REFERENCES `mt_card` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_recommendation_creator_id` FOREIGN KEY (`creator_id`) REFERENCES `mt_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_recommendation_level_id` FOREIGN KEY (`level_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_recommendation_status_id` FOREIGN KEY (`status_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `mt_card_question`
--
DROP TABLE IF EXISTS `mt_card_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mt_card_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_card_id` int(11),
  `card_id` int(11) NOT NULL,
  `type_id` int(11) NOT NULL,
  `response_type_id` int(11) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `description` varchar(1000),
  `template_type_id` int(11),
  `card_picture_url` varchar(1000) NOT NULL DEFAULT "",
  `background_color` varchar(50) DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `privacy_id` int(11),
  `importance` int (11),
  `status_id` int(11),
  PRIMARY KEY (`id`),
  KEY `card_question_card_id` (`card_id`),
  KEY `card_question_parent_card_id` (`parent_card_id`),
  KEY `card_question_creator_id` (`creator_id`),
  KEY `card_question_response_type_id` (`response_type_id`),
  KEY `card_question_type_id` (`type_id`),
  KEY `card_question_privacy_id` (`privacy_id`),
  KEY `card_question_status_id` (`status_id`),
  CONSTRAINT `card_question_card_id` FOREIGN KEY (`card_id`) REFERENCES `mt_card` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_question_parent_card_id` FOREIGN KEY (`parent_card_id`) REFERENCES `mt_card` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_question_creator_id` FOREIGN KEY (`creator_id`) REFERENCES `mt_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_question_response_type_id` FOREIGN KEY (`response_type_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `car_d_question_type_id` FOREIGN KEY (`type_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_question_privacy_id` FOREIGN KEY (`privacy_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_question_status_id` FOREIGN KEY (`status_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `mt_card_question_condition`
--
DROP TABLE IF EXISTS `mt_card_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mt_card_condition` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_card_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `description` varchar(1000),
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status_id` int(11),
  PRIMARY KEY (`id`),
  KEY `card_condition_card_id` (`card_id`),
  KEY `card_condition_parent_card_id` (`parent_card_id`),
  KEY `card_condition_creator_id` (`creator_id`),
  KEY `card_condition_status_id` (`status_id`),
  CONSTRAINT `card_condition_card_id` FOREIGN KEY (`card_id`) REFERENCES `mt_card_question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_condition_parent_card_id` FOREIGN KEY (`parent_card_id`) REFERENCES `mt_card_question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_condition_creator_id` FOREIGN KEY (`creator_id`) REFERENCES `mt_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card_condition_status_id` FOREIGN KEY (`status_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `mt_level`
--
DROP TABLE IF EXISTS `mt_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mt_level` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_level_id` int(11),
  `type_id` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `code` varchar(150),
  `description` varchar(150),
  `long_description` varchar(500),
  `icon` varchar(50) NOT NULL,
  `background_color` varchar(50) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `level_parent_level_id` (`parent_level_id`),
  CONSTRAINT `level_parent_level_id` FOREIGN KEY (`parent_level_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `mt_notification`
--
DROP TABLE IF EXISTS `mt_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mt_notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) NOT NULL,
  `recipient_id` int(11) NOT NULL DEFAULT '1',
  `source_id` int(11) NOT NULL,
  `title` varchar(500) NOT NULL DEFAULT '',
  `description` varchar(500) NOT NULL DEFAULT '',
  `type_id` INT NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `notification_sender_id` (`sender_id`),
  KEY `notification_type_id` (`type_id`),
  KEY `notification_recipient_id` (`recipient_id`),
  CONSTRAINT `notification_sender_id` FOREIGN KEY (`sender_id`) REFERENCES `mt_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notification_recipient_id` FOREIGN KEY (`recipient_id`) REFERENCES `mt_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notification_type_id` FOREIGN KEY (`type_id`) REFERENCES `mt_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `mt_user`
--
DROP TABLE IF EXISTS `mt_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mt_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL,
  `password` varchar(128) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastname` varchar(100) NOT NULL DEFAULT '',
  `firstname` varchar(100) NOT NULL DEFAULT '',
  `avatar_url` varchar(200) NOT NULL DEFAULT 'mt-avatar.jpg',
  `theme_color` varchar(200) NOT NULL DEFAULT 'md-blue-400-bg',
  `gender` varchar(1) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `phone_number` varchar(20) NOT NULL DEFAULT '',
  `address` varchar(255) NOT NULL DEFAULT '',
  `superuser` int(1) NOT NULL DEFAULT '0',
  `status` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `mt_user_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------- LEVEL ---------------
load data local infile 'C:/xampp/htdocs/mt102/database/data/initializers/level.txt'
    into table mt102.mt_level
    fields terminated by '\t'
    enclosed by '"'
    escaped by '\\'
    lines terminated by '\r\n'
    ignore 1 LINES
    (`id`, `parent_level_id`,`title`, `code`, `description`, `long_description`, `icon`, `background_color`);

-- ----------- COMPONENT ---------------
load data local infile 'C:/xampp/htdocs/mt102/database/data/initializers/card.txt'
    into table mt102.mt_card
    fields terminated by '\t'
    enclosed by '"'
    escaped by '\\'
    lines terminated by '\r\n'
    ignore 1 LINES
   (`id`,	`parent_card_id`,	`type_id`,	`title`,	`description`, `template_type_id`,	`creator_id`,	`card_picture_url`,	`background_color`,	`created_at`,	`updated_at`,	`level_id`,	`privacy_id`,	`order`,	`status`);


-- ------------------ USER ------------------
load data local infile 'C:/xampp/htdocs/mt102/database/data/initializers/user.txt'
    into table mt102.mt_user
    fields terminated by '\t'
    enclosed by '"'
    escaped by '\\'
    lines terminated by '\r\n'
    ignore 1 LINES
    (`id`, `email`, `password`, `remember_token`, `lastname`, `firstname`, `avatar_url`, `theme_color`, `gender`, `birthdate`, `phone_number`, `address`, `superuser`, `status`);

-- ----------- RECOMMENED ---------------
load data local infile 'C:/xampp/htdocs/mt102/database/data/initializers/card-recommendation.txt'
    into table mt102.mt_card_recommendation
    fields terminated by '\t'
    enclosed by '"'
    escaped by '\\'
    lines terminated by '\r\n'
    ignore 1 LINES
    (`id`,	`level_id`, `card_id`, `creator_id`, `description`, `created_at`, `updated_at`, `importance`, `status_id`);

-- ----------- QUESTION ---------------
load data local infile 'C:/xampp/htdocs/mt102/database/data/initializers/card-question.txt'
    into table mt102.mt_card_question
    fields terminated by '\t'
    enclosed by '"'
    escaped by '\\'
    lines terminated by '\r\n'
    ignore 1 LINES
    (`id`,`parent_card_id`, `card_id`, `description`,	`type_id`, `response_type_id`, `template_type_id`, `creator_id`, `card_picture_url`, `background_color`, `created_at`, `updated_at`, `privacy_id`, `importance`, `status_id`);


-- ----------- CONTRIBUTION ---------------
load data local infile 'C:/xampp/htdocs/mt102/database/data/initializers/card-contribution.txt'
    into table mt102.mt_card_contribution
    fields terminated by '\t'
    enclosed by '"'
    escaped by '\\'
    lines terminated by '\r\n'
    ignore 1 LINES
    (`id`,	`level_id`, `card_id`, `creator_id`,	`contributor_id`,	`description`,	`created_at`,	`updated_at`,	`status_id`, `privacy_id`);
