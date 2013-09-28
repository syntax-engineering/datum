

module Datum
  class TestGenerator
    #Note: Rails.root isn't loaded yet... 
    @@datum_root = "#{Dir.pwd}/test/datum"
    @@model_template = @@datum_root + "/templates/model_template.rb"
    @@controller_template = @@datum_root + "/templates/controller_template.rb"
    @@datum_model_path = "/generated_tests/models"
    @@datum_controller_path = "/generated_tests/controllers"
    @@model_folder = @@datum_root + @@datum_model_path
    @@controller_folder = @@datum_root + @@datum_controller_path

    attr_accessor :model, :controller, :rows, :file

    def generate method_name
      
      raise "model and controller are nil" if @model.nil? && @controller.nil?
      raise "rows are nil" if @rows.nil?

      test_cases_file_name = generate_test_file method_name

      puts "Generated file: #{@generated_file}"

      inject_test_file_reference

    end

    private

    def inject_test_file_reference

      unless @model.nil?
        path_to_test = "test/models/#{model.constantize.name.underscore}_test.rb"
        require_path = "datum#{@@datum_model_path}/#{@generated_file}"
      else
        path_to_test = "test/controllers/#{controller}_test.rb"
        require_path = "datum#{@@datum_controller_path}/#{@generated_file}"
      end

      line = "require '#{require_path}'"

      original_test = File.read(path_to_test)

      return unless original_test.index(line).nil?

      puts "need to insert: #{line}"

      begin_flag  = "  ### Datum Test Cases - Please don't remove"
      end_flag    = "  ### End Datum Test Cases - Please don't remove"

      post_start = previous_end = pre_end = previous_start = start_inject = end_inject = nil

      pre_end = original_test.index(begin_flag)
      previous_start = pre_end + begin_flag.length unless pre_end.nil?
      previous_end = original_test.index(end_flag)
      post_start = previous_end + end_flag.length unless previous_end.nil?

      post_start = pre_end = original_test.rindex("\nend") if pre_end.nil?

      # print error message if inject point can't be found
      if (post_start.nil? || pre_end.nil? || pre_end > post_start)
        puts "\nERROR: Some difficulty adding and removing generated cases."
        puts "Please try removing the old generated tests"
        puts "and be sure the last 'end' is not indented. Then try again."
        puts "\nFile: #{path_to_test}"
        return
      end

      pre_end -= 3 unless previous_start.nil?

      result = original_test[0..pre_end]
      result += "\n\n#{begin_flag}"
      result += "\n" if previous_start.nil?
      result += original_test[previous_start..(previous_end - 1)] unless previous_start.nil?
      result += "  #{line}\n"
      result += "#{end_flag}"
      result += "\n" if previous_start.nil?
      result += original_test[(post_start)..-1]

      File.open(path_to_test, 'w') {|f| f.write(result) }
    end

    def generate_test_file method_name

      class_name = folder_to_use = template_to_use = nil

      unless @model.nil?
        template_to_use = @@model_template
        folder_to_use = @@model_folder
        class_name = "#{model}_test".classify
      else
        template_to_use = @@controller_template
        folder_to_use = @@controller_folder
        class_name = "#{controller}_test".classify
      end

      generated = File.read(template_to_use)
      imported_source = import_source @file
      cases = generate_cases @rows, method_name
      
      source_file = replace_token @file.to_s, Rails.root.to_s + "/", ""

      generated = replace_token generated, "$$source_file$$", source_file
      generated = replace_token generated, "$$class_name$$", class_name
      generated = replace_token generated, "$$source_method$$", imported_source
      generated = replace_token generated, "$$test_cases$$", cases

      @generated_file = "#{(class_name + "_" + method_name).underscore}.rb"

      full_path = folder_to_use + "/#{@generated_file}"

      f = File.new(full_path, "w+")
      f.write(generated) 
      f.close

      return full_path
    end

    def replace_token data, token, new_value
      data[token] = new_value
      return data
    end

    def import_source f
      begin_flag  = "  ## $$_importable_source_start"
      end_flag    = "  ## $$_importable_source_end"

      original_file = File.read(f)

      start_read = original_file.index(begin_flag) + begin_flag.length
      end_read = original_file.index(end_flag)

      imported = original_file[start_read..end_read]

      return imported
    end

    def generate_cases cases, method_name
      generated = "\n"

      cases.each_with_index {|r, i|
        r[:id] = i += 1
        generated += "  test '#{method_name}_#{i}' do\n"
        generated += "    #{method_name} drive_with(#{r.inspect})\n"
        generated += "  end\n\n"
      }

      return generated
    end

  end
end