require "plan9/structures"

#module Datum
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
      improved_initialize(*attrs)
    end
  end
  end
end
#end