require "datum/helpers"
require "datum/container"
require "datum/datum"

# Adds the process_scenario method to ActiveSupport::TestCase and includes
# the Datum module
# @note Supports most extending test types (functional, integration, etc)
class ActiveSupport::TestCase
  include Datum

  # Imports a scenario file into the execution context of the current test
  #
  # @param [String] scenario_name The name of a scenario file
  # @return [String] The return value
  def process_scenario scenario_name
    __import(scenario_name)
  end
end

# Defines a test to work in conjuction with Datum struct extensions found in
# a file with the same name in the test/datum/data directory
# @param [String] name Name of the file in the datum/data directory
# @param [Block] block A block of Ruby code
def data_test name, &block
  ::Datum::Container.new(name, self)
  self.send(:define_method, name, &block)
  self.class_eval(::Datum::Helpers.read_file(name, ::Datum.data_path))
end