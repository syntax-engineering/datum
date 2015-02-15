require "datum/helpers"
require "datum/container"
require "datum/datum"

# Extends ActiveSupport::Test with the process_scenario method and includes
# the Datum module
#
# @note Supports most extending test types (functional, integration, etc)
class ActiveSupport::TestCase
  include Datum
  # Imports a scenario file into the execution context of the current test
  #
  # @param [:symbol, String] scenario_name The name of a scenario file
  #
  # @example Process a scenario
  #   test "should check name" do
  #     process_scenario :names_of_various_types
  #     assert_not_nil @scenario_loaded_resource.name
  #   end
  #   # process_scenario will look in test/datum/scenarios for the file
  #   # names_of_various_types.rb. That scenario will be processed in the
  #   # execution context of this test. For the purposes of this example,
  #   # the scenario would contain the following:
  #   #  @scenario_loaded_resource = OpenStruct.new name: "John Smith"
  #
  def process_scenario scenario_name
    __import(scenario_name)
  end
end

# Defines a test to work in conjuction with Datum struct extensions found in
# a file with the same name in the test/datum/data directory
#
# @param [String] name Name of the file in the datum/data directory
# @param [Block] block A block of Ruby code
def data_test name, &block
  ::Datum::Container.new(name, self)
  self.send(:define_method, name, &block)
  self.class_eval(::Datum::Helpers.read_file(name, ::Datum.data_path))
end