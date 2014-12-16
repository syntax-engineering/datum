
require "datum_internal/core"
require "datum/datum_struct"
require "datum_internal/utilities"

class ActiveSupport::TestCase
  def process_scenario scenario_name
    __import(scenario_name)
  end
end

def __import scenario_name
  Utils.import_file(scenario_name, Utils.directories.scenario, binding)
end

def __clone resource, override_hash = nil
  Utils.scenario_clone_resource resource, override_hash
end

def data_test name, &block
  DatumInternal::Core.instance_variable_set(:"@context",
    DatumInternal::Core::DataContext.new(name, self))
  self.send(:define_method, name, &block)
  self.class_eval(DatumInternal::Utilities.read_file(
    name, DatumInternal::Utilities.directories.data))
  DatumInternal::Core.instance_variable_set(:"@context", nil)
end