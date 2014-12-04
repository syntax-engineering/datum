
class ActiveSupport::TestCase
  def process_scenario scenario_name
    Scenario.import scenario_name, binding
  end
end

module Scenario
  def self.directory
    @@datum_scenario_dir ||=
    Rails.root.join('test', 'datum', 'scenarios').to_s + File::Separator
  end
  def self.read file
    File.read("#{directory}#{file}.rb")
  end
  def self.clone_resource active_record_resource, hash = nil
    return active_record_resource.dup.attributes.merge(hash) unless hash.nil?
    return active_record_resource.dup.attributes
  end
  @provided_binding = nil
  def self.import scenario_name, provided_binding = nil
    if provided_binding.nil?; provided_binding = @provided_binding
    else; @provided_binding = provided_binding; end
    eval(Scenario.read(scenario_name.to_s), provided_binding)
  end
end