
require "datum/helpers"
require "datum/datum"
require "datum/container"
require "support/test"
require "support/scenario"

module Datum
  @@scenario_path, @@data_path, @@datum_path = nil
  @@all_containers, @@loaded_data = nil

  class << self
    def path; @@datum_path ||= Rails.root.join('test', 'datum'); end
    def data_path; @@data_path ||= ::Datum.path.join('data'); end
    def scenario_path; @@scenario_path ||= ::Datum.path.join('scenarios'); end
    def containers; @@all_containers ||= {}; end
    def loaded_data; @@loaded_data ||= {}; end
  private
    def current_container; @current_container; end;
  end
end