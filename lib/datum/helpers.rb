module Datum

# @!visibility private
# Various helper functions
class Helpers
  class << self
    # @!visibility private
    # @param [String] test_name Test case name generated from data_test usage
    # @return [int] The index of the data_test / datum_id
    def index_from_test_name test_name
      ((test_name.to_s.split('_')[-1]).to_i)
    end

    # @param [String] test_name Test case name generated from data_test usage
    # @return [String] Name of the data_test method which generated the test
    def data_method_from_test_name test_name
      test_name.slice(/(?<=_).*(?=_)/)
    end

    # @param [String] data_method_name The name of the data_test method
    # @param [int] counter The index / datum_id of the current test case
    # @return [String] Test name for current test case, index, data_test method
    def build_test_name data_method_name, counter
     "test_#{data_method_name}_#{counter}"
    end

    # @param [TestCase] test_instance The ActiveSupport::TestCase instance
    # @param [String] method The name of the method
    # @return [String] A key for usage in Datum-compatible Hash instances
    def build_key test_instance, method
     "#{test_instance}_#{method}"
    end

    # @param [String] file_name The name of the file to read
    # @param [Pathname] directory A Pathname representing the file's directory
    # @param [String] ext Optional extention of the file (default: '.rb')
    # @return [String] The file's contents
    def read_file file_name, directory, ext = ".rb"
      File.read directory.join("#{file_name}#{ext}")
    end

    # Reads a ruby file and eval's it's contents at the current code location
    #
    # @param [String] file_name The name of the file to import
    # @param [Pathname] directory A Pathname representing the file's directory
    # @param [Binding] current_binding Context at a particular code location
    def import_file file_name, directory, current_binding
      eval(read_file(file_name, directory), current_binding)
    end

    # @param [ActiveRecord::Base] resource An ActiveRecord Model instance
    # @param [Hash] override_hash Hash of attributes / values to override from
    # @return [Hash] Hash of attributes from provided resource
    def clone_resource resource, override_hash = nil
      override_hash.nil? ? resource.dup.attributes.with_indifferent_access :
        resource.dup.attributes.merge(
          override_hash.with_indifferent_access).with_indifferent_access
    end
  end
end
end