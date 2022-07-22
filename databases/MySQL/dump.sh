#!/bin/bash

#################################################################################
#	Filename:		.../dump.sh													#
#	Purpose:		Script that dump a MySQL database							#
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

# Load the enviroment variables
source .env

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

printf '[INFO]: Starting the dump of the database\n'
docker-compose exec --user mysql "${NAME_OF_DB_SERVICE}" mysqldump --add-drop-table --add-drop-trigger --comments --compatible --complete-insert --database "${NAME_OF_THE_DB}" --default-character-set=utf8mb4 --extended-insert --flush-logs --print-defaults --quote-names --result-file="${DOCKER_PATH_TO_THE_SQL_DUMP}/dump.sql" --set-charset --triggers && \
docker-compose exec --user mysql "${NAME_OF_DB_SERVICE}" tar --create --overwrite --remove-files --force-local --file="${DOCKER_PATH_TO_THE_BZIP}/dump.tar.bz2" --bzip2 --verbose --directory="${DOCKER_PATH_TO_THE_SQL_DUMP}" dump.sql && \
printf '[INFO]: Finished the dump of the database\n'

printf '[INFO]: Copying the bzip2 version of the dump of the database\n'
docker cp "container-${NAME_OF_DB_SERVICE}:${DOCKER_PATH_TO_THE_BZIP}/dump.tar.bz2" "${LOCALHOST_PATH_TO_THE_BZIP}/dump.tar.bz2" && \
printf '[INFO]: Copied the bzip2 version of the dump of the database\n'

printf '[INFO]: Removing the bzip2 version of the dump of the database\n'
docker-compose exec --user mysql "${NAME_OF_DB_SERVICE}" rm --recursive --force "${DOCKER_PATH_TO_THE_BZIP}/dump.tar.bz2" && \
printf '[INFO]: Removed the bzip2 version of the dump of the database\n'
