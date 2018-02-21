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
-- Database {{DATA_DB_NAME}}
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS `{{DATA_DB_NAME}}`
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_unicode_ci;

USE `{{DATA_DB_NAME}}`;
