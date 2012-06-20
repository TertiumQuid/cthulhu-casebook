require 'test_helper'

class CharacterTest < ActiveModel::TestCase
  def test_populate_profile
    character = Character.new(:name => 'test')
    assert_nil character.profile, 'expected no default profile'
    character.send(:populate_profile)
    assert_not_nil character.reload.profile, 'expected populated profile'    
  end
end