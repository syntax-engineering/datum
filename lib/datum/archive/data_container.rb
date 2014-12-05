module Datum

DatumInfo = Struct.new(:id, :data_method, :test_name)

def self.directory
  @@datum_data_dir ||=
  Rails.root.join('test', 'datum', 'data').to_s + File::Separator
end

def self.read file
  File.read("#{directory}#{file}.rb")
end

def self.do_call d
  puts "To Call: #{d}"
end

def self.data_container
  @data_container ||= {}
end

#def self.reusable_struct const, value
#  self.class.send(:remove_const, const) if self.class.const_defined? const
#  self.class.const_set const, value
#end

class DataContainer
  attr_reader :filename, :testcase

  def initialize filename, tstcase
    #@filename = filename; @testcase = tstcase; @data = {}; @imports = []
    #$datum_data_container = self
    #self.class.constants.each {|c| self.class.send(:remove_const, c)}
  end

  def data; @data.length == 0 ? nil : @data; end

  def evaluate &block
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ in evaluate"
    eval Datum.read(filename)
    @imports = nil
    return if data.nil?
    testcase.send(:define_method, filename.to_sym, &block)
    add_test_cases
  end

private

  #nodoc
  def add_test_cases &block
    #x = "this is strange"
    data.each_with_index { |d, i|
    testcase.send(:define_method, "test_#{filename}_#{i + 1}") do
      x = __method__

      #puts "in test file: #{self.class.to_s}"
      #puts "in test case: #{x}"
      @container = Datum.data_container[self.class.to_s]
      #puts "data is: #{@container.data.inspect}"

      #puts "My Datum is: #{container.data[x.to_s]}"

    end
    }
  end

  #nodoc
  def add_datum_structure open_struct
    t = "test_#{filename}_#{@data.length + 1}"
    tf = testcase.to_s
    Datum.data_container[tf] = self #unless Datum.data_container.has_key?(tf)
    @data[t] = open_struct

    puts "-- In add_datum_structure ----------"
    puts "-- test file is: #{tf}"
    puts "-- test case is: #{t}"
    puts "-- struct is: #{open_struct}"

    return DatumInfo.new(@data.length, filename, t)
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
  # def merge_standard_entries original, override = nil, index = nil
  #   i = index.nil? ? @data.length + 1 : index
  #   h = original.merge({id: i, datum_label: i.to_s, data_method: filename,
  #     test_method: "test_#{filename}_#{i}"})
  #   h = h.merge(override) unless override.nil?
  #   return h
  # end

end
end