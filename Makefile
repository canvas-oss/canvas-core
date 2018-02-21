# ----------------------------------------------------------------------------
# Copyright Remy BOISSEZON, Valentin PRODHOMME, Dylan TROLES, Alexandre ZANNI
# 2017-10-27
#
# boissezon.remy@gmail.com
# valentin@prodhomme.me
# chill3d@protonmail.com
# alexandre.zanni@engineer.com
#
# This software is governed by the CeCILL license under French law and
# abiding by the rules of distribution of free software.  You can  use,
# modify and/ or redistribute the software under the terms of the CeCILL
# license as circulated by CEA, CNRS and INRIA at the following URL
# "http://www.cecill.info".
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL license and that you accept its terms.
# ----------------------------------------------------------------------------

# Mustache template in Bash script location
export MO_SCRIPT = $(shell readlink -m lib/mo/mo)
# SQL template parameters
# CANVAS configuration database name
export CONFIGURATION_SCHEMA_NAME = canvas_configuration
# CANVAS dashboard database name
export DASHBOARD_SCHEMA_NAME = canvas_dashboard
# CANVAS core "data" database name
export DATA_DB_NAME = canvas_data
# CANVAS core "data" user "u_canvas_product_inventory" hostname and password
export DATA_U_CANVAS_PRODUCT_INVENTORY_HOSTNAME = %
export DATA_U_CANVAS_PRODUCT_INVENTORY_PASSWORD = u_canvas_product_inventory
# CANVAS core "data" user "u_canvas_vulnerability_inventory" hostname and password
export DATA_U_CANVAS_VULNERABILITY_INVENTORY_HOSTNAME = %
export DATA_U_CANVAS_VULNERABILITY_INVENTORY_PASSWORD = u_canvas_vulnerability_inventory
# CANVAS core "data" user "u_canvas_asset_inventory" hostname and password
export DATA_U_CANVAS_ASSET_INVENTORY_HOSTNAME = %
export DATA_U_CANVAS_ASSET_INVENTORY_PASSWORD = u_canvas_asset_inventory
# CANVAS core "data" user "u_canvas_dashboard" hostname and password
export DATA_U_CANVAS_DASHBOARD_HOSTNAME = %
export DATA_U_CANVAS_DASHBOARD_PASSWORD = u_canvas_dashboard

export TEST_ROOT_PATH = $(shell pwd)
export TEST_MYSQL_HOST = 127.0.0.1
export TEST_MYSQL_PORT = 3306
export TEST_MYSQL_USER = root
export TEST_MYSQL_PASS =

all:
	$(MAKE) -C database all
test:
	$(MAKE) -C database test
clean:
	$(MAKE) -C database clean
