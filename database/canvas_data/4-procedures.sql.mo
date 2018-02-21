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
-- Stored procedures
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- CPE related procedures
-- ----------------------------------------------------------------------------
-- Procedure `{{DATA_DB_NAME}}`.`p_cpe_start_update_process`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cpe_start_update_process`(
  IN cpe_data_timestamp DATETIME,
  IN cpe_schema_version TINYTEXT,
  IN cpe_product_name TINYTEXT,
  IN cpe_product_version TINYTEXT,
  OUT generator_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Create a new CPE generator entry and save its id into "generator_id".'
BEGIN
  INSERT INTO `t_cpe_generator` (
    `t_cpe_generator`.`process_start_date`,
    `t_cpe_generator`.`cpe_data_timestamp`,
    `t_cpe_generator`.`cpe_schema_version`,
    `t_cpe_generator`.`cpe_product_name`,
    `t_cpe_generator`.`cpe_product_version`
  )
  VALUES (
    NOW(),
    cpe_data_timestamp,
    cpe_schema_version,
    cpe_product_name,
    cpe_product_version
  );
  -- Retrieve last inserted generator id
  SELECT LAST_INSERT_ID() INTO generator_id;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cpe_save_cpe`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cpe_save_cpe`(
  IN wfn_part ENUM('a','o','h'),
  IN wfn_vendor TINYTEXT,
  IN wfn_product TINYTEXT,
  IN wfn_version TINYTEXT,
  IN wfn_update TINYTEXT,
  IN wfn_edition TINYTEXT,
  IN wfn_sw_edition TINYTEXT,
  IN wfn_target_sw TINYTEXT,
  IN wfn_target_hw TINYTEXT,
  IN cpe_deprecated TINYINT(1),
  IN cpe_deprecation_date DATETIME,
  IN generator INT UNSIGNED,
  OUT cpe_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Save a CPE item and save corresponding WFN item if needed. CPE item id is saved into "cpe_id".'
BEGIN
  -- Save WFN item if needed
  INSERT INTO `t_wfn_item` (
    `t_wfn_item`.`digest`,
    `t_wfn_item`.`part`,
    `t_wfn_item`.`vendor`,
    `t_wfn_item`.`product`,
    `t_wfn_item`.`version`,
    `t_wfn_item`.`update`,
    `t_wfn_item`.`edition`,
    `t_wfn_item`.`sw_edition`,
    `t_wfn_item`.`target_sw`,
    `t_wfn_item`.`target_hw`
  )
  VALUES (
    f_compute_digest(CONCAT(wfn_part,wfn_vendor,wfn_product,wfn_version,wfn_update,wfn_edition,wfn_sw_edition,wfn_target_sw,wfn_target_hw)),
    wfn_part,
    wfn_vendor,
    wfn_product,
    wfn_version,
    wfn_update,
    wfn_edition,
    wfn_sw_edition,
    wfn_target_sw,
    wfn_target_hw
  )
  ON DUPLICATE KEY UPDATE
    `t_wfn_item`.`id` = LAST_INSERT_ID(`t_wfn_item`.`id`);
  -- Retrieve last inserted wfn id
  SELECT LAST_INSERT_ID() INTO cpe_id;
  -- Then save or update CPE item
  INSERT INTO `t_cpe_item` (
    `t_cpe_item`.`wfn`,
    `t_cpe_item`.`deprecated`,
    `t_cpe_item`.`deprecation_date`,
    `t_cpe_item`.`generator`
  )
  VALUES (
    cpe_id,
    cpe_deprecated,
    cpe_deprecation_date,
    generator
  )
  ON DUPLICATE KEY UPDATE
    `t_cpe_item`.`deprecated` = cpe_deprecated,
    `t_cpe_item`.`deprecation_date` = cpe_deprecation_date,
    `t_cpe_item`.`generator` = generator;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cpe_save_cpe_title`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cpe_save_cpe_title`(
  IN cpe INT UNSIGNED,
  IN lang CHAR(5),
  IN value MEDIUMTEXT,
  IN generator INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Save a CPE item title and replace existing title if any.'
BEGIN
  INSERT INTO `t_cpe_item_title` (
    `t_cpe_item_title`.`cpe`,
    `t_cpe_item_title`.`digest`,
    `t_cpe_item_title`.`lang`,
    `t_cpe_item_title`.`value`,
    `t_cpe_item_title`.`generator`
  )
  VALUES (
    cpe,
    f_compute_digest(CONCAT(lang, value)),
    lang,
    value,
    generator
  )
  ON DUPLICATE KEY UPDATE
    `t_cpe_item_title`.`generator` = generator;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cpe_save_cpe_reference`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cpe_save_cpe_reference`(
  IN cpe INT UNSIGNED,
  IN href VARCHAR(2083),
  IN value MEDIUMTEXT,
  IN generator INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Save a CPE item reference and replace existing if any.'
BEGIN
  INSERT INTO `t_cpe_item_reference` (
    `t_cpe_item_reference`.`cpe`,
    `t_cpe_item_reference`.`digest`,
    `t_cpe_item_reference`.`href`,
    `t_cpe_item_reference`.`value`,
    `t_cpe_item_reference`.`generator`
  )
  VALUES (
    cpe,
    f_compute_digest(CONCAT(href, value)),
    href,
    value,
    generator
  )
  ON DUPLICATE KEY UPDATE
    `t_cpe_item_reference`.`generator` = generator;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cpe_save_cpe_deprecated_by`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cpe_save_cpe_deprecated_by`(
  IN cpe INT UNSIGNED,
  IN wfn_part ENUM('a','o','h'),
  IN wfn_vendor TINYTEXT,
  IN wfn_product TINYTEXT,
  IN wfn_version TINYTEXT,
  IN wfn_update TINYTEXT,
  IN wfn_edition TINYTEXT,
  IN wfn_sw_edition TINYTEXT,
  IN wfn_target_sw TINYTEXT,
  IN wfn_target_hw TINYTEXT,
  IN deprecation_date DATETIME,
  IN deprecation_type TINYTEXT,
  IN generator INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Save a CPE item deprecated_by and replace existing if any.'
BEGIN
  DECLARE wfn_id INT UNSIGNED;
  -- Save WFN item if needed
  INSERT INTO `t_wfn_item` (
    `t_wfn_item`.`digest`,
    `t_wfn_item`.`part`,
    `t_wfn_item`.`vendor`,
    `t_wfn_item`.`product`,
    `t_wfn_item`.`version`,
    `t_wfn_item`.`update`,
    `t_wfn_item`.`edition`,
    `t_wfn_item`.`sw_edition`,
    `t_wfn_item`.`target_sw`,
    `t_wfn_item`.`target_hw`
  )
  VALUES (
    f_compute_digest(CONCAT(wfn_part,wfn_vendor,wfn_product,wfn_version,wfn_update,wfn_edition,wfn_sw_edition,wfn_target_sw,wfn_target_hw)),
    wfn_part,
    wfn_vendor,
    wfn_product,
    wfn_version,
    wfn_update,
    wfn_edition,
    wfn_sw_edition,
    wfn_target_sw,
    wfn_target_hw
  )
  ON DUPLICATE KEY UPDATE
    `t_wfn_item`.`id` = LAST_INSERT_ID(`t_wfn_item`.`id`);
  -- Retrieve last inserted wfn id
  SELECT LAST_INSERT_ID() INTO wfn_id;
  -- Save CPE deprecated_by
  INSERT INTO `t_cpe_item_deprecated_by` (
    `t_cpe_item_deprecated_by`.`cpe`,
    `t_cpe_item_deprecated_by`.`digest`,
    `t_cpe_item_deprecated_by`.`wfn`,
    `t_cpe_item_deprecated_by`.`date`,
    `t_cpe_item_deprecated_by`.`type`,
    `t_cpe_item_deprecated_by`.`generator`
  )
  VALUES (
    cpe,
    f_compute_digest(CONCAT(wfn_id,deprecation_date,deprecation_type)),
    wfn_id,
    deprecation_date,
    deprecation_type,
    generator
  )
  ON DUPLICATE KEY UPDATE
    `t_cpe_item_deprecated_by`.`generator` = generator;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cpe_complete_update_process`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cpe_complete_update_process`(
  IN generator INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Update a CPE generator entry and save the update process end date.'
BEGIN
  UPDATE `t_cpe_generator`
    SET `t_cpe_generator`.`process_end_date` = NOW()
    WHERE `t_cpe_generator`.`id` = generator;
END//
DELIMITER ;

-- ----------------------------------------------------------------------------
-- CVE related procedures
-- ----------------------------------------------------------------------------
-- Procedure `{{DATA_DB_NAME}}`.`p_cve_start_update_process`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_start_update_process`(
  IN cve_data_timestamp DATETIME,
  IN cve_data_type TINYTEXT,
  IN cve_data_format TINYTEXT,
  IN cve_data_version TINYTEXT,
  OUT generator_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Create a new CVE generator entry and save its id into "generator_id".'
BEGIN
  INSERT INTO `t_cve_generator` (
    `t_cve_generator`.`process_start_date`,
    `t_cve_generator`.`cve_data_timestamp`,
    `t_cve_generator`.`cve_data_type`,
    `t_cve_generator`.`cve_data_format`,
    `t_cve_generator`.`cve_data_version`
  )
  VALUES (
    NOW(),
    cve_data_timestamp,
    cve_data_type,
    cve_data_format,
    cve_data_version
  );
  -- Retrieve last inserted generator id
  SELECT LAST_INSERT_ID() INTO generator_id;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cve_save_cve`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_save_cve`(
  IN year CHAR(4),
  IN digits VARCHAR(32),
  IN published_date DATETIME,
  IN modified_date DATETIME,
  IN generator INT UNSIGNED,
  OUT cve_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Save a CVE item. CVE item id is saved into "cve_id".'
BEGIN
  INSERT INTO `t_cve_item` (
    `t_cve_item`.`year`,
    `t_cve_item`.`digits`,
    `t_cve_item`.`published_date`,
    `t_cve_item`.`modified_date`,
    `t_cve_item`.`generator`
  )
  VALUES (
    year,
    digits,
    published_date,
    modified_date,
    generator
  )
  ON DUPLICATE KEY UPDATE
    `t_cve_item`.`id` = LAST_INSERT_ID(`t_cve_item`.`id`),
    `t_cve_item`.`year` = year,
    `t_cve_item`.`digits` = digits,
    `t_cve_item`.`published_date` = published_date,
    `t_cve_item`.`modified_date` = modified_date,
    `t_cve_item`.`generator` = generator;
  -- Retrieve last inserted CVE id
  SELECT LAST_INSERT_ID() INTO cve_id;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cve_save_cve_impact_cvssv2`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_save_cve_impact_cvssv2`(
  IN cve INT UNSIGNED,
  IN cvss_av ENUM('L','A','N'),
	IN cvss_ac ENUM('H','M','L'),
	IN cvss_au ENUM('M','S','N'),
	IN cvss_c ENUM('N','P','C'),
	IN cvss_i ENUM('N','P','C'),
	IN cvss_a ENUM('N','P','C'),
	IN cvss_e ENUM('U','POC','F','H','ND'),
	IN cvss_rl ENUM('OF','TF','W','U','ND'),
	IN cvss_rc ENUM('UC','UR','C','ND'),
	IN generator INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Save or update a CVE item CVSSv2 impact.'
BEGIN
  INSERT INTO `t_cve_item_impact_cvssv2` (
    `t_cve_item_impact_cvssv2`.`cve`,
    `t_cve_item_impact_cvssv2`.`cvss_av`,
    `t_cve_item_impact_cvssv2`.`cvss_ac`,
    `t_cve_item_impact_cvssv2`.`cvss_au`,
    `t_cve_item_impact_cvssv2`.`cvss_c`,
    `t_cve_item_impact_cvssv2`.`cvss_i`,
    `t_cve_item_impact_cvssv2`.`cvss_a`,
    `t_cve_item_impact_cvssv2`.`cvss_e`,
    `t_cve_item_impact_cvssv2`.`cvss_rl`,
    `t_cve_item_impact_cvssv2`.`cvss_rc`,
    `t_cve_item_impact_cvssv2`.`generator`
  )
  VALUES (
    cve,
    cvss_av,
    cvss_ac,
    cvss_au,
    cvss_c,
    cvss_i,
    cvss_a,
    cvss_e,
    cvss_rl,
    cvss_rc,
    generator
  )
  ON DUPLICATE KEY UPDATE
    `t_cve_item_impact_cvssv2`.`cvss_av` = cvss_av,
    `t_cve_item_impact_cvssv2`.`cvss_ac` = cvss_ac,
    `t_cve_item_impact_cvssv2`.`cvss_au` = cvss_au,
    `t_cve_item_impact_cvssv2`.`cvss_c` = cvss_c,
    `t_cve_item_impact_cvssv2`.`cvss_i` = cvss_i,
    `t_cve_item_impact_cvssv2`.`cvss_a` = cvss_a,
    `t_cve_item_impact_cvssv2`.`cvss_e` = cvss_e,
    `t_cve_item_impact_cvssv2`.`cvss_rl` = cvss_rl,
    `t_cve_item_impact_cvssv2`.`cvss_rc` = cvss_rc,
    `t_cve_item_impact_cvssv2`.`generator` = generator;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cve_save_cve_impact_cvssv3`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_save_cve_impact_cvssv3`(
  IN cve INT UNSIGNED,
  IN cvss_av ENUM('N','A','L','P'),
  IN cvss_ac ENUM('L','H'),
  IN cvss_pr ENUM('N','L','H'),
  IN cvss_ui ENUM('N','R'),
  IN cvss_s ENUM('U','C'),
  IN cvss_c ENUM('H','L','N'),
  IN cvss_i ENUM('H','L','N'),
  IN cvss_a ENUM('H','L','N'),
  IN cvss_e ENUM('X','H','F','P','U'),
  IN cvss_rl ENUM('X','U','W','T','O'),
  IN cvss_rc ENUM('X','C','R','U'),
  IN generator INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Save or update a CVE item CVSSv3 impact.'
BEGIN
  INSERT INTO `t_cve_item_impact_cvssv3` (
    `t_cve_item_impact_cvssv3`.`cve`,
    `t_cve_item_impact_cvssv3`.`cvss_av`,
    `t_cve_item_impact_cvssv3`.`cvss_ac`,
    `t_cve_item_impact_cvssv3`.`cvss_pr`,
    `t_cve_item_impact_cvssv3`.`cvss_ui`,
    `t_cve_item_impact_cvssv3`.`cvss_s`,
    `t_cve_item_impact_cvssv3`.`cvss_c`,
    `t_cve_item_impact_cvssv3`.`cvss_i`,
    `t_cve_item_impact_cvssv3`.`cvss_a`,
    `t_cve_item_impact_cvssv3`.`cvss_e`,
    `t_cve_item_impact_cvssv3`.`cvss_rl`,
    `t_cve_item_impact_cvssv3`.`cvss_rc`,
    `t_cve_item_impact_cvssv3`.`generator`
  )
  VALUES (
    cve,
    cvss_av,
    cvss_ac,
    cvss_pr,
    cvss_ui,
    cvss_s,
    cvss_c,
    cvss_i,
    cvss_a,
    cvss_e,
    cvss_rl,
    cvss_rc,
    generator
  )
  ON DUPLICATE KEY UPDATE
    `t_cve_item_impact_cvssv3`.`cvss_av` = cvss_av,
    `t_cve_item_impact_cvssv3`.`cvss_ac` = cvss_ac,
    `t_cve_item_impact_cvssv3`.`cvss_pr` = cvss_pr,
    `t_cve_item_impact_cvssv3`.`cvss_ui` = cvss_ui,
    `t_cve_item_impact_cvssv3`.`cvss_s` = cvss_s,
    `t_cve_item_impact_cvssv3`.`cvss_c` = cvss_c,
    `t_cve_item_impact_cvssv3`.`cvss_i` = cvss_i,
    `t_cve_item_impact_cvssv3`.`cvss_a` = cvss_a,
    `t_cve_item_impact_cvssv3`.`cvss_e` = cvss_e,
    `t_cve_item_impact_cvssv3`.`cvss_rl` = cvss_rl,
    `t_cve_item_impact_cvssv3`.`cvss_rc` = cvss_rc,
    `t_cve_item_impact_cvssv3`.`generator` = generator;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cve_save_cve_description`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_save_cve_description`(
  IN cve INT UNSIGNED,
  IN lang CHAR(5),
  IN value MEDIUMTEXT,
  IN generator INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Save a CVE item description and replace existing if any.'
BEGIN
  INSERT INTO `t_cve_item_description` (
    `t_cve_item_description`.`cve`,
    `t_cve_item_description`.`digest`,
    `t_cve_item_description`.`lang`,
    `t_cve_item_description`.`value`,
    `t_cve_item_description`.`generator`
  )
  VALUES (
    cve,
    f_compute_digest(CONCAT(lang, value)),
    lang,
    value,
    generator
  )
  ON DUPLICATE KEY UPDATE
    `t_cve_item_description`.`generator` = generator;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cve_save_cve_reference`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_save_cve_reference`(
  IN cve INT UNSIGNED,
  IN url VARCHAR(2083),
  IN generator INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Save a CVE item reference and replace existing if any.'
BEGIN
  INSERT INTO `t_cve_item_reference` (
    `t_cve_item_reference`.`cve`,
    `t_cve_item_reference`.`digest`,
    `t_cve_item_reference`.`url`,
    `t_cve_item_reference`.`generator`
  )
  VALUES (
    cve,
    f_compute_digest(url),
    url,
    generator
  )
  ON DUPLICATE KEY UPDATE
    `t_cve_item_reference`.`generator` = generator;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cve_save_cve_affect`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_save_cve_affect`(
  IN cve INT UNSIGNED,
  IN vendor TINYTEXT,
  IN product TINYTEXT,
  IN version TINYTEXT,
  IN generator INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Save a CVE item affected product and replace existing if any.'
BEGIN
  INSERT INTO `t_cve_item_affect` (
    `t_cve_item_affect`.`cve`,
    `t_cve_item_affect`.`digest`,
    `t_cve_item_affect`.`vendor`,
    `t_cve_item_affect`.`product`,
    `t_cve_item_affect`.`version`,
    `t_cve_item_affect`.`generator`
  )
  VALUES (
    cve,
    f_compute_digest(CONCAT(vendor, product, version)),
    vendor,
    product,
    version,
    generator
  )
  ON DUPLICATE KEY UPDATE
    `t_cve_item_affect`.`generator` = generator;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cve_configuration_flush`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_configuration_flush`(
  IN cve INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Erase all configuration entry of a given CVE. It delete disjunct and conjunct entries too.'
BEGIN
  DELETE FROM `t_cve_item_configuration`
    WHERE  `t_cve_item_configuration`.`cve` = cve;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cve_configuration_new`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_configuration_new`(
  IN cve INT UNSIGNED,
  IN generator INT UNSIGNED,
  OUT configuration_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Create a new configuration entry for given CVE'
BEGIN
  INSERT INTO `t_cve_item_configuration` (
    `t_cve_item_configuration`.`cve`,
    `t_cve_item_configuration`.`id`,
    `t_cve_item_configuration`.`generator`
  )
  SELECT
    cve, coalesce(MAX(`t_cve_item_configuration`.`id`), 0)+1, generator
  FROM `t_cve_item_configuration`
  WHERE `t_cve_item_configuration`.`cve` = cve;
  -- Retrieve last inserted configuration id
  SELECT MAX(`t_cve_item_configuration`.`id`)
  INTO configuration_id
  FROM `t_cve_item_configuration`
  WHERE `t_cve_item_configuration`.`cve` = cve;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cve_configuration_add_disjunction`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_configuration_add_disjunction`(
  IN cve INT UNSIGNED,
  IN configuration INT UNSIGNED,
  OUT disjunct_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Create a new configuration entry for given CVE'
BEGIN
  INSERT INTO `t_cve_item_configuration_disjunct` (
    `t_cve_item_configuration_disjunct`.`cve`,
    `t_cve_item_configuration_disjunct`.`configuration`,
    `t_cve_item_configuration_disjunct`.`id`
  )
  SELECT
    cve, configuration, coalesce(MAX(`t_cve_item_configuration_disjunct`.`id`), 0)+1
  FROM `t_cve_item_configuration_disjunct`
  WHERE `t_cve_item_configuration_disjunct`.`cve` = cve
  AND `t_cve_item_configuration_disjunct`.`configuration` = configuration;
  -- Retrieve last inserted disjunct id
  SELECT MAX(`t_cve_item_configuration_disjunct`.`id`)
  INTO disjunct_id
  FROM `t_cve_item_configuration_disjunct`
  WHERE `t_cve_item_configuration_disjunct`.`cve` = cve
  AND `t_cve_item_configuration_disjunct`.`configuration` = configuration;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cve_configuration_add_conjunction`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_configuration_add_conjunction`(
  IN cve INT UNSIGNED,
  IN configuration INT UNSIGNED,
  IN disjunct INT UNSIGNED,
  IN wfn_part ENUM('a','o','h'),
  IN wfn_vendor TINYTEXT,
  IN wfn_product TINYTEXT,
  IN wfn_version TINYTEXT,
  IN wfn_update TINYTEXT,
  IN wfn_edition TINYTEXT,
  IN wfn_sw_edition TINYTEXT,
  IN wfn_target_sw TINYTEXT,
  IN wfn_target_hw TINYTEXT,
  IN vulnerable BIT(1),
  IN opt_version_start TINYTEXT,
  IN opt_version_start_boundary ENUM('I','E'),
  IN opt_version_end TINYTEXT,
  IN opt_version_end_boundary ENUM('I','E'),
  OUT conjunct_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT ''
BEGIN
  -- Save WFN item if needed
  INSERT INTO `t_wfn_item` (
    `t_wfn_item`.`digest`,
    `t_wfn_item`.`part`,
    `t_wfn_item`.`vendor`,
    `t_wfn_item`.`product`,
    `t_wfn_item`.`version`,
    `t_wfn_item`.`update`,
    `t_wfn_item`.`edition`,
    `t_wfn_item`.`sw_edition`,
    `t_wfn_item`.`target_sw`,
    `t_wfn_item`.`target_hw`
  )
  VALUES (
    f_compute_digest(CONCAT(wfn_part,wfn_vendor,wfn_product,wfn_version,wfn_update,wfn_edition,wfn_sw_edition,wfn_target_sw,wfn_target_hw)),
    wfn_part,
    wfn_vendor,
    wfn_product,
    wfn_version,
    wfn_update,
    wfn_edition,
    wfn_sw_edition,
    wfn_target_sw,
    wfn_target_hw
  )
  ON DUPLICATE KEY UPDATE
    `t_wfn_item`.`id` = LAST_INSERT_ID(`t_wfn_item`.`id`);
  -- Retrieve last inserted wfn id
  SELECT LAST_INSERT_ID() INTO conjunct_id;
  -- Then save or CVE configuration conjunction
  INSERT INTO `t_cve_item_configuration_conjunct` (
    `t_cve_item_configuration_conjunct`.`cve`,
    `t_cve_item_configuration_conjunct`.`configuration`,
    `t_cve_item_configuration_conjunct`.`disjunct`,
    `t_cve_item_configuration_conjunct`.`wfn`,
    `t_cve_item_configuration_conjunct`.`vulnerable`,
    `t_cve_item_configuration_conjunct`.`opt_version_start`,
    `t_cve_item_configuration_conjunct`.`opt_version_start_boundary`,
    `t_cve_item_configuration_conjunct`.`opt_version_end`,
    `t_cve_item_configuration_conjunct`.`opt_version_end_boundary`
  )
  VALUES (
    cve,
    configuration,
    disjunct,
    conjunct_id,
    vulnerable,
    opt_version_start,
    opt_version_start_boundary,
    opt_version_end,
    opt_version_end_boundary
  );
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_cve_complete_update_process`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_complete_update_process`(
  IN generator INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Update a CVE generator entry and save the update process end date.'
BEGIN
  UPDATE `t_cve_generator`
    SET `t_cve_generator`.`process_end_date` = NOW()
    WHERE `t_cve_generator`.`id` = generator;
END//
DELIMITER ;

-- ----------------------------------------------------------------------------
-- Asset related procedures
-- ----------------------------------------------------------------------------
-- Procedure `{{DATA_DB_NAME}}`.`p_asset_start_update_process`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_asset_start_update_process`(
  IN server_name VARCHAR(64),
  IN server_version VARCHAR(16),
  IN agent_name VARCHAR(64),
  IN agent_version VARCHAR(16),
  OUT generator_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Create a new Asset generator entry and save its id into "generator_id".'
BEGIN
  INSERT INTO `t_asset_generator` (
    `t_asset_generator`.`process_start_date`,
    `t_asset_generator`.`server_name`,
    `t_asset_generator`.`server_version`,
    `t_asset_generator`.`agent_name`,
    `t_asset_generator`.`agent_version`
  )
  VALUES (
    NOW(),
    server_name,
    server_version,
    agent_name,
    agent_version
  );
  -- Retrieve last inserted generator id
  SELECT LAST_INSERT_ID() INTO generator_id;
END//
DELIMITER ;
-- Procedure `{{DATA_DB_NAME}}`.`p_asset_save_host`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_asset_save_host`(
  IN inet4_addr INT UNSIGNED,
  IN inet4_mask INT UNSIGNED,
  IN hostname TINYTEXT,
  IN generator INT UNSIGNED,
  OUT host_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Save a new host or update existing.'
BEGIN
  INSERT INTO `t_host_item` (
    `t_host_item`.`inet4_addr`,
    `t_host_item`.`inet4_mask`,
    `t_host_item`.`hostname`,
    `t_host_item`.`generator`
  )
  VALUES (
    inet4_addr,
    inet4_mask,
    name,
    generator
  )
  ON DUPLICATE KEY UPDATE
    `t_host_item`.`id` = LAST_INSERT_ID(`t_host_item`.`id`),
    `t_host_item`.`hostname` = hostname,
    `t_host_item`.`generator` = generator;
  -- Retrieve last inserted host id
  SELECT LAST_INSERT_ID() INTO host_id;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_asset_drop_host`

-- Procedure `{{DATA_DB_NAME}}`.`p_asset_save_asset`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_asset_save_asset`(
  IN host INT UNSIGNED,
  IN wfn_part ENUM('a','o','h'),
  IN wfn_vendor TINYTEXT,
  IN wfn_product TINYTEXT,
  IN wfn_version TINYTEXT,
  IN wfn_update TINYTEXT,
  IN wfn_edition TINYTEXT,
  IN wfn_sw_edition TINYTEXT,
  IN wfn_target_sw TINYTEXT,
  IN wfn_target_hw TINYTEXT,
  IN generator INT UNSIGNED,
  OUT asset_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Save a new asset for a host or update existing.'
BEGIN
  DECLARE wfn_id INT UNSIGNED;
  -- Save WFN item if needed
  INSERT INTO `t_wfn_item` (
    `t_wfn_item`.`digest`,
    `t_wfn_item`.`part`,
    `t_wfn_item`.`vendor`,
    `t_wfn_item`.`product`,
    `t_wfn_item`.`version`,
    `t_wfn_item`.`update`,
    `t_wfn_item`.`edition`,
    `t_wfn_item`.`sw_edition`,
    `t_wfn_item`.`target_sw`,
    `t_wfn_item`.`target_hw`
  )
  VALUES (
    f_compute_digest(CONCAT(wfn_part,wfn_vendor,wfn_product,wfn_version,wfn_update,wfn_edition,wfn_sw_edition,wfn_target_sw,wfn_target_hw)),
    wfn_part,
    wfn_vendor,
    wfn_product,
    wfn_version,
    wfn_update,
    wfn_edition,
    wfn_sw_edition,
    wfn_target_sw,
    wfn_target_hw
  )
  ON DUPLICATE KEY UPDATE
    `t_wfn_item`.`id` = LAST_INSERT_ID(`t_wfn_item`.`id`);
  -- Retrieve last inserted wfn id
  SELECT LAST_INSERT_ID() INTO wfn_id;
  -- Save Asset
  INSERT INTO `t_asset_item` (
    `t_asset_item`.`host`,
    `t_asset_item`.`wfn`,
    `t_asset_item`.`generator`
  )
  VALUES (
    host,
    wfn_id,
    generator
  )
  ON DUPLICATE KEY UPDATE
    `t_asset_item`.`id` = LAST_INSERT_ID(`t_asset_item`.`id`),
    `t_asset_item`.`generator` = generator;
  -- Retrieve last inserted asset id
  SELECT LAST_INSERT_ID() INTO asset_id;
END//
DELIMITER ;

-- Procedure `{{DATA_DB_NAME}}`.`p_asset_drop_asset`

-- Procedure `{{DATA_DB_NAME}}`.`p_asset_complete_update_process`
DELIMITER //
CREATE PROCEDURE `{{DATA_DB_NAME}}`.`p_asset_complete_update_process`(
  IN generator INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY INVOKER
COMMENT 'Update an Asset generator entry and save the update process end date.'
BEGIN
  UPDATE `t_asset_generator`
    SET `t_asset_generator`.`process_end_date` = NOW()
    WHERE `t_asset_generator`.`id` = generator;
END//
DELIMITER ;
