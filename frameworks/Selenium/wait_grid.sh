#!/bin/bash

#############################################################################
#	Filename:	    	.../wait_grid.sh									                    		#
#	Purpose:	    	Script that wait that the Selenium Grid is ready	        #
#	Authors:		    Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:	    	This file is licensed under the LGPLv3.					        	#
#	Pre-requisites:		    											                        			#
#					        * sudo	    									                    				#
#############################################################################

set -e

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

__help() {
  echo './wait_grid.sh [options] [command [argument[, ...]]]'
  echo
  echo 'Options:'
  echo -e '\t-s <SEC>, --sleep <SEC>: Tells how many seconds the script must wait between two checks'
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

  if ! command -v jq > /dev/null 2> /dev/null; then
    # Alpine Linux
    if command -v apk > /dev/null 2> /dev/null; then
      sudo apk --quiet --no-cache add jq
    # Debian-based distro
    elif command -v apt > /dev/null 2> /dev/null; then
      sudo apt install --assume-yes --quiet jq
    # MacOS distro
    elif command -v brew > /dev/null 2> /dev/null; then
      sudo brew install jq
    # Fedora
    elif command -v dnf > /dev/null 2> /dev/null; then
      sudo dnf --assumeyes --quiet install jq
    # Gentoo
    elif command -v emerge > /dev/null 2> /dev/null; then
      sudo emerge --quiet y jq
    # Arch Linux
    elif command -v pacman > /dev/null 2> /dev/null; then
      sudo pacman --sync --needed --noconfirm --quiet jq
    fi
  fi

  # On Alpine Linux, some commands are installed in a reduced version
  if command -v apk > /dev/null 2> /dev/null; then
    sudo apk --quiet --no-cache add grep
  fi
}

__wait_grid() {
  local options
  local seconds

  if ! command -v sudo > /dev/null 2> /dev/null; then
    __err "sudo isn't installed"
    return 1
  fi

  source "$(__get_file .env)"

  seconds=1

  __install_dependencies

  if ! options=$(getopt --name "$0" --options 'hs:' --longoptions 'help,sleep:' -- "$@"); then
    __err 'getopt command has failed'
    return 2
  fi

  eval set -- "${options}"

  while true; do
    case "$1" in
      -h | --help)
        __help
        return 0
        ;;
      -s | --sleep)
        seconds="$2"

        shift 2
        continue
        ;;
      --)
        shift
        break
        ;;
      *)
        __err 'Internal error'
        return 3
        ;;
    esac
  done

  clear

  while ! curl --silent --show-error --location "${SE_NODE_GRID_URL}/wd/hub/status" 2> /dev/stdout \
    | jq --raw-output '.value.ready' 2> /dev/stdout \
    | grep 'true' > /dev/null; do
    sleep "${seconds}"
  done

  exec "$@"
}

### Script ###
script_path="$0"

__wait_grid "$@"
