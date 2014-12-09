module Datum
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
        @data_loader = $datum_data_loader
        @datum_id = $datum_data_loader.send "add_structure", self
        improved_initialize(*attrs)
      end

      def datum_id
        @datum_id
      end

      def data_loader
        @data_loader
      end
    end
  end
end
end