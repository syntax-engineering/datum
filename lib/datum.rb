
require "datum/helpers"
require "datum/datum"
require "datum/container"
require "support/test"
require "support/scenario"

# Datum is a flexible data-driven test solution for Rails
module Datum
  @@all_containers, @@scenario_path, @@data_path, @@datum_path = nil

  class << self

    # @!attribute [r] path
    # Fully qualified path for the root of datum directory
    # @return [Pathname]
    def path; @@datum_path ||= Rails.root.join('test', 'datum'); end

    # @!attribute [r] data_path
    # Fully qualified path for the datum/data directory
    # @return [Pathname]
    def data_path; @@data_path ||= ::Datum.path.join('data'); end

    # @!attribute [r] scenario_path
    # Fully qualified path for the datum/scenarios directory
    # @return [Pathname]
    def scenario_path; @@scenario_path ||= ::Datum.path.join('scenarios'); end

    # @!attribute [r] containers
    # Hash of all loaded Containers
    # @return [Hash]
    def containers; @@all_containers ||= {}; end

  private
    def add_container container, key
      ::Datum.containers[key] = container
      ::Datum.instance_variable_set(:"@current_container", container)
    end
    def current_container; @current_container; end;
  end
end