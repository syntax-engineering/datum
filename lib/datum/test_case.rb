

require "datum/helpers"
require "datum/container"
require "datum/datum"

# Extends ActiveSupport::Test with the process_scenario method
#
# @note supports most extending test types (functional, integration, etc)
#
class ActiveSupport::TestCase
  include Datum
  # imports a scenario file into the context of a test
  def process_scenario scenario_name
    __import(scenario_name)
  end
end

def data_test name, &block
  ::Datum::Container.new(name, self)
  self.send(:define_method, name, &block)
  self.class_eval(::Datum::Helpers.read_file(name, ::Datum.data_path))
end