
module Datum
  class DataFile
    attr_reader :data_method, :test_instance, :test_count, :called_tests
    def initialize(data_method, tst_instance)
      @data_method = data_method;
      @test_instance = tst_instance;
      @test_count = 0;
      @called_tests = []
      DatumInternal.data_files[data_method.to_sym] = self
    end
  end
end