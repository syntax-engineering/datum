# Flexible data-driven test solution for Rails
#
# Author:: Tyemill
# Copyright:: Copyright (c) 2012 - 2014 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'datum/railtie'
require "datum/constants"

class ActiveSupport::TestCase
  def process_scenario scenario_name
    scenario_name = scenario_name.to_s
    dir = Rails.root.join('test', 'datum', 'scenarios')
    rd = File.read("#{dir}#{File::Separator}#{scenario_name}.rb")
    eval rd
  end
end

#def define_datum *datum_array

#end

def data_test data_filename, &block
  Datum::DataContainer.new(data_filename.to_s).evaluate &block
end

def import_scenario filename
end

def import_data filename
end

module Datum
  class DataContainer
    attr_reader :filename

    def initialize filename
      @filename = filename
    end

    def directory
      @directory ||= Rails.root.join('test', 'datum', 'data')
    end

    def absolute_path
      @absolute_path ||= "#{directory}#{File::Separator}#{filename}.data"
    end

    def define_datum *datum_array
      datum_hash = datum_array[0]
    end

    def evaluate &block
      ruby = File.read(absolute_path)
      eval ruby
    end
  end
end