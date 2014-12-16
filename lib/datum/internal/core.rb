
require "datum/data_file"

module Datum; module Internal; module Core
  @@data_files, @@loaded_data = nil

  def self.loaded_data; @@loaded_data ||= {}; end
  def self.data_files; @@data_files ||= {}; end




end; end; end