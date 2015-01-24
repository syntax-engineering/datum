module Datum
class Helpers
  class << self
    def test_to_data_method_with_index(test_name)
     [test_name.slice(/(?<=_).*(?=_)/), ((test_name.to_s.split('_')[-1]).to_i)]
    end

    def build_data_test_name data_method_name, counter
     "test_#{data_method_name}_#{counter}"
    end

    def build_datum_key test_instance, data_test_method
     "#{test_instance}_#{data_test_method}"
    end

    def read_file file, directory, ext = ".rb"
      File.read directory.join("#{file}#{ext}")
    end

    def import_file name, directory, current_binding
      eval(read_file(name, directory), current_binding)
    end

    def clone_resource resource, override_hash = nil
      override_hash.nil? ? resource.dup.attributes.with_indifferent_access :
        resource.dup.attributes.merge(
          override_hash.with_indifferent_access).with_indifferent_access
    end
  end
end
end