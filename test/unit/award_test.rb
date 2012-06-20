require 'test_helper'

class AwardTest < ActiveModel::TestCase
  def setup
    @award = Award.new(:_id => 'test.count', :value => '1')    
  end
  
  def test_tag
    assert_equal 'count', @award.tag, 'expected last id part for tag'
  end
  
  def test_tagging
    assert_equal 'test', @award.tagging, 'expected first id part for tagging'
  end
  
  def test_apply_to
    character = Character.create(:name => 'test')
    character.profile.taggings << Tagging.new(:_id => @award.tagging, :tags => [{:_id => @award.tag, :value => 1}] )
    character.profile.save!
    
    @award.apply_to!(character)
    assert_equal '2', character.profile.get('test', 'count').value, 'expected existing value incremented'
  end
  
  def test_display?
    assert_equal true, @award.display?, 'expected displayed when not plot award'
    @award._id = 'plots.test'
    assert_equal false, @award.display?, 'expected no display when plot award'
  end
end