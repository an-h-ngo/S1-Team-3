-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: yoursjsu
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '30ca85d3-016f-11f1-9b14-00ffccd4fcf0:1-155';

--
-- Table structure for table `charge`
--

DROP TABLE IF EXISTS `charge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `charge` (
  `charge_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `term_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` varchar(255) NOT NULL,
  `posted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','paid','overdue','waived') NOT NULL DEFAULT 'pending',
  PRIMARY KEY (`charge_id`),
  KEY `idx_charge_student` (`user_id`),
  KEY `idx_charge_term` (`term_id`),
  CONSTRAINT `charge_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `student` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `charge_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `term` (`term_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `charge`
--

LOCK TABLES `charge` WRITE;
/*!40000 ALTER TABLE `charge` DISABLE KEYS */;
INSERT INTO `charge` VALUES (1,1,1,3898.50,'Tuition - Full Time','2025-07-15 00:00:00','paid'),(2,1,1,478.00,'Student Union Fee','2025-07-15 00:00:00','paid'),(3,2,1,3898.50,'Tuition - Full Time','2025-07-15 00:00:00','paid'),(4,2,1,478.00,'Student Union Fee','2025-07-15 00:00:00','pending'),(5,8,1,3898.50,'Tuition - Full Time','2025-07-15 00:00:00','paid'),(6,9,1,3898.50,'Tuition - Full Time','2025-07-15 00:00:00','paid'),(7,11,1,3898.50,'Tuition - Full Time','2025-07-15 00:00:00','pending'),(8,12,1,2649.00,'Tuition - Part Time','2025-07-15 00:00:00','paid'),(9,1,3,3750.00,'Tuition - Full Time','2024-07-15 00:00:00','paid'),(10,1,3,460.00,'Student Union Fee','2024-07-15 00:00:00','paid'),(11,3,3,3750.00,'Tuition - Full Time','2024-07-15 00:00:00','overdue'),(12,3,3,150.00,'Late Payment Fee','2024-09-01 00:00:00','overdue'),(13,8,3,3750.00,'Tuition - Full Time','2024-07-15 00:00:00','paid'),(14,9,3,3750.00,'Tuition - Full Time','2024-07-15 00:00:00','paid');
/*!40000 ALTER TABLE `charge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course` (
  `course_id` int NOT NULL AUTO_INCREMENT,
  `department_id` int NOT NULL,
  `course_number` varchar(10) NOT NULL,
  `course_title` varchar(150) NOT NULL,
  `units` int NOT NULL,
  PRIMARY KEY (`course_id`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `course_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`) ON DELETE CASCADE,
  CONSTRAINT `course_chk_1` CHECK ((`units` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
/*!40000 ALTER TABLE `course` DISABLE KEYS */;
INSERT INTO `course` VALUES (1,1,'172','Enterprise Software Platforms',3),(2,1,'131','Software Engineering I',3),(3,1,'133','Software Engineering II',3),(4,1,'120','Computer Organization and Architecture',3),(5,1,'152','Computer Networks',3),(6,2,'146','Data Structures and Algorithms',3),(7,2,'157A','Introduction to Database Management Systems',3),(8,2,'166','Information Security',3),(9,2,'151','Object-Oriented Design',3),(10,3,'110','Circuit Analysis I',3),(11,3,'112','Circuit Analysis II',3),(12,4,'030','Calculus I',4),(13,4,'031','Calculus II',4),(14,4,'042','Discrete Mathematics',3),(15,4,'129A','Linear Algebra I',3),(16,5,'01A','First-Year Writing',3),(17,5,'01B','Argument and Analysis',3),(18,6,'050','General Physics I',4),(19,6,'051','General Physics II',4);
/*!40000 ALTER TABLE `course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credential`
--

DROP TABLE IF EXISTS `credential`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credential` (
  `user_id` int NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `last_changed` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `credential_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credential`
--

LOCK TABLES `credential` WRITE;
/*!40000 ALTER TABLE `credential` DISABLE KEYS */;
INSERT INTO `credential` VALUES (1,'$2b$12$LJ3m5ZQzKEfOVx8X1kzWhe8fAjRn0p1xN3cVZ6m2uKq3rS7w5tYdC','2025-01-05 08:00:00'),(2,'$2b$12$aB3cD4eF5gH6iJ7kL8mN9oP0qR1sT2uV3wX4yZ5aB6cD7eF8gH9iJ','2025-01-05 08:10:00'),(3,'$2b$12$kL8mN9oP0qR1sT2uV3wX4yZ5aB6cD7eF8gH9iJkL8mN9oP0qR1sT','2024-12-01 14:00:00'),(4,'$2b$12$V3wX4yZ5aB6cD7eF8gH9iJkL8mN9oP0qR1sT2uV3wX4yZ5aB6cD7','2024-11-20 09:30:00'),(5,'$2b$12$eF8gH9iJkL8mN9oP0qR1sT2uV3wX4yZ5aB6cD7eF8gH9iJkL8mN9','2025-01-02 16:00:00'),(6,'$2b$12$N9oP0qR1sT2uV3wX4yZ5aB6cD7eF8gH9iJkL8mN9oP0qR1sT2uV3','2024-10-15 10:00:00'),(7,'$2b$12$sT2uV3wX4yZ5aB6cD7eF8gH9iJkL8mN9oP0qR1sT2uV3wX4yZ5aB','2024-09-01 11:00:00'),(8,'$2b$12$Qp4rS5tU6vW7xY8zA9bC0dE1fG2hI3jK4lM5nO6pQ7rS8tU9vW0xY','2025-02-10 09:00:00'),(9,'$2b$12$zA9bC0dE1fG2hI3jK4lM5nO6pQ7rS8tU9vW0xY1zA2bC3dE4fG5hI','2025-01-20 14:30:00'),(10,'$2b$12$jK4lM5nO6pQ7rS8tU9vW0xY1zA2bC3dE4fG5hI6jK7lM8nO9pQ0rS','2025-03-01 08:00:00'),(11,'$2b$12$tU9vW0xY1zA2bC3dE4fG5hI6jK7lM8nO9pQ0rS1tU2vW3xY4zA5bC','2024-11-15 10:00:00'),(12,'$2b$12$dE4fG5hI6jK7lM8nO9pQ0rS1tU2vW3xY4zA5bC6dE7fG8hI9jK0lM','2024-12-05 11:00:00'),(13,'$2b$12$nO9pQ0rS1tU2vW3xY4zA5bC6dE7fG8hI9jK0lM1nO2pQ3rS4tU5vW','2024-06-15 08:00:00'),(14,'$2b$12$xY4zA5bC6dE7fG8hI9jK0lM1nO2pQ3rS4tU5vW6xY7zA8bC9dE0fG','2025-02-28 13:00:00'),(15,'$2b$12$hI9jK0lM1nO2pQ3rS4tU5vW6xY7zA8bC9dE0fG1hI2jK3lM4nO5pQ','2024-08-01 08:00:00'),(16,'$2b$12$rS4tU5vW6xY7zA8bC9dE0fG1hI2jK3lM4nO5pQ6rS7tU8vW9xY0zA','2024-08-01 08:00:00'),(17,'$2b$12$bC9dE0fG1hI2jK3lM4nO5pQ6rS7tU8vW9xY0zA1bC2dE3fG4hI5jK','2024-08-01 08:00:00'),(18,'$2b$12$lM4nO5pQ6rS7tU8vW9xY0zA1bC2dE3fG4hI5jK6lM7nO8pQ9rS0tU','2024-08-01 08:00:00'),(19,'$2b$12$vW9xY0zA1bC2dE3fG4hI5jK6lM7nO8pQ9rS0tU1vW2xY3zA4bC5dE','2024-03-01 08:00:00'),(20,'$2b$12$fG4hI5jK6lM7nO8pQ9rS0tU1vW2xY3zA4bC5dE6fG7hI8jK9lM0nO','2024-08-01 08:00:00');
/*!40000 ALTER TABLE `credential` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `department_id` int NOT NULL AUTO_INCREMENT,
  `department_name` varchar(100) NOT NULL,
  `department_code` varchar(10) NOT NULL,
  `department_type` enum('academic','administrative','technical') NOT NULL DEFAULT 'academic',
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `department_code` (`department_code`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'Computer Engineering','CMPE','academic'),(2,'Computer Science','CS','academic'),(3,'Electrical Engineering','EE','academic'),(4,'Mathematics','MATH','academic'),(5,'English','ENGL','academic'),(6,'Physics','PHYS','academic'),(7,'Mechanical Engineering','ME','academic'),(8,'Office of the Registrar','REG','administrative'),(9,'Information Technology','MIS','technical'),(10,'Aerospace Engineering','AE','academic');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_faculty`
--

DROP TABLE IF EXISTS `department_faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_faculty` (
  `user_id` int NOT NULL,
  `department_id` int NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `department_faculty_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `faculty` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `department_faculty_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_faculty`
--

LOCK TABLES `department_faculty` WRITE;
/*!40000 ALTER TABLE `department_faculty` DISABLE KEYS */;
INSERT INTO `department_faculty` VALUES (5,1),(15,1),(4,2),(7,2),(18,3),(16,4),(17,5),(20,6),(6,9),(19,9);
/*!40000 ALTER TABLE `department_faculty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculty`
--

DROP TABLE IF EXISTS `faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faculty` (
  `user_id` int NOT NULL,
  `staff_title` varchar(100) NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `faculty_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculty`
--

LOCK TABLES `faculty` WRITE;
/*!40000 ALTER TABLE `faculty` DISABLE KEYS */;
INSERT INTO `faculty` VALUES (4,'Professor'),(5,'Associate Professor'),(6,'Systems Developer'),(7,'Teaching Assistant'),(15,'Assistant Professor'),(16,'Professor'),(17,'Lecturer'),(18,'Associate Professor'),(19,'Systems Developer'),(20,'Assistant Professor');
/*!40000 ALTER TABLE `faculty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `term_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `paid_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `idx_payment_student` (`user_id`),
  KEY `idx_payment_term` (`term_id`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `student` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `term` (`term_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,1,1,4376.50,'2025-08-01 10:00:00'),(2,2,1,3898.50,'2025-08-10 11:30:00'),(3,8,1,3898.50,'2025-08-05 09:00:00'),(4,9,1,3898.50,'2025-08-07 14:00:00'),(5,12,1,2649.00,'2025-08-03 14:00:00'),(6,1,3,4210.00,'2024-08-01 10:00:00'),(7,8,3,3750.00,'2024-08-10 11:30:00'),(8,9,3,3750.00,'2024-08-05 09:00:00'),(9,7,3,3750.00,'2024-08-12 10:00:00'),(10,12,3,3750.00,'2024-08-08 11:00:00');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prerequisite`
--

DROP TABLE IF EXISTS `prerequisite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prerequisite` (
  `course_id` int NOT NULL,
  `prerequisite_id` int NOT NULL,
  PRIMARY KEY (`course_id`,`prerequisite_id`),
  KEY `prerequisite_id` (`prerequisite_id`),
  CONSTRAINT `prerequisite_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE CASCADE,
  CONSTRAINT `prerequisite_ibfk_2` FOREIGN KEY (`prerequisite_id`) REFERENCES `course` (`course_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prerequisite`
--

LOCK TABLES `prerequisite` WRITE;
/*!40000 ALTER TABLE `prerequisite` DISABLE KEYS */;
INSERT INTO `prerequisite` VALUES (1,2),(3,2),(5,4),(8,5),(7,6),(9,6),(1,7),(11,10),(13,12),(17,16),(19,18);
/*!40000 ALTER TABLE `prerequisite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `section`
--

DROP TABLE IF EXISTS `section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `section` (
  `section_id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `term_id` int NOT NULL,
  `faculty_id` int NOT NULL,
  `capacity` int NOT NULL,
  `waitlist_capacity` int NOT NULL,
  `meeting_days` varchar(20) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `location` varchar(100) NOT NULL,
  `modality` enum('in_person','online','hybrid') NOT NULL DEFAULT 'in_person',
  PRIMARY KEY (`section_id`),
  KEY `idx_section_term` (`term_id`),
  KEY `idx_section_course` (`course_id`),
  KEY `idx_section_faculty` (`faculty_id`),
  CONSTRAINT `section_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE CASCADE,
  CONSTRAINT `section_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `term` (`term_id`) ON DELETE CASCADE,
  CONSTRAINT `section_ibfk_3` FOREIGN KEY (`faculty_id`) REFERENCES `faculty` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `section_chk_1` CHECK ((`capacity` >= 0)),
  CONSTRAINT `section_chk_2` CHECK ((`waitlist_capacity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `section`
--

LOCK TABLES `section` WRITE;
/*!40000 ALTER TABLE `section` DISABLE KEYS */;
INSERT INTO `section` VALUES (1,1,1,5,40,10,'MW','10:30:00','11:45:00','ENG 337','in_person'),(2,1,1,15,40,10,'TR','15:00:00','16:15:00','ENG 337','in_person'),(3,2,1,15,35,5,'MW','09:00:00','10:15:00','ENG 189','in_person'),(4,6,1,4,45,15,'TR','12:00:00','13:15:00','MH 233','in_person'),(5,7,1,4,40,10,'MW','13:30:00','14:45:00','MH 233','in_person'),(6,12,1,16,50,5,'MWF','08:00:00','08:50:00','WSQ 109','in_person'),(7,14,1,16,45,10,'TR','09:00:00','10:15:00','WSQ 109','in_person'),(8,16,1,17,30,5,'MW','11:00:00','12:15:00','SH 240','in_person'),(9,18,1,20,35,5,'TR','10:30:00','11:45:00','SCI 142','hybrid'),(10,8,1,7,30,10,'MW','15:00:00','16:15:00','ENG 403','online'),(11,3,2,15,35,5,'MW','09:00:00','10:15:00','ENG 189','in_person'),(12,5,2,5,40,10,'TR','13:30:00','14:45:00','ENG 337','in_person'),(13,9,2,4,40,10,'TR','10:30:00','11:45:00','MH 233','in_person'),(14,13,2,16,50,5,'MWF','08:00:00','08:50:00','WSQ 109','in_person'),(15,17,2,17,30,5,'MW','11:00:00','12:15:00','SH 240','in_person'),(16,19,2,20,35,5,'TR','10:30:00','11:45:00','SCI 142','hybrid'),(17,2,3,15,35,5,'MW','09:00:00','10:15:00','ENG 189','in_person'),(18,6,3,4,45,15,'TR','12:00:00','13:15:00','MH 233','in_person'),(19,12,3,16,50,5,'MWF','08:00:00','08:50:00','WSQ 109','in_person'),(20,16,3,17,30,5,'MW','11:00:00','12:15:00','SH 240','in_person'),(21,18,3,20,35,5,'TR','10:30:00','11:45:00','SCI 142','hybrid'),(22,14,3,16,45,10,'TR','09:00:00','10:15:00','WSQ 109','in_person');
/*!40000 ALTER TABLE `section` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session` (
  `session_token` varchar(128) NOT NULL,
  `user_id` int NOT NULL,
  `status` enum('active','expired','invalidated') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`session_token`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `session_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session`
--

LOCK TABLES `session` WRITE;
/*!40000 ALTER TABLE `session` DISABLE KEYS */;
INSERT INTO `session` VALUES ('tok_an_active',1,'active','2026-03-16 08:00:00','2026-03-16 20:00:00'),('tok_daniel_active',9,'active','2026-03-16 09:00:00','2026-03-16 21:00:00'),('tok_jessica_active',8,'active','2026-03-16 08:30:00','2026-03-16 20:30:00'),('tok_kevin_active',7,'active','2026-03-16 11:00:00','2026-03-16 23:00:00'),('tok_lisahong_active',15,'active','2026-03-16 08:45:00','2026-03-16 20:45:00'),('tok_mikewu_active',4,'active','2026-03-16 07:30:00','2026-03-16 19:30:00'),('tok_nathan_expired',3,'expired','2026-03-15 10:00:00','2026-03-15 22:00:00'),('tok_ryan_invalidated',11,'invalidated','2026-03-13 10:00:00','2026-03-13 22:00:00'),('tok_sophia_expired',10,'expired','2026-03-14 14:00:00','2026-03-14 23:59:59'),('tok_vincent_active',2,'active','2026-03-16 09:15:00','2026-03-16 21:15:00');
/*!40000 ALTER TABLE `session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `user_id` int NOT NULL,
  `hold_status` enum('none','academic','financial','administrative') NOT NULL DEFAULT 'none',
  `registration_status` enum('eligible','not_eligible','registered') NOT NULL DEFAULT 'eligible',
  PRIMARY KEY (`user_id`),
  CONSTRAINT `student_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (1,'none','registered'),(2,'none','eligible'),(3,'financial','not_eligible'),(7,'none','registered'),(8,'none','registered'),(9,'none','registered'),(10,'none','eligible'),(11,'none','registered'),(12,'none','registered'),(13,'academic','not_eligible'),(14,'none','eligible');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_has_enrollment`
--

DROP TABLE IF EXISTS `student_has_enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_has_enrollment` (
  `user_id` int NOT NULL,
  `section_id` int NOT NULL,
  `status` enum('enrolled','dropped','completed') NOT NULL DEFAULT 'enrolled',
  `enrolled_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dropped_at` datetime DEFAULT NULL,
  `letter_grade` enum('A+','A','A-','B+','B','B-','C+','C','C-','D+','D','D-','F','W','I','IP') DEFAULT NULL,
  PRIMARY KEY (`user_id`,`section_id`),
  KEY `idx_enrollment_student` (`user_id`),
  KEY `idx_enrollment_section` (`section_id`),
  CONSTRAINT `student_has_enrollment_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `student` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `student_has_enrollment_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_has_enrollment`
--

LOCK TABLES `student_has_enrollment` WRITE;
/*!40000 ALTER TABLE `student_has_enrollment` DISABLE KEYS */;
INSERT INTO `student_has_enrollment` VALUES (1,1,'enrolled','2025-08-21 08:30:00',NULL,NULL),(1,5,'enrolled','2025-08-21 08:35:00',NULL,NULL),(1,8,'enrolled','2025-08-21 08:40:00',NULL,NULL),(1,17,'completed','2024-08-22 08:00:00',NULL,'A'),(1,18,'completed','2024-08-22 08:05:00',NULL,'A-'),(1,19,'completed','2024-08-22 08:10:00',NULL,'B+'),(1,20,'completed','2024-08-22 08:15:00',NULL,'A'),(2,2,'enrolled','2025-08-22 09:00:00',NULL,NULL),(2,4,'enrolled','2025-08-22 09:05:00',NULL,NULL),(2,6,'enrolled','2025-08-22 09:10:00',NULL,NULL),(2,18,'completed','2024-08-23 09:00:00',NULL,'B+'),(2,21,'completed','2024-08-23 09:10:00',NULL,'B'),(2,22,'completed','2024-08-23 09:05:00',NULL,'A-'),(3,4,'enrolled','2025-08-23 10:00:00',NULL,NULL),(3,7,'enrolled','2025-08-23 10:05:00',NULL,NULL),(3,9,'enrolled','2025-08-23 10:10:00',NULL,NULL),(3,17,'completed','2024-08-22 10:00:00',NULL,'A'),(3,18,'completed','2024-08-22 10:05:00',NULL,'A'),(3,22,'completed','2024-08-22 10:10:00',NULL,'A-'),(7,1,'enrolled','2025-08-21 12:00:00',NULL,NULL),(7,19,'completed','2024-08-23 07:00:00',NULL,'B+'),(7,20,'completed','2024-08-23 07:05:00',NULL,'A-'),(8,1,'enrolled','2025-08-21 09:00:00',NULL,NULL),(8,4,'enrolled','2025-08-21 09:05:00',NULL,NULL),(8,17,'completed','2024-08-22 09:30:00',NULL,'A-'),(8,18,'completed','2024-08-22 09:35:00',NULL,'B+'),(9,5,'enrolled','2025-08-22 10:00:00',NULL,NULL),(9,7,'enrolled','2025-08-22 10:05:00',NULL,NULL),(9,19,'completed','2024-08-23 10:00:00',NULL,'A'),(9,20,'completed','2024-08-23 10:05:00',NULL,'B'),(9,21,'completed','2024-08-23 10:10:00',NULL,'B+'),(11,2,'enrolled','2025-08-21 11:00:00',NULL,NULL),(11,8,'enrolled','2025-08-21 11:05:00',NULL,NULL),(11,9,'enrolled','2025-08-21 11:10:00',NULL,NULL),(11,18,'completed','2024-08-22 11:00:00',NULL,'A'),(11,22,'completed','2024-08-22 11:05:00',NULL,'A-'),(12,3,'enrolled','2025-08-22 08:00:00',NULL,NULL),(12,6,'enrolled','2025-08-22 08:05:00',NULL,NULL),(12,19,'completed','2024-08-23 08:00:00',NULL,'A-'),(12,20,'completed','2024-08-23 08:05:00',NULL,'A'),(12,21,'completed','2024-08-23 08:10:00',NULL,'B+');
/*!40000 ALTER TABLE `student_has_enrollment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_waitlist`
--

DROP TABLE IF EXISTS `student_waitlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_waitlist` (
  `user_id` int NOT NULL,
  `section_id` int NOT NULL,
  `requested_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('waiting','enrolled','expired','cancelled') NOT NULL DEFAULT 'waiting',
  PRIMARY KEY (`user_id`,`section_id`),
  KEY `idx_waitlist_section` (`section_id`),
  CONSTRAINT `student_waitlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `student` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `student_waitlist_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_waitlist`
--

LOCK TABLES `student_waitlist` WRITE;
/*!40000 ALTER TABLE `student_waitlist` DISABLE KEYS */;
INSERT INTO `student_waitlist` VALUES (3,1,'2025-08-25 08:00:00','waiting'),(3,5,'2025-08-25 08:05:00','waiting'),(10,1,'2025-08-26 09:00:00','waiting'),(10,4,'2025-08-26 09:05:00','waiting'),(10,7,'2025-08-26 09:10:00','waiting'),(13,18,'2024-08-25 08:00:00','expired'),(13,22,'2024-08-25 08:05:00','cancelled'),(14,2,'2025-08-27 10:00:00','waiting'),(14,5,'2025-08-27 10:05:00','waiting'),(14,9,'2025-08-27 10:10:00','waiting');
/*!40000 ALTER TABLE `student_waitlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `term`
--

DROP TABLE IF EXISTS `term`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term` (
  `term_id` int NOT NULL AUTO_INCREMENT,
  `term_name` varchar(50) NOT NULL,
  `registration_open_at` datetime NOT NULL,
  `registration_close_at` datetime NOT NULL,
  `drop_deadline` date NOT NULL,
  PRIMARY KEY (`term_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `term`
--

LOCK TABLES `term` WRITE;
/*!40000 ALTER TABLE `term` DISABLE KEYS */;
INSERT INTO `term` VALUES (1,'Fall 2025','2025-08-20 08:00:00','2025-12-19 23:59:59','2025-09-12'),(2,'Spring 2025','2025-01-21 08:00:00','2025-05-23 23:59:59','2025-02-13'),(3,'Fall 2024','2024-08-21 08:00:00','2024-12-20 23:59:59','2024-09-13'),(4,'Spring 2024','2024-01-22 08:00:00','2024-05-24 23:59:59','2024-02-14'),(5,'Fall 2023','2023-08-21 08:00:00','2023-12-15 23:59:59','2023-09-15'),(6,'Spring 2023','2023-01-23 08:00:00','2023-05-26 23:59:59','2023-02-15'),(7,'Summer 2025','2025-05-01 08:00:00','2025-08-08 23:59:59','2025-06-06'),(8,'Summer 2024','2024-05-01 08:00:00','2024-08-09 23:59:59','2024-06-07'),(9,'Spring 2026','2026-01-20 08:00:00','2026-05-22 23:59:59','2026-02-12'),(10,'Summer 2026','2026-05-01 08:00:00','2026-08-07 23:59:59','2026-06-05');
/*!40000 ALTER TABLE `term` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `sjsu_id` varchar(9) NOT NULL,
  `email` varchar(100) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `status` enum('active','inactive','suspended') NOT NULL DEFAULT 'active',
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `sjsu_id` (`sjsu_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'012345678','an.h.ngo01@sjsu.edu','An','Ngo','active','2023-08-15 10:00:00','2026-03-16 09:00:00'),(2,'012345679','vincent.do01@sjsu.edu','Vincent','Do','active','2024-01-19 10:05:00','2026-03-16 09:05:00'),(3,'012345680','nathan.s.wong@sjsu.edu','Nathan','Wong','active','2024-01-19 08:00:00','2026-03-16 09:10:00'),(4,'100000001','ching-seh.wu@sjsu.edu','Mike','Wu','active','2015-08-01 08:00:00','2026-03-16 10:00:00'),(5,'100000002','mygoat@sjsu.edu','My','Goat','active','2016-08-01 08:00:00','2026-03-16 10:05:00'),(6,'100000007','admin.yoursjsu@sjsu.edu','Your','SJSU','active','2014-06-01 08:00:00','2026-03-16 10:30:00'),(7,'100000009','ta.kevin.nguyen@sjsu.edu','Kevin','Nguyen','active','2022-08-15 08:00:00','2026-03-16 10:40:00'),(8,'012345681','jessica.tran@sjsu.edu','Jessica','Tran','active','2023-08-15 10:30:00','2026-03-16 09:15:00'),(9,'012345682','daniel.park@sjsu.edu','Daniel','Park','active','2024-01-19 11:00:00','2026-03-16 09:20:00'),(10,'012345683','sophia.garcia@sjsu.edu','Sophia','Garcia','active','2024-08-20 09:00:00','2026-03-16 09:25:00'),(11,'012345684','ryan.patel@sjsu.edu','Ryan','Patel','active','2023-01-10 08:00:00','2026-03-16 09:30:00'),(12,'012345685','emily.chen@sjsu.edu','Emily','Chen','active','2022-08-15 09:00:00','2026-03-16 09:35:00'),(13,'012345686','marcus.johnson@sjsu.edu','Marcus','Johnson','inactive','2021-08-15 09:00:00','2025-12-20 10:00:00'),(14,'012345687','olivia.kim@sjsu.edu','Olivia','Kim','active','2024-08-20 13:00:00','2026-03-16 09:45:00'),(15,'100000003','dr.lisa.hong@sjsu.edu','Lisa','Hong','active','2018-01-15 08:00:00','2026-03-16 10:10:00'),(16,'100000004','dr.raj.kumar@sjsu.edu','Raj','Kumar','active','2017-08-01 08:00:00','2026-03-16 10:15:00'),(17,'100000005','prof.anna.clark@sjsu.edu','Anna','Clark','active','2019-08-01 08:00:00','2026-03-16 10:20:00'),(18,'100000006','dr.james.miller@sjsu.edu','James','Miller','active','2020-01-15 08:00:00','2026-03-16 10:25:00'),(19,'100000008','dev.tom.wilson@sjsu.edu','Tom','Wilson','active','2020-03-01 08:00:00','2026-03-16 10:35:00'),(20,'100000010','dr.priya.sharma@sjsu.edu','Priya','Sharma','active','2021-08-01 08:00:00','2026-03-16 10:45:00');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-14  1:49:55
