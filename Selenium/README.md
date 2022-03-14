# Guide to use Docker to create a Selenium test enviroment and to run tests on it

# Contents
* [Pre-requisites](#pre-requisites)
* [Docker services](#docker-services)
  - [selenium-*](#selenium-)
  - [selenium-*-video](#selenium--video)
  - [selenium-hub](#selenium-hub)
* [Files](#files)
  - [.env](#env)
  - [wait_grid.sh](#waitgridsh)
* [How to see test results](#how-to-see-test-results)

# Pre-requisites
The pre-requisite to use Docker is:
* Run
```
sudo -- sh -c -e "echo '127.0.0.1 selenium.local' >> /etc/hosts"
```

# Docker services
## selenium-*
Docker service that manage the a specific web browser.

## selenium-*-video
Docker service that record the tests runned with that specific web browser.

## selenium-hub
Docker service that responsibe for parallelization and the interconnection of the web browsers.

# Files
## .env
This file provides the enviroment variables to a Selenium node.

## wait_grid.sh
This file provides the Shell script to run commands after the Selenium Grid is ready.

# How to see test results
To access to the Selenium Grid and see the test results, go to [selenium.local:4444](http://selenium.local:4444).
