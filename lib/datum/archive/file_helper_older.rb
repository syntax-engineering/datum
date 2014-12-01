
require "datum/section_helper"
require "datum/keyword_helper"
require "datum/scenario_helper"

module Datum
module FileHelper

  def self.parse naked_filename, caller = nil
    absolute_path = caller.nil? ?
      resolve_data_path(naked_filename) :
      resolve_scenario_path(naked_filename)

    hash = read(absolute_path)
    build_sections hash, caller
  end

  def self.resolve_data_path filename
    "#{data_directory}#{File::Separator}#{filename}#{DATA_EXTENSION}"
  end

  def self.resolve_scenario_path filename
    "#{scenario_directory}#{File::Separator}#{filename}#{SCENARIO_EXTENSION}"
  end

  # Load a file into memory, evaluate ERB and load YAML into hash
  def self.read absolute_path
    YAML.load(erb(absolute_path))
  end

  def self.erb absolute_path
    ERB.new(File.read(absolute_path)).result
  end

  def self.build_sections hash, tst
    keyword_list = tst.nil? ? DATA_KEYWORDS : SCENARIO_KEYWORDS
    sections = {}
    hash.each_pair {|label, attribute_hash| # each yaml section
      next if attribute_hash.nil?

      section = SectionHelper.parse(label, attribute_hash, keyword_list)
      sections[label] = section unless section.nil?

      section = KeywordHelper.handle_keywords section, tst
      tst.nil? ?
        DatumHelper.construct_datum(label, attribute_hash) :
        ScenarioHelper.add_instance_method(
          label, section.keywords["instance"], tst)
    }
    return sections.length == 0 ? nil : sections
  end

  def self.data_directory
    @@data_dir ||= resolve_directory(DATA_DIRECTORY_KEY,
      FileHelper.default_data_directory)
  end

  def self.scenario_directory
    @@scenario_dir ||= resolve_directory(SCENARIO_DIRECTORY_KEY,
      FileHelper.default_scenario_directory)
  end

  def self.default_scenario_directory
    @@default_scenario_dir ||= Rails.root.join('test', 'datum', 'scenarios')
  end

  def self.default_data_directory
    @@default_data_dir ||= Rails.root.join('test', 'datum', 'data')
  end

  def self.resolve_directory directory_key, default_directory
    ENV[directory_key].nil? ? default_directory : ENV[directory_key]
  end

end
end