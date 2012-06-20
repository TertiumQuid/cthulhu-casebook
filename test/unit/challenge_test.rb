require 'test_helper'

class ChallengeTest < ActiveModel::TestCase
  def test_tag
    challenge = Challenge.new(:_id => 'first.middle.last')
    assert_equal 'last', challenge.tag, 'expected last id part for tag'
  end
  
  def test_tagging
    challenge = Challenge.new(:_id => 'first.middle.last')
    assert_equal 'first', challenge.tagging, 'expected first id part for tagging'
  end
end