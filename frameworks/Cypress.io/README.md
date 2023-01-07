# Guide to use Docker to create a Cypress.io test enviroment and to run tests on it

# Contents
* [Docker services](#docker-services)
  - [cypress-api](#cypress-api)
  - [cypress-dashboard](#cypress-dashboard)
  - [cypress-director](#cypress-director)
* [Files](#files)
  - [sorry_cypress/.env](#sorrycypressenv)
* [How to see test results](#how-to-see-test-results)

# Docker services
## cypress-api
Docker service that allows to read test run details and results.

## cypress-dashboard
Docker service that generate a web dashboard fro consult the test results.

## cypress-director
Docker service responsibe for parallelization and saving test results.

# Files
## sorry_cypress/.env
This file provides the enviroment variables to the sorry-cypress containers.

# How to see test results
To access to the Cypress.io dashboard and see the test results, go to [`172.150.0.2:6749`](http://172.150.0.2:6749/).
