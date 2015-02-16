require "datum/helpers"

module Datum
# A Container holds attributes for a single data test.
#
# A data_test definition references a specific file in test/datum/data. When
# the data file is loaded, each Datum created is associated with a Container
# which in-turn is associated with the data_test.
#
# Container references are stored in Datum::containers
class Container

  # @!attribute [r] data_method_name
  # The name of the data test method
  # @return [String]
  attr_reader :data_method_name

  # @!attribute [r] test_instance
  # The ActiveSupport::TestCase instance of the data test
  # @return [ActiveSupport::TestCase]
  attr_reader :test_instance

  # @!attribute [r] count
  # The total number of test cases generated for the data method
  # @return [Fixnum]
  def count; @loaded_data.count + @invoked_data.count; end;

  # @!attribute [r] data
  # A Hash of data elements, datum structs for the test case
  # @return [Hash]
  def data; @loaded_data.merge(@invoked_data); end

  alias_method :length, :count
  alias_method :size, :count
  alias_method :test_count, :count

  # @!visibility private
  # Creates a Hash key formatted for use with a Container.
  # @param [TestCase] tst_instance The TestCase instance for the data_test
  # @param [String] data_method_name The name of the data_test method
  # @return [String]
  def self.key tst_instance, data_method_name
    Helpers.build_key(tst_instance, data_method_name)
  end

  # @!visibility private
  # @param [String] data_method_name The name of test method to be called
  # @param [TestCase] tst_instance The instance containing the data_method_name
  def initialize(data_method_name, tst_instance)
    @data_method_name = data_method_name; @test_instance = tst_instance
    @loaded_data = {}; @invoked_data = {}
    ::Datum.send(:add_container, self,
      Container.key(@test_instance, @data_method_name))
  end

private

  def add_datum datum
    test_name = Helpers.build_test_name(data_method_name, test_count + 1)
    @loaded_data[Datum.key(test_instance, test_name)] = datum
    add_data_test test_name
    [count, test_name]
  end

  def invoke_datum key, tst_case
    @invoked_data[key] = datum = @loaded_data.delete(key)
    tst_case.instance_variable_set :@datum, datum
    tst_case.send datum.container.data_method_name
  end

  def add_data_test test_name
    test_instance.send(:define_method, test_name) do
      datum_key = Datum.key(nm = self.class.to_s, __method__)
      container_key = Container.key(nm,
        Helpers.data_method_from_test_name(__method__))
      ::Datum.containers[container_key].send(:invoke_datum, datum_key, self)
    end
  end

end
end
