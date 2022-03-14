#!/bin/sh
# ./wait_grid.sh mvn clean test

set -e

source .env

clear

while ! curl -sSL "http://selenium.local:${SE_NODE_GRID_URL##*:}/wd/hub/status" 2>&1 | \
	jq -r '.value.ready' 2>&1 | \
	grep "true" >/dev/null
do
	sleep 1
done

exec "$@"