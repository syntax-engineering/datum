
require "datum/artifact"
require "datum/utilities"

module Datum
class Resource < Artifact
  attr_reader :caller, :instance

  RESOURCE_KEYWORDS = ["_model"];

  def initialize caller
    @caller = caller
  end

  def parse label, attribute_hash
    super label, attribute_hash

    klass_from_keywords!

    unless @keywords["klass"].nil? && @keywords["clone"].nil?
      @instance = create_new_instance attribute_hash
    else
      raise "Unknown Model / Class from:
      #{label} :: #{attribute_hash.inspect} ::
      Extracted Keywords: #{@keywords}"
    end
    #puts "Datum::Artifact.process_scenario_instance -> #{label} ::
    #      #{new_instance.inspect}"
  end

protected

  def all_keywords
    return ARTIFACT_KEYWORDS + RESOURCE_KEYWORDS
  end

  # from a model || existing instnace - create instance
  def klass_from_keywords! instance = nil
    unless @keywords["model"].nil? && instance.nil?
      begin
        @keywords["klass"] = instance.nil? ? @keywords["model"].constantize :
        instance
      rescue NameError => nErr
        puts "Warning: Was unable to constantize: #{@keywords['model']}"
      end
    end
  end

  def create_new_instance attribute_hash
   unless @keywords["clone"].nil? #self.send(keywords["clone"])
     instance_to_clone = @caller.send(@keywords["clone"])
     klass_from_keywords! instance_to_clone.class
     attribute_hash = Utilities.remove_rails_defaults!(
       instance_to_clone.attributes).merge(attribute_hash)
   end

   new_instance = nil; klass = @keywords["klass"]
   new_instance =  klass.create attribute_hash unless klass.nil?

   return new_instance
  end
end
end