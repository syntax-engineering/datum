# Flexible data-driven test solution for Rails
#
# Author:: Tyemill
# Copyright:: Copyright (c) 2012 - 2014 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'datum/railtie'
require "datum/structures"
require "scenario"

module Datum

  def self.directory
    Rails.root.join('test', 'datum', 'data').to_s + File::Separator
  end

  def self.read file
    File.read("#{directory}#{file}.rb")
  end


  DatumInfo = Struct.new(:tst, :name, :list)

end



def data_test data_filename, &block
  #Datum.process data_filename, &block, klass
end
