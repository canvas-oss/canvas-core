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
-- Triggers
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

-- Trigger  `{{DATA_DB_NAME}}`.`tr_assess_updated_cve`

-- Trigger  `{{DATA_DB_NAME}}`.`tr_assess_updated_asset`
DELIMITER //
CREATE TRIGGER `{{DATA_DB_NAME}}`.`tr_assess_updated_asset`
AFTER UPDATE ON `{{DATA_DB_NAME}}`.`t_asset_item`
FOR EACH ROW
BEGIN
  -- Working data
  DECLARE cve_id INT;
  DECLARE cve_configuration INT;
  DECLARE cve_disjunct INT;
  DECLARE cve_match BINARY;
  -- Cursors : foreach CVE configuration disjunct
  DECLARE done INT DEFAULT 0;
  DECLARE foreach_cve_dis CURSOR FOR SELECT `t_cve_item_configuration_disjunct`.`cve`, `t_cve_item_configuration_disjunct`.`configuration`, `t_cve_item_configuration_disjunct`.`id` FROM `{{DATA_DB_NAME}}`.`t_cve_item_configuration_disjunct`;
  DECLARE CONTINUE handler FOR SQLSTATE '02000' set done = 1;
  -- Foreach CVE configuration disjunct entry
  OPEN foreach_cve_dis;
    foreach_loop: REPEAT
      -- Leave foreach loop if there is no more entry
      IF done THEN
          LEAVE foreach_loop;
      END IF;

      -- Fetch next CVE configuration disjunct entry
      FETCH foreach_cve_dis INTO cve_id, cve_configuration, cve_disjunct;
      -- Compare CVE configuration conjunction against host configuration
      SET cve_match = f_is_cve_match_host(cve_id, cve_configuration, cve_disjunct, NEW.host);
      IF cve_match THEN
        -- Insert or update an assessment entry if needed
        -- TODO: compute CVSS v2 and v3 Score
        INSERT INTO `{{DATA_DB_NAME}}`.`t_assessment` (
          `asset`,
          `cve`,
          `timestamp`,
          `cvssv2_score`,
          `cvssv3_score`
        )
        VALUES (
          NEW.id,
          cve_id,
          NOW(),
          0.0,
          0.0
        )
        ON DUPLICATE KEY UPDATE
          `t_assessment`.`timestamp` = NOW();
      END IF;

      UNTIL done
    END REPEAT;
  CLOSE foreach_cve_dis;
END//
DELIMITER ;
