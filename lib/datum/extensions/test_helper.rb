require "datum/datum"
require "datum/scenario"

module Datum
module Extensions
module TestHelper
  attr_reader :datum

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

## Global namespace extension (for testcase reference pre-load)
def xxx datum_to_load, &block
    #puts "Datum::TestHelperExtension.xxx :: #{datum_to_load}"


    ## First difference:  The 'name' of the scenario is passed with method
    ##                    need to parse

    datum_to_load.gsub! " ", "_"

    datum = Datum::Datum.new(datum_to_load)
    datum.parse

    send(:define_method, datum_to_load.to_sym, &block) #add the block to the test
    i = 1
    datum.elements.each_pair { |key, value|
      tst = "test_#{datum_to_load}_#{i}"
      value.attributes["id"] = i
      value.attributes["datum_label"] = key
      value.attributes["datum_iterations"] = datum.elements.length
      send :define_method, tst.to_sym do
        @datum = build_datum value.attributes
        send datum_to_load
      end


      #Object.send(:define_method, key.to_s) do
      #  puts "@@@@@!!!!!!!!!!!!!!!!@@@@@"
      #end
      i += 1
    }



end

##############################################################################
##############################################################################

## Global namespace extension (for ERB usage)
def import_scenario scenario ## added to the global namespace for file acecess
  #puts "import_scenario :: #{scenario}"
  return Datum::Scenario.read Datum::Scenario.new(scenario, nil).absolute_path
end

def import_datum datum ## added to the global namespace for file acecess
  #puts "import_scenario :: #{scenario}"
  return Datum::Datum.read Datum::Datum.new(datum).absolute_path
end

##############################################################################
##############################################################################
##############################################################################

## Removed because (at this time) I feel the project developer should decide
## where and when Datum gets loaded (for example, we use Devise - I'd want)
## my loaded stuff to have access to those helpers.
##
## @TODO: Revist how / where to include TestHelperExtension

#class ActiveSupport::TestCase
#  include Datum::TestHelperExtension
#end

#class ActionController::TestCase
#  include Datum::TestHelperExtension
#end