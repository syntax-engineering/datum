module DatumInternal
module Core
  def self.context; @context; end;
  class DataContext
    def initialize(data_method, tst_instance)
#      @data_file = DataFile.new(data_method, tst_instance)
    end

    def add_test_case
      i = @data_file.instance_variable_get(:@test_count) + 1
      @data_file.instance_variable_set(:@test_count, i)
      [@data_file, i, data_test_method, datum_key]
    end

    def data_test_method
      DataFile.data_test_method(@data_file.data_method, @data_file.test_count)
    end

    def datum_key
      DataFile.datum_key(@data_file.test_instance, data_test_method)
    end
  end
end
end