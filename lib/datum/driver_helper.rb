
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
        log "load_model_data attempting to constantize"
        driver_method = table.to_s.singularize
        data = driver_method.classify.constantize.all.reverse
        log "load_model_data data loaded"
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
        driver_method = table.to_s.singularize
        log "load_file_data: attempting require..."
        file = "lib/datum/locals/#{table}"
        klas = driver_method.classify.pluralize
        require file
        log "load_file_data: require was successful"
        cls = klas.constantize
        log "load_file_data: classify pluralize constantize was successful"
        data = cls::data.reverse
        log "load_file_data: data reading was successful"
        data = mock_data data
        log "load_file_data: mocking was successful"
      rescue Exception => exc
        ## database-driven
        log "load_file_data: file load failed for: #{file}"
        log "load_file_data: driver_method: #{driver_method}"
        log "load_file_data: class: #{klas}"
        log "... attempting database connection."
      end
      
      return data
    end
    
    def self.mock_data data
      modified_data = []
      data.each_with_index {|e, i|
        o = Object.new
        e.each_pair {|key, value|
          addMockExtension key, value, o
        }
        modified_data.push o
      }
      return modified_data
    end

    def self.addMockExtension(ext, instance, obj)
      method_name = ext.to_sym
      obj.class.send :define_method, method_name do
        return instance unless instance.to_i.to_s == instance || instance == ""
        return nil if instance == ""
        return instance.to_i
      end
    end

    private 
    
    def self.context
      return Datum::Context
    end
    
  end
end
