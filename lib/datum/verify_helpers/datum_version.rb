# used to help verify basic datum functionality
# see rake datum:db:verify for details
class DatumVersion < ActiveRecord::Base
  establish_connection :datum
  
end
