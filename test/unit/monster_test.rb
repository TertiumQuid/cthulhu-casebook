require 'test_helper'

class MonsterTest < ActiveModel::TestCase
  def setup
    load_monsters
  end
  
  def test_find_location
    monsters = Monster.find_location('arkham_miskatonic_university').all
    assert_operator monsters.size, ">", 0, 'expected to find location monsters'
    assert_operator monsters.size, "<", Monster.count, 'expected locational subset of all monsters'
    assert_operator 0, "==", monsters.select{ |m| !m.locations.include?('arkham_miskatonic_university')}.size, 'expected only location monsters'
  end
  
  def test_encounters_monster_at
    load_locations
    character = Character.create!(:name => 'available', :clues => Encounter.cost)
    location = Location.find('arkham_miskatonic_university')

    assert_nil Monster.encounters_monster_at?(character, location, -1), 'expected no monster from failed random chance test'
    
    monster = Monster.encounters_monster_at?(character, location, 100)
    assert monster.is_a?(Monster), 'expected monster from passed random chance test'    
  end
  
  def test_difficulty
    assert_equal 1, Monster.new.difficulty, 'expected default difficulty'
  end
  
  def test_fight_with_confront
    character = Character.create!(:name => 'test@example.com')
    assert_difference 'character.reload.clues', -1 do
      assert_equal true, Monster.first.fight(character, :confront), 'expected success with clues'
    end
  end
  
  def test_fight_with_tag
    character = Character.create!(:name => 'test@example.com')
    character.profile.set('skills', 'conflict', 1000)
    
    assert_equal true, Monster.first.fight(character, 'fight'), 'expected success with high-valued tag'
  end
end