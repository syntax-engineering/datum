
module Datum
  class TestSource
    @@available_attrs = [:file, :model, :controller, :rows, :method_name]
    attr_accessor *@@available_attrs

    def initialize(params = nil)
      unless params.nil?
        params.each do |key,value|
          self.send(:"#{key}=",value) if @@available_attrs.include?(key.to_sym)
        end
      end

      Datum::Context.current_source = self
    end

  end
end