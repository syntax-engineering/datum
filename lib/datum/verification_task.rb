module Datum
  # some reports of connections / settings issues. 
  # verify allows for a full check of the datum db scenarios
  # intended to be used as part of enable to report datum readiness
  class VerificationTask


    def disable_user_questions
      @@ask_user = false
    end    

    def rock
      
      puts "\n### !!!Datum Verification !!!"
      puts "### !!!This command DROPS the Datum Database!!!"

      if @@ask_user
        puts "\n>>>>>>>>>>>>>>>> Proceed with Datum Verification? y/n"
        continue = STDIN.gets.chomp
        unless continue == 'y' || continue == 'yes'
          puts "\n ... Canceling Datum Verification\n "
          exit!
        end
      end
      
      database_ready = false
      database_removed = false
      files_removed = false

      begin
        dbtsks = DbTasks.new
        puts "\n Dropping Existing Datum Database...\n "
        dbtsks.drop
        puts "\n Drop complete\n "
        puts "\n Verifing Datum functionality...\n "
        dbtsks.create 
        puts "   >> Database created"
        copy_verification_files
        puts "   >> Directories verified\n "
        dbtsks.migrate
        database_ready = true 
        puts "   >> Migration complete"
        seed_verification_table
        puts "   >> Storage verified"
        puts "   >> Attempting data driven test cases from database"
        exec_test
        puts "   >> Database driven test complete"
        dbtsks.dump
        puts "   >> Fixtures generated"
        remove_verification_table_data
        dbtsks.load
        puts "   >> Fixture data uploaded"
        dbtsks.localize({:table => "datum_versions"})
        puts "   >> Localization complete"
        dbtsks.drop
        database_removed = true
        puts "   >> Database dropped"
        puts "   >> Attempting data driven test cases from file"
        exec_test
        puts "   >> Data file driven test complete"
        remove_verification_files
        files_removed = true
        puts " \n ... Core Datum functionality verified!\n "
      rescue Exception => exc
        puts "   >> !!!! Verification failed !!!!"
        puts "#{exc}"
        puts "\n### !!! Please file email datum@tyemill.com with the above output !!!"
      ensure
        remove_verification_table_data if database_ready && !database_removed
        remove_verification_files unless files_removed 
      end
    end

    protected

    def seed_verification_table
      DatumVersion.create([
        {:version => "0.0.1"},
        {:version => "0.8.0"},
        {:version => "0.8.1"},
        {:version => "0.8.2"},
        {:version => "0.8.3"},
        {:version => "0.8.4"},
        {:version => "0.8.5"},
        {:version => "0.8.6"},
        {:version => "0.8.7"},
        {:version => "0.9.0"},
        {:version => "0.9.1"},
        {:version => "0.9.2"}])
    end

    def exec_test
      puts "   >> Starting data-driven test cases...\n "
      result = system "ruby -Itest #{@@test_src}"
      raise 'Datum Testcases did not complete successfully!' if !result
      puts "\n "
    end

    def remove_verification_table_data
      DatumVersion.delete_all
    end

    def copy_verification_files
      # need to make sure all existing fixtures are moved to prevent
      # overwritting or unwanted data in verification process
      FileUtils.cp_r "#{@@local_path}", "#{@@datum_tmp}"
      FileUtils.remove_dir "#{@@local_path}"
      (Datum::EnableTask.new).create_directories

      FileUtils.cp_r @@migration_src, "#{@@local_path}/migrate"
      FileUtils.cp_r @@model_src, "#{@@local_path}/models"
      FileUtils.cp_r @@test_src, "#{@@unit_dir}"
    end

    # delete: the migration, the fixture, the ruby file, the model
    def remove_verification_files

      # need to move fixtures back
      FileUtils.remove_dir "#{@@local_path}"
      FileUtils.cp_r "#{@@datum_tmp}", "#{@@local_path}"
      FileUtils.remove_dir "#{@@datum_tmp}"

      files = [@@test_drop]
      files.each { |file|
        context.log "Removing file: #{file}"
        FileUtils.remove_file file  
      }
      
    end

    private
    @@ask_user = true
    @@local_path = "#{Rails.root}/test/lib/datum"
    @@datum_tmp = "#{Rails.root}/test/lib/datum_tmp"
    @@gem_path = File.expand_path(File.dirname(__FILE__))
    @@migration_file = "20120726105125_create_datum_versions.rb"
    @@version_str = "DatumVersion"
    @@version_tbl = @@version_str.tableize
    @@version_single = @@version_tbl.singularize  
    @@model_file = "#{@@version_single}.rb"
    @@fixture_file = "#{@@version_tbl}.yml"
    @@test_file = "#{@@version_single}_test.rb"
    @@ruby_file = "#{@@version_tbl}.rb"
    @@migration_src = "#{@@gem_path}/verify_helpers/#{@@migration_file}"
    @@model_src = "#{@@gem_path}/verify_helpers/#{@@model_file}"
    @@test_src = "#{@@gem_path}/verify_helpers/#{@@test_file}"
    @@unit_dir = "#{Rails.root}/test/unit"
    @@test_drop = "#{@@unit_dir}/#{@@test_file}"

    def context
      return Datum::Context
    end
  end
end