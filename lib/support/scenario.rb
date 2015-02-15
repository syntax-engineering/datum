
# for use in a scenario file, imports an existing scenario's code and objects
# @param scenario_name (Symbol) the name of a scenario file
def __import scenario_name
  ::Datum::Helpers.import_file scenario_name, ::Datum.scenario_path, binding
end

# for use in a scenario file, clones the attributes of an existing instance
# @param resource [ActiveRecord::Base] an ActiveRecord Model instance
# @param override_hash [Hash] Hash of attributes / values to override from
# @return [Hash] Hash of attributes from provided resource
def __clone resource, override_hash = nil
  ::Datum::Helpers.clone_resource resource, override_hash
end