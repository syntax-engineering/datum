
require "datum/internal"
require "datum/datum_struct"

class ActiveSupport::TestCase
  def process_scenario scenario_name
    __import(scenario_name)
  end
end

def __import scenario_name
  Datum.scenario_import(scenario_name, binding)
end

def __clone resource, override_hash = nil
  Datum.scenario_clone_resource resource, override_hash
end

def data_test name, &block
  $datum_test_case = self
  build = @datum_data_method.nil? ? true : false
  @datum_data_method = name
  Datum.add_methods(build, self, name, &block)
  eval Datum.read_file(name, Datum.directories.data)
end