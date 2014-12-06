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
    @counter += 1
    test_name = Datum.data_test_name @file_name, @counter
    datum_key = Datum.datum_key @test_instance, test_name
    Datum.loaded_data[datum_key] = datum_structure
    @test_instance.class_eval do
      define_method test_name do
        datum_key = Datum.datum_key(self.class.to_s, __method__)
        @datum = Datum.loaded_data[datum_key]
        self.send @datum.data_method
      end
    end
    @file_name
  end
end
end