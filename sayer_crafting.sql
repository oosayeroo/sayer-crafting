CREATE TABLE IF NOT EXISTS `sayer_crafting` (
  `citizenid` varchar(50) DEFAULT NULL,
  `levels` text DEFAULT NULL,
  PRIMARY KEY (`citizenid`),
  KEY `levels` (`levels`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
