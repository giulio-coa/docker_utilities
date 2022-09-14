#!/bin/sh

#########################################################################
#	Filename:		.../init.sh					            				          				#
#	Purpose:		Script that restore the test dabase				          			#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.			        			#
#########################################################################

set -e

[ -d /data/demo ] \
  && mongorestore --verbose --db='demo' --objcheck --drop --convertLegacyIndex --stopOnError /data/demo
