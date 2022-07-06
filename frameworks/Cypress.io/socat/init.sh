#!/bin/sh

#########################################################################################
#	Filename:		.../init.sh															#
#	Purpose:		Script that redirect the HTTP request to the opportune containers	#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>			#
#	License:		This file is licensed under the LGPLv3.								#
#########################################################################################

# If you want to add/change some redirects, be careful to run the last one not in the background
# (without the `&` at the end), otherwise the socat Docker container dies.

socat TCP4-LISTEN:4321,fork TCP4:cypress-director:1234 &
echo "[INFO]: I redirect port 4321 to cypress-director:1234"

echo "[INFO]: I'm redirecting port 15034 to cypress-db:27017"
socat TCP4-LISTEN:15034,fork TCP4:cypress-db:27017
