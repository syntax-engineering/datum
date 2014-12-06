module Datum
class DataLoader
  attr_reader :test_instance, :file_name, :counter

  def initialize(tst, file)
    @test_instance = tst; @file_name = file; @counter = 0
    self.class.constants.each {|c| self.class.send(:remove_const, c)}
  end

  def load(&block)
    @test_instance.send(:define_method, @file_name, &block)
    eval Datum.read_file(@file_name, Datum.directories.data)
  end

  def add_structure datum_structure
    test_name, datum_key = prep_for_new_structure
    Datum.loaded_data[datum_key] = datum_structure
    add_test_case test_name
    @file_name
  end
private
  def prep_for_new_structure
    @counter += 1
    test_name = Datum.data_test_name(@file_name, @counter)
    [test_name, Datum.datum_key(@test_instance, test_name)]
  end
  def add_test_case test_name
    @test_instance.class_eval do
      define_method test_name do
        datum_key = Datum.datum_key(self.class.to_s, __method__)
        @datum = Datum.loaded_data[datum_key]
        self.send @datum.data_method
      end
    end
  end
end
end