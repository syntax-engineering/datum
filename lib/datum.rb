
#require "datum_internal/utilities"
#require "datum_internal/internals"
#require "datum_internal/data_context"

require "datum/datum_struct"
require "datum/datum_directories"
require "datum/data_file"
require "datum/test_case_extension"
require "datum/scenario_file_api"
require "datum/data_test"

module Datum
  @@data_files, @@loaded_data, @@dirs = nil


  def self.data_files; @@data_files ||= {}; end

  def self.directories
    @@dirs ||= Datum::DatumDirectories.new(Rails.root.join('test', 'datum'))
  end

  def self.test_to_data_method_with_index(test_name)
    [test_name.slice(/(?<=_).*(?=_)/), ((test_name.to_s.split('_')[-1]).to_i)]
  end

  def self.data_test_method data_method_name, counter
    "test_#{data_method_name}_#{counter}"
  end

  def self.datum_key test_instance, data_test_method
    "#{test_instance}_#{data_test_method}"
  end

  def self.scenario_clone_resource resource, override_hash = nil
    override_hash.nil? ?
      resource.dup.attributes.with_indifferent_access :
      resource.dup.attributes.merge(
        override_hash.with_indifferent_access).with_indifferent_access
  end

  class << self
  private
    def self.context; @context; end;
    def self.loaded_data; @@loaded_data ||= {}; end

    def read_file file, directory, ext = ".rb"
      File.read directory.join("#{file}#{ext}")
    end

    def import_file name, directory, current_binding
      eval(read_file(name, directory), current_binding)
    end



  end
end