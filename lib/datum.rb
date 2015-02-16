
require "datum/helpers"
require "datum/datum"
require "datum/container"
require "support/test"
require "support/scenario"

# Datum is a flexible data-driven test solution for Rails. Datum's primary
# features include: 1) The method data_test, for making test cases
# generated from datasets you define. 2) Scenarios, a load-on-demand
# mechanism for seeding the test db.
#
# The Datum Parts & API:
# + Datum.[Class Attributes] calls to Datum and Scenario paths as
#   well as access to all Containers.
#
# + Top Level Namespace provides access to data_test (for use in your tests
#   directly) and a couple of basic Scenario helpers (__import, __clone, etc).
#
# + ActiveSupport::TestCase is modified to include Datum and add the
#   process_scenario method.
#
# + Datum::ImmutableStruct is a struct for defining sub-classed datasets to
#   use with tests defined via data_test.
#
# + Container is a high-level storage of each data_test and it's associated
#   datasets, test instance, etc
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