require "datum/verification_task"
require "datum/enable_task"
require "datum/db_tasks"

namespace :datum do
  
  desc "Enable datum functionality"
  task :enable do
    (Datum::EnableTask.new).rock
  end

  namespace :db do

    desc "Create datum database"
    task :create do invoke "create" end
    
    desc "Migrate datum database"
    task :migrate do invoke "migrate" end
    
    desc "Drop datum database"
    task :drop do invoke "drop" end
    
    desc "Dump data as fixtures from datum database"
    task :dump do invoke "dump" end
    
    desc "Loads fixtures specific to datum database"
    task :load do invoke "load" end
    
    #desc "Quick verification of basic datum functionality"
    #task :verify do invoke "verify" end
    
    desc "Enables datum execution without database dependency"
    task :localize, :table do |t, args|
      (Datum::DbTasks.new).localize args
    end
    
    private
    def invoke method
      (Datum::DbTasks.new).send(method)
    end
    
  end
end