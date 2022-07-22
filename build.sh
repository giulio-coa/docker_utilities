#!/bin/bash

#################################################################################
#	Filename:		./build.sh													#
#	Purpose:		Script that builds a docker-compose project					#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.						#
#	Pre-requisites:																#
#					* docker													#
#					* docker-compose											#
#################################################################################

if ! command -v docker-compose &> /dev/null; then
	# shellcheck disable=SC3037
	echo -e "${bold_red:-}docker-compose isn't installed${reset:-}" > /dev/stderr
	return 1
elif ! command -v docker &> /dev/null; then
	# shellcheck disable=SC3037
	echo -e "${bold_red:-}docker isn't installed${reset:-}" > /dev/stderr
	return 1
fi

clear

# Uncomment this line if there is more docker-compose file that you want use or
# if the docker-compose file that you use have a different name from the default name
# i.e.: COMPOSE_FILE=docker-compose.production.yml:docker-compose.test.yml:docker-compose.debug.yml
# shellcheck disable=SC2034
#COMPOSE_FILE=

# Uncomment this line if there is more profile that you want use in your docker enviroment
# i.e.: COMPOSE_PROFILES=development,test
# shellcheck disable=SC2034
#COMPOSE_PROFILES=

# Set the name of the docker-compose project
# The default value is the name of the directory where the script is run
# shellcheck disable=SC2034
COMPOSE_PROJECT_NAME="$(basename "$(dirname "${PWD}")")"

docker-compose rm -v --force --stop 2> /dev/null
docker-compose down --volumes --rmi 'local' --remove-orphans 2> /dev/null
docker volume prune --force 2> /dev/null

docker-compose up --force-recreate --always-recreate-deps --no-start --build --remove-orphans
