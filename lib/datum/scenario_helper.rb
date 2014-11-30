module Datum
module ScenarioHelper
  def self.add_instance_method(ext, instance, tst)
    method_name = ext.to_sym
    tst.class.send :define_method, method_name do
      return instance
    end
  end
end
end