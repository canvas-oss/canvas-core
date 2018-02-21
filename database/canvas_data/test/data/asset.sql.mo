-- ----------------------------------------------------------------------------
-- Copyright Remy BOISSEZON, Valentin PRODHOMME, Dylan TROLES, Alexandre ZANNI
-- 2017-12-10
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
-- Database {{DATA_DB_NAME}}
-- ----------------------------------------------------------------------------
USE `{{DATA_DB_NAME}}`;

-- ----------------------------------------------------------------------------
-- Table `t_asset_generator`
-- ----------------------------------------------------------------------------
INSERT INTO `{{DATA_DB_NAME}}`.`t_asset_generator` (`process_start_date`, `process_end_date`, `server_name`, `server_version`, `agent_name`, `agent_version`) VALUES
  (NOW(), NULL, 'Server CANVAS', '0.1', 'Agent CANVAS', '0.1');

-- ----------------------------------------------------------------------------
-- Table `t_host_item`
-- ----------------------------------------------------------------------------
INSERT INTO `{{DATA_DB_NAME}}`.`t_host_item` (`generator`, `inet4_addr`, `inet4_mask`,`hostname`) VALUES
  -- 1 Linux Host
  (1, INET_ATON('10.10.1.1'), INET_ATON('255.255.255.0'), 'pc-user-1.lan'),
  -- 1 Linux Host
  (1, INET_ATON('10.10.1.2'), INET_ATON('255.255.255.0'), 'pc-user-2.lan'),
  (1, INET_ATON('10.10.1.3'), INET_ATON('255.255.255.0'), 'pc-user-3.lan'),
  -- 1 Apache based Webserver
  (1, INET_ATON('10.10.2.1'), INET_ATON('255.255.255.0'), 'web-server-1.lan'),
  -- 1 Hardware DMC 3000
  (1, INET_ATON('10.10.3.1'), INET_ATON('255.255.255.0'), 'dmc-3000.lan');

-- ----------------------------------------------------------------------------
-- Table `t_wfn_item`
-- ----------------------------------------------------------------------------
INSERT INTO `{{DATA_DB_NAME}}`.`t_wfn_item` (`digest`, `part`, `vendor`, `product`,`version`,`update`,`edition`,`sw_edition`,`target_sw`,`target_hw`) VALUES
  (f_compute_digest(CONCAT('o','apache','struts','2.3.10','*','*','*','*','*')), 'o','apache','struts','2.3.10','*','*','*','*','*'),
  (f_compute_digest(CONCAT('o','apache','sling_servlets_post','*','*','*','*','*','*')), 'o','apache','sling_servlets_post','*','*','*','*','*','*'),
  (f_compute_digest(CONCAT('o','apache','commons_email','1.0','*','*','*','*','*')), 'o','apache','commons_email','1.0','*','*','*','*','*'),
  (f_compute_digest(CONCAT('h','mirion_technologies','dmc_3000','-','*','*','*','*','*')), 'h','mirion_technologies','dmc_3000','-','*','*','*','*','*'),
  (f_compute_digest(CONCAT('o','mirion_technologies','dmc_3000_firmware','-','*','*','*','*','*')), 'o','mirion_technologies','dmc_3000_firmware','-','*','*','*','*','*'),
  (f_compute_digest(CONCAT('o','linux','linux_kernel','2.0.5','*','*','*','*','*')), 'o','linux','linux_kernel','2.0.5','*','*','*','*','*');

-- ----------------------------------------------------------------------------
-- Table `t_asset_item`
-- ----------------------------------------------------------------------------
INSERT INTO `{{DATA_DB_NAME}}`.`t_asset_item` (`host`, `wfn`,`generator`) VALUES
  -- 1 Linux Host
  (1, 6, 1),
  -- 1 Linux Host
  (2, 6, 1),
  -- 1 Linux Host
  (3, 6, 1),
  -- 1 Apache based Webserver
  (4, 1, 1),
  (4, 2, 1),
  (4, 3, 1),
  -- 1 Hardware DMC 3000
  (5, 4, 1),
  (5, 5, 1);

-- ----------------------------------------------------------------------------
-- Table `t_asset_generator`
-- ----------------------------------------------------------------------------
UPDATE `{{DATA_DB_NAME}}`.`t_asset_generator` SET `process_end_date` = NOW() WHERE `t_asset_generator`.`id` = 1;
