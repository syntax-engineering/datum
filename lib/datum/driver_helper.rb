
module Datum
  
  class DriverHelper
    
    def self.load_data table
      context.table_data = load_file_data(table) || load_model_data(table)
    end
    
    def self.add_datum_exec_ext init_before_exec, result
      return result if !init_before_exec && !context.initialized?
      
      first = !init_before_exec && context.initialized?
      last = init_before_exec && !context.initialized?
      
      base = "," if result == "."
      base = "," + result unless base == ","
      base = "[" + base if first
      base += "]" if last
      return base
    end
    
    def self.enable_logger
      @@logger = true
    end
    
    def self.disable_logger
      @@logger = false
    end
    
    protected
    @@logger = false
    
    def self.log msg
      Rails.logger.debug "$$ " + msg unless !@@logger
    end
    
    def self.load_model_data table
      data = nil
      begin
        driver_method = table.to_s.singularize
        data = driver_method.classify.constantize.all.reverse
      rescue Exception => exc
        log "load_model_data: could not get data from model #{driver_method}"
        log exc
      raise 
        "Accessing datum database with table / model #{driver_method} failed."
      end
      
      return data
    end
    
    def self.load_file_data table
      data = nil
      begin
        require "lib/datum/locals/#{table}"
        cls = driver_method.classify.pluralize.constantize
        data = cls::data.reverse
        data = mock_data data
      rescue Exception => exc
        ## database-driven
        log "load_file_data: file load failed. moving to database load."
      end
      
      return data
    end
    
    private 
    
    def self.context
      return Datum::Context
    end
    
  end
end
