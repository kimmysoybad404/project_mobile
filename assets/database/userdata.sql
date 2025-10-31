-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 31, 2025 at 09:42 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `asset_borrowing`
--

-- --------------------------------------------------------

--
-- Table structure for table `userdata`
--

CREATE TABLE `userdata` (
  `UserID` smallint(5) UNSIGNED NOT NULL,
  `Role` enum('1','2','3') NOT NULL COMMENT '1 = borrower\r\n2 = Lender\r\n3 = staff',
  `Name` varchar(20) NOT NULL,
  `Username` varchar(20) NOT NULL,
  `Password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `userdata`
--

INSERT INTO `userdata` (`UserID`, `Role`, `Name`, `Username`, `Password`) VALUES
(14, '1', 'BR', 'BRNAJA', '$argon2id$v=19$m=65536,t=3,p=1$UUoLJhH+BicYtK7/AkIzCQ$Y5S315VYUviOd8xslJkMWgA/yH8SvOVAnVaQsGLcIzg'),
(15, '2', 'LD', 'LDNAJA', '$argon2id$v=19$m=65536,t=3,p=1$JLxFZLQ69ds2wNgaigjdbw$FyJLm3WGq2eOXUyliG6AgVZz2/OP61VvVt/Ti96qa1Q'),
(16, '3', 'ST', 'STNAJA', '$argon2id$v=19$m=65536,t=3,p=1$lPR0r2r6CE9KdjBnW7t/Ng$8KFnHPVROFLQE2OUo0ZT1Dzisv425wfM3KnsmiC78TI');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `userdata`
--
ALTER TABLE `userdata`
  ADD PRIMARY KEY (`UserID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `userdata`
--
ALTER TABLE `userdata`
  MODIFY `UserID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
