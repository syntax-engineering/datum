# Flexible data-driven test solution for Rails
#
# Author:: Tyemill
# Copyright:: Copyright (c) 2012 - 2014 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)
#
# Extension for ActiveSupport::TestCase


class ActiveSupport::TestCase
  def process_scenario scenario_name
    Scenario.import scenario_name, binding
  end
end

