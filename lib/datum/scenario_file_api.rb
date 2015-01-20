

def __import scenario_name
  Datum.send :import_file, scenario_name, Datum.directories.scenario, binding
  #Datum.import_file(scenario_name, Datum.directories.scenario, binding)
end

def __clone resource, override_hash = nil
  Datum.scenario_clone_resource resource, override_hash
end