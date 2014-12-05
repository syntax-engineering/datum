# Flexible data-driven test solution for Rails
#
# Author:: Tyemill
# Copyright:: Copyright (c) 2012 - 2014 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'datum/railtie'
require "datum/structures"
require "scenario"
#DatumInfo = Struct.new(:tst, :name, :list)
module Datum
  @@managed_data = {}; @@directory = nil

  def self.directory
    @@directory ||= Rails.root.join(
      'test', 'datum', 'data').to_s + File::Separator
  end

  def self.read(file); File.read("#{directory}#{file}.rb"); end
  def self.read_datum(key); @@managed_data[key]; end
  def self.add_datum(key, val); @@managed_data[key] = val; end

  class DataManager

    def initialize(tst, file)
      @testcase = tst; @filename = file; @counter = 0
      self.class.constants.each {|c| self.class.send(:remove_const, c)}
    end
    def self.test_name(file, counter);"test_#{file}_#{counter}";end
    def self.datum_key(testcase, test_name); "#{testcase}##{test_name}"; end


    def process(&block)
      @testcase.send(:define_method, @filename, &block)
      eval Datum.read(@filename)
    end

    def add_structure struct
      @counter += 1; nm = DataManager.test_name(@filename, @counter)
      k = DataManager.datum_key(@testcase, nm); Datum.add_datum(k, struct)
      @testcase.class_eval do
        define_method nm do
          full_key = DataManager.datum_key(self.class.to_s, __method__)
          @datum = Datum.read_datum(full_key)
          self.send @datum.data_method
        end
      end
      return @filename
    end

  end

end

def data_test file, &block
  $datum_data_manager = Datum::DataManager.new(self, file)
  $datum_data_manager.process(&block)
end