# datum helps data-driven testing.
#
# Author:: Gabriel Marius, Tyemill
# Copyright:: Copyright (c) 2013 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'datum/railtie'
require 'datum/scenario_helper'

module Datum
  autoload :ScenarioHelper, 'datum/scenario_helper'
  autoload :TestCaseExtension, 'datum/test_case_extension'
  autoload :TestCase, 'datum/test_case'
end

##require 'active_support/testing/setup_and_teardown'
#include ActiveSupport::Testing::SetupAndTeardown
##module ClassMethods
##  def setup(*args, &block)
##    puts "my my my my"
    #super
##  end

##  def teardown(*args, &block)
##    puts "bye bye bye bye"
    #super
##  end
##end

##require 'active_support/testing/declarative'

##module ActiveSupport
##  module Testing
##    module Declarative
##      alias_method :test_test, :test
##      def test(name, &block)
##        puts "name: #{name} -- tc: #{@test_case}"
##        test_test(name, &block)
##      end
##    end
##  end
##end



class ActiveSupport::TestCase
  include Datum::ScenarioHelper

##  def setup(*args, &block)
##    puts "my my my my"
    #super
##  end

##  def teardown(*args, &block)
##    puts "bye bye bye bye"
    #super
##  end


  ##@@data_blocks = {}
  ##@@code_blocks = {}

  #def self.bar
  #  puts "bar"
  #end

  #def foo
    #self.bar
  #  puts "foo"
  #  ActiveSupport::TestCase.bar
  #end

  ##@@datum = {}
  ##@datum = nil
  
  ##def datum
  ##  return @datum
  ##end

  #def setup
  #  puts "base setup"
  #end

  #def setup
  #  puts " [base-setup] - #{@test_case} "

  #  return if @test_case == "test_the_truth"

  #  data = @@data_blocks["my_thing"]
    
  #  unless data.nil?
  #    block = (data.pop)
      #puts "++ #{block}"
      #puts " in setup: #{simpsons_house.name}"
  #    raw_hash = block.yield unless block.nil?
  #    @datum = build_datum raw_hash
      #@@data_blocks["my_thing"].delete if data.count == 0
  #  end

  #end

  ##def initialize(test_case)
    ##super
    #puts " \n"
    #@datum = @@datum.delete(test_case) unless @@datum.nil?
    
    #puts "\n[init: #{test_case}] "
    #print "  [#{caller_locations(1,1)[0].label}]  "
    ##@test_case = test_case

    ##@local_blocks = @@data_blocks
    #@local_code = @@code_blocks 

    #my_thing
  ##end

  ##def build_datum h
    ##a_datum = Object.new
    ##h.each_pair {|key, value|
    ##  addDatumAttribute key, value, a_datum
    ##}

    ##return a_datum
  ##end

  ##def addDatumAttribute(ext, instance, obj)
    ##method_symbol = ext.to_sym # so that this works with strs & syms
    ##cls_var_str = "@" + ext.to_s
    ##obj.instance_variable_set(cls_var_str.to_sym, instance)
    ##obj.class.send :define_method, method_symbol do
    ##  val = eval("#{cls_var_str}")
    ##  return val unless val.to_i.to_s == val || val == ""
    ##  return nil if val == ""
    ##  return val.to_i
    ##end
  ##end

#  def self.drive_with h, n, &block
#    h.each_with_index {|x, i|
#      tc = "test_#{n}_#{i + 1}"
#      @@datum[tc] = build_datum x
#      send(:define_method, tc, &block)
#    }
#  end

  ##def self.data_for meth, &block
  ##  @@data_blocks[meth] = [] unless @@data_blocks.has_key? meth
  ##  @@data_blocks[meth].push block
  ##  puts "data_blocks size: #{@@data_blocks[meth].count}"
    #add_data false, method, block

    #puts "key is: #{meth}"
    #block.call
  ##end

#  def self.delayed_data_for meth, &block
    #add_data true, method, block    
#  end

#  def self.add_data delay, meth, &block
    #@@data_blocks[meth] = [] unless @@data_blocks.has_key? meth
    #@@data_blocks[meth].push {:block => block, :delay => delay}
#  end

  ##def self.datum_test meth, &block
  ##  puts "[datum test]"
  ##  data = @@data_blocks[meth]
  ##  return #if data.nil?
  ##  data.each_with_index {|x, i|
  ##    tc = "test_#{meth}_#{i + 1}"
  ##    puts "adding... #{tc}"
  ##    send(:define_method, tc, &block)
  ##  }
  ##end

  #def self.datum_tst meth, &block
  #  send :define_method, "test_thing" do
  #    block.call
  #  end
  #end

  #tc = "test_#{meth}_#{i + 1}"
  #send :define_method, tc do
  #  row = block.call
  #  @datum = build_datum row
  #  print " [pre_call] "
  #  send(meth)
  #end




#  def self.datum_test meth, &block
    #@@code_blocks[meth] = block
#    data = @@data_blocks[meth]
#    data.each_with_index {|x, i|
#      m = "#{meth}_#{i + 1}"
#      tc = "test_#{meth}_#{i + 1}"
#      gc = "gen_#{m}"
#      send :define_method, tc do
#        row = x.call
#        @datum = build_datum row
#        print " [pre_call] "
        #send(:define_method, gc, &block)
#        send(meth)
#      end
#    }
#  end


end
