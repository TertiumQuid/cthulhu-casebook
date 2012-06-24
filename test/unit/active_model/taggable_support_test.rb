require 'test_helper'

class TaggableSupportTest < ActiveModel::TestCase
  def setup
    @class = Award
    @instance = @class.new(:_id => 'first.last', :value => 1)
  end
  
  def test_class_support
    [Award,Challenge,Lure,Requirement,Penalty].each do |c|
      assert c.ancestors.include?(ActiveModel::TaggableSupport), "expected to be included in #{c}"
    end
  end
  
  def test_tag
    assert_equal 'last', @instance.tag, 'expected last id part for tag'
  end
  
  def test_tagging
    assert_equal 'first', @instance.tagging, 'expected first id part for tagging'
  end  
  
  def test_apply_to
    character = Character.create(:name => 'test')
    character.profile.taggings << Tagging.new(:_id => @instance.tagging, :tags => [{:_id => @instance.tag, :value => 1}] )
    character.profile.save!
    
    @instance.apply_to(character)
    assert_equal '2', character.profile.get(@instance.tagging, @instance.tag).value, 'expected existing value incremented'
  end  
end