
require "datum/helpers"
require "datum/datum"
require "datum/container"
require "support/test"
require "support/scenario"

module Datum
  @@all_containers, @@scenario_path, @@data_path, @@datum_path = nil

  class << self

    # Fully qualified Pathname for the root Datum directory
    def path; @@datum_path ||= Rails.root.join('test', 'datum'); end
    # Fully qualified Pathname for the datum/data directory
    def data_path; @@data_path ||= ::Datum.path.join('data'); end
    # Fully qualified Pathname for the datum/scenarios directory
    def scenario_path; @@scenario_path ||= ::Datum.path.join('scenarios'); end
    # A Hash of all current Container references
    def containers; @@all_containers ||= {}; end

  private
    def add_container container, key
      ::Datum.containers[key] = container
      ::Datum.instance_variable_set(:"@current_container", container)
    end
    def current_container; @current_container; end;
  end
end