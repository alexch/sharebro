
-- phpMyAdmin SQL Dump
-- version OVH
-- http://www.phpmyadmin.net
--
-- Client: mysql5-6.90
-- Généré le : Sam 05 Novembre 2011 à 23:38
-- Version du serveur: 5.0.90
-- Version de PHP: 5.3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Base de données: `lipsumar_multi`
--

-- --------------------------------------------------------

--
-- Structure de la table `greader_items`
--

CREATE TABLE IF NOT EXISTS `greader_items` (
  `uid` int(11) NOT NULL auto_increment,
  `user_id` varchar(50) NOT NULL,
  `url` text NOT NULL,
  `title` text NOT NULL,
  `body` text NOT NULL,
  `tstamp` int(11) NOT NULL,
  PRIMARY KEY  (`uid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=365 ;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `greader_stats_item_count`
--
CREATE TABLE IF NOT EXISTS `greader_stats_item_count` (
`email` text
,`item_count` bigint(21)
);
-- --------------------------------------------------------

--
-- Structure de la table `greader_user2friend`
--

CREATE TABLE IF NOT EXISTS `greader_user2friend` (
  `user_id` varchar(50) NOT NULL,
  `friend_id` varchar(50) NOT NULL,
  `tstamp` int(11) NOT NULL,
  PRIMARY KEY  (`user_id`,`friend_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `greader_users`
--

CREATE TABLE IF NOT EXISTS `greader_users` (
  `uid` varchar(50) NOT NULL,
  `email` text NOT NULL,
  `tstamp` int(11) NOT NULL,
  `secret` text NOT NULL,
  PRIMARY KEY  (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la vue `greader_stats_item_count`
--
DROP TABLE IF EXISTS `greader_stats_item_count`;

CREATE ALGORITHM=UNDEFINED DEFINER=`lipsumar_multi`@`%` SQL SECURITY DEFINER VIEW `greader_stats_item_count` AS select `u`.`email` AS `email`,(select count(0) AS `count(*)` from `greader_items` where (`greader_items`.`user_id` = `u`.`uid`)) AS `item_count` from `greader_users` `u` order by (select count(0) AS `count(*)` from `greader_items` where (`greader_items`.`user_id` = `u`.`uid`)) desc;
