module Datum
class CtrlrTestCase < ActiveController::TestCase

  def self.xx_for method_name, &block
    raise "wait wait wait"
  end

end
end