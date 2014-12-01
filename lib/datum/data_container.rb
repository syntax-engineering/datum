module Datum
  def self.__datum_scenario_dir
    @@datum_scenario_dir ||=
    Rails.root.join('test', 'datum', 'scenarios').to_s + File::Separator
  end
  def self.__datum_read_scenario file
    File.read("#{__datum_scenario_dir}#{file}.rb")
  end
class DataContainer
  attr_reader :filename, :testcase

  #def self.import filename
  #  @@datum_ruby_buffer =
  #  DataContainer.read(DataContainer.build_absolute_path(filename))
  #  return @@datum_ruby_buffer
  #end

  def self.build_absolute_path filename
    "#{DataContainer.directory}#{filename}.rb"
  end

  def initialize filename, tstcase
    @filename = filename; @testcase = tstcase; @data = {}
  end

  def self.directory
    @@directory ||= (Rails.root.join('test', 'datum', 'data')).to_s +
    File::Separator
  end

  def absolute_path ##{File::Separator}
    @absolute_path ||= DataContainer.build_absolute_path filename
  end

  def data
    @data.length == 0 ? nil : @data
  end

  def self.read absolute_path
    File.read(absolute_path)
  end

  def evaluate &block
    ruby = DataContainer.read absolute_path
    eval ruby
    @imports = nil
    return if data.nil?
    testcase.send(:define_method, filename.to_sym, &block)
    i = 1
    data.each_pair { |key, datum|
      tst = "test_#{filename}_#{i}"
      datum["id"] = i
      datum["method"] = filename
      datum["datum_label"] = key
      datum["data_cases"] = data.length
      #send :define_method, tst.to_sym do
      testcase.send(:define_method, tst.to_sym) do
        @datum = Datum::DataContainer.build_datum datum
        send @datum.method
      end
      i += 1
    }
  end
private

  def data_import filename
    ap = DataContainer.build_absolute_path(filename)
    @imports = [] if @imports.nil?
    unless @imports.include? ap
      @imports.push ap
      eval DataContainer.read(ap)
    end
  end

  def define_datum *datum_array
    if datum_array[0].is_a?(Hash)
      @data[(@data.length + 1).to_s] = datum_array[0]
    elsif datum_array[1].is_a?(Hash)
      @data[datum_array[0].to_s] = datum_array[1]
    else
     raise "Unknown data entry in #{absolute_path} :: #{datum_array.inspect}"
    end
  end

  def self.build_datum datum #, iteration, length
    a_datum = Object.new

    a_datum.instance_variable_set(:@attributes, {})
    a_datum.class.send :define_method, :attributes do
      eval("@attributes")
    end

    datum.each_pair {|key, value|
      Datum::DataContainer.add_datum_attribute key, value, a_datum
      a_datum.attributes[key] = value
    }

    return a_datum
  end

  def self.add_datum_attribute(ext, instance, obj)
    method_symbol = ext.to_sym
    cls_var_str = "@" + ext.to_s
    obj.instance_variable_set(cls_var_str.to_sym, instance)
    obj.class.send :define_method, method_symbol do
      val = eval("#{cls_var_str}")
      return nil if val == ""
      return val unless val.is_a? String
      return val.to_i if val.to_i.to_s == val
      return val
    end
  end

end
end