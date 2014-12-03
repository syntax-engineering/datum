# Flexible data-driven test solution for Rails
#
# Author:: Tyemill
# Copyright:: Copyright (c) 2012 - 2014 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'datum/railtie'
require "datum/data_container"
require "datum/structures"


class ActiveSupport::TestCase
  def process_scenario scenario_name
    __datum_scenario_handler scenario_name
  end
  def import_scenario scenario_name
    __datum_scenario_handler scenario_name
  end
  def clone_resource active_record_resource, hash = nil
    return active_record_resource.dup.attributes.merge(hash) unless hash.nil?
    return active_record_resource.dup.attributes
  end

private
  def __datum_scenario_handler scenario_name
    eval Datum.read_scenario(scenario_name.to_s)
  end
end

def data_test data_filename, &block
  Datum::DataContainer.new(data_filename.to_s, self).evaluate &block
end

module Datum
  def self.scenario_directory
    @@datum_scenario_dir ||=
    Rails.root.join('test', 'datum', 'scenarios').to_s + File::Separator
  end
  def self.read_scenario file
    File.read("#{scenario_directory}#{file}.rb")
  end
  def self.data_directory
    @@datum_data_dir ||=
    Rails.root.join('test', 'datum', 'data').to_s + File::Separator
  end
  def self.read_data file
    File.read("#{data_directory}#{file}.rb")
  end
end