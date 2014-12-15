
require "plan9/structures"

module Datum
module Utils
  @@dirs = nil

  DatumDirectories = Plan9::ImmutableStruct.new(:root) do
    def data; root.join('data'); end; def scenario; root.join('scenarios'); end
  end

  def self.directories
    @@dirs ||= DatumDirectories.new(Rails.root.join('test', 'datum'))
  end

  def self.read_file file, directory
    File.read directory.join("#{file}.rb")
  end

  def self.import_file name, directory, current_binding
    eval(read_file(name, directory), current_binding)
  end

  def self.scenario_clone_resource resource, override_hash = nil
    override_hash.nil? ?
      resource.dup.attributes.with_indifferent_access :
      resource.dup.attributes.merge(
        override_hash.with_indifferent_access).with_indifferent_access
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

end
end