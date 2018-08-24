begin
  require 'rails'

  module Datum
    # @!visibility private
    class Railtie < Rails::Railtie
      # @!visibility private
      rake_tasks do
        load "tasks/datum_tasks.rake"
      end
    end
  end
rescue LoadError => error
  # do nothing
end