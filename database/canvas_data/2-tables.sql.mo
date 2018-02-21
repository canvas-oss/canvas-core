-- ----------------------------------------------------------------------------
-- Copyright Remy BOISSEZON, Valentin PRODHOMME, Dylan TROLES, Alexandre ZANNI
-- 2017-10-27
--
-- boissezon.remy@gmail.com
-- valentin@prodhomme.me
-- chill3d@protonmail.com
-- alexandre.zanni@engineer.com
--
-- This software is governed by the CeCILL license under French law and
-- abiding by the rules of distribution of free software.  You can  use,
-- modify and/ or redistribute the software under the terms of the CeCILL
-- license as circulated by CEA, CNRS and INRIA at the following URL
-- "http://www.cecill.info".
--
-- The fact that you are presently reading this means that you have had
-- knowledge of the CeCILL license and that you accept its terms.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- Tables
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- WFN related tables
-- ----------------------------------------------------------------------------
-- Table `{{DATA_DB_NAME}}`.`t_wfn_item`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_wfn_item` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `digest` BINARY(20) NOT NULL,
  `part` ENUM('a','o','h') NOT NULL,
  `vendor` TINYTEXT NOT NULL,
  `product` TINYTEXT NOT NULL,
  `version` TINYTEXT NOT NULL,
  `update` TINYTEXT NOT NULL,
  `edition` TINYTEXT NOT NULL,
  `sw_edition` TINYTEXT NOT NULL,
  `target_sw` TINYTEXT NOT NULL,
  `target_hw` TINYTEXT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_digest` (`digest`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------------------------------------------------------
-- CPE `t_cpe_` related tables
-- ----------------------------------------------------------------------------
-- Table `{{DATA_DB_NAME}}`.`t_cpe_generator`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cpe_generator` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `process_start_date` DATETIME NOT NULL,
  `process_end_date` DATETIME DEFAULT NULL,
  `cpe_data_timestamp` DATETIME NOT NULL,
  `cpe_schema_version` TINYTEXT NOT NULL,
  `cpe_product_name` TINYTEXT NULL,
  `cpe_product_version` TINYTEXT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cpe_item`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cpe_item` (
  `wfn` INT UNSIGNED NOT NULL,
  `deprecated` BOOLEAN NOT NULL,
  `deprecation_date` DATETIME NULL,
  `generator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`wfn`),
  INDEX `fk_cpe_has_wfn` (`wfn` ASC),
  CONSTRAINT `fk_cpe_has_wfn`
    FOREIGN KEY (`wfn`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_wfn_item` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  INDEX `fk_cpe_has_generator` (`generator` ASC),
  CONSTRAINT `fk_cpe_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cpe_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cpe_item_title`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cpe_item_title` (
  `cpe` INT UNSIGNED NOT NULL,
  `digest` BINARY(20) NOT NULL,
  `lang` NCHAR(5) NOT NULL,
  `value` MEDIUMTEXT NOT NULL,
  `generator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`cpe`, `digest`),
  INDEX `fk_cpe_title_has_cpe` (`cpe` ASC),
  CONSTRAINT `fk_cpe_title_has_cpe`
    FOREIGN KEY (`cpe`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cpe_item` (`wfn`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  INDEX `fk_cpe_title_has_generator` (`generator` ASC),
  CONSTRAINT `fk_cpe_title_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cpe_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cpe_item_reference`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cpe_item_reference` (
  `cpe` INT UNSIGNED NOT NULL,
  `digest` BINARY(20) NOT NULL,
  `href` VARCHAR(2083) NOT NULL,
  `value` MEDIUMTEXT NOT NULL,
  `generator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`cpe`, `digest`),
  INDEX `fk_cpe_reference_has_cpe` (`cpe` ASC),
  CONSTRAINT `fk_cpe_reference_has_cpe`
    FOREIGN KEY (`cpe`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cpe_item` (`wfn`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  INDEX `fk_cpe_reference_has_generator` (`generator` ASC),
  CONSTRAINT `fk_cpe_reference_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cpe_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cpe_item_deprecated_by`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cpe_item_deprecated_by` (
  `cpe` INT UNSIGNED NOT NULL,
  `digest` BINARY(20) NOT NULL,
  `wfn` INT UNSIGNED NOT NULL,
  `date` DATETIME NOT NULL,
  `type` TINYTEXT NOT NULL,
  `generator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`cpe`, `digest`),
  INDEX `fk_cpe_deprecated_by_has_cpe` (`cpe` ASC),
  CONSTRAINT `fk_cpe_deprecated_by_has_cpe`
    FOREIGN KEY (`cpe`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cpe_item` (`wfn`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  INDEX `fk_cpe_deprecated_by_has_wfn` (`wfn` ASC),
  CONSTRAINT `fk_cpe_deprecated_by_has_wfn`
    FOREIGN KEY (`wfn`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_wfn_item` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  INDEX `fk_cpe_deprecated_by_has_generator` (`generator` ASC),
  CONSTRAINT `fk_cpe_deprecated_by_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cpe_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------------------------------------------------------
-- CVE `t_cve_` related tables
-- ----------------------------------------------------------------------------
-- Table `{{DATA_DB_NAME}}`.`t_cve_generator`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cve_generator` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `process_start_date` DATETIME NOT NULL,
  `process_end_date` DATETIME DEFAULT NULL,
  `cve_data_timestamp` DATETIME NOT NULL,
  `cve_data_type` VARCHAR(16) NULL,
  `cve_data_format` VARCHAR(16) NULL,
  `cve_data_version` VARCHAR(16) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cve_item`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cve_item` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `year` NCHAR(4) NOT NULL,
  `digits` VARCHAR(32) NOT NULL,
  `published_date` DATETIME NOT NULL,
  `modified_date` DATETIME NULL,
  `generator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_cve_id` (`year`,`digits`),
  INDEX `fk_cve_has_generator` (`generator` ASC),
  CONSTRAINT `fk_cve_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cve_item_description`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cve_item_description` (
  `cve` INT UNSIGNED NOT NULL,
  `digest` BINARY(20) NOT NULL,
  `lang` NCHAR(5) NOT NULL,
  `value` MEDIUMTEXT NOT NULL,
  `generator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`cve`,`digest`),
  INDEX `fk_cve_description_has_cve` (`cve` ASC),
  CONSTRAINT `fk_cve_description_has_cve`
    FOREIGN KEY (`cve`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  INDEX `fk_cve_description_has_generator` (`generator` ASC),
  CONSTRAINT `fk_description_cve_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cve_item_reference`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cve_item_reference` (
  `cve` INT UNSIGNED NOT NULL,
  `digest` BINARY(20) NOT NULL,
  `url` VARCHAR(2083) NOT NULL,
  `generator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`cve`,`digest`),
  INDEX `fk_cve_reference_has_cve` (`cve` ASC),
  CONSTRAINT `fk_cve_reference_has_cve`
    FOREIGN KEY (`cve`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  INDEX `fk_cve_reference_has_generator` (`generator` ASC),
  CONSTRAINT `fk_cve_reference_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cve_item_affect`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cve_item_affect` (
  `cve` INT UNSIGNED NOT NULL,
  `digest` BINARY(20) NOT NULL,
  `vendor` TINYTEXT NOT NULL,
  `product` TINYTEXT NOT NULL,
  `version` TINYTEXT NOT NULL,
  `generator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`cve`,`digest`),
  INDEX `fk_cve_affect_has_cve` (`cve` ASC),
  CONSTRAINT `fk_cve_affect_has_cve`
    FOREIGN KEY (`cve`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  INDEX `fk_cve_affect_has_generator` (`generator` ASC),
  CONSTRAINT `fk_cve_affect_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cve_item_configuration`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cve_item_configuration` (
  `cve` INT UNSIGNED NOT NULL,
  `id` INT UNSIGNED NOT NULL,
  `generator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`cve`,`id`),
  CONSTRAINT `fk_cve_configuration_has_cve`
    FOREIGN KEY (`cve`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  INDEX `fk_cve_configuration_has_generator` (`generator` ASC),
  CONSTRAINT `fk_cve_configuration_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cve_item_configuration_disjunct`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cve_item_configuration_disjunct` (
  `cve` INT UNSIGNED NOT NULL,
  `configuration` INT UNSIGNED NOT NULL,
  `id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`cve`,`configuration`,`id`),
  CONSTRAINT `fk_cve_configuration_disjunct_has_cve_configuration`
    FOREIGN KEY (`cve`,`configuration`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_item_configuration` (`cve`,`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cve_item_configuration_conjunct`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cve_item_configuration_conjunct` (
  `cve` INT UNSIGNED NOT NULL,
  `configuration` INT UNSIGNED NOT NULL,
  `disjunct` INT UNSIGNED NOT NULL,
  `wfn` INT UNSIGNED NOT NULL,
  `vulnerable` BIT(1) NOT NULL,
  `opt_version_start` TINYTEXT,
  `opt_version_start_boundary` ENUM('I','E') NOT NULL DEFAULT 'I' ,
  `opt_version_end` TINYTEXT,
  `opt_version_end_boundary` ENUM('I','E') NOT NULL DEFAULT 'I',
  PRIMARY KEY (`cve`,`configuration`,`disjunct`,`wfn`),
  CONSTRAINT `fk_cve_configuration_conjunct_has_cve_configuration_disjunct`
    FOREIGN KEY (`cve`,`configuration`,`disjunct`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_item_configuration_disjunct` (`cve`,`configuration`,`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_cve_configuration_conjunct_has_wfn`
    FOREIGN KEY (`wfn`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_wfn_item` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cve_item_impact_cvssv2`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cve_item_impact_cvssv2` (
  `cve` INT UNSIGNED NOT NULL,
  `cvss_av` ENUM('L','A','N') NOT NULL,
  `cvss_ac` ENUM('H','M','L') NOT NULL,
  `cvss_au` ENUM('M','S','N') NOT NULL,
  `cvss_c` ENUM('N','P','C') NOT NULL,
  `cvss_i` ENUM('N','P','C') NOT NULL,
  `cvss_a` ENUM('N','P','C') NOT NULL,
  `cvss_e` ENUM('U','POC','F','H','ND') NOT NULL,
  `cvss_rl` ENUM('OF','TF','W','U','ND') NOT NULL,
  `cvss_rc` ENUM('UC','UR','C','ND') NOT NULL,
  `generator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`cve`),
  CONSTRAINT `fk_cve_impact_cvssv2_has_cve`
    FOREIGN KEY (`cve`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  INDEX `fk_cve_impact_cvssv2_has_generator` (`generator` ASC),
  CONSTRAINT `fk_cve_impact_cvssv2_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_cve_item_impact_cvssv3`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_cve_item_impact_cvssv3` (
  `cve` INT UNSIGNED NOT NULL,
  `cvss_av` ENUM('N','A','L','P') NOT NULL,
  `cvss_ac` ENUM('L','H') NOT NULL,
  `cvss_pr` ENUM('N','L','H') NOT NULL,
  `cvss_ui` ENUM('N','R') NOT NULL,
  `cvss_s` ENUM('U','C') NOT NULL,
  `cvss_c` ENUM('H','L','N') NOT NULL,
  `cvss_i` ENUM('H','L','N') NOT NULL,
  `cvss_a` ENUM('H','L','N') NOT NULL,
  `cvss_e` ENUM('X','H','F','P','U') NOT NULL,
  `cvss_rl` ENUM('X','U','W','T','O') NOT NULL,
  `cvss_rc` ENUM('X','C','R','U') NOT NULL,
  `generator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`cve`),
  CONSTRAINT `fk_cve_impact_cvssv3_has_cve`
    FOREIGN KEY (`cve`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  INDEX `fk_cve_impact_cvssv3_has_generator` (`generator` ASC),
  CONSTRAINT `fk_cve_impact_cvssv3_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------------------------------------------------------
-- Asset `t_asset_` & `t_host_` related tables
-- ----------------------------------------------------------------------------
-- Table `{{DATA_DB_NAME}}`.`t_asset_generator`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_asset_generator` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `process_start_date` DATETIME NOT NULL,
  `process_end_date` DATETIME DEFAULT NULL,
  `server_name` VARCHAR(64) NULL,
  `server_version` VARCHAR(16) NULL,
  `agent_name` VARCHAR(64) NULL,
  `agent_version` VARCHAR(16) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_host_item`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_host_item` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `generator` INT UNSIGNED NOT NULL,
  `inet4_addr` INT UNSIGNED DEFAULT NULL,
  `inet4_mask` INT UNSIGNED DEFAULT NULL,
  `hostname` TINYTEXT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_inet4` (`inet4_addr`,`inet4_mask`),
  INDEX `fk_host_has_generator` (`generator` ASC),
  CONSTRAINT `fk_host_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_asset_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_asset_item`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_asset_item` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `host` INT UNSIGNED NOT NULL,
  `wfn` INT UNSIGNED NULL,
  `generator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uk_asset` (`host`,`wfn`),
  INDEX `fk_asset_has_host` (`host` ASC),
  INDEX `fk_asset_has_generator` (`generator` ASC),
  INDEX `fk_asset_has_wfn` (`wfn` ASC),
  CONSTRAINT `fk_asset_has_host`
    FOREIGN KEY (`host`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_host_item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_asset_has_generator`
    FOREIGN KEY (`generator`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_asset_generator` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_asset_has_wfn`
    FOREIGN KEY (`wfn`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_wfn_item` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_asset_item_environment_cvssv2`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_asset_item_environment_cvssv2` (
  `asset` INT UNSIGNED NOT NULL,
  `cvss_cdp` ENUM('N','L','LM','MH','H','ND') NOT NULL,
  `cvss_td` ENUM('N','L','M','H','ND') NOT NULL,
  `cvss_cr` ENUM('L','M','H','ND') NOT NULL,
  `cvss_ir` ENUM('L','M','H','ND') NOT NULL,
  `cvss_ar` ENUM('L','M','H','ND') NOT NULL,
  PRIMARY KEY (`asset`),
  CONSTRAINT `fk_asset_environment_cvssv2_has_asset`
    FOREIGN KEY (`asset`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_asset_item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Table `{{DATA_DB_NAME}}`.`t_asset_item_environment_cvssv3`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_asset_item_environment_cvssv3` (
  `asset` INT UNSIGNED NOT NULL,
  `cvss_cr` ENUM('X','H','M','L') NOT NULL,
  `cvss_ir` ENUM('X','H','M','L') NOT NULL,
  `cvss_ar` ENUM('X','H','M','L') NOT NULL,
  `cvss_mav` ENUM('N','A','L','P') NOT NULL,
  `cvss_mac` ENUM('L','H') NOT NULL,
  `cvss_mpr` ENUM('N','L','H') NOT NULL,
  `cvss_mui` ENUM('N','R') NOT NULL,
  `cvss_ms` ENUM('U','C') NOT NULL,
  `cvss_mc` ENUM('H','L','N') NOT NULL,
  `cvss_mi` ENUM('H','L','N') NOT NULL,
  `cvss_ma` ENUM('H','L','N') NOT NULL,
  PRIMARY KEY (`asset`),
  CONSTRAINT `fk_asset_environment_cvssv3_has_asset`
    FOREIGN KEY (`asset`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_asset_item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------------------------------------------------------
-- Assessment related tables
-- ----------------------------------------------------------------------------
-- Table `{{DATA_DB_NAME}}`.`t_assessment`
CREATE TABLE IF NOT EXISTS `{{DATA_DB_NAME}}`.`t_assessment` (
  `asset` INT UNSIGNED NOT NULL,
  `cve` INT UNSIGNED NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `cvssv2_score` FLOAT(4,2) UNSIGNED NOT NULL,
  `cvssv3_score` FLOAT(4,2) UNSIGNED NOT NULL,
  PRIMARY KEY (`asset`, `cve`),
  INDEX `fk_assessment_has_cve` (`cve` ASC),
  INDEX `fk_assessment_has_asset` (`asset` ASC),
  CONSTRAINT `fk_assessment_has_cve`
    FOREIGN KEY (`cve`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_cve_item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_assessment_has_asset`
    FOREIGN KEY (`asset`)
    REFERENCES `{{DATA_DB_NAME}}`.`t_asset_item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
