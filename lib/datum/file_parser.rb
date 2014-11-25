
require "datum/section_parser"

module Datum

# Read Scenario or Data into memory, parse accordingly
module FileParser

  #DEFAULT_DATA_DIRECTORY      = Rails.root.join('test', 'datum', 'data')
  #DEFAULT_SCENARIO_DIRECTORY  = Rails.root.join('test', 'datum', 'scenarios')
  DATA_DIRECTORY_KEY          = "DATUM_DATA_DIRECTORY"
  SCENARIO_DIRECTORY_KEY      = "DATUM_SCENARIO_DIRECTORY"
  DATA_EXTENSION              = ".data"
  SCENARIO_EXTENSION          = ".scenario"
  #DATA_DIRECTORY              = resolve_data_directory
  #SCENARIO_DIRECTORY          = resolve_scenario_directory

  def self.parse_data filename
    hash = read(absolute_path(data_directory, filename, DATA_EXTENSION))
    build_sections hash
  end

  def self.parse_scenario filename
    hash = read(absolute_path(SCENARIO_DIRECTORY, filename,
      SCENARIO_EXTENSION))
  end

private

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

  def self.absolute_path path, filename, extension
    "#{path}#{File::Separator}#{filename}#{extension}"
  end

  # Load a file into memory, evaluate ERB and load YAML into hash
  def self.read absolute_path
    YAML.load(ERB.new(File.read(absolute_path)).result)
  end

  # Check data environment setting, return it if present or default
  def self.data_directory
    @@data_directory ||= directory(DATA_DIRECTORY_KEY, default_data_directory)
  end

  def self.default_data_directory
    @@default_data_directory ||= Rails.root.join('test', 'datum', 'data')
  end

  # Check scenario environment setting, return it if present or default
  def self.resolve_scenario_directory
    directory(SCENARIO_DIRECTORY_KEY, DEFAULT_SCENARIO_DIRECTORY)
  end

  # Check the environment setting, return it or default
  def self.directory directory_key, default_directory
    ENV[directory_key].nil? ? default_directory : ENV[directory_key]
  end
end
end