
require "datum/internal"
require "datum/data_loader"
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
  ($datum_data_loader = Datum::DataLoader.new(self, name)).load(&block)
end