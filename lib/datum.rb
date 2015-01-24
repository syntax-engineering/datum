require "datum/helpers"
require "datum/datum_struct"
#require "datum/data_file"
#require "datum/test_case_extension"
#require "datum/scenario_file_api"
#require "datum/data_test"


require "datum/scenario"

require "datum/data_context"

def data_test name, &block
  #Datum::DataFile.instance_variable_set(:"@context", Datum::DataContext.new(name, self))
  c = Datum::DataContext.new(name, self)
  self.send(:define_method, name, &block)
  self.class_eval(Datum::DataContext.send(:read_file, name, Datum::Helpers.data_directory))
  #Datum::DataFile.instance_variable_set(:"@context", nil);
end