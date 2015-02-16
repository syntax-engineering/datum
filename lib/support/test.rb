require "datum/helpers"
require "datum/container"
require "datum/datum"

# Adds the process_scenario method to ActiveSupport::TestCase and includes
# the Datum module
# @note Supports most extending test types (functional, integration, etc)
# @example Making a Scenario
#   # test/datum/scenarios/simpsons_scenario.rb
#   # any code included in this file gets loaded when calling process_scenario
#   @homer = Person.create(first_name: "Homer", last_name: "Simpson")
#   @marge = Person.create(__clone(@homer, {first_name: "Marge"}))
# @!method process_scenario(scenario_name)
#   Imports a scenario file into the execution context of the current test
#   @param [Symbol, String] scenario_name The name of a scenario file
#   @return [void]
#   @example Using process_scenario
#     test "should verify basic scenario" do
#       process_scenario :simpsons_scenario
#       assert_not_nil @homer, "process_scenario did not define @homer"
#       assert_not_nil @marge, "process_scenario did not define @marge"
#     end
class ActiveSupport::TestCase
  include Datum

  def process_scenario scenario_name
    __import(scenario_name)
  end
end

# @!method data_test(name, &block)
#   Defines a test to work in conjuction with Datum struct extensions found in
#   a file with the same name in the test/datum/data directory
#   @param [String] name Name of the file in the datum/data directory
#   @param [Block] block A block of Ruby code
#   @return [void]
def data_test name, &block
  ::Datum::Container.new(name, self)
  self.send(:define_method, name, &block)
  self.class_eval(::Datum::Helpers.read_file(name, ::Datum.data_path))
end