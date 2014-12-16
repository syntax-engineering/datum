require "plan9/structures"

module Datum
  DatumDirectories = Plan9::ImmutableStruct.new(:root) do
    def data
      root.join('data')
    end
    def scenario
      root.join('scenarios')
    end
  end
end