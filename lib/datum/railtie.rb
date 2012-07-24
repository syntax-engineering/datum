
module Datum
  require 'rails'
#  require 'active_support'

  class Railtie < Rails::Railtie
    rake_tasks do 
      load "tasks/datum.rake"
    end
#    initializer 'Rails logger' do
#      Datum.logger = Rails.logger
#    end
  end
end