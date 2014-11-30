# Flexible data-driven test solution for Rails
#
# Author:: Tyemill
# Copyright:: Copyright (c) 2012 - 2014 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'datum/railtie'
require "datum/constants"
require "datum/file_helper"
require "datum/datum_helper"

# Enables ActiveSupport::TestCase and all extensions
class ActiveSupport::TestCase
  def process_scenario scenario_name
    Datum::FileHelper.parse scenario_name, self
  end
end

def data_test data_filename, &block
  Datum::DatumHelper.build_testcases data_filename, self, &block
end

def import_scenario filename
  return File.read(Datum::FileHelper.resolve_scenario_path(filename))
end

def import_data filename
  return File.read(Datum::FileHelper.resolve_data_path(filename))
end

