require 'test_helper'

class AwardTest < ActiveModel::TestCase
  def setup
    @award = Award.new(:_id => 'test.count', :value => '1')    
  end
  
  def test_display?
    assert_equal true, @award.display?, 'expected displayed when not plot award'
    @award._id = 'plots.test'
    assert_equal false, @award.display?, 'expected no display when plot award'
  end
end