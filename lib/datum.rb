# datum for data-driven testing.
#
# Author:: Gabriel Marius, Tyemill
# Copyright:: Copyright (c) 2013 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'datum/railtie'
require 'datum/scenario_helper'

module Datum
  autoload :ScenarioHelper, 'datum/scenario_helper'
  autoload :TestCase, 'datum/test_case'
  autoload :CtrlrTestCase, 'datum/ctrlr_test_case'
end

class ActiveSupport::TestCase
  include Datum::ScenarioHelper
end