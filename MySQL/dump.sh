#!/bin/sh

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
COMPOSE_PROJECT_NAME=$(basename $(dirname $PWD))

echo '[INFO]: Starting the dump of the database'
docker-compose exec --user mysql $NAME_OF_DB_SERVICE mysqldump --add-drop-table --add-drop-trigger --comments --compatible --complete-insert --database "${NAME_OF_THE_DB}" --default-character-set=utf8mb4 --extended-insert --flush-logs --print-defaults --quote-names --result-file="${DOCKER_PATH_TO_THE_SQL_DUMP}/dump.sql" --set-charset --triggers && \
docker-compose exec --user mysql $NAME_OF_DB_SERVICE tar --create --overwrite --remove-files --force-local --file="${DOCKER_PATH_TO_THE_BZIP}/dump.tar.bz2" --bzip2 --verbose --directory="${DOCKER_PATH_TO_THE_SQL_DUMP}" dump.sql && \
echo '[INFO]: Finished the dump of the database'

echo '[INFO]: Copying the bzip2 version of the dump of the database'
docker cp "container-${NAME_OF_DB_SERVICE}:${DOCKER_PATH_TO_THE_BZIP}/dump.tar.bz2" "${LOCALHOST_PATH_TO_THE_BZIP}/dump.tar.bz2" && \
echo '[INFO]: Copied the bzip2 version of the dump of the database'

echo '[INFO]: Removing the bzip2 version of the dump of the database'
docker-compose exec --user mysql $NAME_OF_DB_SERVICE rm -rf "${DOCKER_PATH_TO_THE_BZIP}/dump.tar.bz2" && \
echo '[INFO]: Removed the bzip2 version of the dump of the database'
