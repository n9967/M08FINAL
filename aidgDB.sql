-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: aidg
-- ------------------------------------------------------
-- Server version	8.0.39

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

--
-- Table structure for table `ai_detail_guy`
--

DROP TABLE IF EXISTS `ai_detail_guy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_detail_guy` (
  `AIDG_ID` int NOT NULL,
  `Appointment_number` int DEFAULT NULL,
  `P_ID` int DEFAULT NULL,
  `Customer_cars` varchar(255) DEFAULT NULL,
  `Quote` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`AIDG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_detail_guy`
--

LOCK TABLES `ai_detail_guy` WRITE;
/*!40000 ALTER TABLE `ai_detail_guy` DISABLE KEYS */;
INSERT INTO `ai_detail_guy` VALUES (101,1001,1,'Tesla Model 3',250.00),(102,1002,2,'Ford Mustang',200.00),(103,1003,3,'BMW X5',300.00),(104,1004,4,'Chevrolet Camaro',180.00),(105,1005,5,'Audi Q7',220.00);
/*!40000 ALTER TABLE `ai_detail_guy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment` (
  `Appointment_number` int NOT NULL,
  `Customer_ID` int DEFAULT NULL,
  `AIDG_ID` int DEFAULT NULL,
  `Schedule_date` date DEFAULT NULL,
  `Customer_cars` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Appointment_number`),
  KEY `Customer_ID` (`Customer_ID`),
  KEY `AIDG_ID` (`AIDG_ID`),
  CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`Customer_ID`) REFERENCES `customer` (`Customer_ID`),
  CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`AIDG_ID`) REFERENCES `ai_detail_guy` (`AIDG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment`
--

LOCK TABLES `appointment` WRITE;
/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
INSERT INTO `appointment` VALUES (1001,1,101,'2024-10-01','Tesla Model 3'),(1002,2,102,'2024-10-02','Ford Mustang'),(1003,3,103,'2024-10-03','BMW X5'),(1004,4,104,'2024-10-04','Chevrolet Camaro'),(1005,5,105,'2024-10-05','Audi Q7');
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `Customer_ID` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Phone` varchar(255) DEFAULT NULL,
  `Customer_cars` varchar(255) DEFAULT NULL,
  `Payment` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Customer_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'John Doe','555-1234','Tesla Model 3',250.00),(2,'Jane Smith','555-5678','Ford Mustang',200.00),(3,'Emily Davis','555-9012','BMW X5',300.00),(4,'Michael Brown','555-3456','Chevrolet Camaro',180.00),(5,'Sarah Johnson','555-7890','Audi Q7',220.00);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detailers`
--

DROP TABLE IF EXISTS `detailers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detailers` (
  `Detailer_ID` int NOT NULL,
  `Appointment_number` int DEFAULT NULL,
  `ProsPay` decimal(10,2) DEFAULT NULL,
  `LowersPay` decimal(10,2) DEFAULT NULL,
  `TotalCars` int DEFAULT NULL,
  PRIMARY KEY (`Detailer_ID`),
  KEY `Appointment_number` (`Appointment_number`),
  CONSTRAINT `detailers_ibfk_1` FOREIGN KEY (`Appointment_number`) REFERENCES `appointment` (`Appointment_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detailers`
--

LOCK TABLES `detailers` WRITE;
/*!40000 ALTER TABLE `detailers` DISABLE KEYS */;
INSERT INTO `detailers` VALUES (201,1001,110.00,NULL,17),(202,1002,NULL,60.00,13),(203,1003,100.00,NULL,13),(204,1004,NULL,65.00,13),(205,1005,100.00,NULL,10);
/*!40000 ALTER TABLE `detailers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `INV_ID` int NOT NULL,
  `Appointment_number` int DEFAULT NULL,
  `Customer_ID` int DEFAULT NULL,
  `Customer_cars` varchar(255) DEFAULT NULL,
  `Payment` decimal(10,2) DEFAULT NULL,
  `Totals` decimal(10,2) DEFAULT NULL,
  `Expenses` decimal(10,2) DEFAULT NULL,
  `Quote` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`INV_ID`),
  KEY `Appointment_number` (`Appointment_number`),
  KEY `Customer_ID` (`Customer_ID`),
  CONSTRAINT `invoice_ibfk_1` FOREIGN KEY (`Appointment_number`) REFERENCES `appointment` (`Appointment_number`),
  CONSTRAINT `invoice_ibfk_2` FOREIGN KEY (`Customer_ID`) REFERENCES `customer` (`Customer_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES (301,1001,1,'Tesla Model 3',250.00,310.00,110.00,250.00),(302,1002,2,'Ford Mustang',200.00,260.00,60.00,200.00),(303,1003,3,'BMW X5',300.00,400.00,100.00,300.00),(304,1004,4,'Chevrolet Camaro',180.00,245.00,65.00,180.00),(305,1005,5,'Audi Q7',220.00,320.00,100.00,220.00);
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_supplies`
--

DROP TABLE IF EXISTS `order_supplies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_supplies` (
  `Order_ID` int NOT NULL,
  `Order_Date` date DEFAULT NULL,
  `Supply_ID` int DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Total_Cost` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Order_ID`),
  KEY `Supply_ID` (`Supply_ID`),
  CONSTRAINT `order_supplies_ibfk_1` FOREIGN KEY (`Supply_ID`) REFERENCES `supply` (`Supply_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_supplies`
--

LOCK TABLES `order_supplies` WRITE;
/*!40000 ALTER TABLE `order_supplies` DISABLE KEYS */;
INSERT INTO `order_supplies` VALUES (1,'2024-09-01',1,20,300.00),(2,'2024-09-02',2,50,125.00),(3,'2024-09-03',3,30,210.00),(4,'2024-09-04',4,15,375.00),(5,'2024-09-05',5,25,300.00);
/*!40000 ALTER TABLE `order_supplies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suits_programmers`
--

DROP TABLE IF EXISTS `suits_programmers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suits_programmers` (
  `P_ID` int NOT NULL,
  `AIDG_ID` int DEFAULT NULL,
  `Expenses` decimal(10,2) DEFAULT NULL,
  `Net_worth` decimal(10,2) DEFAULT NULL,
  `Role` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`P_ID`),
  KEY `AIDG_ID` (`AIDG_ID`),
  CONSTRAINT `suits_programmers_ibfk_1` FOREIGN KEY (`AIDG_ID`) REFERENCES `ai_detail_guy` (`AIDG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suits_programmers`
--

LOCK TABLES `suits_programmers` WRITE;
/*!40000 ALTER TABLE `suits_programmers` DISABLE KEYS */;
INSERT INTO `suits_programmers` VALUES (1,101,500.00,10000.00,'Lead Programmer'),(2,102,300.00,8000.00,'Junior Programmer'),(3,103,200.00,6000.00,'AI Engineer'),(4,104,150.00,4000.00,'Suits Manager'),(5,105,100.00,3000.00,'Support Staff');
/*!40000 ALTER TABLE `suits_programmers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supply`
--

DROP TABLE IF EXISTS `supply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supply` (
  `Supply_ID` int NOT NULL,
  `Supply_Name` varchar(255) DEFAULT NULL,
  `Category` varchar(255) DEFAULT NULL,
  `Description` text,
  `Stock_Level` int DEFAULT NULL,
  `Cost` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Supply_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supply`
--

LOCK TABLES `supply` WRITE;
/*!40000 ALTER TABLE `supply` DISABLE KEYS */;
INSERT INTO `supply` VALUES (1,'Car Shampoo','Cleaning','High-quality car shampoo',100,15.00),(2,'Microfiber Towels','Accessories','Soft microfiber towels',200,2.50),(3,'Glass Cleaner','Cleaning','Streak-free glass cleaner',150,7.00),(4,'Polish Wax','Polishing','Premium car wax',75,25.00),(5,'Wheel Cleaner','Cleaning','Powerful wheel cleaner',50,12.00);
/*!40000 ALTER TABLE `supply` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-29 20:42:47
