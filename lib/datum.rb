

# Flexible data-driven test solution for Rails
#
# Author:: Tyemill
# Copyright:: Copyright (c) 2012 - 2014 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)


require 'datum/extensions/railtie'

module Datum
  autoload :Datum, 'datum/extensions/test_helper'
end

require "datum/extensions/test_helper"

# Enables ActiveSupport::TestCase and all extensions
class ActiveSupport::TestCase
  include Datum::Extensions::TestHelper
end

#class ActionController::TestCase
  #include Datum::Extensions::TestHelper
#end