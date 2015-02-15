
# For use in a scenario file, imports an existing scenario's code and objects
#
# @param [symbol, String] scenario_name The name of a scenario file
def __import scenario_name
  ::Datum::Helpers.import_file scenario_name, ::Datum.scenario_path, binding
end

# For use in a scenario file, clones the attributes of an existing instance
#
# @example Cloning an Existing Resource
#   # file test/datum/scenarios/clone_example_scenario.rb
#   @marge = Person.create(first_name: "Marge", last_name: "Simpson")
#   @homer = Person.create(__clone(@marge, {first_name: "Homer"}))
#
#   # file test/models/another_person_test.rb
#   test "check name again" do
#     process_scenario :clone_example_scenario
#     assert_equal "Marge", @marge.first_name
#     assert_equal "Homer", @homer.first_name
#    end
#
# @param [ActiveRecord::Base] resource An ActiveRecord Model instance
# @param [Hash] override_hash Hash of attributes / values to override from
# @return [Hash] Hash of attributes from provided resource
def __clone resource, override_hash = nil
  ::Datum::Helpers.clone_resource resource, override_hash
end