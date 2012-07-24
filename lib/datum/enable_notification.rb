
module Datum
  NOTIFICATION = 
  "
  ### !!!ADDITIONAL UPDATES REQUIRED!!!
  
   Datum requires:
    + application.rb to reference testcase specific models
    + database.yml to contain a datum environment
    
    - application.rb should contain:
    config.autoload_paths += %W(\#{Rails.root}/test/lib/datum/models)
    
    - database.yml should contain something like:
    
    datum:
      adapter: mysql2
      encoding: utf8
      reconnect: false
      database: yourapp_datum
      pool: 5
      username: root
      password: 
      socket: /tmp/mysql.sock

  "
end
