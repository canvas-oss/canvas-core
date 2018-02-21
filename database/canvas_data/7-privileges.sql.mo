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
-- Privileges
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Product inventory related privileges
-- ----------------------------------------------------------------------------
-- Read/Write/Execute access to all cpe related tables
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cpe_item`
  TO `u_canvas_product_inventory`@`{{DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cpe_generator`
  TO `u_canvas_product_inventory`@`{{DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cpe_item_reference`
  TO `u_canvas_product_inventory`@`{{DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cpe_item_title`
  TO `u_canvas_product_inventory`@`{{DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME}}`;
-- Read/Write/Execute access to wfn table
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_wfn_item`
  TO `u_canvas_product_inventory`@`{{DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME}}`;
-- Execute access to helper functions
GRANT EXECUTE
  ON FUNCTION `{{DATA_DB_NAME}}`.`f_compute_digest`
  TO `u_canvas_product_inventory`@`{{DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME}}`;
-- Execute access ton all CPE related procedures
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cpe_start_update_process`
  TO `u_canvas_product_inventory`@`{{DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cpe_save_cpe`
  TO `u_canvas_product_inventory`@`{{DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cpe_save_cpe_title`
  TO `u_canvas_product_inventory`@`{{DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cpe_save_cpe_reference`
  TO `u_canvas_product_inventory`@`{{DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cpe_complete_update_process`
  TO `u_canvas_product_inventory`@`{{DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME}}`;

-- ----------------------------------------------------------------------------
-- Vulnerability inventory related privileges
-- ----------------------------------------------------------------------------
-- Read/Write/Execute access to all cve related tables
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cve_item`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cve_generator`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cve_item_reference`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cve_item_description`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cve_item_affect`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cve_item_configuration`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cve_item_configuration_disjunct`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cve_item_configuration_conjunct`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cve_item_impact_cvssv2`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_cve_item_impact_cvssv3`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
-- Read/Write/Execute access to wfn table
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_wfn_item`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
-- Execute access to helper functions
GRANT EXECUTE
  ON FUNCTION `{{DATA_DB_NAME}}`.`f_compute_digest`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
-- Execute access ton all CVE related procedures
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_start_update_process`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_save_cve`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_save_cve_impact_cvssv2`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_save_cve_impact_cvssv3`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_save_cve_description`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_save_cve_reference`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
    ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_save_cve_affect`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_cve_complete_update_process`
  TO `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`;

-- ----------------------------------------------------------------------------
-- Asset inventory related privileges
-- ----------------------------------------------------------------------------
-- Read/Write/Execute access to all asset related tables
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_asset_item`
  TO `u_canvas_asset_inventory`@`{{DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_asset_generator`
  TO `u_canvas_asset_inventory`@`{{DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_asset_item_environment_cvssv2`
  TO `u_canvas_asset_inventory`@`{{DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_asset_item_environment_cvssv3`
  TO `u_canvas_asset_inventory`@`{{DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME}}`;
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_host_item`
  TO `u_canvas_asset_inventory`@`{{DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME}}`;
-- Read/Write/Execute access to wfn table
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `{{DATA_DB_NAME}}`.`t_wfn_item`
  TO `u_canvas_asset_inventory`@`{{DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME}}`;
-- Execute access to helper functions
GRANT EXECUTE
  ON FUNCTION `{{DATA_DB_NAME}}`.`f_compute_digest`
  TO `u_canvas_asset_inventory`@`{{DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME}}`;
-- Execute access ton all Asset related procedures
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_asset_start_update_process`
  TO `u_canvas_asset_inventory`@`{{DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_asset_save_host`
  TO `u_canvas_asset_inventory`@`{{DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_asset_save_asset`
  TO `u_canvas_asset_inventory`@`{{DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME}}`;
GRANT EXECUTE
  ON PROCEDURE `{{DATA_DB_NAME}}`.`p_asset_complete_update_process`
  TO `u_canvas_asset_inventory`@`{{DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME}}`;

-- ----------------------------------------------------------------------------
-- Dashboard related privileges
-- ----------------------------------------------------------------------------
-- Read access to all tables
GRANT SELECT
  ON `{{DATA_DB_NAME}}`.*
  TO`u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`;

FLUSH PRIVILEGES;
