
require "datum/datum_struct"
require "datum/utils"

module Datum
  @@data_files, @@loaded_data = nil;
  def self.loaded_data; @@loaded_data ||= {}; end
  def self.data_files; @@data_files ||= {}; end
  def self.context; @context; end;

  #def self.called_data; @@called_data ||= {}; end
  #def self.finished_data; @@called_data ||= {}; end
  #def self.context= ctxt; @context = ctxt; end;

  class DatumContext
    def initialize(data_method, tst_instance)
      @data_file = DataFile.new(data_method, tst_instance)
    end

    def add_test_case
      i = @data_file.instance_variable_get(:@test_count) + 1
      @data_file.instance_variable_set(:@test_count, i)
      [@data_file, i, data_test_method, datum_key]
    end

    def data_test_method
      DataFile.data_test_method(@data_file.data_method, @data_file.test_count)
    end

    def datum_key
      DataFile.datum_key(@data_file.test_instance, data_test_method)
    end
  end

  class DataFile
    attr_reader :data_method, :test_instance, :test_count, :called_tests
    def initialize(data_method, tst_instance)
      @data_method = data_method; @test_instance = tst_instance; @test_count = 0; @called_tests = []
      Datum.data_files[data_method.to_sym] = self
    end

    def self.data_test_method data_method_name, counter
      "test_#{data_method_name}_#{counter}"
    end

    def self.datum_key test_instance, data_test_method
      "#{test_instance}_#{data_test_method}"
    end
  end
end

include Datum

class ActiveSupport::TestCase
  def process_scenario scenario_name
    __import(scenario_name)
  end
end

def __import scenario_name
  Utils.import_file(scenario_name, Utils.directories.scenario, binding)
end

def __clone resource, override_hash = nil
  Utils.scenario_clone_resource resource, override_hash
end

def data_test name, &block
  Datum.instance_variable_set(:"@context", DatumContext.new(name, self))
  self.send(:define_method, name, &block)
  self.class_eval(Utils.read_file(name, Utils.directories.data))
  Datum.instance_variable_set(:"@context", nil)
end