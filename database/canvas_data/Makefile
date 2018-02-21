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

# Filenames
SQL_FILE_DATABASES 	= 0-databases.sql.mo
SQL_FILE_USERS 		= 1-users.sql.mo
SQL_FILE_TABLES		= 2-tables.sql.mo
SQL_FILE_FUNCTIONS  = 3-functions.sql.mo
SQL_FILE_PROCEDURES = 4-procedures.sql.mo
SQL_FILE_VIEWS 		= 5-views.sql.mo
SQL_FILE_TRIGGERS 	= 6-triggers.sql.mo
SQL_FILE_PRIVILEGES = 7-privileges.sql.mo
SQL_FILE_SEEDS 		= 8-seeds.sql.mo
SQL_FILE_OUT		= canvas_data.sql

all:
	export DATA_DB_NAME
	echo "Generating $(DATA_DB_NAME) database definition file into $(SQL_FILE_OUT)..."
	echo "" > $(SQL_FILE_OUT)
	cat $(SQL_FILE_DATABASES) | $(MO_SCRIPT) >> $(SQL_FILE_OUT)
	cat $(SQL_FILE_USERS) | $(MO_SCRIPT) >> $(SQL_FILE_OUT)
	cat $(SQL_FILE_TABLES) | $(MO_SCRIPT) >> $(SQL_FILE_OUT)
	cat $(SQL_FILE_FUNCTIONS) | $(MO_SCRIPT) >> $(SQL_FILE_OUT)
	cat $(SQL_FILE_VIEWS) | $(MO_SCRIPT) >> $(SQL_FILE_OUT)
	cat $(SQL_FILE_TRIGGERS) | $(MO_SCRIPT) >> $(SQL_FILE_OUT)
	cat $(SQL_FILE_PRIVILEGES) | $(MO_SCRIPT) >> $(SQL_FILE_OUT)
	cat $(SQL_FILE_SEEDS) | $(MO_SCRIPT) >> $(SQL_FILE_OUT)
test: all
	$(MAKE) -C test test
clean:
	rm -f $(SQL_FILE_OUT)
	$(MAKE) -C test clean