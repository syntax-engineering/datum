require "datum/artifact"
#require "lib/datum/file"

# regular expressions work (run all tests for a specific datum, etc)
# ruby -I"lib:test" test/models/datum_test.rb -n /test_basic_*/
#
# specific instance of test
# ruby -I"lib:test" test/models/datum_test.rb -n test_basic_1
#
# TODO: Would be nice to execute by label

module Datum
class Datum
  attr_reader :basename, :elements

  DATUM_DIRECTORY = "DATUM_DIRECTORY"
  DATUM_EXTENSION = ".datum"

  def initialize basename
    @basename = basename
  end

  def parse
    hash = load
    enumerate_all_elements hash
  end

  def absolute_path
    "#{directory}#{File::Separator}#{@basename}#{extension}"
  end

  def load
    Datum.yaml(Datum.erb(Datum.read(absolute_path)))
  end

  def directory
    @directory ||= ENV[directory_key].nil? ? default_directory :
    ENV[directory_key]
  end

  def default_directory
    @default_directory ||= build_default_directory
  end

  def self.read absolute_path
    File.read absolute_path
  end

  def self.erb file_data
    ERB.new(file_data).result
  end

  def self.yaml erb_data
    YAML.load erb_data
  end

protected

  def enumerate_all_elements hash
    hash.each_pair {|label, attribute_hash|
      unless attribute_hash.nil?
        artifact = Artifact.new
        internal_elements[label] = artifact
        artifact.parse label, attribute_hash
        construct_datum(label, attribute_hash) # global call to add datum to
                                               # namespace for . access
      end
    }
  end

  def internal_elements
    @elements ||= {}
  end

  def directory_key
    DATUM_DIRECTORY
  end

  def build_default_directory
    Rails.root.join('test', 'datum', 'datums')
  end

  def extension
    DATUM_EXTENSION
  end


private

end
end