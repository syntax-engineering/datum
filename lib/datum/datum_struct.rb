require "plan9/structures"

module Datum
class DatumStruct < Plan9::ImmutableStruct
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
    attr_reader :datum_data_method, :datum_test_instance, :datum_test_method, :datum_count, :datum_length, :datum_data_file

    def initialize(*attrs)
      dtm_id = configure_datum_properties
      if is_hash_case?(*attrs); attrs.first[:datum_id] = dtm_id
      else; attrs.push(dtm_id) end
      datum_initialize(*attrs)
    end

    def datum_count; datum_data_file.test_count; end
    def datum_length; datum_count; end

    private
    def configure_datum_properties
      context = Datum::DataContext.instance_variable_get(:"@context")
      @datum_data_file, dtm_id, @datum_test_method, key = context.add_test_case
      @datum_test_instance = datum_data_file.test_instance
      @datum_data_method = datum_data_file.data_method

      loaded = Datum::DataContext.send(:"loaded_data")
      loaded[key] = self
      add_test_case_method
      dtm_id
    end
    def add_test_case_method
      datum_test_instance.send(:define_method, datum_test_method) do
        key = Datum::Helpers.datum_key(self.class.to_s, __method__)
        @datum = Datum::DataContext.send(:"loaded_data")[key]
        @datum.datum_data_file.called_tests.push @datum.datum_id
        self.send(@datum.datum_data_method)
      end
    end

  end
  end
end
end