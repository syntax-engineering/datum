module Datum
module ScenarioHelper
# When factory is used, instances are stored here
  @@factory_extensions = Hash.new

  # given  => {:foo => "vfoo", :bar => "vbar"}, :foo
  # return => "vfoo" -- {:bar => "vbar"}
  def read_delete hash, key
    return nil if !hash.key? key
    v = hash[key]
    hash.delete key
    return v
  end


  # scenarios are yml files that are loaded on demand
  #
  # a scenario puts the database in a specific state for testing purposes.
  # each scenario file can be standalone or it can import from other 
  # scenarios.
  # 
  # supported key words:
  # _model: "model" <- notes the model to use for the element
  # _clone: element.to.clone <- a previously loaded element from the scenario
  # _import: "scenario_file" <- a scenario to load in addition to current
  #
  # TODO: Full documentation
  def process_scenario scenario
    #raise "#{Dir.pwd}/test/scenarios/#{scenario}.yml"
    scenario_hash = YAML.load(
      File.read("#{Dir.pwd}/test/scenarios/#{scenario}.yml"))

    scenario_hash.each_pair {|key, value|
      ref_label = key.to_s
      ref_hash = value

      ref_model = read_delete(ref_hash, "_model")
      ref_model = ref_model.constantize unless ref_model.nil?
      ref_scope = read_delete(ref_hash, "_scope")
      ref_import = read_delete(ref_hash, "_import")
      ref_clone = read_delete(ref_hash, "_clone")
      if 0 != ref_hash.count
        ref_hash.each_pair {|second_key, second_value|
          begin
            #
            # using eval directly on variables can be bad.
            #
            # e.g. "Feedback" as a votable type is in fact a string AND
            # a constant (a model name)
            second_value = eval second_value if second_value.include? "."
            ref_hash[second_key] = second_value
          rescue Exception => exc
          end
        }
        if(!ref_clone.nil?)
          inst = self.send(ref_clone)
          ref_model = inst.class
          ref_hash = (remove_rails_defaults! inst.attributes).merge ref_hash
        end
        new_instance = ref_model.create ref_hash unless ref_model.nil?
      elsif !ref_import.nil?
        # todo support comma seperated import
        process_scenario ref_label
      else
        new_instance =
            eval("#{ref_model.to_s.tableize.downcase}(:#{ref_label})")
      end

      unless ref_scope.nil?
        Thread.current[:account_id] = ref_scope.to_i
      end


      if !new_instance.nil?
        addExtension ref_label, new_instance unless ref_label.nil? || 
        !ref_import.nil?
      elsif !ref_label.nil? and ref_import.nil?
        inst = self.send(ref_label)
        ref_hash.each_pair {|second_key, second_value|
          inst[second_key] = second_value
        }
        f = inst.save
        #raise "could not save instance" unless f
        inst = inst.class.find_by_id(inst.id)
      end

      unless ref_scope.nil?
        Thread.current[:account_id] = nil
      end

    }

  end

  def creator(*arguments)
    options = arguments.extract_options!
    provided_model = arguments[0]

    new_instance = provided_model.create options[:values]

    if !options[:key].nil?
      #raise "Extension Error: key #{options[:key]} in use." if
      #@@factory_extensions.has_key? options[:key]
      @@factory_extensions[options[:key]] = new_instance
      addExtension options[:key], new_instance
    end

  end

  #def addExtension(ext, instance)
  #  method_name = ext.to_sym
  #  self.class.send :define_method, method_name do
  #    return instance
  #  end
  #end

  def addExtension(ext, instance)
    addInstanceExtension ext, instance
    addSingleton ext, ActiveSupport::TestCase, instance
  end

  def addSingleton(ext, klass, instance)
    method_symbol = ext.to_sym
    klass.define_singleton_method(method_symbol) do
      return instance
    end
  end

  def addInstanceExtension(ext, instance)
    method_name = ext.to_sym
    self.class.send :define_method, method_name do
      return instance
    end
  end

  def remove_rails_defaults!(hash)
    hash.delete_if {|key, value| 
      key == "id" || key == "created_at" || key == "updated_at"}
    
    return hash
  end
end
end