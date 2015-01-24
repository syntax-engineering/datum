module Datum
class Helpers
  @@scenario_directory = @@data_directory = @@datum_directory = nil

  class << self
    def test_to_data_method_with_index(test_name)
      [test_name.slice(/(?<=_).*(?=_)/), ((test_name.to_s.split('_')[-1]).to_i)]
    end

    def data_test_method data_method_name, counter
      "test_#{data_method_name}_#{counter}"
    end

    def datum_key test_instance, data_test_method
      "#{test_instance}_#{data_test_method}"
    end

    def datum_directory
      @@datum_directory ||= Rails.root.join('test', 'datum')
    end

    def data_directory
      @@data_directory ||= datum_directory.join('data')
    end

    def scenario_directory
      @@scenario_directory ||= datum_directory.join('scenarios')
    end

    def read_file file, directory, ext = ".rb"
        File.read directory.join("#{file}#{ext}")
    end

    def import_file name, directory, current_binding
      eval(read_file(name, directory), current_binding)
    end

    def scenario_clone_resource resource, override_hash = nil
      override_hash.nil? ?
        resource.dup.attributes.with_indifferent_access :
        resource.dup.attributes.merge(
          override_hash.with_indifferent_access).with_indifferent_access
    end


  end
end
end