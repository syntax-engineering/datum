
module Datum
  class TestCase < ActiveSupport::TestCase

    @@test_data = {}
    @datum = nil

    def datum
      return @datum
    end

    def initialize(test_case)
      @test_case = test_case
      super
    end

    # Called before Setup
    ##def before_setup
    ##  begin
    ##    method_name = "pre_" + @test_case
    ##    puts " [B before_setup] #{method_name}"
        
    ##    row = send(method_name)
    ##    @datum = build_datum row
    ##    puts " datum: #{@datum.inspect}"
        
    ##  rescue
    ##    @datum = nil
    ##  end

    ##  super
    ##end

    #def setup
    #  puts " [complex setup] "
    #end

    #def setup
    #  puts " [B Setup] "
    #  originalSetup
    #end

    def self.datum_for method_name, &block
      rows = @@test_data[method_name]
      rows = [] if rows.nil?
      rows.push block
      @@test_data[method_name] = rows
    end

    def self.options_for method_name, options
      rows = direct_access options
      unless rows.nil?
        @@test_data[method_name] = rows
      else
        raise "options not implemented"
      end
    end

    def self.indirect_access options

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


    # :method_name => The method to apply these options to
    #
    # Direct Data Access Options
    # :rows => Array of hashs or objects (each one is a 'row')
    # :row => An object or hash - single row of data
    #
    # Indirect Data Access Options
    # :model => Model to query 'all'
    # :query => Query to execute
    #
    #def self.datum_options options
    #  puts "#{options.inspect}"
    #end

    #def self.data_for(method_name, artifact)
    #  puts "boom"
    #end

    #def self.data_for method_name, &block
    #  rows = @@test_data[method_name]
    #  rows = [] if rows.nil?
    #  rows.push block
    #  @@test_data[method_name] = rows
    #end

    def self.datum_test method_name, &block
      rows = @@test_data[method_name]
      
      # first make the pre method
      return if rows.nil?
      rows.each_with_index {|x, i|
        
        if 0 == i
          nm = TestCase.body_name(method_name)
###          puts "name: #{nm}"
          send(:define_method, nm.to_sym, &block)
        end

        tst = "test_#{method_name}_#{i + 1}"
        #send(:define_method, tst, &block)
        send :define_method, tst.to_sym do
          tst_wrapper(tst)
        end
      }
    end

    def tst_wrapper tst_case
###      puts " -- -- -- test starting... #{tst_case}"
      load_datum tst_case
      send(TestCase.body_name(TestCase.trim_to_token(tst_case)))
###      puts " -- -- -- test finished... #{tst_case}"
    end

  private

    def self.trim_to_token test_name
      test_name[(test_name.index("_") + 1)..(test_name.rindex("_")-1)]
    end

    def self.body_name tst_case
      "body_" + tst_case
    end

    def load_datum test_case
      token = test_case[(test_case.index("_") + 1)..(test_case.rindex("_")-1)]
###      puts " load_datum -- tst: #{test_case} -- tok: #{token}"
      
      rows = @@test_data[token]

      unless rows.nil?
###        puts " load_datum -- rows for #{token}: #{rows.count}"
        block = rows.pop
        pre = "pre_" + test_case
        #self.class.send(:define_method, pre, &block)
        self.class.send(:define_method, pre, &block)
        row = send(pre)
###        puts " load_datum -- row: #{row.inspect}"
        #row = block.call
        @datum = build_datum row
###        puts " load_datum -- datum: #{@datum.inspect}"
      else
###        puts " load_datum -- no rows for #{token}"
      end
    end

    def build_datum h
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
        return val unless val.to_i.to_s == val || val == ""
        return nil if val == ""
        return val.to_i
      end
    end

  end
end

