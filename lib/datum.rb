# datum helps data-driven testing.
#
# Author:: Gabriel Marius, Tyemill
# Copyright:: Copyright (c) 2012 Tyemill, llc.
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'datum/railtie'
require 'datum/driver_helper'
require 'datum/context'
#require 'test/unit'

module Datum
  ActiveSupport::TestCase.class_eval do
    alias_method :original_initialize, :initialize
    
    
    def initialize(tst)
      log NEW_TST
      original_initialize tst
    end
    
    def drive_with table 
     datum_helper::load_data table if !datum_context::initialized?
     @@driver_row = datum_context.next_row
     log "drive_with table: #{table}"
     log "drive_with row: #{@@driver_row.attributes}" unless @@driver_row.nil?
    end
    
    def datum
      return @@driver_row
    end
    
    private
    @@driver_row = nil
    NEW_TST = "@@@     N E W  T S T  C A S E     @@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    def log msg
      datum_helper.log msg
    end
    
    def datum_helper
      return Datum::DriverHelper
    end
    
    def datum_context
      return Datum::Context
    end
    
  end

  MiniTest::Unit.class_eval do
      alias_method :original__run_suite, :_run_suite

    def _run_suite suite, type
      header = "#{type}_suite_header"
      puts send(header, suite) if respond_to? header

      filter = options[:filter] || '/./'
      filter = Regexp.new $1 if filter =~ /\/(.*)\//

      testcases = suite.send("#{type}_methods").grep(filter)
      assertions = []
      p_test = nil
      testcases.map { |test_case|  
        while datum_context::continue? || p_test != test_case do
          __runner assertions, test_case, suite
          p_test = test_case
        end
      }
      return assertions.size, assertions.inject(0) { |sum, n| sum + n }
    end

    def __runner(assertions, test_case, suite)
      testcase_result = inner_runner(test_case, suite)
      assertions.push testcase_result
    end

    def inner_runner(method, suite)
      inst = suite.new method
      inst._assertions = 0
      print "#{suite}##{method} = " if @verbose
      @start_time = Time.now
      datum_init = datum_context::initialized?
      result = inst.run self
      time = Time.now - @start_time
      print "%.2f s = " % time if @verbose
      result = Datum::DriverHelper::add_datum_exec_ext datum_init, result
      print result
      puts if @verbose

      inst._assertions
    end

    private
    def datum_context
      return Datum::Context
    end

  end
  
  
end
