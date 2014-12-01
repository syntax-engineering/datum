# Flexible data-driven test solution for Rails
#
# Author:: Tyemill
# Copyright:: Copyright (c) 2012 - 2014 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'datum/railtie'
#require "datum/constants"
require "datum/data_container"

class ActiveSupport::TestCase
  def process_scenario scenario_name
    __datum_scenario_handler scenario_name
  end
  def import_scenario scenario_name
    __datum_scenario_handler scenario_name
  end
private
  def __datum_scenario_handler scenario_name
    eval Datum.__datum_read_scenario(scenario_name.to_s)
  end
end

def data_test data_filename, &block
  Datum::DataContainer.new(data_filename.to_s, self).evaluate &block
end
