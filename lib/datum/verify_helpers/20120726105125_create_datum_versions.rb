# used to help verify basic datum functionality
# see rake datum:db:verify for details
class CreateDatumVersions < ActiveRecord::Migration
  
  ActiveRecord::Base.establish_connection :datum
  ActiveRecord::Base.connection.initialize_schema_migrations_table
   
  def self.up
    create_table :datum_versions do |t|
      t.string :version
      t.timestamps
    end
  end

  def self.down
    drop_table :datum_versions
  end
end