
#namespace :db do
#  namespace :test do
    # this is called after the standard rails db:test:load
    # db:test:prepare will call load on its own
#    task :load do 
#      puts "db:test:load"

      # need to look in the root/test/datum directory for any *_datum files
      # and need to load them

#      p = "#{Rails.root}/test/datum/"
#      Dir.glob("#{p}*_datum.rb").each {|x|
#        require "#{x}"
#      }

#    end
#  end
#end

require "datum/operation_helpers"

namespace :datum do

  desc "Enable datum"
  task :install => :environment do
    src = File.expand_path '../..', __FILE__  # frm /root/lib/datum/file
                                              # to  /root/lib
    src += "/datum/assets/copy_from"
    dest = Dir.pwd #does *not* have trailing /

    oh = Datum::OperationHelpers.new

    oh.copy_from src, dest # 
    
  end

  desc "Generate datum tests from test/datum"
  task :generate, [:specific_file] => [:environment] do |t, args|

    p = "#{Rails.root}/"
    
    
    if args[:specific_file].nil?
      p += "/test/datum/source/**/*_datum.rb"  
      Dir.glob("#{p}").each {|x|
        require "#{x}"
      } 

    else
      p += args[:specific_file]
      raise "File does not exist: #{p}" unless File.exists? p
      require "#{p}"
    end
  end

  # ex case 16: 
  #   rake "datum:ex[company_test, company_names_should_work,16]"
  # ex cases 1-8: 
  #   rake "datum:ex[company_test, company_names_should_work,[1-8]$]"
  # ex all cases of a specific method:
  #   rake "datum:ex[company_test, company_names_should_work]"
  # ex all cases of a file
  desc "Execute a test case"
  task :ex, [:test_file, :test_method, :id] => [:environment] do |t, args|
    
    cmd = "rake test"

    unless args[:test_file].nil?
      test_file = find_test_file args[:test_file]
      raise "could not find #{args[:test_file]}" if test_file.nil?
    end

    unless args[:test_method].nil?
      tst = args[:test_method]

      tst = "test_" + tst unless tst.starts_with? ("test_")

      puts "#{chk_exotic(args[:id])}"

      tst += "_#{args[:id]}" unless args[:id].nil?
      tst = "\"/#{tst}/\"" if chk_exotic(args[:id])

      cmd += " #{test_file} #{tst}"
    else
      cmd += " #{test_file}"
    end
    
    puts "#{cmd}"
    exec(cmd)

  end

  def find_test_file test_file
    variations = [
      "test/models/#{test_file}.rb", 
      "test/controllers/#{test_file}.rb"
    ]

    variations.each {|v|
      return v if File.exists? v
      puts "Could not find: #{v}"
    }

    return nil

  end

  def chk_exotic pattrn
    return true if pattrn.nil?
    return !pattrn.index("[").nil? 
    return !pattrn.index("\\").nil?
  end

end