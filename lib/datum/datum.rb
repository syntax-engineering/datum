require "datum/container"
require "datum/helpers"
require "plan9/structures"

module Datum
class Datum < Plan9::ImmutableStruct
  def self.new(*attrs, &block)
    attrs.push "datum_id"
    super(*attrs, &block)
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
    attr_reader :test_method_name, :container

    def initialize(*atrs)
      dtm_id = configure_attributes
      is_hash_case?(*atrs) ? atrs.first[:datum_id] = dtm_id : atrs.push(dtm_id)
      datum_initialize(*atrs)
    end

    private
    def configure_attributes
      @container = ::Datum.send(:"current_container")
      (dtm_id, @test_method_name, key = @container.send(:add_datum, self))[0]
    end
  end
  end
end
end