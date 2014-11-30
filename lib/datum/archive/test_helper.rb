require "datum/file_parser"
require "datum/structures"
require "datum/internals/datum_utilities"
require "datum/internals/path_utilities"

#####

module Datum
module Extensions
module TestHelper

  def process_scenario scenario_name
    Datum::FileParser.parse scenario_name, self
  end

end
end
end

#####

def data_test data_filename, &block

  data_filename.gsub! " ", "_"
  sections = Datum::FileParser.parse data_filename
  send(:define_method, data_filename.to_sym, &block)
  i = 1
  sections.each_pair { |key, value|
    tst = "test_#{data_filename}_#{i}"
    value.attributes["id"] = i
    value.attributes["datum_label"] = key
    value.attributes["datum_iterations"] = sections.length
    send :define_method, tst.to_sym do
      @datum = Datum::Internals::DatumUtilities.build_datum value.attributes
      send data_filename
    end

    i += 1
  }
end

#####
## Global namespace extension (for ERB usage)

def import_scenario filename
  return File.read(Datum::Internals::PathUtilities.resolve_scenario_path(filename))
end

def import_data filename
  return File.read(Datum::Internals::PathUtilities.resolve_data_path(filename))
end
