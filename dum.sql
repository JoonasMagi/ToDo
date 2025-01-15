/*!999999-- enable the sandbox mode */
-- MariaDB dump 10.19  Distrib 10.11.8-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: 
-- ------------------------------------------------------
-- Server version	11.6.2-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `studentdb`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `studentdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;

USE `studentdb`;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primaarvõti (INT AUTO_INCREMENT) kategooria ainulaadseks IDks',
  `user_id` int(11) NOT NULL COMMENT 'Viit tabelisse users(id). ON DELETE CASCADE: kustutame ka kategooriad, kui kasutaja kustutatakse',
  `name` varchar(50) NOT NULL COMMENT 'Kategooria nimi (nt "Töö"), seetõttu piisab VARCHAR(50)',
  PRIMARY KEY (`id`),
  KEY `fk_categories_user` (`user_id`),
  CONSTRAINT `fk_categories_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Tabel hoiab kasutajapõhiseid kategooriaid (nt Töö, Isiklik, Hobi).';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` (`id`, `user_id`, `name`) VALUES (1,1,'Isiklik'),
(2,1,'Töö'),
(3,2,'Blogi'),
(4,3,'Projektid'),
(5,5,'Arendus');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primaarvõti (INT AUTO_INCREMENT) iga logikirje ainulaadseks IDks',
  `user_id` int(11) NOT NULL COMMENT 'Viit tabelisse users(id). ON DELETE RESTRICT, et logid ei kustuks automaatselt, ON UPDATE CASCADE',
  `action` varchar(200) NOT NULL COMMENT 'Tegevuse lühikirjeldus (nt "Task created"), VARCHAR(200) lubab veidi pikemat teksti',
  `logged_at` datetime NOT NULL COMMENT 'Tegevuse toimumise aeg (DATETIME), automaatset uuendust pole vaja',
  PRIMARY KEY (`id`),
  KEY `fk_logs_user` (`user_id`),
  CONSTRAINT `fk_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Tabel hoiab rakenduse logisid (ajaloolised sündmused, mida ei kustutata automaatselt kasutajaga).';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT INTO `logs` (`id`, `user_id`, `action`, `logged_at`) VALUES (1,1,'Login successful','2025-01-01 12:30:00'),
(2,1,'Task created','2025-01-02 11:21:00'),
(3,2,'Task updated','2025-01-03 10:45:00'),
(4,3,'Category added','2025-01-03 14:00:00'),
(5,5,'Settings changed','2025-01-05 09:15:00');
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primaarvõti (INT AUTO_INCREMENT) iga uue ülesande unikaalseks tuvastamiseks',
  `user_id` int(11) NOT NULL COMMENT 'Viit tabelisse users(id). ON DELETE CASCADE: kui kasutaja kustub, kustuvad ka tema ülesanded',
  `title` varchar(100) NOT NULL COMMENT 'Lühike ülesande pealkiri, seetõttu VARCHAR(100)',
  `description` text DEFAULT NULL COMMENT 'Pikem ülesande kirjeldus (TEXT võimaldab suuremat mahtu kui VARCHAR)',
  `due_date` date NOT NULL COMMENT 'Ülesande tähtaeg, pole vaja kellaaega, seega DATE',
  `created_at` datetime NOT NULL COMMENT 'Ülesande loomise kuupäev+kellaaeg (DATETIME, automaatset uuendust pole vaja)',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'TIMESTAMP, mis värskendub automaatselt igal muutmisel',
  PRIMARY KEY (`id`),
  KEY `fk_tasks_user` (`user_id`),
  CONSTRAINT `fk_tasks_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Tabel hoiab todo-rakenduse ülesandeid, iga ülesanne seostub konkreetse kasutajaga.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` (`id`, `user_id`, `title`, `description`, `due_date`, `created_at`, `updated_at`) VALUES (1,1,'Kodulehe uuendus','Värskenda esilehe tekste ja pildigaleriid','2025-01-10','2025-01-01 10:05:00','2025-01-15 08:36:21'),
(2,1,'Osta toidukraami','Piim, leib, munad, või, õunad','2025-01-06','2025-01-02 11:20:00','2025-01-15 08:36:21'),
(3,2,'Kirjuta blogipostitus','Teema: andmebaasi optimeerimine','2025-01-07','2025-01-02 09:55:00','2025-01-15 08:36:21'),
(4,3,'Projektikoosolek','Koosolek Zoomis kell 14:00','2025-01-08','2025-01-03 11:00:00','2025-01-15 08:36:21'),
(5,5,'Uue funktsiooni prototüüp','Tuleb luua prototüüp uuele funktsioonile','2025-01-12','2025-01-04 09:10:00','2025-01-15 08:36:21');
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_settings`
--

DROP TABLE IF EXISTS `user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primaarvõti (INT AUTO_INCREMENT) iga seade eraldi kirjeks',
  `user_id` int(11) NOT NULL COMMENT 'Viit tabelisse users(id). ON DELETE CASCADE, et kustutada seaded kasutaja kustumisel',
  `setting_key` varchar(50) NOT NULL COMMENT 'Seade võti (nt "theme"), lühike string, seega VARCHAR(50)',
  `setting_value` varchar(100) NOT NULL COMMENT 'Seade väärtus (nt "dark"), VARCHAR(100) on enamasti piisav',
  PRIMARY KEY (`id`),
  KEY `fk_user_settings_user` (`user_id`),
  CONSTRAINT `fk_user_settings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Tabel hoiab iga kasutaja seadeid (nt teema, teavituste režiim, keel).';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_settings`
--

LOCK TABLES `user_settings` WRITE;
/*!40000 ALTER TABLE `user_settings` DISABLE KEYS */;
INSERT INTO `user_settings` (`id`, `user_id`, `setting_key`, `setting_value`) VALUES (1,1,'theme','dark'),
(2,1,'notifications','enabled'),
(3,2,'theme','light'),
(4,3,'notifications','disabled'),
(5,5,'language','et');
/*!40000 ALTER TABLE `user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primaarvõti (INT AUTO_INCREMENT) unikaalse kasutaja ID tarbeks',
  `username` varchar(50) NOT NULL COMMENT 'Kasutajanimi, lühike string (VARCHAR(50))',
  `email` varchar(100) NOT NULL COMMENT 'E-posti aadress, sobib VARCHAR(100), et mahutada pikemad domeenid',
  `created_at` datetime NOT NULL COMMENT 'Kasutame DATETIME, et talletada registreerimise kuupäev ja kellaaeg',
  `last_login` timestamp NULL DEFAULT NULL COMMENT 'TIMESTAMP, et salvestada viimane sisselogimise aeg; NULL, kui pole logitud',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Tabel hoiab kasutajate andmeid (login, email, registreerimise aeg, viimane login).';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `username`, `email`, `created_at`, `last_login`) VALUES (1,'john_doe','john@example.com','2025-01-01 10:00:00','2025-01-01 12:30:00'),
(2,'jane_smith','jane@example.com','2025-01-02 09:15:00','2025-01-03 14:45:20'),
(3,'anna_lee','anna@example.com','2025-01-02 11:05:00','2025-01-02 15:10:00'),
(4,'timo_tester','timo@example.org','2025-01-03 08:00:00','2025-01-04 13:40:10'),
(5,'kara_dev','kara@devmail.net','2025-01-04 08:15:00','2025-01-05 09:00:00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'studentdb'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-15 10:43:41
