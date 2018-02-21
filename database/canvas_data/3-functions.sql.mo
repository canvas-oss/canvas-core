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
-- Functions
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Helpers
-- ----------------------------------------------------------------------------
-- Compute digest in order to replace SQL unique constraint
DELIMITER //
CREATE FUNCTION `{{DATA_DB_NAME}}`.`f_compute_digest`(
	data LONGTEXT
)
RETURNS BINARY(20)
LANGUAGE SQL
DETERMINISTIC
NO SQL
SQL SECURITY INVOKER
COMMENT 'Return a BINARY(20) SHA1 digest of data.'
BEGIN
  RETURN UNHEX(SHA1(data));
END//
DELIMITER ;

-- Transform a WFN parameter string in order to be used with SQL LIKE
DELIMITER //
CREATE FUNCTION `{{DATA_DB_NAME}}`.`f_wfn_param_to_sql_like`(
	`param` TINYTEXT
)
RETURNS TINYTEXT CHARSET utf8 COLLATE utf8_unicode_ci
LANGUAGE SQL
DETERMINISTIC
NO SQL
SQL SECURITY INVOKER
COMMENT 'Transform a WFN parameter in order prepare a SQL LIKE comparison. Return a TINYTEXT string.'
BEGIN
  RETURN REPLACE(REPLACE(REPLACE(REPLACE(param, "%", "\%"), "*", "%"), "_", "\_"), "?", "_");
END//
DELIMITER ;

-- Check if a CVE configuration conjunction match a host configuration
DELIMITER //
CREATE FUNCTION `{{DATA_DB_NAME}}`.`f_is_cve_match_host`(
	`cve_id` INT,
  `cve_configuration` INT,
  `cve_disjunct` INT,
  `host` INT
)
RETURNS BINARY
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'Return TRUE if the given CVE configuration match the given host configuration.'
BEGIN
  -- Working data
  DECLARE cve_cfg_count INT;
  DECLARE host_cfg_match INT;
  -- Retrieve the number of CVE configuration conjunct entries that have to match host configuration
  SELECT
    COUNT(*) INTO cve_cfg_count
  FROM `t_cve_item_configuration_conjunct`
  WHERE `t_cve_item_configuration_conjunct`.`cve` = cve_id
  AND `t_cve_item_configuration_conjunct`.`configuration` = cve_configuration
  AND `t_cve_item_configuration_conjunct`.`disjunct` = cve_disjunct;
  -- Retrieve the number of distinct CVE configuration conjunct entries that match host configuration
  SELECT
    COUNT(*) INTO host_cfg_match FROM (
      SELECT
        `t_cve_item_configuration_conjunct`.`wfn`
      FROM `t_cve_item_configuration_conjunct`
      -- JOIN conjunct WFN details
      INNER JOIN `t_wfn_item` AS `conjunct_configuration`
        ON `conjunct_configuration`.`id` = `t_cve_item_configuration_conjunct`.`wfn`
      -- JOIN asset list from host
      INNER JOIN `t_asset_item` AS `asset_list`
        ON `asset_list`.`host` = host
      -- JOIN asset WFN details -- JOIN it only if it match at least one conjunct WFN
      INNER JOIN `t_wfn_item` AS `host_configuration`
        ON `host_configuration`.`id` = `asset_list`.`wfn`
        AND `host_configuration`.`part` = `conjunct_configuration`.`part`
        AND `host_configuration`.`vendor` like f_wfn_param_to_sql_like(`conjunct_configuration`.`vendor`)
        AND `host_configuration`.`product` like f_wfn_param_to_sql_like(`conjunct_configuration`.`product`)
        AND `host_configuration`.`version` like f_wfn_param_to_sql_like(`conjunct_configuration`.`version`)
        AND `host_configuration`.`update` like f_wfn_param_to_sql_like(`conjunct_configuration`.`update`)
        AND `host_configuration`.`edition` like f_wfn_param_to_sql_like(`conjunct_configuration`.`edition`)
        AND `host_configuration`.`sw_edition` like f_wfn_param_to_sql_like(`conjunct_configuration`.`sw_edition`)
        AND `host_configuration`.`target_sw` like f_wfn_param_to_sql_like(`conjunct_configuration`.`target_sw`)
        AND `host_configuration`.`target_hw` like f_wfn_param_to_sql_like(`conjunct_configuration`.`target_hw`)
      WHERE `t_cve_item_configuration_conjunct`.`cve` = cve_id
      AND `t_cve_item_configuration_conjunct`.`configuration` = cve_configuration
      AND `t_cve_item_configuration_conjunct`.`disjunct` = cve_disjunct
      GROUP BY `conjunct_configuration`.`id`
    ) AS subquery;
  -- Return results
  IF cve_cfg_count > 0 THEN
    RETURN cve_cfg_count = host_cfg_match;
  ELSE
    RETURN 0;
  END IF;
END//
DELIMITER ;
