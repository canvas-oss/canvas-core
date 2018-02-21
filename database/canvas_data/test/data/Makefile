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
	cat cve.sql.mo | $(MO_SCRIPT) > cve.sql
	cat asset.sql.mo | $(MO_SCRIPT) > asset.sql
clean:
	rm -f cve.sql
	rm -f asset.sql
