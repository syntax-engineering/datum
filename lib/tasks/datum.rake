# desc "Explaining what the task does"
# task :datum do
#   # Task goes here
# end

namespace :datum do

  desc "Enable datum functionality"
  task :enable => :environment do
    #(Datum::EnableTask.new).rock
    puts "enable datum"
  end

end