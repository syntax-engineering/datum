
module Datum
  class EnableTask

    def rock
      puts "\n Enabling Datum Data-Driven Testing Tools."
      create_directories
      notify_check
      update_yml if @@update_yml
      update_app if @@update_app
      puts " Datum enabled.\n "
    end
    
    private
    @@application_path = @@info = nil
    @@update_app = @@update_yml = false
    @@datum_drop_path = "test/lib/datum"
    @@datum_model_path = 'config.autoload_paths += %W(#{Rails.root}/' + 
    "#{@@datum_drop_path}" + '/models)'
    @@datum_app_scan = "config.autoload_paths.*#{@@datum_drop_path}/models"
    #@@datum_app_scan = "config.autoload_paths.*test\/lib\/datum\/models"
    #@@datum_drop_path.gsub(Regexp.new("\\/"), "\\/")
    #"config.autoload_paths.*#{encoded_path}\/models"
    
    def create_directories
      ["#{@@datum_drop_path}/fixtures", "#{@@datum_drop_path}/locals",
      "#{@@datum_drop_path}/migrate", "#{@@datum_drop_path}/models"].each { 
        |path| FileUtils.mkdir_p(path) if !File::directory?(path)}  
      
      puts " Datum directories created."
    end
    
    def notify_check
      @@update_yml = need_yml?
      @@update_app = need_app?
    
      notify unless !@@update_yml && !@@update_app
    end
    
    def notify
      require "datum/enable_notification"
      puts "#{Datum::NOTIFICATION}"
      puts " Files that may need updates: "
      puts "   database.yml" if @@update_yml
      puts "   application.rb" if @@update_app
      puts "\n>>>>>>>>>>>>>>>> Attempt updates for you? y/n"
      continue = STDIN.gets.chomp
      unless continue == 'y' || continue == 'yes'
        puts "\n Files must be updated manually to fully enable Datum\n "
        exit!
      end
    end
    
    def update_yml
      app_name = Rails.root.to_s.split("/").last
      target_hash = @@info["test"] ? @@info["test"] : @@info["development"]
      
      if target_hash.nil?
        puts " Can't update database.yml without a pre-existing"
        puts " test or development segment."
        puts "###### !!!! Please update database.yml manually !!!! ######\n "
        return
      end
      
      File.open(Rails.root.join("config/database.yml"), 'a') do |f1|
        f1.puts "\n\n#\n# database entry for data-driven testing.\n#"
        f1.puts "datum:"
        target_hash.each_pair {|key, value| 
          f1.puts "  #{key}: #{value}" unless key == "database"
          f1.puts "  database: #{app_name}_datum" if key == "database"
        }
      end
      
      puts " database.yml updated with datum entry"
    end
    
    def update_app
      FileUtils.mkdir_p("tmp")
      tmp_path = "tmp/app.tmp"
      tempfile = File.open(tmp_path, 'w')
      readfile = open_app_file

      readfile.each do |line|
        tempfile << line
        if line.strip == "class Application < Rails::Application"
tempfile << "\n    # Added as part of datum install, enables access to datum specific models\n"
tempfile << "    #{@@datum_model_path}\n\n"
        end
      end
      
      readfile.close
      tempfile.close
      FileUtils.mv(tmp_path, @@application_path)
      
      puts " application.rb updated with datum model reference"
    end
    
    def need_yml?
      @@info = YAML::load(IO.read(Rails.root.join("config/database.yml")))
      return true unless @@info["datum"]
      return false
    end
    
    def need_app?
      pattern = Regexp.new "#{@@datum_app_scan}"
      readfile = open_app_file
      readfile.each do |line|
        return false if line.scan(pattern).length != 0
      end
      return true
    end
    
    def open_app_file
      @@application_path = Rails.root.join("config/application.rb")
      return File.new(@@application_path)
    end
  end
end
