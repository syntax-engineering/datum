
# simple test for Datum functionality verification
require 'test_helper'

class DatumVersionTest < ActiveSupport::TestCase

  test "datum versions should be accessible" do
    drive_with :datum_versions
    str = datum.version
  end
end