
module Datum
module Extensions
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/datum.rake" # enable datum rake tasks
    end
  end
end
end