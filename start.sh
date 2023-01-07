#!/bin/bash

#########################################################################
#	Filename:		./start.sh																								#
#	Purpose:		Script that starts a docker-compose project								#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.										#
#	Pre-requisites:																												#
#									* docker-compose																			#
#									* sudo																								#
#########################################################################

### Functions ###
__err() {
  local reset bold_red

  # colors
  reset='\e[0m'
  bold_red='\e[1;31m'

  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: ${bold_red}$@${reset}" > /dev/stderr
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

__help() {
  echo './start.sh [options]'
  echo
  echo 'Options:'
  echo -e '\t-b, --build: Execute the build of the Docker containers'
  echo -e '\t-h, --help: Print this menu'
}

__install_dependencies() {
  if ! command -v curl > /dev/null 2> /dev/null; then
    # Alpine Linux
    if command -v apk > /dev/null 2> /dev/null; then
      sudo apk --quiet --no-cache add curl
    # Debian-based distro
    elif command -v apt > /dev/null 2> /dev/null; then
      sudo apt install --assume-yes --quiet curl
    # MacOS distro
    elif command -v brew > /dev/null 2> /dev/null; then
      sudo brew install curl
    # Fedora
    elif command -v dnf > /dev/null 2> /dev/null; then
      sudo dnf --assumeyes --quiet install curl
    # Gentoo
    elif command -v emerge > /dev/null 2> /dev/null; then
      sudo emerge --quiet y curl
    # Arch Linux
    elif command -v pacman > /dev/null 2> /dev/null; then
      sudo pacman --sync --needed --noconfirm --quiet curl
    fi
  fi

  # On Alpine Linux, some commands are installed in a reduced version
  if command -v apk > /dev/null 2> /dev/null; then
    sudo apk --quiet --no-cache add sed
  fi
}

__start() {
  local options

  if ! command -v docker-compose > /dev/null 2> /dev/null; then
    __err "docker-compose isn't installed"
    return 1
  elif ! command -v sudo > /dev/null 2> /dev/null; then
    __err "sudo isn't installed"
    return 1
  fi

  __install_dependencies

  if ! options=$(getopt --name "$0" --options 'bh' --longoptions 'build,help' -- "$@"); then
    __err 'getopt command has failed'
    return 2
  fi

  eval set -- "${options}"

  while true; do
    case "$1" in
      -b | --build)
        # check if the build script exists and, if not, download it
        if [[ ! -f "$(__get_file build.sh)" ]]; then
          curl \
            --fail \
            --location \
            --output "$(__get_file build.sh)" \
            https://raw.githubusercontent.com/giulio-coa/docker_utilities/master/build.sh \
            2> /dev/null

          chmod 755 "$(__get_file build.sh)"

          __err "You don't have the build script"
          __err 'I have downloaded it'
          __err 'Personalize it and re-run the start script'
          return 3
        fi

        if ! $(__get_file build.sh); then
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
        __err 'Internal error'
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
  COMPOSE_PROJECT_NAME="$(basename "$(dirname "$(__get_file .)")")"

  docker-compose start
}

### Script ###
script_path="$0"

__start "$@"
