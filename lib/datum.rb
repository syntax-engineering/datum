
require "datum/datum_struct"
require "datum/utils"

module Datum
  @@loaded_data = nil

  def self.loaded_data
    @@loaded_data ||= {}
  end
end

include Datum

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
  DatumStruct.test_case = self
  @datum_data_method = name
  self.send(:define_method, name, &block)
  Utils.import_file(name, Utils.directories.data, binding)
end