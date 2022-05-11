# Guide to use Docker to create a Cypress.io test enviroment and to run tests on it

# Contents
* [Pre-requisites](#pre-requisites)
* [Docker services](#docker-services)
  - [cypress-api](#cypress-api)
  - [cypress-dashboard](#cypress-dashboard)
  - [cypress-director](#cypress-director)
  - [socat](#socat)
* [Files](#files)
  - [sorry_cypress/.env](#sorrycypressenv)
  - [socat/init.sh](#socatinitsh)
* [How to see test results](#how-to-see-test-results)

# Pre-requisites
The pre-requisite to use Docker is:
* Run `sudo -- sh -c -e "echo '127.0.0.1 cypress.rewix.local' >> /etc/hosts"`
* Find `cypress` installation path
```
  $ DEBUG=cypress:* cypress version

  ...
  # here it is
  cypress:cli Reading binary package.json from: /Users/agoldis/Library/Caches/Cypress/3.4.1/Cypress.app/Contents/Resources/app/package.json +0ms
  ...
```
&ensp;&ensp;&ensp;&ensp;&ensp;and change the default dashboard URL
```
  $ cat /Users/agoldis/Library/Caches/Cypress/3.4.1/Cypress.app/Contents/Resources/app/packages/server/config/app.yml

  ...
  # Replace this with a URL of the alternative dashboard
  production:
    # api_url: "https://api.cypress.io/"
    api_url: "http://localhost:4321/"
  ...
```
&ensp;&ensp;&ensp;&ensp;&ensp;**N.B.** `4321` is the port that the `socat` service expose for the `cypress-director` service.

# Docker services
## cypress-api
Docker service that allows to read test run details and results.

## cypress-dashboard
Docker service that generate a web dashboard fro consult the test results.

## cypress-director
Docker service responsibe for parallelization and saving test results.

## socat
Docker service that redirect the HTTP(S) requests to the appropriate services.

# Files
## sorry_cypress/.env
This file provides the enviroment variables to the sorry-cypress containers.

## socat/init.sh
This file provides the Shell Script used by the socat Docker container to redirect the HTTP(S) request to the apposite container.
**N.B.** If you want to add/change some redirects, be careful to run the last one not in the background (without the `&` at the end), otherwise the socat Docker container dies.

# How to see test results
To access to the Cypress.io dashboard and see the test results, go to [cypress.local:6749](http://cypress.local:6749).
