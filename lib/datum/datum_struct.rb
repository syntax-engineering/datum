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
      attr_reader :datum_id, :datum_data_method, :datum_test_method

      def initialize(*attrs)
        #@data_loader = $datum_data_loader
        @datum_data_method, @datum_id, @datum_test_method =
        Datum.add_datum_structure(self)
        improved_initialize(*attrs)
      end

    end
  end
end
end