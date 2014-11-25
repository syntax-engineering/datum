require "datum/datum"
require "datum/scenario"
require "datum/file_parser"
require "datum/utilities"

module Datum
module Extensions
module TestHelper
  #attr_reader :datum

  def process_scenario scenario_name
    s = Scenario.new(scenario_name, self)
    s.parse
  end

  def __datum_scenario_callback(ext, instance)
    add_instance_extension ext, instance
    add_singleton ext, ActiveSupport::TestCase, instance
  end

private
  def add_singleton(ext, klass, instance)
    method_symbol = ext.to_sym
    klass.define_singleton_method(method_symbol) do
      return instance
    end
  end

  def add_instance_extension(ext, instance)
    method_name = ext.to_sym
    self.class.send :define_method, method_name do
      return instance
    end
  end
end
end
end

# Added to enable a global method per label
def construct_datum label, hash
  o = build_datum hash
  Object.send(:define_method, label) do
    o
  end
end

def build_datum h #, iteration, length
  a_datum = Object.new
  h.each_pair {|key, value|
    addDatumAttribute key, value, a_datum
  }
  return a_datum
end

def addDatumAttribute(ext, instance, obj)
  method_symbol = ext.to_sym # so that this works with strs & syms
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



# Utilities.construct_datum(label, attribute_hash)
def datum_test data_filename, &block
  data_filename.gsub! " ", "_"
  sections = Datum::FileParser.parse_data data_filename
  send(:define_method, data_filename.to_sym, &block)
  i = 1
  sections.each_pair { |key, value|
    tst = "test_#{data_filename}_#{i}"
    value.attributes["id"] = i
    value.attributes["datum_label"] = key
    value.attributes["datum_iterations"] = sections.length
    send :define_method, tst.to_sym do
      @datum = build_datum value.attributes
      send data_filename
    end

    i += 1
  }
end


## Global namespace extension (for testcase reference pre-load)


##############################################################################
##############################################################################

## Global namespace extension (for ERB usage)
def import_scenario scenario ## added to the global namespace for file acecess
  return Datum::Scenario.read Datum::Scenario.new(scenario, nil).absolute_path
end

def import_datum datum ## added to the global namespace for file acecess
  return Datum::Datum.read Datum::Datum.new(datum).absolute_path
end
