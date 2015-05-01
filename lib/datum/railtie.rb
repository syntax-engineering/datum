module Datum
require 'rails'

# @!visibility private
class Railtie < Rails::Railtie
  # @!visibility private
  rake_tasks do
    load "tasks/datum_tasks.rake"
  end

end
end