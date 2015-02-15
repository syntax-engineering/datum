
# for use in a scenario file, imports an existing scenario's code and objects
# @param [symbol || String] scenario_name the name of a scenario file
def __import scenario_name
  ::Datum::Helpers.import_file scenario_name, ::Datum.scenario_path, binding
end

# for use in a scenario file, clones the attributes of an existing instance
# @param [ActiveRecord::Base] resource An ActiveRecord Model instance
# @param [Hash] override_hash Hash of attributes / values to override from
# @return [Hash] Hash of attributes from provided resource
def __clone resource, override_hash = nil
  ::Datum::Helpers.clone_resource resource, override_hash
end