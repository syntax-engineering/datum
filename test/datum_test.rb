require 'test_helper'

class DatumTest < Minitest::Test
  def test_the_truth
    assert true
  end

  def test_can_load_a_scenario
    process_scenario :the_truth
    assert @the_truth
  end

  data_test 'can_make_data_tests' do
    assert @datum.value_two unless @datum.value_one
    assert @datum.value_one unless @datum.value_two
  end
end