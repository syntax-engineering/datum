
module Datum
  
  class Context
    
    def self.initialized?
      return @@initialized
    end
    
    def self.continue?
      @@table_data.nil? ? false : (@@table_data.count != 0 ? true : false)
    end
    
    protected
    
    def self.next_row
      result = nil if @@table_data.nil?
      result = @@table_data.delete_at(0) unless @@table_data.nil?
      @@initialized = false if !result.nil? && @@table_data.count == 0

      log "next row table_data: #{@@table_data}"
      #log "next row result: #{result.attributes}" unless result.nil?
      log "next row initialized: #{@@initialized}"
      return result
    end
    
    def self.datum_directory
      return @@directory
    end
    
    def self.table_data
      return @@table_data
    end
    
    def self.table_data= data
      @@table_data = data
      @@initialized = true if !@@table_data.nil?
    end
    
    def self.log msg
      Datum::DriverHelper.log msg
    end
    
    @@directory = "#{Rails.env}/lib/datum"
    @@test_directory = "#{Rails.env}/test/lib/datum"
    @@table_data = nil
    @@initialized = false
    
    private
    
    
  
  end
  
end
