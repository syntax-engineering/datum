
def data_test name, &block
#  DatumInternal.instance_variable_set(:"@context",
#    DatumInternal::DataContext.new(name, self))
#  self.send(:define_method, name, &block)
#  self.class_eval(DatumInternal::Utilities.read_file(
#    name, DatumInternal::Utilities.directories.data))
#  DatumInternal.instance_variable_set(:"@context", nil)
end