module Datum
  VERSION = "0.9.1"
end

## 0.8.1
## Added datum:db:verify to simplify detecting pre-release holes in config
## Added tests to formally sign-off datum releases (not complete)
## 0.8.2
## Fixed errors in verification / environment
## 0.8.3
## Added functionality in verification to handle existing datum files
## 0.8.4
## Fixed bug with leftover verification test case.
## 0.8.5
## Fixed bug with pre-existing datum database (verification failed when
## pre-existing store exists)
## 0.8.6
## Fixed migration not observing schema version (regression)
## Updated drop to use connection instead of rake task (unreliable)
## 0.8.7
## Added db:prepare rake task
## 0.9.0
## prepare no longer uses load, instead it uses load_when_empty
## attr_accessor added to datum_version model
## 0.9.1
## TODO: add attr_accessor to generated models
## TODO: look into hooking to the class used by selenium
## TODO: look into round tripping from generated ruby files
## TODO: run_once
## TODO: run_id
## TODO: helper for error_msgs
## TODO: Test cases are still being executed in reverse order