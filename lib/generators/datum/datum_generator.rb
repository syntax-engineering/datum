require 'rails/generators/migration'
require 'rails/generators/generated_attribute'

# Generator code was modified from https://github.com/ryanb/nifty-generators/
# Nifty Generators is Copyright (c) 2011 Ryan Bates and distributed via the
# MIT License
class DatumGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  no_tasks { attr_accessor :scaffold_name, :model_attributes}
  source_root File.expand_path('../templates', __FILE__)
  
  argument :scaffold_name, :type => :string, :required => true, :banner => 'ModelName'
  argument :args_for_m, :type => :array, :default => [], :banner => 'model:attributes'
  
  class_option :skip_migration, 
  :desc => 'Don\'t generate migration file for model.', :type => :boolean
  
  class_option :skip_model, 
  :desc => 'Don\'t generate a model or migration file.', :type => :boolean
  
  def initialize(*args, &block)
    super
    print_usage unless scaffold_name.underscore =~ /^[a-z][a-z0-9_\/]+$/
    
    @datum_path = "test/lib/datum"
    @model_attributes = []
    @skip_model = options.skip_model?

    args_for_m.each do |arg|
      if arg.include?(':')
        @model_attributes << Rails::Generators::GeneratedAttribute.new(*arg.split(':'))
      end
    end

    @model_attributes.uniq!

    if @model_attributes.empty?
      @skip_model = true # skip model if no attributes
      if model_exists?
        model_columns_for_attributes.each do |column|
          @model_attributes << Rails::Generators::GeneratedAttribute.new(
          column.name.to_s, column.type.to_s)
        end
      else
        @model_attributes << Rails::Generators::GeneratedAttribute.new(
        'name', 'string')
      end
    end
  end
  
  def create_model
    unless @skip_model
      template 'datum_model.rb', "#{@datum_path}/models/#{model_path}.rb"
    end
  end
  def create_migration
    unless @skip_model || options.skip_migration?
      migration_template 'datum_migration.rb', 
      "#{@datum_path}/migrate/create_#{model_path.pluralize.gsub('/', '_')}.rb"
    end
  end
  
private

  def plural_name
    scaffold_name.underscore.pluralize
  end
  
  def plural_class_name
    plural_name.camelize
  end
  
  def table_name
    if scaffold_name.include?('::') && @namespace_model
      plural_name.gsub('/', '_')
    end
  end
  
  def class_name
    scaffold_name.split('::').last.camelize
  end
  
  def model_path
    class_name.underscore
  end
  
  def model_exists?
    File.exist? destination_path("#{@datum_path}/models/#{singular_name}.rb")
  end
  
  def destination_path(path)
    File.join(destination_root, path)
  end
  
  # FIXME: Should be proxied to ActiveRecord::Generators::Base
  # Implement the required interface for Rails::Generators::Migration.
  def self.next_migration_number(dirname) #:nodoc:
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end
end
