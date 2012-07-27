require 'test_helper'
require "datum/enable_task"

class EnableTaskTest < ActiveSupport::TestCase
  
  def setup
    @enableTask = Datum::EnableTask.new
    @enableTask.disable_user_questions
    @enableTask.disable_verification
  end

  def call_enable
    assert_nothing_raised do
      @enableTask.rock
    end
  end

  test "enable should create directories" do
    call_enable
    dirs = @enableTask.datum_directories
    assert_not_nil dirs, "Enable Task directories should not be nil"

    dirs.each { |directory|
      assert File.directory?(directory), 
      "Enable Task did not create directory: #{directory}"
    }
  end

  test "post call to need_yml should return false" do
    call_enable
    assert false == @enableTask.send(:need_yml?), 
    "need_yml? did not detect new yml section"
  end

  test "post call to need_app should return false" do
    call_enable
    assert false == @enableTask.send(:need_app?), 
    "need_app? did not detect new config add-in"
  end

  test "clean database.yml should yield true need_yml" do

      clean_yml = "#{Rails.env}/dummy/test/lib/datum/utils/database.yml"
      config_dir = "#{Rails.env}/dummy/config/database.yml"

      FileUtils.cp(clean_yml, config_dir)

      assert true == @enableTask.send(:need_yml?), 
    "need_yml? should have returned true with a clean yml"

    test_post_call_to_need_yml_should_return_false
  end

  test "clean application.rb should yield true need_app" do

      clean_app = "#{Rails.env}/dummy/test/lib/datum/utils/application.rb"
      config_app = "#{Rails.env}/dummy/config/application.rb"

      FileUtils.cp(clean_app, config_app)

      assert true == @enableTask.send(:need_app?), 
    "need_app? should have returned true with a clean application.rb"

    test_post_call_to_need_app_should_return_false

  end



end