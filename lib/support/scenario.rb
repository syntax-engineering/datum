
# For use in a scenario file, imports an existing scenario's code and objects
#
# @example Import an Existing Scenario
#   ## file test/datum/scenarios/original_scenario.rb
#   @clancy = Person.create(
#     first_name: "Clancy",
#     last_name: "Wiggum")
#
#   ## file test/datum/scenarios/example_scenario.rb
#   @marge = Person.create(
#     first_name: "Marge",
#     last_name: "Simpson")
#
#   __import :original_scenario # will give this scenario access to @clancy
#
#   ## file test/models/person_test.rb
#   test "check name" do
#     process_scenario :example_scenario
#     assert_not_nil @marge.first_name # from example_scenario
#     assert_not_nil @clancy.first_name # from original_scenario (imported)
#   end
#
# @param [:symbol, String] scenario_name The name of a scenario file
def __import scenario_name
  ::Datum::Helpers.import_file scenario_name, ::Datum.scenario_path, binding
end

# For use in a scenario file, clones the attributes of an existing instance
# @param [ActiveRecord::Base] resource An ActiveRecord Model instance
# @param [Hash] override_hash Hash of attributes / values to override from
# @return [Hash] Hash of attributes from provided resource
def __clone resource, override_hash = nil
  ::Datum::Helpers.clone_resource resource, override_hash
end