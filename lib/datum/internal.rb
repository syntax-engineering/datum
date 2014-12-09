require "plan9/structures"
#require "datum/data_loader"

module Datum
  @@dirs, @@loaded_data = nil;

  DatumDirectories = Plan9::ImmutableStruct.new(:root) do
    def data; root.join('data'); end; def scenario; root.join('scenarios'); end
  end

  def self.directories
    @@dirs ||= DatumDirectories.new(Rails.root.join('test', 'datum'))
  end

  def self.loaded_data
    @@loaded_data ||= {}
  end

  def self.resolve_loaded_data key
    d = loaded_data[key]; d.nil? ? loaded_data[key] = [] : d
  end

  def self.read_file file, directory
    File.read directory.join("#{file}.rb")
  end

  def self.scenario_import scenario_name, current_binding
    eval(read_file(scenario_name, directories.scenario), current_binding)
  end

  def self.scenario_clone_resource resource, override_hash = nil
    override_hash.nil? ?
      resource.dup.attributes.with_indifferent_access :
      resource.dup.attributes.merge(
        override_hash.with_indifferent_access).with_indifferent_access
  end

  def self.data_test_name data_name, counter
    "test_#{data_name}_#{counter}"
  end

  def self.datum_key test_instance, data_test_name
    "#{test_instance}_#{data_test_name}"
  end

  def self.parse_test_name test_name
    [test_name.slice(/(?<=_).*(?=_)/),
     ((test_name.to_s.split('_')[-1]).to_i) - 1]
  end

  def self.add_datum_structure datum_structure
    method_cases = Datum.resolve_loaded_data(Datum.datum_key(
      $datum_test_case, @datum_data_method))
    method_cases.push(datum_structure)
    [@datum_data_method, method_cases.length, add_datum_test(
      Datum.data_test_name(@datum_data_method, method_cases.length))]
  end

  def self.add_datum_test test_name
    $datum_test_case.class_eval do
      define_method test_name do
        data_name, index = Datum.parse_test_name(method_name)
        @datum = Datum.loaded_data[Datum.datum_key(self.class.to_s,
            data_name)][index]
        self.send(@datum.datum_data_method)
      end
    end
    test_name
  end


  def self.add_methods build, tst, name, &block
    tst.send(:define_method, name, &block)
    return unless build
    #tst.class_eval do
      #def self.add_structure datum_structure
      #  method_cases = Datum.resolve_loaded_data(Datum.datum_key(
      #    self, @datum_data_method))
      #  method_cases.push(datum_structure)
      #  [@datum_data_method, method_cases.length, add_test_case(
      #    Datum.data_test_name(@datum_data_method, method_cases.length))]
      #end
      # def tst.add_test_case test_name
      #   self.class_eval do
      #     define_method test_name do
      #       data_name, index = Datum.parse_test_name(method_name)
      #       @datum = Datum.loaded_data[Datum.datum_key(self.class.to_s,
      #         data_name)][index]
      #       self.send(@datum.datum_data_method)
      #     end
      #   end
      #   test_name
      # end
    #end
  end



end

