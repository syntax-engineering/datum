
require "datum/helpers"
require "datum/datum"
require "datum/container"
require "support/test"
require "support/scenario"

# @api
# Datum is a flexible data-driven test solution for Rails
module Datum
  @@all_containers, @@scenario_path, @@data_path, @@datum_path = nil

  class << self

    # @api
    # @return [Pathname] fully qualified path for the root of datum directory
    def path; @@datum_path ||= Rails.root.join('test', 'datum'); end
    # @api
    # @return [Pathname] fully qualified path for the datum/data directory
    def data_path; @@data_path ||= ::Datum.path.join('data'); end
    # @api
    # @return [Pathname] fully qualified path for the datum/scenarios directory
    def scenario_path; @@scenario_path ||= ::Datum.path.join('scenarios'); end
    # @api
    # @return [Hash] Hash of all loaded Containers
    def containers; @@all_containers ||= {}; end

  private
    def add_container container, key
      ::Datum.containers[key] = container
      ::Datum.instance_variable_set(:"@current_container", container)
    end
    def current_container; @current_container; end;
  end
end