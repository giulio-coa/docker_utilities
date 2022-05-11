#!/bin/sh
# ./start.sh [-b | --build]

#################################################################################
#	Filename:		.../start.sh												#
#	Purpose:		Script that start a docker-compose project					#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.						#
#################################################################################

flag=''

no_color='\e[0;39m'
bold_red='\e[1;31m'

# check the presence of the options
options=$(getopt -n $0 -o 'b' -l 'build'  -- $@)

# check if getopt has failed
if [ $? -ne 0 ]
then
	echo "${bold_red}getopt command has failed.${no_color}" > /dev/stderr
	return 2
fi

# set the options
eval set -- $options

# parse the options without parameters
while true
do
	case $1 in
		# check if the program must update all the repositories
		-b | --build)
			# check if the build script exists and, if not, download it
			if [ ! -f ./build.sh ]
			then
				echo "${bold_red}You don't have the build script.${no_color}" > /dev/stderr

				wget -O build.sh https://raw.githubusercontent.com/giulio-coa/docker_utilities/master/build.sh

				chmod 755 build.sh

				echo 'I have downloaded it.'
				echo 'Personalize it and re-run the start script.'

				exit 1
			fi

			./build.sh

			flag='-'
			;;
		--)
			shift
			break
			;;
	esac

	shift
done

unset options

unset no_color
unset bold_red

[ -z "${flag}" ] && {
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
}

unset flag

docker-compose start
