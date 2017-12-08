# provider-directory-api

[![XO code style](https://img.shields.io/badge/code_style-XO-5ed9c7.svg)](https://github.com/sindresorhus/xo)

This repository contains implementation code for the __Provider Directory__ project.

Documentation corresponding to the `dev` branch of this repository can be found [here](https://github.com/medicity/medicity-documentation/tree/dev/provider-directory).

## Directions

1. git clone git@github.com:medicity/provider-directory-api.git
1. cd provider-directory-api
1. npm install
1. npm run start
1. visit http://localhost:3000 in browser

### Running Tests

1. add a file to the `config` folder named `local.js` containing the code below:

        module.exports = {
          mongo: {
            host: 'localhost'
          }
        }

  > This will insure that you run tests against your local mongo instance and avoid concurrency issues with the centralized build
1. run one of the following npm commands
  1. `npm test` (run all tests)
  1. `npm run ava` (run unit tests)
  1. `npm run cuke` (run all cucumber tests)
  1. `npm run cuke-debug` (run all cucumber tests with debug output)
  1. `npm run cuke-feature {path to feature}` (run tests for a specific cucumber feature)

    > e.g. `npm run cuke-feature test/features/zips.feature`
  1. `npm run cuke-feature-debug {path to feature}` (run tests for a specific cucumber feature with debug output)

    > e.g. `npm run cuke-feature-debug test/features/zips.feature`
  1. `npm run cuke -- --name='{scenario name regex}'` (run a specific scenario)

    > e.g. `npm run cuke -- --name='create a client'`
  1. `npm run cuke-debug -- --name='{scenario name regex}'` (run a specific scenario with debug output)

    > e.g. `npm run cuke-debug -- --name='create a client'`
