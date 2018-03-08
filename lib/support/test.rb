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

  def after_setup
    process_scenarios @@queued_scenarios
    super
  end

  def queue_scenario scenario_name
    @@queued_scenarios = [] if @@queued_scenarios.nil?
    @@queued_scenarios << scenario_name
  end

  def process_scenario scenario_name, use_db_transaction = false
    if use_db_transaction
      ActiveRecord::Base.transaction do
        __import(scenario_name)
      end
    else
      __import(scenario_name)
    end
  end

  def process_scenarios scenarios
    unless scenarios.blank?
      ActiveRecord::Base.transaction do
        scenarios.each do |scenario_name|
          process_scenario scenario_name
        end
      end
    end
    scenarios = []
  end
end

# Defines a test to work in conjuction with Datum struct extensions found in
# a file with the same name in the test/datum/data directory
#
# @param [String] name Name of the file in the datum/data directory
# @param [Block] block A block of Ruby code
#
# @return [void]
#
# @example Defining a data_test
#   # test/datum/data/simple_person_data.rb
#
#   # first, define a sub-class of Datum to use in your test
#   PersonData = Datum.new(:first_name, :last_name, :name, :short_name)
#
#   # next, use your sub-class to create datasets which will be accessible to
#   # your data_test as @datum
#   #
#   # your data can be generated, etc... here, we're keeping it simple
#   homer = PersonData.new("Homer", "Simpson", "Homer Simpson", "Homer S.")
#   marge = PersonData.new("Marge", homer.last_name,
#     "Marge #{homer.last_name}", "Marge S.")
#
#   # test/datum/scenarios/simpsons_scenario.rb
#
#   @homer = Person.create(first_name: "Homer", last_name: "Simpson")
#   @marge = Person.create(__clone(@homer, {first_name: "Marge"}))
#
#   # test/models/person_test.rb
#   require 'test_helper'
#   class PersonTest < ActiveSupport::TestCase
#
#     # this data method will be called once for each Datum defined in
#     # test/datum/data/simple_person_data.rb
#     #
#     # each time this method is called @datum will reference the current
#     # dataset
#     data_test "simple_person_data" do
#       process_scenario :simpsons_scenario
#       person = self.instance_variable_get("@#{@datum.first_name.downcase}")
#       assert_equal @datum.first_name, person.first_name
#       assert_equal @datum.last_name, person.last_name
#       assert_equal @datum.name, person.name
#       assert_equal @datum.short_name, person.short_name
#     end
#   end
def data_test name, &block
  ::Datum::Container.new(name, self)
  self.send(:define_method, name, &block)
  self.class_eval(::Datum::Helpers.read_file(name, ::Datum.data_path))
end
