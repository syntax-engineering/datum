module Datum
class FileInfo
  attr_reader :filename, :absolute_path, :directory

  def initialize filename, is_scenario = false
    @filename = filename; @is_scenario = is_scenario
  end

  def extension
    is_scenario? ? SCENARIO_EXTENSION : DATA_EXTENSION
  end

  def absolute_path
    @absolute_path ||= "#{directory}#{File::Separator}#{filename}#{extension}"
  end

  def is_scenario?
    @is_scenario
  end

  def directory
    @directory ||= is_scenario? ?
      FileInfo::resolve_directory(
        SCENARIO_DIRECTORY_KEY, FileInfo::default_scenario_directory) :
        FileInfo::resolve_directory(
        DATA_DIRECTORY_KEY, FileInfo::default_data_directory)
  end

  def self.default_scenario_directory
    @@default_scenario_dir ||= Rails.root.join('test', 'scenario', 'data')
  end

  def self.default_data_directory
    @@default_data_dir ||= Rails.root.join('test', 'datum', 'data')
  end

private

  # Check the environment setting, return it or default
  def self.resolve_directory directory_key, default_directory
    ENV[directory_key].nil? ? default_directory : ENV[directory_key]
  end

end
end