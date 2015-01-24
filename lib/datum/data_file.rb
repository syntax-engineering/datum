
# module Datum
#   class DataFile
#     @@data_files, @@loaded_data = nil
#     attr_reader :data_method, :test_instance, :test_count, :called_tests
#     def self.data_files; @@data_files ||= {}; end

#     def initialize(data_method, tst_instance)
#       @data_method = data_method;
#       @test_instance = tst_instance;
#       @test_count = 0;
#       @called_tests = []
#       DataFile.data_files[data_method.to_sym] = self
#     end

#     class << self
#     private
#       def context; @context; end;
#       def loaded_data; @@loaded_data ||= {}; end

#       def read_file file, directory, ext = ".rb"
#         File.read directory.join("#{file}#{ext}")
#       end

#       def import_file name, directory, current_binding
#         eval(read_file(name, directory), current_binding)
#       end
#     end
#   end
# end