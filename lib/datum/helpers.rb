module Datum
class Helpers
  def self.body_name tst_case
    "body_" + tst_case
  end

  def self.trim_to_token test_name
    test_name[(test_name.index("_") + 1)..(test_name.rindex("_")-1)]
  end

  def self.direct_access options
    rows = options[:rows]
    if rows.nil?
      row = options[:row]
      unless row.nil?
        rows = []
        rows.push row
      end
    end
    return rows
  end

  def self.build_datum h
    a_datum = Object.new
    h.each_pair {|key, value|
      addDatumAttribute key, value, a_datum
    }
    return a_datum
  end

  def self.addDatumAttribute(ext, instance, obj)
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
  
end
end