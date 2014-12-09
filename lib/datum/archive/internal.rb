require "plan9/structures"
require "datum/data_loader"

module Datum
  @@dirs, @@loaded_data = nil;

  DatumDirectories = Plan9::ImmutableStruct.new(:root) do
    def data; root.join('data'); end; def scenario; root.join('scenarios'); end
  end

  def self.directories
    @@dirs ||= DatumDirectories.new(Rails.root.join('test', 'datum'))
  end

  def self.loaded_data
    @@loaded_data ||= {}
  end

  def self.read_file file, directory
    File.read directory.join("#{file}.rb")
  end

  def self.scenario_import scenario_name, current_binding
    eval(read_file(scenario_name, directories.scenario), current_binding)
  end

  def self.scenario_clone_resource resource, override_hash = nil
    override_hash.nil? ?
      resource.dup.attributes.with_indifferent_access :
      resource.dup.attributes.merge(
        override_hash.with_indifferent_access).with_indifferent_access
  end

  def self.data_test_name data_name, counter
    "test_#{data_name}_#{counter}"
  end

  def self.datum_key test_instance, data_test_name
    "#{test_instance}##{data_test_name}"
  end
end

