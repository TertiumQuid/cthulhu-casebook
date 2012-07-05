require 'test_helper'

class CharacterTest < ActiveModel::TestCase
  def setup
    @character = Character.new(:name => 'test')
  end
  
  def test_find_for_users
    c1 = Character.create!(:name => 'c1', :user_id => '123')
    c2 = Character.create!(:name => 'c2', :user_id => 'abc')
    c3 = Character.create!(:name => 'c3', :user_id => 'fail')
    
    assert Character.find_for_users([]).blank?, 'expected no characters with no given user ids'
    assert_equal [c1,c2], Character.find_for_users(['123', 'abc']).all, 'expected all characters with given user ids'
  end
  
  def test_new_for_user
    name = 'test'
    assert_difference 'User.count', +1 do
      character = Character.new_for_user :name => name
      assert character.new?, 'expected character to be new, not saved'
      assert_equal name, character.name, 'expected character params assigned'
      assert_not_nil character.user_id, 'expected user assigned'
    end
  end
  
  def test_location
    assert_nil @character.location, 'expected no default location'    
    
    @character.send(:populate_profile)
    assert_not_nil @character.location, 'expected location to be set'
    assert_equal @character.profile.get('location', 'current'), @character.location, 'expected location from profile tag'
  end

  def test_lodgings
    assert_nil @character.lodgings, 'expected no default lodgings'    
    
    @character.send(:populate_profile)
    assert_not_nil @character.lodgings, 'expected lodgings to be set'
    assert_equal @character.profile.get('lodgings', 'current'), @character.lodgings, 'expected lodgings from profile tag'
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
    assert_not_nil @character.last_seen_at, 'expected last seen at set when spending clues'
  end
  
  def test_befriend
    @character.save!
    friend = Character.create!(:name => 'test')
    assert_difference '@character.reload.character_friend_ids.size', +1, 'expected friend added' do
      @character.befriend!(friend)
    end
    assert_no_difference '@character.reload.character_friend_ids.size', 'expected duplicate friend not added' do
      @character.befriend!(friend)
    end
    assert @character.character_friend_ids.include?(friend._id.to_s), 'expected friend id string in character_friend_ids'
  end
  
  def test_local_friends
    @character.save!
    friend = Character.create!(:name => 'test', :last_seen_at => Time.now.utc - 7.hours)
    assert_equal @character.location, friend.location, 'expected identical starting locations'
    @character.befriend! friend
    
    friends = @character.local_friends
    assert_equal [], friends, 'expected no recently seen friends'
    
    friend.update_attribute(:last_seen_at, Time.now.utc - 5.hours)
    friends = @character.local_friends
    assert_equal [friend], friends, 'expected all and only local friends returned'
  end
  
  def test_relocate
    @character.save!    
    @character.relocate!('arkham_southside')
    assert_equal 'arkham_southside', @character.reload.location.value, 'expected updated location saved'
  end
  
  def test_friends
    @character.save!
    assert_equal [], @character.friends, 'expected no default friends'
    
    c1 = Character.create!(:name => 'c1')
    c2 = Character.create!(:name => 'c2')
    @character.update_attribute(:character_friend_ids, [c1._id.to_s])
    assert_equal [c1], @character.friends.all, 'expected characters from character_friend_ids'
  end
end