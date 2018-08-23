require 'minitest'

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "datum"

TestNode = Struct.new(:id, :parent_id)

require "minitest/autorun"
