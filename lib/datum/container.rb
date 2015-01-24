require "datum/helpers"

module Datum
class Container

  attr_reader :data_method, :test_instance, :called_tests, :data

  def initialize(data_method, tst_instance)
    @data_method = data_method
    @test_instance = tst_instance
    @called_tests = []
    @data = []

    ::Datum.containers[data_method.to_sym] = self
    ::Datum.instance_variable_set(:"@current_container", self)
  end

  def count; @data.count; end;

  alias_method :length, :count
  alias_method :size, :count
  alias_method :test_count, :count

private
  def add_datum datum
    data.push datum
    test_name = ::Datum::Helpers.build_data_test_name(data_method, test_count)
    key = ::Datum::Helpers.build_datum_key(test_instance, test_name)
    ::Datum.loaded_data[key] = datum
    ::Datum::Container.send(:"add_data_test", self, test_name)
    [count, test_name, key]
  end

  class << self
  private
    def add_data_test(container, test_method_name)
      container.test_instance.send(:define_method, test_method_name) do
        key = ::Datum::Helpers.build_datum_key(self.class.to_s, __method__)
        @datum = ::Datum.loaded_data[key]
        @datum.container.called_tests.push @datum.datum_id
        self.send(@datum.container.data_method)
      end
    end
  end

end
end
