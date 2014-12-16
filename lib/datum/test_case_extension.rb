
require "datum/scenario_file_api"

# add process_scenario into ActiveSupport::TestCase
#
# @note supports all extending test types (functional, integration, etc)
#
class ActiveSupport::TestCase
  def process_scenario scenario_name
    __import(scenario_name)
  end
end