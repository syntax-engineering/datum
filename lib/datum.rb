# Flexible data-driven test solution for Rails
#
# Author:: Tyemill
# Copyright:: Copyright (c) 2012 - 2014 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'datum/railtie'
require "datum/data_container"
require "datum/structures"
require "scenario"

def data_test data_filename, &block
  Datum::DataContainer.new(data_filename.to_s, self).evaluate &block
end