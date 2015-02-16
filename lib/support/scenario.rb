
# From a scenario file, imports an existing scenario's code into the current
# Binding context of the current scenario.
#
# @param [Symbol, String] scenario_name The name of a scenario file
# @return [void]
#
# @example Using __import
#   # test/datum/scenarios/springfield_police_scenario.rb
#   @clancy = Person.create(first_name: "Clancy", last_name: "Wiggum")
#   @eddie = Person.create(first_name: "Eddie", last_name: "Police-Officer")
#
#   # test/datum/scenarios/extended_simpsons_scenario.rb
#   @homer = Person.create(first_name: "Homer", last_name: "Simpson")
#   @marge = Person.create(__clone(@homer, {first_name: "Marge"}))
#   @bart = Person.create(__clone(@homer, {first_name: "Marge"}))
#
#   __import :springfield_police_scenario # will give us clancy, eddie
#
#   # Using @eddie from imported :springfield_police_scenario to
#   # define @lou's last_name
#   @lou = Person.create first_name: "Lou", last_name: @eddie.last_name
def __import scenario_name
  ::Datum::Helpers.import_file scenario_name, ::Datum.scenario_path, binding
end

# From a scenario file, clones the attributes of an existing instance and
# overrides as specified.
#
# @param [ActiveRecord::Base] resource An ActiveRecord Model instance
# @param [Hash] override_hash Hash of attributes / values to override from
#
# @return [Hash] Hash of attributes from provided resource
#
# @example Using __clone
#   # test/datum/scenarios/simpsons_scenario.rb
#   # any code included in this file gets loaded when calling process_scenario
#   @homer = Person.create(first_name: "Homer", last_name: "Simpson")
#   @marge = Person.create(__clone(@homer, {first_name: "Marge"}))
def __clone resource, override_hash = nil
  ::Datum::Helpers.clone_resource resource, override_hash
end