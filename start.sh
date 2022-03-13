#!/bin/sh

# Check if the build script exists and, if not, download it
if [ ! -f ./build.sh ]
then
	wget -O build.sh https://raw.githubusercontent.com/giulio-coa/docker_utilities/master/build.sh
fi

clear

./build.sh

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

docker-compose start
