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
-- Views
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- CVE related views
-- ----------------------------------------------------------------------------
-- View `{{DATA_DB_NAME}}`.`v_cve`
CREATE OR REPLACE
  ALGORITHM=UNDEFINED
  DEFINER=`u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`
  VIEW `{{DATA_DB_NAME}}`.`v_cve` AS
  SELECT
    `t_cve_item`.`id` AS `id`,
    `t_cve_item`.`year` AS `year`,
    `t_cve_item`.`digits` AS `digits`,
    `t_cve_item`.`published_date` AS `published_date`,
    `t_cve_item`.`modified_date` AS `modified_date`,
    `t_cve_generator`.`cve_data_timestamp` AS `source_date`,
    `t_cve_generator`.`cve_data_type` AS `source_type`,
    `t_cve_generator`.`cve_data_format` AS `source_format`,
    `t_cve_generator`.`cve_data_version` AS `source_version`,
    `t_cve_item_impact_cvssv2`.`cvss_av` AS `cvssv2_av`,
    `t_cve_item_impact_cvssv2`.`cvss_ac` AS `cvssv2_ac`,
    `t_cve_item_impact_cvssv2`.`cvss_au` AS `cvssv2_au`,
    `t_cve_item_impact_cvssv2`.`cvss_c` AS `cvssv2_c`,
    `t_cve_item_impact_cvssv2`.`cvss_i` AS `cvssv2_i`,
    `t_cve_item_impact_cvssv2`.`cvss_a` AS `cvssv2_a`,
    `t_cve_item_impact_cvssv2`.`cvss_e` AS `cvssv2_e`,
    `t_cve_item_impact_cvssv2`.`cvss_rl` AS `cvssv2_rl`,
    `t_cve_item_impact_cvssv2`.`cvss_rc` AS `cvssv2_rc`,
    `t_cve_item_impact_cvssv3`.`cvss_av` AS `cvssv3_av`,
    `t_cve_item_impact_cvssv3`.`cvss_ac` AS `cvssv3_ac`,
    `t_cve_item_impact_cvssv3`.`cvss_pr` AS `cvssv3_pr`,
    `t_cve_item_impact_cvssv3`.`cvss_ui` AS `cvssv3_ui`,
    `t_cve_item_impact_cvssv3`.`cvss_s` AS `cvssv3_s`,
    `t_cve_item_impact_cvssv3`.`cvss_c` AS `cvssv3_c`,
    `t_cve_item_impact_cvssv3`.`cvss_i` AS `cvssv3_i`,
    `t_cve_item_impact_cvssv3`.`cvss_a` AS `cvssv3_a`,
    `t_cve_item_impact_cvssv3`.`cvss_e` AS `cvssv3_e`,
    `t_cve_item_impact_cvssv3`.`cvss_rl` AS `cvssv3_rl`,
    `t_cve_item_impact_cvssv3`.`cvss_rc` AS `cvssv3_rc`
  FROM `t_cve_item`
  INNER JOIN `t_cve_generator` ON `t_cve_item`.`generator` = `t_cve_generator`.`id`
  LEFT JOIN `t_cve_item_impact_cvssv2` ON `t_cve_item`.`id` = `t_cve_item_impact_cvssv2`.`cve`
  LEFT JOIN `t_cve_item_impact_cvssv3` ON `t_cve_item`.`id` = `t_cve_item_impact_cvssv3`.`cve`;

-- View `{{DATA_DB_NAME}}`.`v_cve_description`
CREATE OR REPLACE
  ALGORITHM=UNDEFINED
  DEFINER=`u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`
  VIEW `{{DATA_DB_NAME}}`.`v_cve_description` AS
  SELECT
    `t_cve_item_description`.`cve` AS `cve`,
    `t_cve_item_description`.`lang` AS `lang`,
    `t_cve_item_description`.`value` AS `value`
  FROM `t_cve_item_description`;

