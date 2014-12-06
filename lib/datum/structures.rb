require "plan9/structures"

module Datum

DatumDirectories = Plan9::ImmutableStruct.new(:root) do
  def data; root.join('data'); end; def scenario; root.join('scenarios'); end
end

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
end