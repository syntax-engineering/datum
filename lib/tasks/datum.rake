

namespace :datum do
  desc "Enable Datum functionality, create Datum file structure"
  task :enable => :environment do
    #init_directory Datum::FileHelper.data_directory
    #init_directory Datum::FileHelper.scenario_directory
  end

  def init_directory directory
    #FileUtils.mkdir_p directory
    #{}`touch "#{directory}#{File::Separator}.keep"`
  end
end