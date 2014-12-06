
require "datum/internal"
require "datum/data_loader"


class DatumStruct < Plan9::ImprovedStruct

  def self.new(*attrs, &block)
    attrs.push(:data_method)
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
      alias_method :improved_initialize, :initialize

      def initialize(*attrs)
        attrs.push($datum_data_loader.add_structure(self))
        improved_initialize(*attrs)
      end
    end
  end
end

class ActiveSupport::TestCase
  def process_scenario scenario_name
    __import(scenario_name)
  end
end

def __import scenario_name
  Datum.scenario_import(scenario_name, binding)
end

def __clone resource, override_hash = nil
  Datum.scenario_clone_resource resource, override_hash
end

def data_test name, &block
  ($datum_data_loader = Datum::DataLoader.new(self, name)).load(&block)
end