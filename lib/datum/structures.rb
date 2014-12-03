
require "plan9/structures"

module Datum
class OpenStruct < OpenStruct
  def initialize(hash=nil)
    super(hash)
    $datum_data_container.send "add_datum_structure".to_sym, self
  end
end

class DatumStruct < Plan9::ImprovedStruct

protected
  def self.init_new(struct)
    super(struct)
    datumize_constructor!(struct)
    struct
  end

private
  def self.datumize_constructor! struct
  struct.class_eval do
    alias_method :improved_initialize, :initialize

    def initialize(*attrs)
      $datum_data_container.send "add_datum_structure".to_sym, self
      improved_initialize(*attrs)
    end
  end
  end
end
end