require 'test_helper'

class CharacterTest < ActiveModel::TestCase
  def test_location
    character = Character.new(:name => 'test')
    assert_nil character.location, 'expected no default location'    
    
    character.send(:populate_profile)
    assert_not_nil character.location, 'expected location to be set'
    assert_equal character.profile.get('location', 'current'), character.location, 'expected location from profile tag'
  end
  
  def test_populate_profile
    character = Character.new(:name => 'test')
    assert_nil character.profile, 'expected no default profile'
    character.send(:populate_profile)
    assert_not_nil character.reload.profile, 'expected populated profile'    
  end
  
  def test_reset_messages_count
    character = Character.create!(:name => 'test', :messages_count => 99)
    assert_difference 'character.reload.messages_count', -99 do
      character.reset_messages_count
    end
  end
end