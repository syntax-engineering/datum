# Flexible data-driven test solution for Rails
#
# Author:: Tyemill
# Copyright:: Copyright (c) 2012 - 2014 Tyemill
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)
#
# methods accessible without scope

###########
###########

# Creates a data-driven testcase.
#
# @param name [String] the data file to use, e.g. `permission_cases`
# @param &block [block] the method body to call with each datum
def data_test name, &block
  $datum_data_manager = Datum::DataManager.new(self, name)
  $datum_data_manager.process(&block)
end