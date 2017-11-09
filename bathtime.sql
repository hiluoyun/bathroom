-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: 2017-11-09 04:32:11
-- 服务器版本： 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `bathtime`
--

-- --------------------------------------------------------

--
-- 表的结构 `bath_cell`
--

CREATE TABLE IF NOT EXISTS `bath_cell` (
  `house_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `cell_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL,
  `sex` int(11) NOT NULL,
  PRIMARY KEY (`cell_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=59 ;

--
-- 转存表中的数据 `bath_cell`
--

INSERT INTO `bath_cell` (`house_id`, `room_id`, `cell_id`, `user_id`, `status`, `sex`) VALUES
(1, 1, 1, 0, 1, 1),
(1, 1, 2, 0, 1, 1),
(1, 1, 3, 0, 1, 1),
(1, 1, 4, 0, 1, 1),
(1, 1, 5, 0, 1, 1),
(1, 1, 6, 0, 1, 1),
(1, 1, 7, 0, 1, 1),
(1, 1, 8, 0, 1, 1),
(1, 2, 9, 0, 1, 1),
(1, 2, 10, 0, 1, 1),
(1, 2, 11, 0, 1, 1),
(1, 2, 12, 0, 1, 1),
(1, 2, 13, 0, 1, 1),
(1, 2, 14, 0, 1, 1),
(1, 2, 15, 0, 1, 1),
(1, 2, 16, 0, 1, 1),
(1, 2, 17, 0, 1, 1),
(1, 3, 18, 0, 1, 1),
(1, 3, 19, 0, 1, 1),
(1, 3, 20, 0, 1, 1),
(1, 4, 21, 0, 1, 0),
(1, 4, 22, 0, 1, 0),
(1, 4, 23, 0, 1, 0),
(1, 4, 24, 0, 1, 0),
(1, 5, 25, 0, 1, 0),
(1, 5, 26, 0, 1, 0),
(1, 5, 27, 0, 0, 0),
(1, 5, 28, 0, 0, 0),
(1, 5, 29, 0, 1, 0),
(1, 5, 30, 0, 1, 0),
(1, 5, 31, 0, 0, 0),
(1, 5, 32, 0, 1, 0),
(1, 5, 33, 0, 1, 0),
(1, 5, 34, 0, 1, 0),
(1, 6, 35, 0, 1, 0),
(1, 6, 36, 0, 1, 0),
(1, 6, 37, 0, 1, 0),
(2, 7, 38, 0, 1, 1),
(2, 7, 39, 0, 1, 1),
(2, 7, 40, 0, 1, 1),
(2, 7, 41, 0, 1, 1),
(2, 7, 42, 0, 1, 1),
(2, 7, 43, 0, 1, 1),
(2, 8, 44, 0, 1, 1),
(2, 8, 45, 0, 1, 1),
(2, 8, 46, 0, 1, 1),
(2, 9, 47, 0, 1, 0),
(2, 9, 48, 0, 1, 0),
(2, 9, 49, 0, 1, 0),
(2, 9, 50, 0, 1, 0),
(2, 9, 51, 0, 1, 0),
(2, 9, 52, 0, 1, 0),
(2, 9, 53, 0, 1, 0),
(2, 9, 54, 0, 1, 0),
(2, 10, 55, 0, 1, 0),
(2, 10, 56, 0, 1, 0),
(2, 10, 57, 0, 1, 0),
(2, 10, 58, 0, 1, 0);

-- --------------------------------------------------------

--
-- 表的结构 `bath_floor`
--

CREATE TABLE IF NOT EXISTS `bath_floor` (
  `house_id` int(11) NOT NULL,
  `floor_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `sex` tinyint(1) NOT NULL,
  PRIMARY KEY (`floor_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- 转存表中的数据 `bath_floor`
--

INSERT INTO `bath_floor` (`house_id`, `floor_id`, `name`, `sex`) VALUES
(1, 1, '一层', 1),
(1, 2, '二层', 0),
(2, 3, '一层', 1),
(2, 4, '二层', 0);

-- --------------------------------------------------------

--
-- 表的结构 `bath_house`
--

CREATE TABLE IF NOT EXISTS `bath_house` (
  `local_id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  PRIMARY KEY (`house_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- 转存表中的数据 `bath_house`
--

INSERT INTO `bath_house` (`local_id`, `house_id`, `name`, `start_time`, `end_time`) VALUES
(1, 1, '西园一浴室', '01:00:00', '23:59:00'),
(1, 2, '东园二浴室', '12:00:00', '23:00:00');

-- --------------------------------------------------------

--
-- 表的结构 `bath_location`
--

CREATE TABLE IF NOT EXISTS `bath_location` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- 转存表中的数据 `bath_location`
--

INSERT INTO `bath_location` (`id`, `name`) VALUES
(1, '四川大学'),
(2, '西里特西');

-- --------------------------------------------------------

--
-- 表的结构 `bath_room`
--

CREATE TABLE IF NOT EXISTS `bath_room` (
  `floor_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL AUTO_INCREMENT,
  `number` int(11) NOT NULL,
  `sex` int(11) DEFAULT NULL,
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

--
-- 转存表中的数据 `bath_room`
--

INSERT INTO `bath_room` (`floor_id`, `room_id`, `number`, `sex`) VALUES
(1, 1, 8, 1),
(1, 2, 9, 1),
(1, 3, 3, 1),
(2, 4, 6, 0),
(2, 5, 10, 0),
(2, 6, 3, 0),
(3, 7, 6, 1),
(3, 8, 3, 1),
(4, 9, 8, 0),
(4, 10, 4, 0);

-- --------------------------------------------------------

--
-- 表的结构 `date_queue`
--

CREATE TABLE IF NOT EXISTS `date_queue` (
  `name` varchar(30) NOT NULL,
  `time` time NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `date_queue`
--

INSERT INTO `date_queue` (`name`, `time`) VALUES
('haha2', '10:56:00'),
('haha3', '00:00:16'),
('haha34', '00:00:16');

-- --------------------------------------------------------

--
-- 表的结构 `info_details`
--

CREATE TABLE IF NOT EXISTS `info_details` (
  `id` int(11) NOT NULL,
  `details` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `info_details`
--

INSERT INTO `info_details` (`id`, `details`) VALUES
(1, '各位用户好！\n    掌上澡堂自开通以来，感谢大家的支持。大家能够快速地熟悉并掌握掌上澡堂的使用方法，享受掌上澡堂带来的便利。不过在运行过程中，部分用户忘记及时结束洗澡，而系统仍在计费。为了保障用户的利益，我们对软件进行升级改造，超过系统默认时间的时候，系统将自动结束。大家可以尽快前往应用商店升级。\n    若您有任何意见或者建议，请直接拨打掌上澡堂的管理员热线：18380205203，您也可以在手机APP中【意见反馈】模块提交您的意见。\n                                【掌上澡堂】'),
(2, '各位用户您好！\n     东园一浴室由于升级改造原因，暂时无法使用，请大家合理安排自己的沐浴时间。大家可以选择其他浴室替代，详情请看下面：\n   \n     东园一浴室 二层 【9室】、【10室】升级改造\n\n     给您带来不便敬请谅解！\n     若您有任何意见或者建议，请直接拨打掌上澡堂的管理员热线：18380205203，您也可以在手机APP中【意见反馈】模块提交您的意见。\n                                                                         【掌上澡堂】\n');

-- --------------------------------------------------------

--
-- 表的结构 `info_outline`
--

CREATE TABLE IF NOT EXISTS `info_outline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `time` datetime NOT NULL,
  `sketch` varchar(100) DEFAULT NULL,
  `priority` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `time` (`time`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- 转存表中的数据 `info_outline`
--

INSERT INTO `info_outline` (`id`, `name`, `time`, `sketch`, `priority`) VALUES
(1, '掌上澡堂系统升级', '2017-04-12 10:06:12', '增加系统自动停止功能', NULL),
(2, '东园一浴室维修通知', '2017-04-13 16:28:22', '浴室正在维修暂时无法使用，请选择其他浴室', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `personal_profile`
--

CREATE TABLE IF NOT EXISTS `personal_profile` (
  `user_id` int(11) NOT NULL,
  `max_time` double DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `portrait` varchar(30) DEFAULT NULL,
  `local_id` int(11) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0:normal 1:waiting -1:busy',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `personal_profile`
--

INSERT INTO `personal_profile` (`user_id`, `max_time`, `cost`, `portrait`, `local_id`, `phone`, `status`) VALUES
(0, NULL, NULL, NULL, 2, NULL, 0),
(1, 2, 100.8, '\\bathResource\\profile.jpg', 1, '18820768025', 0),
(25, NULL, NULL, '$portrait', 2, NULL, 0),
(27, NULL, NULL, NULL, 2, NULL, 0),
(28, NULL, NULL, NULL, 2, NULL, 0),
(29, NULL, NULL, NULL, 2, NULL, 0),
(37, NULL, NULL, '/bathResource/profile.jpg', 1, NULL, 0);

-- --------------------------------------------------------

--
-- 表的结构 `system`
--

CREATE TABLE IF NOT EXISTS `system` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `help` text NOT NULL,
  `aboutUs` text NOT NULL,
  `download` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `system`
--

INSERT INTO `system` (`id`, `help`, `aboutUs`, `download`) VALUES
(1, '如何正确使用该软件？\n1、下载软件，使用邮箱进行注册，认证成功后，即完成注册。\n2、登录界面，选择用户的澡堂位置、楼层、浴室等相关信息后，进入预约、排队界面。\n3、用户选择空位后即可进行预约，用户需在八分钟内赶到预约地点，超过规定时间后自动取消。\n4、当浴室显示满员时，软件可进行排队，界面会显示现排队人数和预计排队时间，当出现空位后，系统会通知并自动预约。\n5、用户结束使用后，用户点击“结束”按钮，可在手机上终止服务，除此之外，在超出系统的默认时间后，系统将自动终止服务。\n', '四川大学计算机学院\n\n指导老师：陈延涛\n\n作者：罗辉', '/bathResource/download.jpg');

-- --------------------------------------------------------

--
-- 表的结构 `system_feedback`
--

CREATE TABLE IF NOT EXISTS `system_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `content` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- 转存表中的数据 `system_feedback`
--

INSERT INTO `system_feedback` (`id`, `name`, `content`) VALUES
(1, 'haha', 'fuckuou'),
(2, 'haha', 'yingaikeyiba'),
(3, 'haha', 'fdfsdfsdgsd');

-- --------------------------------------------------------

--
-- 表的结构 `system_hint`
--

CREATE TABLE IF NOT EXISTS `system_hint` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `system_hint`
--

INSERT INTO `system_hint` (`id`, `text`, `status`) VALUES
(1, '预约后，请及时赶到浴室\r\n若无可用浴室位置，请进行自动排队', 1);

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `sex` tinyint(1) NOT NULL DEFAULT '1',
  `status` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=38 ;

--
-- 转存表中的数据 `user`
--

INSERT INTO `user` (`id`, `name`, `password`, `sex`, `status`) VALUES
(1, 'luohui', '123', 1, 0),
(2, 'xiaoyiyu', '1234', 0, 0),
(12, 'xuzixun', '1234', 0, 0),
(13, 'test', '123', 0, 0),
(15, 'test2', '123', 0, 0),
(16, 'test3', '123', 0, 0),
(17, 'test5', '123', 0, 0),
(18, 'hiluo', '123', 0, 0),
(19, 'test99', '123', 0, 0),
(20, 'worini', '123', 0, 0),
(21, 'kkkkkkk', '123', 0, 0),
(25, 'kkkkkkk2', '123', 0, 0),
(27, 'xuzixin', '321', 0, 0),
(28, 'xuzixin2', '321', 0, 0),
(29, 'zhuoxiong', '123', 0, 0),
(37, 'haha', '123', 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `wait_queue`
--

CREATE TABLE IF NOT EXISTS `wait_queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `cell_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=39 ;

--
-- 转存表中的数据 `wait_queue`
--

INSERT INTO `wait_queue` (`id`, `user_id`, `status`, `cell_id`) VALUES
(1, 34, 1, 3),
(2, 23, 1, 3),
(38, 37, 1, 6);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
