require 'test_helper'

class MonsterTest < ActiveModel::TestCase
  def test_find_location
    load_monsters
    monsters = Monster.find_location('arkham_miskatonic_university').all
    assert_operator monsters.size, ">", 0, 'expected to find location monsters'
    assert_operator monsters.size, "<", Monster.count, 'expected locational subset of all monsters'
    assert_operator 0, "==", monsters.select{ |m| !m.locations.include?('arkham_miskatonic_university')}.size, 'expected only location monsters'
  end
  
  def test_encounters_monster_at
    load_locations
    load_monsters    
    character = Character.create!(:name => 'available', :moxie => Encounter.cost)
    location = Location.find('arkham_miskatonic_university')

    assert_nil Monster.encounters_monster_at?(character, location, -1), 'expected no monster from failed random chance test'
    
    monster = Monster.encounters_monster_at?(character, location, 100)
    assert monster.is_a?(Monster), 'expected monster from passed random chance test'    
  end
end