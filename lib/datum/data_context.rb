module Datum
class DataContext

    @@data_files, @@loaded_data = nil
    attr_reader :data_method, :test_instance, :test_count, :called_tests
    def self.data_files; @@data_files ||= {}; end

    def initialize(data_method, tst_instance)
      #@data_file = Datum::DataFile.new(data_method, tst_instance)
      @data_method = data_method;
      @test_instance = tst_instance;
      @test_count = 0;
      @called_tests = []
      DataContext.data_files[data_method.to_sym] = self
      DataContext.instance_variable_set(:"@context", self)
    end

    def add_test_case
      @test_count += 1
      [self, @test_count, data_test_method, datum_key]
    end

private
    def data_test_method
      Datum::Helpers.data_test_method(data_method, test_count)
    end

    def datum_key
      Datum::Helpers.datum_key(test_instance, data_test_method)
    end

    class << self
    private
      def context; @context; end;
      def loaded_data; @@loaded_data ||= {}; end


    end

end
end
