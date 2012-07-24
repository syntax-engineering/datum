
module Datum
  class DbTasks
    def initialize
      Rails.env = @@datum_environment
    end
    
    def create
      Rake::Task['db:create'].invoke()
    end
    
    def migrate
      ActiveRecord::Base.establish_connection(Rails.env)
      ActiveRecord::Migrator.migrate "#{@@local_path}/migrate"
    end
    
    def drop
      Rake::Task['db:drop'].invoke()
    end
    
    # get into the datum fixtures directory, walk the yml, load into db
    def load
      Dir.glob("#{@@local_path}/fixtures/*.yml").entries.each do |entry|
        file_name = entry.to_s.split('/').last.to_s.split('.')[0]
        target_model = file_name.classify.constantize
        data_hash = YAML.load(File.read(entry))
        data_hash.each_value {|value|
          value.delete "id"
          value.delete "created_at"
          value.delete "updated_at"
          target_model.create value
        }
      end
    end
    
    # get into datum db, get relevant tables, produce ymls (for sharing)
    # tonyamoyal.com/2009/12/09/
    # converting-table-data-to-yaml-for-testing-in-ruby-on-rails/
    def dump
      sql  = "SELECT * FROM %s"
      skip_tables = ["schema_info", "schema_migrations"]
      ActiveRecord::Base.establish_connection(Rails.env)
      tables = (ActiveRecord::Base.connection.tables - skip_tables)
      tables.each do |table_name|
        i = "000"
        File.open("#{@@local_path}/fixtures/#{table_name}.yml", 
        'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash}.to_yaml
        end
      end
    end
    
    # take Models data, produce a file for use without db
    def localize args
      tasked_model = args[:table].classify.constantize
      data = tasked_model.all
      file_name = args[:table]
      File.open("#{@@local_path}/locals/#{file_name}.rb", 'w') do |f1|
        f1.puts "\n\n#\n# data dump for code access of table #{file_name}"
        f1.puts "#\nmodule #{tasked_model.to_s.pluralize}"
        f1.puts "def self.data\nd = ["
          data.each_with_index {|e, i|
            hash = e.attributes
            hash.each_pair {|key, value|
              new_value = value.to_s
              hash[key] = new_value
            }
            f1.puts "#{hash.to_s},"
          }
        f1.puts "]\nend\nend"
      end
    end
    
    private
    @@local_path = "#{Rails.root}/test/lib/datum"
    @@datum_environment = "datum"
    
  end
end
