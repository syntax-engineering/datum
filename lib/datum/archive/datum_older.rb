# Flexible data-driven test solution for Rails
#
# Author:: Tyemill
# Copyright:: Copyright (c) 2012 - 2014 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'datum/railtie'
require "datum/constants"
#require "datum/file_helper"
#require "datum/datum_helper"

# Enables ActiveSupport::TestCase and all extensions
class ActiveSupport::TestCase
  def process_scenario scenario_name
    #Datum::FileHelper.parse scenario_name, self
    fm = Datum::FileManager.new(scenario_name, self).process

  end
end

def data_test data_filename, &block
  data_filename.gsub! " ", "_"
  #sections = Datum::FileHelper.parse data_filename
  #Datum::DatumHelper.build_testcases data_filename, self, sections, &block

  fm = Datum::FileManager.new data_filename, self

end

def import_scenario filename
#  return Datum::FileHelper.erb(
#    Datum::FileHelper.resolve_scenario_path(filename))
end

def import_data filename
#  return Datum::FileHelper.erb(
#    Datum::FileHelper.resolve_data_path(filename))
end

require "datum/file_helper"

module Datum
class FileManager
  attr_reader :testcase, :naked_filename, :file_hash

  def initialize naked_filename, tstcase = nil
    @naked_filename = naked_filename
    @testcase = tstcase
    @sections = {}
  end

  def process
    @file_hash = FileHelper.read(absolute_path)
    @file_hash.each_pair {|label, attribute_hash|
      build_sections label, attribute_hash
    }
  end

  def absolute_path
    @absolute_path ||= testcase.nil? ?
      FileHelper.data_path(naked_filename) :
      FileHelper.scenario_path(naked_filename)
  end



  def sections
    @sections.length == 0 ? nil : @sections
  end

private

  def build_sections label, attribute_hash
    return if attribute_hash.nil?
    fs = FileSection.new(label, attribute_hash, testcase)
    fs.parse_section
    sections[label] = fs

    section = KeywordHelper.handle_keywords section, testcase

    if testcase.nil?
      DatumHelper.construct_datum(label, attribute_hash)
    else
      ScenarioHelper.add_instance_method(label, section.keywords["instance"], tst)
    end
  end

end

class FileSection
  attr_reader :label, :attribute_hash, :testcase

  def initialize label, attribute_hash, testcase = nil
    @label = label
    @attribute_hash = attribute_hash
    @testcase = testcase
    @keywords = {}
  end

  def parse
    enumerate_attributes
  end

  def possible_keywords
    testcase.nil? ? DATA_KEYWORDS : SCENARIO_KEYWORDS
  end

  def keywords
    @keywords.length == 0 ? nil : @keywords
  end

private

  def enumerate_attributes

    # keys and values need to be looked at
    # if cloned - all items from external source comes into list - but
    # new items don't need to be eval'ed or keyworded
    #




    attribute_hash.each_pair {|key, value|
      keyword = enumerate_keywords key, possible_keywords
      if keyword.nil?
        attribute_hash[key] = evaluate_value value
      else
        handle_keyword(keyword, value)
      end
    }
  end

  def handle_keyword keyword, value
    attribute_hash.delete keyword
    key = keyword[1..-1]
    @keywords[key] = value unless value.nil?
  end

  def handle_clone
    instance_to_clone = testcase.send(@keywords["clone"])
    mdl = instance_to_clone.class.to_s
    if "Object" == mdl
      attrs = instance_to_clone.attributes
    else
      @keywords["clone"] = mdl
      attrs = remove_rails_defaults!(instance_to_clone.attributes)
    end
    attribute_hash = attrs.merge(attribute_hash)
  end

  def self.initialize_datum label
    o = build_datum
    Object.send(:define_method, label) do
      o
    end
    return o
  end

  def self.build_datum a_datum = nil, key = nil, value = nil
    if a_datum.nil?
      a_datum = Object.new
      a_datum.instance_variable_set(:@attributes, {})
      a_datum.class.send :define_method, :attributes do
        eval("@attributes")
      end
    end

    unless key.nil? && value.nil?
      add_datum_attribute key, value, a_datum
      a_datum.attributes[key] = value
    end

    return a_datum
  end

  def self.add_datum_attribute(ext, instance, obj)
    method_symbol = ext.to_sym
    cls_var_str = "@" + ext.to_s
    obj.instance_variable_set(cls_var_str.to_sym, instance)
    obj.class.send :define_method, method_symbol do
      val = eval("#{cls_var_str}")
      return nil if val == ""
      return val unless val.is_a? String
      return val.to_i if val.to_i.to_s == val
      return val
    end
  end

  def self.enumerate_keywords potential_keyword, possible_words
    if potential_keyword.starts_with? "_"
      possible_words.each do |keyword|
        return keyword if keyword == potential_keyword
      end
    end
    return nil
  end

  def self.evaluate_value value # attempt to avoid entering begin / rescue
    result = value              # for basic perf win
    if value.is_a?(String) && value.include?(".")
      begin; result = eval value; rescue Exception => exc; end
    end # puts "Error => eval'ing value: #{value}"
    return result
  end

  # delete default attributes from hash (id, created_at, updated_at)
  def self.remove_rails_defaults!(hash)
    hash.delete("id"); hash.delete("created_at"); hash.delete("updated_at")
    return hash
  end

end

end
