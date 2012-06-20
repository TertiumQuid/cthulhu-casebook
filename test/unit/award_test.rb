require 'test_helper'

class AwardTest < ActiveModel::TestCase
  def test_tag
    award = Award.new(:_id => 'first.middle.last')
    assert_equal 'last', award.tag, 'expected last id part for tag'
  end
  
  def test_tagging
    award = Award.new(:_id => 'first.middle.last')
    assert_equal 'first', award.tagging, 'expected first id part for tagging'
  end
  
  def apply_to
    character = Character.create(:name => 'test')
    profile = Profile.new(:taggings => [{:_id => 'test', :tags => [{:_id => 'count', :value => 1}] }])
    profile.character = character
    profile.save!
    
    award = Award.new(:_id => 'test.count', :value => '1')
    award.apply_to!(character)
    assert_equal '2', character.profile.get('test', 'count'), 'expected existing value incremented'
  end
end