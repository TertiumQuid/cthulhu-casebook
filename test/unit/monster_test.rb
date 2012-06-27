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
    monster = Monster.first
    character = Character.create!(:name => 'test@example.com', :monster => monster)
    assert_difference 'character.reload.clues', -1 do
      assert_equal true, monster.fight(character, :confront), 'expected success with clues'
    end
    assert_nil character.monster_id, 'expected character no longer associated with monster'
  end
  
  def test_fight_with_tag
    monster = Monster.first
    character = Character.create!(:name => 'test@example.com', :monster => monster)
    character.profile.set('skills', 'conflict', 1000)
    
    assert_equal true, monster.fight(character, 'fight'), 'expected success with high-valued tag'
    assert_nil character.monster_id, 'expected character no longer associated with monster' 
  end
  
  def test_penalize
    character = Character.create!(:name => 'test@example.com')
    monster = Monster.find('lunatic')
    monster.penalize(character)
    assert_equal '1', character.profile.get('pathology', 'wounds').value, 'expected wounds added'
  end
  
  def test_combined_chance_of_success
    monster = Monster.first
    character = Character.create!(:name => 'test@example.com')
    
    base_chance = monster.send(:combined_chance_of_success, 
                  character.profile.find_tagging('skills'), 
                  character.profile.trappings, 
                  'conflict', 'fight')

    character.profile.set('skills', 'conflict', 10) && character.profile.save
    assert_difference 'base_chance', +10, 'expected skill value calculated' do
      base_chance = monster.send(:combined_chance_of_success, 
                    character.profile.find_tagging('skills'), 
                    character.profile.trappings, 
                    'conflict', 'fight')
    end
    
    skill_equipment = Equipment.new(:title => 'skills', :location => 'hand')
    skill_equipment.modifiers << Tag.new(:_id => 'skills.conflict', :value => 10)
    skill_equipment.save!
    character.profile.trappings.equip!(skill_equipment) && character.profile.save
    assert_difference 'base_chance', +10, 'expected equipment skill value calculated' do
      base_chance = monster.send(:combined_chance_of_success, 
                    character.profile.find_tagging('skills'), 
                    character.profile.trappings, 
                    'conflict', 'fight')
    end

    skill_equipment = Equipment.new(:title => 'skills', :location => 'hand')
    skill_equipment.modifiers << Tag.new(:_id => 'fight', :value => 10)
    skill_equipment.save!
    character.profile.trappings.equip!(skill_equipment) && character.profile.save
    assert_difference 'base_chance', +10, 'expected equipment strategy value calculated' do
      base_chance = monster.send(:combined_chance_of_success, 
                    character.profile.find_tagging('skills'), 
                    character.profile.trappings, 
                    'conflict', 'fight')
    end
  end
end