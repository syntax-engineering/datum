require "datum/helpers"
require "datum/datum_struct"
require "datum/data_context"

def data_test name, &block
  #Datum::DataFile.instance_variable_set(:"@context", Datum::DataContext.new(name, self))
  c = Datum::DataContext.new(name, self)
  self.send(:define_method, name, &block)
  self.class_eval(Datum::Helpers.send(:read_file, name, Datum::Helpers.data_directory))
  #Datum::DataFile.instance_variable_set(:"@context", nil);
end

# Extends ActiveSupport::Test with the process_scenario method
#
# @note supports most extending test types (functional, integration, etc)
#
class ActiveSupport::TestCase
  # imports a scenario file into the context of a test
  def process_scenario scenario_name
    __import(scenario_name)
  end
end

# imports a scenario into an existing scenario or test
def __import scenario_name
  Datum::Helpers.send :import_file, scenario_name, Datum::Helpers.scenario_directory, binding
  #Datum.import_file(scenario_name, Datum.directories.scenario, binding)
end

# clones the attributes of a resource, overriding as directed
def __clone resource, override_hash = nil
  Datum::Helpers.scenario_clone_resource resource, override_hash
  #Datum::Scenario.send :scenario_clone_resource, resource, override_hash
end