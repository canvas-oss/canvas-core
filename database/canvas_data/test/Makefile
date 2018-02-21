# ----------------------------------------------------------------------------
# Copyright Remy BOISSEZON, Valentin PRODHOMME, Dylan TROLES, Alexandre ZANNI
# 2017-12-10
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

test:
	$(MAKE) -C data test
	# Create canvas_data database
	mysql --host=$(TEST_MYSQL_HOST) --port=$(TEST_MYSQL_PORT) --protocol=TCP --user=$(TEST_MYSQL_USER) --password=$(TEST_MYSQL_PASS) -v --show-warnings < $(TEST_ROOT_PATH)/database/canvas_data/canvas_data.sql
	# Inject test data
	# WFN Related test data

	# CPE Related test data

	# CVE Related test data
	mysql --host=$(TEST_MYSQL_HOST) --port=$(TEST_MYSQL_PORT) --protocol=TCP --user=$(TEST_MYSQL_USER) --password=$(TEST_MYSQL_PASS) -v --show-warnings < ./data/cve.sql
	# Asset related test data
	mysql --host=$(TEST_MYSQL_HOST) --port=$(TEST_MYSQL_PORT) --protocol=TCP --user=$(TEST_MYSQL_USER) --password=$(TEST_MYSQL_PASS) -v --show-warnings < ./data/asset.sql
clean:
	$(MAKE) -C data clean
