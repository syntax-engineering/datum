




# Extends ActiveSupport::Test with the process_scenario method
#
# @note supports most extending test types (functional, integration, etc)
#
class ActiveSupport::TestCase
  # imports a scenario file into the context of a test
  def process_scenario scenario_name
    __import(scenario_name)
  end
end

# imports a scenario into an existing scenario or test
def __import scenario_name
  Datum::DataContext.send :import_file, scenario_name, Datum::Helpers.scenario_directory, binding
  #Datum.import_file(scenario_name, Datum.directories.scenario, binding)
end

# clones the attributes of a resource, overriding as directed
def __clone resource, override_hash = nil
  Datum::Scenario.send :scenario_clone_resource, resource, override_hash
end

module Datum
module Scenario
  class << self
  private
    def scenario_clone_resource resource, override_hash = nil
      override_hash.nil? ?
        resource.dup.attributes.with_indifferent_access :
        resource.dup.attributes.merge(
          override_hash.with_indifferent_access).with_indifferent_access
    end
  end
end
end