# datum helps data-driven testing.
#
# Author:: Gabriel Marius, Tyemill
# Copyright:: Copyright (c) 2013 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'datum/railtie'
require 'datum/test_generator'
require 'datum/test_source'
require 'datum/context'
require 'datum/test_builder'

module Datum
  autoload :TestHelpers, 'datum/test_helpers'
end

class ActiveSupport::TestCase
  include Datum::TestHelpers
  #include Datum::TestBuilder

  #def initialize(s)
  #  puts "---------------------- #{s} ----------------------" unless s.nil?
  #end
  @@datum = {}
  @datum = nil
  
  def datum
    return @datum
  end

  #def self.datum
  #  return @@datum
  #end

  def initialize(test_case)
    super
    @datum = @@datum.delete(test_case) unless @@datum.nil?
    # puts "-- #{test_case_class} -- #{self.class.name}"
    # eval here won't work because the test has already been enumerated ... 
  end

  def self.build_datum h
    a_datum = Object.new
    h.each_pair {|key, value|
      addDatumAttribute key, value, a_datum
    }
    return a_datum
  end

  def self.addDatumAttribute(ext, instance, obj)
    method_name = ext.to_sym
    obj.instance_variable_set(:@datum_value, instance)
    obj.class.send :define_method, method_name do
      return @datum_value unless @datum_value.to_i.to_s == @datum_value || @datum_value == ""
      return nil if @datum_value == ""
      return @datum_value.to_i
    end
  end

  #def self.drive f, hh 
  #  hh.each_with_index {|x, i|
  #    i += 1
  #    send(:define_method, "test_foo_#{i}") do
  #      @datum = build_datum x
  #      send(f)
  #    end
  #  }
  #end

  def self.drive_with h, n, &block
    h.each_with_index {|x, i|
      tc = "test_#{n}_#{i + 1}"
      @@datum[tc] = build_datum x
      send(:define_method, tc, &block)
    }
  end

end
