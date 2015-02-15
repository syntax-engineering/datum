

require "datum/helpers"
require "datum/container"
require "datum/datum"

# Extends ActiveSupport::Test with the process_scenario method
#
# @note supports most extending test types (functional, integration, etc)
class ActiveSupport::TestCase
  include Datum
  # imports a scenario file into the context of current test
  # @param scenario_name (Symbol) the name of a scenario file
  def process_scenario scenario_name
    __import(scenario_name)
  end
end

# Used to define a test to work in conjuction with Datum struct extensions
# found in a file with the same name in the test/datum/data directory
# @param name (String) name of the file in the datum/data directory
# @param block (block) a block of Ruby code
def data_test name, &block
  ::Datum::Container.new(name, self)
  self.send(:define_method, name, &block)
  self.class_eval(::Datum::Helpers.read_file(name, ::Datum.data_path))
end