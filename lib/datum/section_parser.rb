
require "datum/structures"

module Datum
module SectionParser

  DATA_KEYWORDS = ["_clone"];
  SCENARIO_KEYWORDS = ["_model"] + DATA_KEYWORDS;

  def self.parse_data_section label, attribute_hash
    hash, keywords = enumerate_attributes label, attribute_hash, DATA_KEYWORDS
    Structures::Section.new(label, hash, keywords)
  end

  def self.parse_scenario_section
  end

private
  def self.enumerate_attributes label, attribute_hash, keyword_list
    keywords = nil
    attribute_hash.each_pair {|key, value|
      keyword = resolve_keyword key, keyword_list
      if keyword.nil?
        attribute_hash[key] = evaluate_value value
      else
        attribute_hash, keywords =
        handle_keyword(keywords, attribute_hash, keyword, value)
      end
    }
    [attribute_hash, keywords]
  end

  def self.handle_keyword section_keywords, attribute_hash, keyword, value
    attribute_hash.delete keyword
    unless value.nil?
      section_keywords = {} if section_keywords.nil?
      section_keywords[keyword[1..-1]] = value
    end
    [attribute_hash, section_keywords]
  end

  def self.resolve_keyword key, keywords
    if key.starts_with? "_"
      keywords.each do |keyword|
        return keyword if keyword == possible_keyword
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
end
end