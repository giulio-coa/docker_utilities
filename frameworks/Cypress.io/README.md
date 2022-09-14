# Guide to use Docker to create a Cypress.io test enviroment and to run tests on it

# Contents
* [Pre-requisites](#pre-requisites)
* [Docker services](#docker-services)
  - [cypress-api](#cypress-api)
  - [cypress-dashboard](#cypress-dashboard)
  - [cypress-director](#cypress-director)
* [Files](#files)
  - [sorry_cypress/.env](#sorrycypressenv)
* [How to see test results](#how-to-see-test-results)

# Pre-requisites
The pre-requisite to use Docker is:
* Find `cypress` installation path
```
  $ DEBUG=cypress:* cypress version

  ...
  # here it is
  cypress:cli Reading binary package.json from: /Users/agoldis/Library/Caches/Cypress/3.4.1/Cypress.app/Contents/Resources/app/package.json +0ms
  ...
```
&emsp;&emsp;&emsp;and change the default dashboard URL
```
  $ cat /Users/agoldis/Library/Caches/Cypress/3.4.1/Cypress.app/Contents/Resources/app/packages/server/config/app.yml

  ...
  # Replace this with a URL of the alternative dashboard
  production:
    # api_url: "https://api.cypress.io/"
    api_url: "http://172.150.5.4:1234/"
  ...
```

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
