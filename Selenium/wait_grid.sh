#!/bin/sh
# ./wait_grid.sh mvn clean test

#################################################################################
#	Filename:		.../wait_grid.sh											#
#	Purpose:		Script that wait that the Selenium Grid is ready			#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.						#
#################################################################################

set -e

source .env

clear

while ! curl --silent --show-error --location "http://selenium.local:${SE_NODE_GRID_URL##*:}/wd/hub/status" 2> /dev/stdout | \
	jq --raw-output '.value.ready' 2> /dev/stdout | \
	grep 'true' > /dev/null
do
	sleep 1
done

exec "$@"
