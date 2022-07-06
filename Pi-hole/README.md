# Guide to use Docker to create a Pi-Hole container

# Contents
* [Docker services](#docker-services)
  - [pihole](#pihole)
* [Files](#files)
  - [.env](#env)
  - [unbound.sh](#unboundsh)
* [Warning](#warning)

# Docker services
## pihole
Docker service that creates Pi-Hole.

# Files
## .env
This file provides the enviroment variables to the pihole containers.

## unbound.sh
Script that installs and configures Unbound in the Docker container to make Pi-Hole a recursive DNS server.

# Warning
This container is created to be a DNS server only. If you want to make it a DHCP server as well, see the [reference](https://github.com/pi-hole/docker-pi-hole#quick-start).