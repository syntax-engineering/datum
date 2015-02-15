require "datum/container"
require "datum/helpers"
require "plan9/structures"

module Datum
# @api
# Datum ImmutableStruct to be extended by data_test test cases
class Datum < Plan9::ImmutableStruct
  def self.new(*attrs, &block)
    attrs.push "datum_id"
    super(*attrs, &block)
  end

  # @param test_instance [TestCase] the TestCase instance for the test
  # @param test_name [String] the name of the test
  # @return [String] Datum compatible Hash key
  def self.key test_instance, test_name
    Helpers.build_key(test_instance, test_name)
  end

protected

  def self.init_new(struct)
    super(struct)
    datumize_constructor!(struct)
    struct
  end

private
  def self.datumize_constructor! struct

  struct.class_eval do
    alias_method :datum_initialize, :initialize

    # @return [String] The name of the test method
    attr_reader :test_method_name
    # @return [Container] A reference to the Container of this Datum
    attr_reader :container

    def initialize(*atrs)
      dtm_id = configure_attributes
      is_hash_case?(*atrs) ? atrs.first[:datum_id] = dtm_id : atrs.push(dtm_id)
      datum_initialize(*atrs)
    end

    private
    def configure_attributes
      @container = ::Datum.send(:current_container)
      (dtm_id, @test_method_name = @container.send(:add_datum, self))[0]
    end
  end
  end
end
end