#!/bin/bash

#################################################################################
#	Filename:		./start.sh													#
#	Purpose:		Script that starts a docker-compose project					#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.						#
#	Pre-requisites:																#
#					* docker-compose											#
#					* sudo														#
#################################################################################

__help() {
	printf './start.sh [options]\n\n'
	printf 'Options:\n'
	printf '\t-b, --build: Execute the build of the Docker containers\n'
	printf '\t-h, --help: Print this menu\n'
}

__install_dependencies() {
	if ! command -v curl &> /dev/null; then
		# Alpine Linux
		if command -v apk &> /dev/null; then
			sudo apk --quiet --no-cache add curl
		# Debian-based distro
		elif command -v apt &> /dev/null; then
			sudo apt install --assume-yes --quiet curl
		# MacOS distro
		elif command -v brew &> /dev/null; then
			sudo brew install curl
		# Fedora
		elif command -v dnf &> /dev/null; then
			sudo dnf --assumeyes --quiet install curl
		# Gentoo
		elif command -v emerge &> /dev/null; then
			sudo emerge --quiet y curl
		# Arch Linux
		elif command -v pacman &> /dev/null; then
			sudo pacman --sync --needed --noconfirm --quiet curl
		fi
	fi

	# On Alpine Linux, some commands are installed in a reduced version
	if command -v apk &> /dev/null; then
		sudo apk --quiet --no-cache add sed
	fi
}

__start() {
	local reset bold_red
	local options

	# colors
	reset='\e[0m'
	bold_red='\e[1;31m'

	if ! command -v docker-compose &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red}docker-compose isn't installed${reset}" > /dev/stderr
		return 1
	elif ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red}sudo isn't installed${reset}" > /dev/stderr
		return 1
	fi

	__install_dependencies

	if ! options=$(getopt --name "$0" --options 'bh' --longoptions 'build,help'  -- "$@"); then
		# shellcheck disable=SC3037
		echo -e "${bold_red}getopt command has failed.${reset}" > /dev/stderr
		return 2
	fi

	eval set -- "${options}"

	while true; do
		case "$1" in
			-b | --build)
				# check if the build script exists and, if not, download it
				if [[ ! -f ./build.sh ]]; then
					curl --fail --location --output build.sh https://raw.githubusercontent.com/giulio-coa/docker_utilities/master/build.sh 2> /dev/null

					chmod 755 build.sh

					# shellcheck disable=SC3037
					echo -e "${bold_red}You don't have the build script.${reset}" > /dev/stderr
					printf 'I have downloaded it.\n' > /dev/stderr
					printf 'Personalize it and re-run the start script.\n' > /dev/stderr
					return 3
				fi

				if ! ./build.sh; then
					clear
				fi

				shift
				continue
				;;
			-h | --help)
				__help
				return 0
				;;
			--)
				shift
				break
				;;
			*)
				# shellcheck disable=SC3037
				echo -e "${bold_red}Internal error.${reset}" > /dev/stderr
				return 4
				;;
		esac
	done

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

	docker-compose start
}

__start "$@"
