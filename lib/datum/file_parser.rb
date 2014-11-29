
require "datum/section_parser"

module Datum

# Read Scenario or Data into memory, parse accordingly
module FileParser

  def self.parse_data filename
    parse_file(FileInfo.new(filename, false))
  end

  def self.parse_scenario filename
    parse_file(FileInfo.new(filename, true))
  end

private

  def self.parse_file file_info
    hash = read(file_info.absolute_path)
    build_sections hash
  end

  def self.build_sections hash
    sections = nil
    hash.each_pair {|label, attribute_hash| # each yaml section
      next if attribute_hash.nil?
      section = SectionParser.parse_data_section label, attribute_hash
      unless section.nil?
        sections = {} if sections.nil?
        sections[label] = section
      end
      construct_datum(label, attribute_hash) # add datum to global
    }
    return sections
  end

  # Load a file into memory, evaluate ERB and load YAML into hash
  def self.read absolute_path
    YAML.load(ERB.new(File.read(absolute_path)).result)
  end

end
end