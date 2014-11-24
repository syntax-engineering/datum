require "datum/datum"
require "datum/resource"

module Datum
class Scenario < Datum
  attr_reader :caller

  SCENARIO_DIRECTORY = "SCENARIO_DIRECTORY"
  SCENARIO_EXTENSION = ".scenario"

  def initialize basename, caller
    super basename
    @caller = caller
  end

protected

  def enumerate_all_elements hash
    hash.each_pair {|label, attribute_hash|
      unless attribute_hash.nil?
        resource = Resource.new(@caller)
        internal_elements[label] = resource
        resource.parse label, attribute_hash
        @caller.__datum_scenario_callback(label,
          resource.instance) unless resource.instance.nil?
      end
    }
  end

  def directory_key
    SCENARIO_DIRECTORY
  end

  def extension
    SCENARIO_EXTENSION
  end

  def build_default_directory
    Rails.root.join('test', 'datum', 'scenarios')
  end

end
end