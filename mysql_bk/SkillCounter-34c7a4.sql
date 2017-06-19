-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: shareddb1a.hosting.stackcp.net
-- Generation Time: Apr 27, 2017 at 08:12 PM
-- Server version: 10.1.14-MariaDB
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `SkillCounter-34c7a4`
--

-- --------------------------------------------------------

--
-- Table structure for table `button`
--

CREATE TABLE `button` (
  `username` varchar(20) NOT NULL,
  `skillname` varchar(30) NOT NULL,
  `btnNum` int(1) NOT NULL,
  `btn1Name` varchar(10) NOT NULL,
  `btn1TextColor` varchar(7) NOT NULL,
  `btn1BkColor` varchar(7) NOT NULL,
  `btn2Name` varchar(10) DEFAULT NULL,
  `btn2TextColor` varchar(7) DEFAULT NULL,
  `btn2BkColor` varchar(7) DEFAULT NULL,
  `btn3Name` varchar(10) DEFAULT NULL,
  `btn3TextColor` varchar(7) DEFAULT NULL,
  `btn3BkColor` varchar(7) DEFAULT NULL,
  `btn4Name` varchar(10) DEFAULT NULL,
  `btn4TextColor` varchar(7) DEFAULT NULL,
  `btn4BkColor` varchar(7) DEFAULT NULL,
  `btn5Name` varchar(10) DEFAULT NULL,
  `btn5TextColor` varchar(7) DEFAULT NULL,
  `btn5BkColor` varchar(7) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `button`
--

INSERT INTO `button` (`username`, `skillname`, `btnNum`, `btn1Name`, `btn1TextColor`, `btn1BkColor`, `btn2Name`, `btn2TextColor`, `btn2BkColor`, `btn3Name`, `btn3TextColor`, `btn3BkColor`, `btn4Name`, `btn4TextColor`, `btn4BkColor`, `btn5Name`, `btn5TextColor`, `btn5BkColor`) VALUES
('headspinnerd', 'Achop', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#c88000', 'Bad', '#ffffff', '#ff00ff', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'AcKeep', 3, 'Great', '#ffc4ff', '#ff0000', 'OK', '#000000', '#c88000', 'Bad', '#ffffff', '#ff00ff', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'AcToHllwbkToAc', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#c88000', 'Bad', '#ffffff', '#ff00ff', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'AcToJdToAc', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#c88000', 'Bad', '#ffffff', '#ff00ff', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Airchair Stretch', 1, 'Count', '#ffffff', '#ff0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Ball Glide', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#c88000', 'Bad', '#ffffff', '#ff00ff', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Chest Press', 1, 'Count', '#ffffff', '#ff0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Diverging Low Row', 1, 'Count', '#ffffff', '#ff0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Fast Glide', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#c88000', 'Bad', '#ffffff', '#ff00ff', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'HandStand', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#c88000', 'Bad', '#ffffff', '#ff00ff', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Headspin Total', 3, 'OK', '#ffecff', '#d41e40', 'OK', '#ffffff', '#8080ff', 'Oops', '#ffffe7', '#7f54af', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Hllwbk Stretch', 1, 'Count', '#ffffff', '#ff0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Lat Pulldown', 1, 'Count', '#ffffff', '#ff0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Leg Extension', 1, 'Count', '#ffffff', '#ff0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Leg Press', 1, 'Count', '#ffffff', '#ff0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Long Drill', 3, 'Great', '#ffffbc', '#ff0000', 'OK', '#ffd89f', '#ab92fe', 'Bad', '#5adba9', '#ad52c0', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Onehand Tap', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#ffffff', '#8080ff', 'Bad', '#ffffff', '#7f54af', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Only Onehand Tap', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#c88000', 'Bad', '#ffffff', '#ff00ff', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Open Glide', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#c88000', 'Bad', '#ffffff', '#ff00ff', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Peace Glide', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#c88000', 'Bad', '#fff4ff', '#a63fff', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Radar Stretch', 1, 'Count', '#ffffff', '#ff0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Rubiks Cube', 3, 'Fantastic!', '#ffffff', '#fd409b', 'So-so', '#ffffff', '#9999fe', 'Terrible', '#5a2ba9', '#97b142', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Sample Skill', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#c88000', 'Bad', '#ffffff', '#ff00ff', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Seated Calf Extension ', 1, 'Count', '#ffffff', '#ff0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'test', 3, 'Great', '#e7ffff', '#ff0000', 'OK', '#d0daff', '#8080ff', 'Bad', '#ffffff', '#7f54af', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'testa', 4, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#8080ff', 'Bad', '#ffffff', '#ff00ff', 'button', '#7dffff', '#9bc8ff', NULL, NULL, NULL),
('headspinnerd', 'testb', 4, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#8080ff', 'Bad', '#ffffff', '#ff00ff', 'button', '#7dffff', '#9bc8ff', NULL, NULL, NULL),
('headspinnerd', 'testc', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#8080ff', 'Bad', '#ffffff', '#ff00ff', NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Triceps Extension', 1, 'Count', '#ffffff', '#ff0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('headspinnerd', 'Zen', 3, 'Great', '#ffffff', '#ff0000', 'OK', '#000000', '#c88000', 'Bad', '#ffffff', '#ff00ff', NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `practiceTime`
--

CREATE TABLE `practiceTime` (
  `username` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `startTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `endTime` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `practiceTime`
--

INSERT INTO `practiceTime` (`username`, `startTime`, `endTime`) VALUES
('headspinnerd', '2017-03-19 21:54:10', '2017-03-19 22:47:43'),
('headspinnerd', '2017-03-21 16:08:42', '2017-03-21 16:45:38'),
('headspinnerd', '2017-03-23 15:57:04', '2017-03-23 16:40:38'),
('headspinnerd', '2017-03-26 15:47:48', '2017-03-26 16:27:02'),
('headspinnerd', '2017-03-31 22:07:20', '2017-03-31 22:40:43'),
('headspinnerd', '2017-04-06 13:54:31', '2017-04-06 15:24:48'),
('headspinnerd', '2017-04-11 15:33:29', '2017-04-11 15:54:50');

-- --------------------------------------------------------

--
-- Table structure for table `serverInfo`
--

CREATE TABLE `serverInfo` (
  `info1` varchar(100) NOT NULL,
  `info2` varchar(100) NOT NULL,
  `info3` varchar(100) NOT NULL,
  `info4` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `serverInfo`
--

INSERT INTO `serverInfo` (`info1`, `info2`, `info3`, `info4`) VALUES
('NO', 'NO', 'NO', 'NO');

-- --------------------------------------------------------

--
-- Table structure for table `skillCounter`
--

CREATE TABLE `skillCounter` (
  `username` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `skillName` char(30) COLLATE utf8_unicode_ci NOT NULL,
  `first_count` smallint(3) NOT NULL DEFAULT '0',
  `second_count` smallint(3) NOT NULL DEFAULT '0',
  `third_count` smallint(3) NOT NULL DEFAULT '0',
  `fourth_count` smallint(3) NOT NULL DEFAULT '0',
  `fifth_count` smallint(3) NOT NULL DEFAULT '0',
  `comment` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `update_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `skillCounter`
--

INSERT INTO `skillCounter` (`username`, `date`, `skillName`, `first_count`, `second_count`, `third_count`, `fourth_count`, `fifth_count`, `comment`, `update_date`) VALUES
('headspinnerd', '2017-02-18', 'AcKeep', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-18', 'AcToHllwbkToAc', 1, 5, 4, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-18', 'Ball Glide', 7, 1, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-18', 'Headspin Total', 2, 6, 7, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-18', 'Open Glide', 4, 8, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-18', 'Peace Glide', 2, 2, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-18', 'Rubiks Cube', 0, 2, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-21', 'AcKeep', 1, 1, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-21', 'AcToHllwbkToAc', 1, 4, 12, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-21', 'AcToJdToAc', 0, 0, 4, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-21', 'Ball Glide', 5, 4, 4, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-21', 'Headspin Total', 1, 10, 4, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-21', 'Onehand Tap', 2, 7, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-21', 'Open Glide', 3, 7, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-21', 'Peace Glide', 1, 2, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-21', 'Rubiks Cube', 0, 1, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-22', 'AcKeep', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-22', 'AcToHllwbkToAc', 1, 3, 7, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-22', 'AcToJdToAc', 0, 1, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-22', 'Ball Glide', 5, 2, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-22', 'Fast Glide', 6, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-22', 'Headspin Total', 2, 6, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-22', 'Long Drill', 1, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-22', 'Open Glide', 3, 3, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-22', 'Peace Glide', 2, 2, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-22', 'Rubiks Cube', 0, 3, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-24', 'AcKeep', 1, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-24', 'AcToHllwbkToAc', 2, 1, 17, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-24', 'AcToJdToAc', 5, 0, 6, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-24', 'Ball Glide', 7, 0, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-24', 'Fast Glide', 1, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-24', 'HandStand', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-24', 'Headspin Total', 3, 6, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-24', 'Long Drill', 0, 1, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-24', 'Onehand Tap', 8, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-24', 'Open Glide', 6, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-24', 'Peace Glide', 5, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-24', 'Rubiks Cube', 0, 4, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-25', 'AcKeep', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-25', 'AcToHllwbkToAc', 0, 6, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-25', 'AcToJdToAc', 0, 1, 6, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-25', 'Ball Glide', 9, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-25', 'Fast Glide', 1, 7, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-25', 'Headspin Total', 2, 4, 9, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-25', 'Long Drill', 0, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-25', 'Onehand Tap', 9, 4, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-25', 'Open Glide', 8, 5, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-25', 'Peace Glide', 5, 2, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-25', 'Rubiks Cube', 0, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-27', 'AcToHllwbkToAc', 2, 2, 9, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-27', 'AcToJdToAc', 0, 0, 9, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-27', 'Ball Glide', 3, 2, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-27', 'Fast Glide', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-27', 'HandStand', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-27', 'Headspin Total', 0, 8, 6, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-27', 'Long Drill', 0, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-27', 'Onehand Tap', 3, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-27', 'Open Glide', 1, 4, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-27', 'Peace Glide', 0, 1, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-27', 'Rubiks Cube', 0, 2, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-28', 'AcKeep', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-28', 'AcToHllwbkToAc', 3, 5, 7, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-28', 'AcToJdToAc', 0, 0, 9, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-28', 'Ball Glide', 5, 1, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-28', 'Fast Glide', 2, 5, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-28', 'Headspin Total', 4, 5, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-28', 'Long Drill', 1, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-28', 'Onehand Tap', 4, 3, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-28', 'Open Glide', 0, 3, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-28', 'Peace Glide', 4, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-02-28', 'Rubiks Cube', 1, 4, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-02', 'AcKeep', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-02', 'AcToHllwbkToAc', 1, 5, 6, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-02', 'Ball Glide', 7, 1, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-02', 'Fast Glide', 1, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-02', 'HandStand', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-02', 'Headspin Total', 4, 4, 4, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-02', 'Long Drill', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-02', 'Onehand Tap', 2, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-02', 'Open Glide', 2, 3, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-02', 'Peace Glide', 3, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-02', 'Rubiks Cube', 0, 7, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-04', 'AcKeep', 1, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-04', 'AcToHllwbkToAc', 1, 6, 9, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-04', 'Ball Glide', 5, 4, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-04', 'Fast Glide', 2, 4, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-04', 'Headspin Total', 1, 7, 5, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-04', 'Long Drill', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-04', 'Onehand Tap', 5, 3, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-04', 'Open Glide', 4, 4, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-04', 'Peace Glide', 4, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-04', 'Rubiks Cube', 0, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'Achop', 0, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'AcKeep', 1, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'AcToHllwbkToAc', 4, 0, 8, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'AcToJdToAc', 1, 7, 4, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'Ball Glide', 6, 4, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'Fast Glide', 1, 4, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'HandStand', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'Headspin Total', 0, 10, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'Long Drill', 0, 2, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'Onehand Tap', 2, 5, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'Open Glide', 2, 6, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'Peace Glide', 1, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-06', 'Rubiks Cube', 0, 1, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-08', 'Headspin Total', 0, 0, 0, 0, 0, 'skip for backache', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-09', 'AcKeep', 1, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-09', 'AcToHllwbkToAc', 1, 1, 6, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-09', 'AcToJdToAc', 0, 0, 4, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-09', 'Ball Glide', 7, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-09', 'Fast Glide', 2, 5, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-09', 'Headspin Total', 4, 5, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-09', 'Long Drill', 0, 3, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-09', 'Onehand Tap', 7, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-09', 'Only Onehand Tap', 0, 3, 4, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-09', 'Open Glide', 4, 3, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-09', 'Peace Glide', 5, 0, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-09', 'Rubiks Cube', 1, 3, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Ball Glide', 7, 1, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Chest Press', 0, 35, 0, 0, 0, '36kg', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Diverging Low Row', 0, 40, 0, 0, 0, '36kg', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Fast Glide', 2, 2, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Headspin Total', 2, 8, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Hllwbk Stretch', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Lat Pulldown', 0, 40, 0, 0, 0, '32kg', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Leg Extension', 0, 15, 0, 0, 0, '32kg', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Leg Press', 0, 40, 0, 0, 0, '109kg', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Onehand Tap', 2, 6, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Open Glide', 2, 6, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Peace Glide', 5, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Rubiks Cube', 0, 2, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Seated Calf Extension', 0, 37, 0, 0, 0, '45kg', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-11', 'Triceps Extension', 0, 20, 0, 0, 0, '32kg', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-13', 'AcKeep', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-13', 'AcToHllwbkToAc', 2, 2, 11, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-13', 'AcToJdToAc', 0, 2, 7, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-13', 'Ball Glide', 3, 4, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-13', 'Fast Glide', 1, 7, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-13', 'Headspin Total', 2, 6, 5, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-13', 'Long Drill', 0, 2, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-13', 'Onehand Tap', 4, 3, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-13', 'Open Glide', 2, 5, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-13', 'Peace Glide', 2, 1, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-13', 'Rubiks Cube', 0, 4, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'Achop', 0, 1, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'AcKeep', 1, 0, 0, 0, 0, '1 thread', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'AcToHllwbkToAc', 1, 2, 7, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'AcToJdToAc', 0, 6, 5, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'Ball Glide', 5, 5, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'Fast Glide', 0, 4, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'HandStand', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'Headspin Total', 1, 9, 3, 0, 0, '1 terrible count', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'Long Drill', 0, 2, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'Onehand Tap', 6, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'Open Glide', 4, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'Peace Glide', 1, 0, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-16', 'Rubiks Cube', 0, 2, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'AcKeep', 1, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'AcToHllwbkToAc', 0, 0, 11, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'AcToJdToAc', 0, 3, 7, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'Ball Glide', 4, 3, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'Fast Glide', 1, 5, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'Headspin Total', 2, 7, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'Hllwbk Stretch', 0, 1, 0, 0, 0, '30sec', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'Long Drill', 0, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'Onehand Tap', 5, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'Only Onehand Tap', 0, 2, 7, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'Open Glide', 4, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'Peace Glide', 1, 2, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-19', 'Rubiks Cube', 1, 2, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-20', 'Hllwbk Stretch', 0, 1, 0, 0, 0, '30sec', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-21', 'Ball Glide', 7, 2, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-21', 'Fast Glide', 2, 7, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-21', 'Headspin Total', 0, 12, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-21', 'Hllwbk Stretch', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-21', 'Long Drill', 0, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-21', 'Onehand Tap', 8, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-21', 'Open Glide', 7, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-21', 'Peace Glide', 3, 1, 4, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-21', 'Rubiks Cube', 0, 1, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'AcKeep', 1, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'AcToHllwbkToAc', 0, 1, 6, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'Ball Glide', 4, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'Fast Glide', 0, 4, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'Headspin Total', 1, 8, 8, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'Hllwbk Stretch', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'Long Drill', 0, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'Onehand Tap', 3, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'Open Glide', 2, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'Peace Glide', 2, 1, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'Radar Stretch', 0, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'Rubiks Cube', 0, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'Triceps Extension', 0, 30, 0, 0, 0, '23kg', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-23', 'Zen', 0, 1, 7, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-24', 'Airchair Stretch', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-24', 'Hllwbk Stretch', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-24', 'Radar Stretch', 0, 2, 0, 0, 0, '30sec for back and 30sec for thigh', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-24', 'Tricep-pushup', 0, 60, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-25', 'Airchair Stretch', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-25', 'Hllwbk Stretch', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-25', 'Radar Stretch', 0, 2, 0, 0, 0, '30sec for back and 30sec for thigh', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-25', 'Tricep-pushup', 0, 60, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-26', 'AcKeep', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-26', 'AcToHllwbkToAc', 0, 2, 6, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-26', 'AcToJdToAc', 0, 3, 7, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-26', 'Ball Glide', 5, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-26', 'Fast Glide', 2, 4, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-26', 'Headspin Total', 1, 8, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-26', 'Long Drill', 0, 1, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-26', 'Onehand Tap', 3, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-26', 'Open Glide', 3, 4, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-26', 'Peace Glide', 2, 1, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-26', 'Rubiks Cube', 0, 3, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-26', 'Zen', 0, 0, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-28', 'AcKeep', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-28', 'AcToHllwbkToAc', 1, 3, 10, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-28', 'AcToJdToAc', 0, 2, 5, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-28', 'Ball Glide', 2, 1, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-28', 'Fast Glide', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-28', 'Headspin Total', 0, 4, 6, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-28', 'Onehand Tap', 4, 2, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-28', 'Open Glide', 2, 3, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-28', 'Peace Glide', 0, 0, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-31', 'AcKeep', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-31', 'AcToHllwbkToAc', 0, 3, 9, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-31', 'AcToJdToAc', 0, 1, 9, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-31', 'Ball Glide', 4, 4, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-31', 'Fast Glide', 0, 2, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-31', 'HandStand', 0, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-31', 'Headspin Total', 0, 6, 9, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-31', 'Long Drill', 0, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-31', 'Onehand Tap', 4, 7, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-31', 'Open Glide', 5, 5, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-31', 'Peace Glide', 1, 1, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-03-31', 'Rubiks Cube', 0, 2, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-04', 'AcKeep', 4, 4, 1, 0, 0, 'Succeeded Zen while keeping', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-04', 'AcToHllwbkToAc', 1, 3, 7, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-04', 'AcToJdToAc', 0, 1, 6, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-04', 'Ball Glide', 4, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-04', 'Fast Glide', 0, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-04', 'HandStand', 1, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-04', 'Headspin Total', 2, 5, 4, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-04', 'Long Drill', 1, 2, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-04', 'Open Glide', 5, 2, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-04', 'Peace Glide', 2, 0, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-04', 'Rubiks Cube', 0, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-04', 'Zen', 0, 0, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'AcKeep', 2, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'AcToHllwbkToAc', 0, 0, 7, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'AcToJdToAc', 0, 1, 5, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'Ball Glide', 2, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'Diverging Low Row', 30, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'Fast Glide', 1, 5, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'Headspin Total', 2, 9, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'Long Drill', 0, 0, 2, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'Onehand Tap', 9, 2, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'Open Glide', 8, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'Peace Glide', 2, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'Rubiks Cube', 1, 1, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'Triceps Extension', 40, 0, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-06', 'Zen', 0, 3, 8, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-08', 'AcKeep', 2, 1, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-08', 'AcToHllwbkToAc', 1, 2, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-08', 'Ball Glide', 2, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-08', 'Fast Glide', 0, 4, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-08', 'Headspin Total', 2, 8, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-08', 'Long Drill', 0, 3, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-08', 'Onehand Tap', 5, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-08', 'Open Glide', 3, 5, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-08', 'Peace Glide', 2, 0, 1, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-08', 'Rubiks Cube', 0, 3, 0, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-08', 'Zen', 0, 1, 3, 0, 0, '', '2017-04-11 00:00:00'),
('headspinnerd', '2017-04-11', 'AcKeep', 1, 0, 0, 0, 0, '', '2017-04-11 17:09:51'),
('headspinnerd', '2017-04-11', 'AcToHllwbkToAc', 0, 2, 5, 0, 0, '', '2017-04-11 17:09:51'),
('headspinnerd', '2017-04-11', 'Ball Glide', 3, 2, 3, 0, 0, '', '2017-04-11 17:09:51'),
('headspinnerd', '2017-04-11', 'Fast Glide', 0, 2, 1, 0, 0, '', '2017-04-11 17:09:51'),
('headspinnerd', '2017-04-11', 'Headspin Total', 0, 7, 3, 0, 0, '', '2017-04-11 17:09:51'),
('headspinnerd', '2017-04-11', 'Long Drill', 0, 0, 1, 0, 0, '', '2017-04-11 17:09:51'),
('headspinnerd', '2017-04-11', 'Onehand Tap', 4, 3, 0, 0, 0, '', '2017-04-11 17:09:51'),
('headspinnerd', '2017-04-11', 'Open Glide', 4, 3, 0, 0, 0, '', '2017-04-11 17:09:51'),
('headspinnerd', '2017-04-11', 'Peace Glide', 1, 0, 1, 0, 0, '', '2017-04-11 17:09:51'),
('headspinnerd', '2017-04-11', 'Rubiks Cube', 0, 1, 2, 0, 0, '', '2017-04-11 17:09:51'),
('headspinnerd', '2017-04-11', 'Zen', 0, 0, 1, 0, 0, '', '2017-04-11 17:09:51'),
('headspinnerd', '2017-04-15', 'AcKeep', 3, 2, 0, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-15', 'AcToHllwbkToAc', 0, 3, 7, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-15', 'AcToJdToAc', 0, 1, 11, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-15', 'Ball Glide', 6, 0, 0, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-15', 'Fast Glide', 1, 7, 0, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-15', 'HandStand', 0, 1, 1, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-15', 'Headspin Total', 2, 10, 3, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-15', 'Long Drill', 1, 2, 0, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-15', 'Onehand Tap', 10, 4, 0, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-15', 'Open Glide', 9, 3, 2, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-15', 'Peace Glide', 1, 1, 3, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-15', 'Rubiks Cube', 0, 2, 0, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-15', 'Zen', 0, 0, 5, 0, 0, '', '2017-04-15 23:44:06'),
('headspinnerd', '2017-04-16', 'Fast Glide', 4, 2, 0, 0, 0, '', '2017-04-17 11:25:25'),
('headspinnerd', '2017-04-17', 'AcKeep', 2, 0, 0, 0, 0, '', '2017-04-17 16:40:23'),
('headspinnerd', '2017-04-17', 'AcToHllwbkToAc', 2, 1, 7, 0, 0, '', '2017-04-17 16:40:23'),
('headspinnerd', '2017-04-17', 'AcToJdToAc', 0, 0, 6, 0, 0, '', '2017-04-17 16:40:23'),
('headspinnerd', '2017-04-17', 'Ball Glide', 4, 2, 1, 0, 0, '', '2017-04-17 16:40:22'),
('headspinnerd', '2017-04-17', 'Fast Glide', 1, 3, 0, 0, 0, '', '2017-04-17 16:40:22'),
('headspinnerd', '2017-04-17', 'Headspin Total', 2, 9, 1, 0, 0, '', '2017-04-17 16:40:22'),
('headspinnerd', '2017-04-17', 'Long Drill', 0, 2, 0, 0, 0, '', '2017-04-17 16:40:23'),
('headspinnerd', '2017-04-17', 'Onehand Tap', 8, 3, 0, 0, 0, '', '2017-04-17 16:40:22'),
('headspinnerd', '2017-04-17', 'Open Glide', 8, 2, 0, 0, 0, '', '2017-04-17 16:40:22'),
('headspinnerd', '2017-04-17', 'Peace Glide', 2, 0, 1, 0, 0, '', '2017-04-17 16:40:22'),
('headspinnerd', '2017-04-17', 'Rubiks Cube', 0, 2, 3, 0, 0, '', '2017-04-17 16:40:22'),
('headspinnerd', '2017-04-17', 'Triceps Extension', 35, 0, 0, 0, 0, '', '2017-04-17 16:40:23'),
('headspinnerd', '2017-04-17', 'Zen', 0, 1, 3, 0, 0, '', '2017-04-17 16:40:23'),
('headspinnerd', '2017-04-20', 'AcKeep', 1, 1, 0, 0, 0, '', '2017-04-22 00:40:04'),
('headspinnerd', '2017-04-20', 'Ball Glide', 4, 0, 0, 0, 0, '', '2017-04-22 00:40:04'),
('headspinnerd', '2017-04-20', 'Chest Press', 27, 0, 0, 0, 0, '', '2017-04-22 00:40:04'),
('headspinnerd', '2017-04-20', 'Headspin Total', 0, 9, 1, 0, 0, '', '2017-04-22 09:49:45'),
('headspinnerd', '2017-04-20', 'Leg Press', 35, 0, 0, 0, 0, '', '2017-04-22 00:40:04'),
('headspinnerd', '2017-04-20', 'Long Drill', 0, 2, 0, 0, 0, '', '2017-04-22 00:40:04'),
('headspinnerd', '2017-04-20', 'Onehand Tap', 0, 7, 1, 0, 0, '', '2017-04-22 00:40:04'),
('headspinnerd', '2017-04-20', 'Open Glide', 5, 4, 0, 0, 0, '', '2017-04-22 00:40:04'),
('headspinnerd', '2017-04-20', 'Peace Glide', 1, 0, 1, 0, 0, '', '2017-04-22 00:40:04'),
('headspinnerd', '2017-04-20', 'Rubiks Cube', 0, 0, 2, 0, 0, '', '2017-04-22 00:40:04'),
('headspinnerd', '2017-04-20', 'Triceps Extension', 25, 0, 0, 0, 0, '', '2017-04-22 00:40:04'),
('headspinnerd', '2017-04-20', 'Zen', 0, 2, 2, 0, 0, '', '2017-04-22 00:40:04'),
('headspinnerd', '2017-04-21', 'Fast Glide', 4, 3, 2, 0, 0, '', '2017-04-23 10:21:53'),
('headspinnerd', '2017-04-21', 'Headspin Total', 1, 3, 0, 0, 0, '', '2017-04-23 10:21:53'),
('headspinnerd', '2017-04-22', 'AcKeep', 1, 0, 0, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-22', 'AcToHllwbkToAc', 1, 0, 5, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-22', 'AcToJdToAc', 0, 2, 8, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-22', 'Ball Glide', 2, 1, 3, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-22', 'Fast Glide', 0, 5, 0, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-22', 'Headspin Total', 0, 8, 2, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-22', 'Long Drill', 0, 1, 1, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-22', 'Onehand Tap', 6, 1, 0, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-22', 'Open Glide', 4, 3, 0, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-22', 'Peace Glide', 0, 0, 2, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-22', 'Rubiks Cube', 0, 1, 2, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-22', 'Zen', 0, 0, 1, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-23', 'Hllwbk Stretch', 1, 0, 0, 0, 0, '', '2017-04-24 18:22:40'),
('headspinnerd', '2017-04-24', 'AcKeep', 2, 1, 0, 0, 0, '', '2017-04-24 19:59:15'),
('headspinnerd', '2017-04-24', 'AcToHllwbkToAc', 1, 4, 5, 0, 0, '', '2017-04-24 19:59:15'),
('headspinnerd', '2017-04-24', 'AcToJdToAc', 0, 3, 8, 0, 0, '', '2017-04-24 19:59:15'),
('headspinnerd', '2017-04-24', 'Ball Glide', 4, 2, 2, 0, 0, '', '2017-04-24 19:59:15'),
('headspinnerd', '2017-04-24', 'Fast Glide', 0, 3, 0, 0, 0, '', '2017-04-24 19:59:15'),
('headspinnerd', '2017-04-24', 'Headspin Total', 1, 7, 2, 0, 0, '', '2017-04-24 19:59:15'),
('headspinnerd', '2017-04-24', 'Long Drill', 0, 3, 1, 0, 0, '', '2017-04-24 19:59:15'),
('headspinnerd', '2017-04-24', 'Onehand Tap', 5, 3, 0, 0, 0, '', '2017-04-24 19:59:15'),
('headspinnerd', '2017-04-24', 'Open Glide', 3, 5, 0, 0, 0, '', '2017-04-24 19:59:15'),
('headspinnerd', '2017-04-24', 'Peace Glide', 0, 2, 1, 0, 0, '', '2017-04-24 19:59:15'),
('headspinnerd', '2017-04-24', 'Rubiks Cube', 0, 1, 4, 0, 0, '', '2017-04-24 19:59:15'),
('headspinnerd', '2017-04-24', 'Zen', 0, 0, 1, 0, 0, '', '2017-04-24 22:25:47');

-- --------------------------------------------------------

--
-- Table structure for table `userInfo`
--

CREATE TABLE `userInfo` (
  `username` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `password` text COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `registerDate` date NOT NULL,
  `lastLoginDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `userInfo`
--

INSERT INTO `userInfo` (`username`, `password`, `email`, `name`, `registerDate`, `lastLoginDate`) VALUES
('headspinnerd', '438797', 'kouairchair@gmail.com', 'Koki Tanaka', '0000-00-00', '2017-04-27'),
('test3', 'safdasdfasdfa', 'headspinnerd@gmail.com', '', '0000-00-00', '2017-04-26');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `button`
--
ALTER TABLE `button`
  ADD PRIMARY KEY (`username`,`skillname`);

--
-- Indexes for table `practiceTime`
--
ALTER TABLE `practiceTime`
  ADD PRIMARY KEY (`startTime`);

--
-- Indexes for table `serverInfo`
--
ALTER TABLE `serverInfo`
  ADD PRIMARY KEY (`info1`,`info2`,`info3`,`info4`);

--
-- Indexes for table `skillCounter`
--
ALTER TABLE `skillCounter`
  ADD PRIMARY KEY (`username`,`date`,`skillName`);

--
-- Indexes for table `userInfo`
--
ALTER TABLE `userInfo`
  ADD PRIMARY KEY (`username`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
