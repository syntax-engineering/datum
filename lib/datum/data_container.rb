module Datum

DatumInfo = Struct.new(:id, :data_method, :test_name)

def self.directory
  @@datum_data_dir ||=
  Rails.root.join('test', 'datum', 'data').to_s + File::Separator
end

def self.read file
  File.read("#{directory}#{file}.rb")
end

#def self.reusable_struct const, value
#  self.class.send(:remove_const, const) if self.class.const_defined? const
#  self.class.const_set const, value
#end

class DataContainer
  attr_reader :filename, :testcase

  def initialize filename, tstcase
    @filename = filename; @testcase = tstcase; @data = []; @imports = []
    $datum_data_container = self
    self.class.constants.each {|c| self.class.send(:remove_const, c)}
  end

  def data; @data.length == 0 ? nil : @data; end

  def evaluate &block
    eval Datum.read(filename)
    @imports = nil
    return if data.nil?
    testcase.send(:define_method, filename.to_sym, &block)
    add_test_cases
  end

private

  #nodoc
  def add_test_cases
    data.each_with_index { |d, i|
    testcase.send(:define_method, "test_#{filename}_#{i + 1}") do
      @datum = $datum_data_container.data[i]
      send @datum.datum_info.data_method
    end
    }
  end

  #nodoc
  def add_datum_structure open_struct
    @data.push(open_struct)
    return DatumInfo.new(
      @data.length, filename, "test_#{filename}_#{@data.length}")
  end

  #nodoc
  def import_data filename
    ap = "#{Datum.directory}#{filename}.rb"
    unless @imports.include? ap
      @imports.push ap
      eval Datum.read filename
    end
  end

  #nodoc
  #def define_datum hash
  #  @data.push(merge_standard_entries hash)
  #end

  #nodoc
  def merge_standard_entries original, override = nil, index = nil
    i = index.nil? ? @data.length + 1 : index
    h = original.merge({id: i, datum_label: i.to_s, data_method: filename,
      test_method: "test_#{filename}_#{i}"})
    h = h.merge(override) unless override.nil?
    return h
  end

end
end