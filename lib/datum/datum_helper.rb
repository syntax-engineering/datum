require 'datum/file_helper'
require 'datum/datum_helper'

module Datum
module DatumHelper


  def self.build_testcases data_filename, tstcase, &block
    data_filename.gsub! " ", "_"
    sections = FileHelper.parse data_filename
    tstcase.send(:define_method, data_filename.to_sym, &block)
    #send(:define_method, data_filename.to_sym, &block)
    i = 1
    sections.each_pair { |key, value|
      tst = "test_#{data_filename}_#{i}"
      value.attributes["id"] = i
      value.attributes["datum_label"] = key
      value.attributes["datum_iterations"] = sections.length
      #send :define_method, tst.to_sym do
      tstcase.send(:define_method, tst.to_sym) do
        @datum = Datum::DatumHelper.build_datum value.attributes
        send data_filename
      end

      i += 1
    }
  end


  def self.construct_datum label, hash
    o = build_datum hash
    Object.send(:define_method, label) do
      o
    end
  end

  def self.build_datum h #, iteration, length
    a_datum = Object.new

    a_datum.instance_variable_set(:@attributes, {})
    a_datum.class.send :define_method, :attributes do
      eval("@attributes")
    end

    h.each_pair {|key, value|
      add_datum_attribute key, value, a_datum
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