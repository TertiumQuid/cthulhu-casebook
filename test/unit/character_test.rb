require 'test_helper'

class CharacterTest < ActiveModel::TestCase
  def setup
    @character = Character.new(:name => 'test')
  end
  
  def test_location
    assert_nil @character.location, 'expected no default location'    
    
    @character.send(:populate_profile)
    assert_not_nil @character.location, 'expected location to be set'
    assert_equal @character.profile.get('location', 'current'), @character.location, 'expected location from profile tag'
  end
  
  def test_populate_profile
    assert_nil @character.profile, 'expected no default profile'
    @character.send(:populate_profile)
    assert_not_nil @character.reload.profile, 'expected populated profile'    
  end
  
  def test_reset_messages_count
    character = Character.create!(:name => 'test', :messages_count => 99)
    assert_difference 'character.reload.messages_count', -99 do
      character.reset_messages_count
    end
  end
  
  def test_encounter_monster
    @character.save!    
    monster_id = 'test'
    assert_nil @character.monster
    @character.encounter_monster! monster_id
    @character.reload
    assert_equal monster_id, @character.monster_id, 'expected character monster to be set'
  end
  
  def test_fighting_monster?
    assert_equal false, @character.fighting_monster?, 'expected not to be fighting monster by default'
    @character.monster_id = 'test'
    assert_equal true, @character.fighting_monster?, 'expected to be fighting monster after monster id set'
  end
  
  def test_spend_clues
    assert_difference '@character.clues', -1 do
      @character.spend_clues
    end
    assert_difference '@character.clues', -2 do
      @character.spend_clues(2)
    end
  end
end