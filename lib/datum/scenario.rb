
# imports a scenario into an existing scenario or test
def __import scenario_name
  ::Datum::Helpers.import_file scenario_name, ::Datum.scenario_path, binding
end

# clones the attributes of a resource, overriding as directed
def __clone resource, override_hash = nil
  ::Datum::Helpers.clone_resource resource, override_hash
end