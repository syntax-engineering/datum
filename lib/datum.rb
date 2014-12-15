
require "datum/internal/core"
require "datum/datum_struct"
require "datum/utils"

module Datum
  def self.core; Datum::Internal::Core; end;
end

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
  Datum.core.instance_variable_set(:"@context",
    Datum.core::DatumContext.new(name, self))
  #self.send(:define_method, name, &block)
  #self.class_eval(Utils.read_file(name, Utils.directories.data))
  #Datum.instance_variable_set(:"@context", nil)
end