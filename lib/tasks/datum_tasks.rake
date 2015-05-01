namespace :datum do

  require 'fileutils'

  desc "Creates test/datum/data and test/datum/scenarios"
  task :install => :environment do
    puts "Created:
    #{mkdir_keep Datum.data_path}
    #{mkdir_keep Datum.scenario_path}"
  end

private

  def mkdir_keep dir
    s = dir.to_s; FileUtils.mkdir_p s; `touch "#{dir + '.keep'}"`; s
  end

end