-- View `{{DATA_DB_NAME}}`.`v_cve_reference`
CREATE OR REPLACE
  ALGORITHM=UNDEFINED
  DEFINER=`u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`
  VIEW `{{DATA_DB_NAME}}`.`v_cve_reference` AS
  SELECT
    `t_cve_item_reference`.`cve` AS `cve`,
    `t_cve_item_reference`.`url` AS `href`
  FROM `t_cve_item_reference`;

  -- View `{{DATA_DB_NAME}}`.`v_cve_affect`
  CREATE OR REPLACE
    ALGORITHM=UNDEFINED
    DEFINER=`u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`
    VIEW `{{DATA_DB_NAME}}`.`v_cve_affect` AS
    SELECT
      `t_cve_item_affect`.`cve` AS `cve`,
      `t_cve_item_affect`.`vendor` AS `vendor`,
      `t_cve_item_affect`.`product` AS `product`,
      `t_cve_item_affect`.`version` AS `version`
    FROM `t_cve_item_affect`;

-- ----------------------------------------------------------------------------
-- CPE related views
-- ----------------------------------------------------------------------------
-- View `{{DATA_DB_NAME}}`.`v_cpe`
CREATE OR REPLACE
  ALGORITHM=UNDEFINED
  DEFINER=`u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`
  VIEW `{{DATA_DB_NAME}}`.`v_cpe` AS
  SELECT
    `t_cpe_item`.`wfn` AS `id`,
    `t_cpe_item`.`deprecated` AS `deprecated`,
    `t_cpe_item`.`deprecation_date` AS `deprecation_date`,
    `t_cpe_generator`.`cpe_data_timestamp` AS `source_date`,
    `t_cpe_generator`.`cpe_schema_version` AS `source_format`,
    `t_cpe_generator`.`cpe_product_name` AS `source_name`,
    `t_cpe_generator`.`cpe_product_version` AS `source_version`,
    `t_wfn_item`.`part` AS `wfn_part`,
    `t_wfn_item`.`vendor` AS `wfn_vendor`,
    `t_wfn_item`.`product` AS `wfn_product`,
    `t_wfn_item`.`version` AS `wfn_version`,
    `t_wfn_item`.`update` AS `wfn_update`,
    `t_wfn_item`.`edition` AS `wfn_edition`,
    `t_wfn_item`.`sw_edition` AS `wfn_sw_edition`,
    `t_wfn_item`.`target_sw` AS `wfn_target_sw`,
    `t_wfn_item`.`target_hw` AS `wfn_target_hw`
  FROM `t_cpe_item`
  INNER JOIN `t_cpe_generator` ON `t_cpe_item`.`generator` = `t_cpe_generator`.`id`
  INNER JOIN `t_wfn_item` ON `t_cpe_item`.`wfn` = `t_wfn_item`.`id`;

-- View `{{DATA_DB_NAME}}`.`v_cpe_title`
CREATE OR REPLACE
  ALGORITHM=UNDEFINED
  DEFINER=`u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`
  VIEW `{{DATA_DB_NAME}}`.`v_cpe_title` AS
  SELECT
    `t_cpe_item_title`.`cpe` AS `cpe`,
    `t_cpe_item_title`.`lang` AS `lang`,
    `t_cpe_item_title`.`value` AS `value`
  FROM `t_cpe_item_title`;

-- View `{{DATA_DB_NAME}}`.`v_cpe_reference`
CREATE OR REPLACE
  ALGORITHM=UNDEFINED
  DEFINER=`u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`
  VIEW `{{DATA_DB_NAME}}`.`v_cpe_reference` AS
  SELECT
    `t_cpe_item_reference`.`cpe` AS `cpe`,
    `t_cpe_item_reference`.`href` AS `href`,
    `t_cpe_item_reference`.`value` AS `value`
  FROM `t_cpe_item_reference`;

  -- View `{{DATA_DB_NAME}}`.`v_cpe_deprecated_by`
  CREATE OR REPLACE
    ALGORITHM=UNDEFINED
    DEFINER=`u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`
    VIEW `{{DATA_DB_NAME}}`.`v_cpe_deprecated_by` AS
    SELECT
      `t_cpe_item_deprecated_by`.`cpe` AS `cpe`,
      `t_cpe_item`.`wfn` AS `wfn`,
      `t_cpe_item_deprecated_by`.`date` AS `date`,
      `t_cpe_item_deprecated_by`.`type` AS `type`
    FROM `t_cpe_item_deprecated_by`
    INNER JOIN `t_cpe_item` ON `t_cpe_item_deprecated_by`.`wfn` = `t_cpe_item`.`wfn`;

