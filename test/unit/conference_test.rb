require 'test_helper'

class ConferenceTest < ActiveModel::TestCase
  def test_find_for
    assert_nil Conference.find_for('123', 'abc'), 'expected no conference for bad ids'
    conference = Conference.create!(:character_ids => ['first', 'second'])
    assert_nil Conference.find_for('first', 'abc'), 'expected no conference for bad id'
    assert_equal conference, Conference.find_for('first', 'second'), 'expected matching conference'
    assert_equal conference, Conference.find_for('second', 'first'), 'expected matching conference with reversed ids'    
  end
  
  def test_recent
    c1 = Conference.create!(:character_ids => ['first', 'second'])
    c1.update_attribute(:conferred_at, Time.now.utc - (Conference::COOLDOWN_HOURS + 1).hours)
    c2 = Conference.create!(:character_ids => ['third'])
    c2.update_attribute(:conferred_at, Time.now.utc - (Conference::COOLDOWN_HOURS + 1).hours)
    c3 = Conference.create!(:character_ids => ['first'])
    
    assert_equal [c3], Conference.recent('first').all, 'expected all and only matching character conferences in last day'
  end
  
  def test_set_conferred_at
    conference = Conference.new
    conference.set_conferred_at
    assert_not_nil conference.conferred_at, 'expected conferred_at timestamp set'
  end
  
  def test_confer
     character = Character.create!(:name => 'test')
     friend = Character.create!(:name => 'test')
     
     friend.profile.set('location', 'current', 'arkham_rivertown') && friend.profile.save!
     assert_no_difference ['character.reload.clues', 'friend.reload.clues'], 'expected no clues from different locations' do
       conference = Conference.confer(character._id, friend._id)
       assert_not_nil conference.errors[:character_ids], 'expected error on character_ids'
     end    
     friend.profile.set('location', 'current', character.location.value) && friend.profile.save!

     assert_difference ['character.reload.clues', 'friend.reload.clues'], +1, 'expected characters to gain 1 clue' do
       conference = Conference.confer(character._id, friend._id)
       assert_not_nil conference.conferred_at, 'expected last conferred_at timestamp set'
     end
     
     assert_no_difference ['character.reload.clues', 'friend.reload.clues'], 'expected no clues during cooldown period' do
       conference = Conference.confer(character._id, friend._id)
       assert_not_nil conference.errors[:conferred_at], 'expected error on conferred_at'
     end    
   end
end