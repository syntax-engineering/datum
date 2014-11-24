module Datum
class Artifact
  attr_reader :keywords, :attributes, :label

  ARTIFACT_KEYWORDS = ["_clone"];

  def parse label, attribute_hash
    @label = label
    @attributes = attribute_hash

    # get keywords - enum attributes -- attribute_hash is modified
    remove_keywords_from_attributes! label, attribute_hash

  end

protected

  def all_keywords
    return ARTIFACT_KEYWORDS
  end

private

  def remove_keywords_from_attributes! label, attribute_hash
    attribute_hash.each_pair {|key, value|  # go through all attributes
      if(key.start_with?("_") && !((keyword = verify_keyword(key)).nil?))
        @keywords = {} if @keywords.nil? && !value.nil?
        attribute_hash.delete(keyword)      # delete key / value of keyword
        @keywords[keyword[1..-1]] = value unless value.nil? # store keywords
      else
        begin                                         # when not keyword
          result = eval value if value.include? "."   # eval value if has .
          attribute_hash[key] = result unless result.nil? # replace value
        rescue Exception => exc
          binding.remote_pry if value == "one.first_value"
          #puts "Error => eval'ing value: #{value}"
        end
      end
    }
  end

  def verify_keyword possible_keyword
    all_keywords.each do |keyword|
      return keyword if keyword == possible_keyword
    end
    return nil
  end

end
end