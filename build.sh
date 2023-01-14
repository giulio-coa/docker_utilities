#!/bin/bash

#########################################################################
#	Filename:		./build.sh																								#
#	Purpose:		Script that builds a docker-compose project								#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.										#
#	Pre-requisites:																												#
#									* docker																							#
#									* docker-compose																			#
#########################################################################

### Functions ###
__err() {
  local reset bold_red

  # colors
  reset='\e[0m'
  bold_red='\e[1;31m'

  echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: ${bold_red}$@${reset}" > /dev/stderr
}

__get_file() {
  case "${script_path}" in
    /*)
      echo "$(dirname "${script_path}")/$1"
      ;;
    *)
      echo "${PWD}/$(dirname "${script_path}")/$1"
      ;;
  esac
}

### Script ###
if ! command -v docker-compose > /dev/null 2> /dev/null; then
  __err "docker-compose isn't installed"
  return 1
elif ! command -v docker > /dev/null 2> /dev/null; then
  __err "docker isn't installed"
  return 1
fi

script_path="$0"

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
COMPOSE_PROJECT_NAME="$(basename "$(dirname "$(__get_file .)")")"

docker-compose rm -v --force --stop 2> /dev/null
docker-compose down --volumes --rmi 'local' --remove-orphans 2> /dev/null
docker volume prune --force 2> /dev/null

docker-compose up --force-recreate --always-recreate-deps --no-start --build --remove-orphans
