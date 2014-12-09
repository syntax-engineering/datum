
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

  def self.data_test_name data_name, counter
    "test_#{data_name}_#{counter}"
  end

  def self.datum_key test_instance, data_test_name
    "#{test_instance}_#{data_test_name}"
  end

  def self.test_to_data_method_with_index test_name
    [test_name.slice(/(?<=_).*(?=_)/),
     ((test_name.to_s.split('_')[-1]).to_i) - 1]
  end

  def self.add_datum_structure datum_structure
    tc = DatumStruct.test_case
    data_method = tc.instance_variable_get('@datum_data_method')
    d = Datum.loaded_data[key = datum_key(tc, data_method)]
    method_cases = d.nil? ? Datum.loaded_data[key] = [] : d
    method_cases.push(datum_structure)
    [data_method, method_cases.length, add_datum_test(tc,
      data_test_name(data_method, method_cases.length))]
  end

  def self.add_datum_test test_case, test_name
    test_case.class_eval do
      define_method test_name do
        data_name, index = Utils.test_to_data_method_with_index(method_name)
        @datum = Datum.loaded_data[Utils.datum_key(self.class.to_s,
            data_name)][index]
        self.send(@datum.datum_data_method)
      end
    end
    test_name
  end
end
end