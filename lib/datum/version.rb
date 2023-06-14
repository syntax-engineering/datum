# frozen_string_literal: true

module Datum
  # @!visibility private
  VERSION = '4.3.2.2'
end

## 0.8.1 - 0.9.2
## Original datum, proof-of-concept
##
## 4.0.0
## Full rewrite, updated with latest concepts and code -- Still in Testing
##
## 4.0.x
## Several small updates (readme, etc) -- Readme still needs work.
## 4.0.6
## Seems like the build process was dead on arrival? Trying a re-build .7
## 4.0.7
## Does not seem to have fixed the issue. :(
## 4.0.8
## Removing railtie reference
## 4.0.9
## Removing railtie and rake task
## 4.1.0
## Removing files.
## 4.2.0
## Support added for gems.
## 4.3.0
## Add load_scenarios and both test and test class level transactions
## 4.3.1
## Use rails default transactions for test methods. This should make it easier to
## support multiple rails versions.
## 4.3.2
## Test package release workflow
