
# datum
module Datum
  module TestHelpers
class ActiveSupport::TestCase

  def drive_with h
    datum = Object.new
    h.each_pair {|key, value|
      addDatumAttribute key, value, datum
    }
    return datum
  end

  def addDatumAttribute(ext, instance, obj)
    method_name = ext.to_sym
    obj.class.send :define_method, method_name do
      return instance unless instance.to_i.to_s == instance || instance == ""
      return nil if instance == ""
      return instance.to_i
    end
  end

end
end
end