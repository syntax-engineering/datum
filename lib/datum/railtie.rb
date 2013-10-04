module Datum
require 'rails'

class Railtie < Rails::Railtie
  
  rake_tasks do 
    load "tasks/datum_tasks.rake"
  end

end
end