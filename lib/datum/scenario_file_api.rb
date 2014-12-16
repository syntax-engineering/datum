require "datum_internal/utilities"

def __import scenario_name
  DatumInternal::Utilities.import_file(scenario_name,
    DatumInternal::Utilities.directories.scenario, binding)
end

def __clone resource, override_hash = nil
  DatumInternal::Utilities.scenario_clone_resource resource, override_hash
end