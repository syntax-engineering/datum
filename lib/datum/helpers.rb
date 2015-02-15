module Datum

# @!visibility private
# Various helper functions
class Helpers
  class << self

    # @param test_name [String] test case name generated from data_test usage
    # @return [int] the index of the data_test / datum_id
    def index_from_test_name test_name
      ((test_name.to_s.split('_')[-1]).to_i)
    end

    # @param test_name [String] test case name generated from data_test usage
    # @return [String] name of the data_test method which generated the test
    def data_method_from_test_name test_name
      test_name.slice(/(?<=_).*(?=_)/)
    end

    # @param data_method_name [String] the name of the data_test method
    # @param counter [int] the index / datum_id of the current test case
    # @return [String] test name for current test case, index, data_test method
    def build_test_name data_method_name, counter
     "test_#{data_method_name}_#{counter}"
    end

    # @param test_instance [TestCase] the ActiveSupport::TestCase instance
    # @param method [String] the name of the method
    # @return [String] a key for usage in Datum-compatible Hash instances
    def build_key test_instance, method
     "#{test_instance}_#{method}"
    end

    # @param file_name [String] the name of the file to read
    # @param directory [Pathname] a Pathname representing the file's directory
    # @param ext [String] optional extention of the file (default: '.rb')
    # @return [String] the file's contents
    def read_file file_name, directory, ext = ".rb"
      File.read directory.join("#{file_name}#{ext}")
    end

    # reads a ruby file and eval's it's contents at the current code location
    # @param file_name [String] the name of the file to import
    # @param directory [Pathname] a Pathname representing the file's directory
    # @param current_binding [Binding] context at a particular code location
    def import_file file_name, directory, current_binding
      eval(read_file(file_name, directory), current_binding)
    end

    # @param resource [ActiveRecord::Base] an ActiveRecord Model instance
    # @param override_hash [Hash] Hash of attributes / values to override from
    # @return [Hash] Hash of attributes from provided resource
    def clone_resource resource, override_hash = nil
      override_hash.nil? ? resource.dup.attributes.with_indifferent_access :
        resource.dup.attributes.merge(
          override_hash.with_indifferent_access).with_indifferent_access
    end
  end
end
end