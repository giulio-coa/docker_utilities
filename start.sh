#!/bin/sh

#################################################################################################
#	Filename:		./start.sh							#
#	Purpose:		Script that start a docker-compose project			#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.				#
#################################################################################################

__start() {
	local __BUILD
	local reset bold_red
	local options

	# set the flag to don't execute the build of the docker-compose project
	__BUILD=0

	# colors
	reset='\e[0m'
	bold_red='\e[1;31m'

	# check the presence of the options
	options=$(getopt --name "$0" --options 'bh' --longoptions 'build,help'  -- "$@")

	# check if getopt has failed
	if [ $? -ne 0 ]
	then
		echo -e "${bold_red}getopt command has failed.${reset}" > /dev/stderr
		return 1
	fi

	# set the options as arguments
	eval set -- "${options}"

	# parse the options
	while true
	do
		case "$1" in
			-b | --build)
				# check if the build script exists and, if not, download it
				if [ ! -e ./build.sh ] || [ ! -f ./build.sh ]
				then
					wget --output-document=./build.sh https://raw.githubusercontent.com/giulio-coa/docker_utilities/master/build.sh

					chmod 755 ./build.sh

					echo -e "${bold_red}You don't have the build script.${reset}" > /dev/stderr
					echo 'I have downloaded it.' > /dev/stderr
					echo 'Personalize it and re-run the start script.' > /dev/stderr
					return 2
				fi

				./build.sh && __BUILD=1

				shift
				continue
				;;
			-h | --help)
				echo './start.sh [options]'
				echo ''
				echo 'Options:'
				echo -n $'\t'; echo '-b, --build: Execute the build of the Docker containers'
				echo -n $'\t'; echo '-h, --help: Print this menu'
				return 0
				;;
			--)
				shift
				break
				;;
			*)
				echo -e "${bold_red}Internal error.${reset}" > /dev/stderr
				return 3
				;;
		esac
	done

	if [ $__BUILD -eq 0 ]
	then
		clear

		# Uncomment this line if there is more docker-compose file that you want use or
		# if the docker-compose file that you use have a different name from the default name
		# i.e.: COMPOSE_FILE=docker-compose.production.yml:docker-compose.test.yml:docker-compose.debug.yml
		#COMPOSE_FILE=

		# Uncomment this line if there is more profile that you want use in your docker enviroment
		# i.e.: COMPOSE_PROFILES=development,test
		#COMPOSE_PROFILES=

		# Uncomment this line if there isn't a name top-level element into the docker-compose file
		# i.e.: COMPOSE_PROJECT_NAME=$(basename $(dirname "${PWD}"))
		#       COMPOSE_PROJECT_NAME=Generic Docker Compose project
		#COMPOSE_PROJECT_NAME=
	fi

	docker-compose start
}

__start "$@"
