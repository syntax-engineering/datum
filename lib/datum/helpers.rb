module Datum
class Helpers
  class << self
    def index_from_test_name test_name
      ((test_name.to_s.split('_')[-1]).to_i)
    end

    def data_method_from_test_name test_name
      test_name.slice(/(?<=_).*(?=_)/)
    end

    #def test_to_data_method_with_index(test_name)
    # [data_method_from_test_name, index_from_test_name(test_name)]
    #end

    def build_test_name data_method_name, counter
     "test_#{data_method_name}_#{counter}"
    end

    def build_key test_instance, method
     "#{test_instance}_#{method}"
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