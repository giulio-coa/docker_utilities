#!/bin/sh

#################################################################################
#	Filename:		.../restore.sh												#
#	Purpose:		Script that restore a MongoDB database						#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.						#
#################################################################################

# Load the enviroment variables
source .env

clear

# Uncomment this line if there is more docker-compose file that you want use or
# if the docker-compose file that you use have a different name from the default name
# i.e.: COMPOSE_FILE=docker-compose.production.yml:docker-compose.test.yml:docker-compose.debug.yml
#COMPOSE_FILE=

# Uncomment this line if there is more profile that you want use in your docker enviroment
# i.e.: COMPOSE_PROFILES=development,test
#COMPOSE_PROFILES=

# Set the name of the docker-compose project
# The default value is the name of the directory where the script is run
COMPOSE_PROJECT_NAME=$(basename $(dirname "${PWD}"))

echo '[INFO]: Extracting the dump of the database'
docker-compose exec "${NAME_OF_DB_SERVICE}" tar --extract --overwrite --remove-files --force-local --file="${DOCKER_PATH_TO_THE_BZIP}/dump.tar.bz2" --verbose --directory="${DOCKER_PATH_TO_THE_BZIP}/" && \
docker-compose exec "${NAME_OF_DB_SERVICE}" rm -rf "${DOCKER_PATH_TO_THE_BZIP}/dump.tar.bz2" && \
echo '[INFO]: Extracted the dump of the database'

echo '[INFO]: Starting the restore of the database'
docker-compose exec "${NAME_OF_DB_SERVICE}" mongorestore --verbose --db="${NAME_OF_THE_DB}" --objcheck --drop --convertLegacyIndex --stopOnError "${PATH_TO_THE_DUMP_DIRECTORY}/${NAME_OF_THE_DB}" && \
echo '[INFO]: Finished the restore of the database'