-- ----------------------------------------------------------------------------
-- Asset related views
-- ----------------------------------------------------------------------------
-- View `{{DATA_DB_NAME}}`.`v_host`
CREATE OR REPLACE
  ALGORITHM=UNDEFINED
  DEFINER=`u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`
  VIEW `{{DATA_DB_NAME}}`.`v_host` AS
  SELECT
    `t_host_item`.`id` AS `id`,
    INET_NTOA(`t_host_item`.`inet4_addr`) AS `inet4_addr`,
    INET_NTOA(`t_host_item`.`inet4_mask`) AS `inet4_mask`,
    `t_host_item`.`hostname` AS `hostname`,
    `t_asset_generator`.`process_start_date` AS `source_date`,
    `t_asset_generator`.`agent_name` AS `source_name`,
    `t_asset_generator`.`agent_version` AS `source_version`
  FROM `t_host_item`
  INNER JOIN `t_asset_generator` ON `t_host_item`.`generator` = `t_asset_generator`.`id`;

-- View `{{DATA_DB_NAME}}`.`v_asset`
CREATE OR REPLACE
  ALGORITHM=UNDEFINED
  DEFINER=`u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`
  VIEW `{{DATA_DB_NAME}}`.`v_asset` AS
  SELECT
    `t_asset_item`.`id` AS `id`,
    `t_asset_item`.`host` AS `host`,
    `t_wfn_item`.`part` AS `wfn_part`,
    `t_wfn_item`.`vendor` AS `wfn_vendor`,
    `t_wfn_item`.`product` AS `wfn_product`,
    `t_wfn_item`.`version` AS `wfn_version`,
    `t_wfn_item`.`update` AS `wfn_update`,
    `t_wfn_item`.`edition` AS `wfn_edition`,
    `t_wfn_item`.`sw_edition` AS `wfn_sw_edition`,
    `t_wfn_item`.`target_sw` AS `wfn_target_sw`,
    `t_wfn_item`.`target_hw` AS `wfn_target_hw`,
    `t_asset_generator`.`process_start_date` AS `source_date`,
    `t_asset_generator`.`agent_name` AS `source_name`,
    `t_asset_generator`.`agent_version` AS `source_version`
  FROM `t_asset_item`
  INNER JOIN `t_asset_generator` ON `t_asset_item`.`generator` = `t_asset_generator`.`id`
  LEFT JOIN `t_wfn_item` ON `t_asset_item`.`wfn` = `t_wfn_item`.`id`;

-- ----------------------------------------------------------------------------
-- Assessment related views
-- ----------------------------------------------------------------------------
-- View `{{DATA_DB_NAME}}`.`v_assessment`
CREATE OR REPLACE
  ALGORITHM=UNDEFINED
  DEFINER=`u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`
  VIEW `{{DATA_DB_NAME}}`.`v_assessment` AS
  SELECT
  `t_assessment`.`asset` AS `asset`,
  `t_asset_item`.`host` AS `host`,
  `t_assessment`.`cve` AS `cve`,
  `t_cve_item`.`year` AS `year`,
  `t_cve_item`.`digits` AS `digits`,
  `t_assessment`.`timestamp` AS `date`,
  `t_assessment`.`cvssv2_score` AS `cvssv2_score`,
  `t_assessment`.`cvssv3_score` AS `cvssv3_score`
  FROM `t_assessment`
  INNER JOIN `t_cve_item` ON `t_cve_item`.`id` = `t_assessment`.`cve`
  INNER JOIN `t_asset_item` ON `t_asset_item`.`id` = `t_assessment`.`asset`;
