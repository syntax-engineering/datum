module Datum
module FileHelper

  def self.data_path naked_filename
    build_path(data_directory, naked_filename, DATA_EXTENSION)
  end

  def self.scenario_path naked_filename
    build_path(scenario_directory, naked_filename, SCENARIO_EXTENSION)
  end

  def self.read absolute_path
    YAML.load(erb(absolute_path))
  end

  def self.erb absolute_path
    ERB.new(File.read(absolute_path)).result
  end

  def self.data_directory
    @@data_dir ||= resolve_directory(DATA_DIRECTORY_KEY,
      default_data_directory)
  end

  def self.scenario_directory
    @@scenario_dir ||= resolve_directory(SCENARIO_DIRECTORY_KEY,
      default_scenario_directory)
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

  def self.build_path directory, naked_filename, extension
    "#{directory}#{File::Separator}#{naked_filename}#{extension}"
  end

end
end