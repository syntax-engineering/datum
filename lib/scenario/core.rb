# Flexible data-driven test solution for Rails
#
# Author:: Tyemill
# Copyright:: Copyright (c) 2012 - 2014 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)
#
# core Scenario API

module Scenario

  @provided_binding = nil

  def self.directory
    Rails.root.join('test', 'datum', 'scenarios').to_s + File::Separator
  end
  def self.read file
    File.read("#{directory}#{file}.rb")
  end
  def self.clone_resource active_record_resource, hash = nil
    return active_record_resource.dup.attributes.merge(hash) unless hash.nil?
    return active_record_resource.dup.attributes
  end

  def self.import scenario_name, provided_binding = nil
    if provided_binding.nil?; provided_binding = @provided_binding
    else; @provided_binding = provided_binding; end
    eval(Scenario.read(scenario_name.to_s), provided_binding)
  end

end