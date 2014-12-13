
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

  #def self.data_test_name data_name, counter
  #  "test_#{data_name}_#{counter}"
  #end

  def self.add_datum_test_case datum_structure
    puts "add called"
    return
    # datum_test_name = data_test_name DatumStruct.data_method, datum_structure.test_case_count
    # DatumStruct.test_case.instance_variable_set(:"@#{datum_test_name}", datum_structure)
    # DatumStruct.test_case.class_eval do
    #   define_method datum_test_name do
    #     @datum = DatumStruct.test_case.instance_variable_get(:"@#{__method__.to_s}")
    #     self.send(@datum.datum_data_method)
    #   end
    # end
  end

end
end