require 'datum/helpers'

module Datum
class TestCase < ActiveSupport::TestCase

  attr_reader :test_case, :datum; @@test_data = {}

  def initialize(test_case)
    @test_case = test_case
    super
  end

  def self.datum_for method_name, &block
    rows = @@test_data[method_name]
    rows = [] if rows.nil?
    rows.push block
    @@test_data[method_name] = rows
  end

  def self.options_for method_name, options # options == row or rows
    rows = Helpers.direct_access options
    unless rows.nil?
      @@test_data[method_name] = rows
    else
      raise "options not implemented"
    end
  end
  
  def self.datum_test method_name, &block #def self.indirect_access options
    rows = @@test_data[method_name]
    return if rows.nil?

    rows.each_with_index {|x, i|
      
      if 0 == i
        send(:define_method, Helpers.body_name(method_name).to_sym, &block)
      end
      tst = "test_#{method_name}_#{i + 1}"
      send :define_method, tst.to_sym do
        tst_wrapper(tst)
      end
    }
  end

private

  def Helpers
    return Datum::Helpers
  end

  def tst_wrapper tst_case
    load_datum tst_case
    send(Helpers.body_name(Helpers.trim_to_token(tst_case)))
  end

  def load_datum test_case
    rows = @@test_data[Helpers.trim_to_token(test_case)]

    unless rows.nil?
      block = rows.pop
      unless block.is_a? Hash
        pre = "pre_" + test_case
        self.class.send(:define_method, pre, &block)
        row = send(pre)
      else
        row = block
      end
      @datum = Helpers.build_datum row
    end
  end

end
end

