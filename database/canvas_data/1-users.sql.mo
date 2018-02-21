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
-- Users
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- User `u_canvas_product_inventory`
CREATE USER `u_canvas_product_inventory`@`{{DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME}}`
  IDENTIFIED BY "{{DATA_U_CANVAS_PRODUCT_INVENTORY_PASSWORD}}";

-- User `u_canvas_vulnerability_inventory`
CREATE USER `u_canvas_vulnerability_inventory`@`{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME}}`
  IDENTIFIED BY "{{DATA_U_CANVAS_VULNERABILITY_INVENTORY_PASSWORD}}";

-- User `u_canvas_asset_inventory`
CREATE USER `u_canvas_asset_inventory`@`{{DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME}}`
  IDENTIFIED BY "{{DATA_U_CANVAS_ASSET_INVENTORY_PASSWORD}}";

-- User `u_canvas_dashboard`
CREATE USER `u_canvas_dashboard`@`{{DATA_U_CANVAS_DASHBOARD_HOSTNAME}}`
  IDENTIFIED BY "{{DATA_U_CANVAS_DASHBOARD_PASSWORD}}";
  